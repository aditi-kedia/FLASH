#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include    <unistd.h>
#include    <sys/types.h>
#include    <sys/wait.h>
#include <sys/utsname.h>
#include    <errno.h>
#include    <string.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


#define OUTPUT_REDIRECTION ">"
#define INPUT_REDIRECTION "<"
#define ERROR_REDIRECTION "2>"

#define OUTPUT_REDIRECTION_APPEND ">>"
#define INPUT_REDIRECTION_APPEND "<<"
#define ERROR_REDIRECTION_APPEND "2>>"
#define RET_VAL_VAR "?"
#define ASCII_UPPER_A 65
#define ASCII_UPPER_Z 90

#define HASH "#"
#define MAX_SIZE 1024
#define EXIT "exit"
#define SET "set"
#define GET "get"
#define ARRAY_SIZE(arr) (sizeof((arr)) / sizeof((arr)[0]))

#define ENABLE 1
#define TRUE 1
#define FALSE 0
#define DISABLE 0
#define E_OK 0
#define E_GENERAL -1
#define E_EXIT -2
#define E_INCORRECT_ARGS -3
#define MEMORY_ALLOC_FAILURE -4
#define CD "cd"

int fBackground = DISABLE;
int ec = E_OK;


struct HashTable {
    struct Node *HashTable[15];
    int numberOfElements, capacity;
};

struct Node{
    char *key;
    char *value;
    struct Node *next;
};

 
int TokenizeString(const char *const str, char ***arr, const char * re, int);
int ProcessCommandLine(char *commandLine);
int ProcessSingleCommand(char *command);
int ProcessPipes(char *command, char ***outputSplit);
int CreateEnvironment();
int ExecuteCommandInBackground(char **arguments, int numberOfCommands);
int ExecuteCommandInForeground(char **arguments, int *returnValue, int numberOfCommands);
char **GetEnvPath(char **options);
int SetEnvironmentVariable(char *);
int GetEnvironmentVariable(char *);
char **PreprocessCommandsForPipe(char *command, int *numberOfCommands);
char *environment;
int ProcessMultiplePipes(char **pipes, int numberOfPipes);
void RemoveEscapeSpace(char *str);
char *hostName;
int PipedExecution(char ***pipeCommandList, int numberOfPipes, int *numberOfCommands);
int PipeExecutables(char ***pipeArray);
char **RedirectionCheck(char **arguments, int *outfd, int *infd, int *errfd, int numberOfArguments);
void setNode(struct Node* node, char* key, char* value);
int hashFunction(struct HashTable* mp, char* key);
void insert(struct HashTable* mp, char* key, char* value);
void delete (struct HashTable* mp, char* key);
char* search(struct HashTable* mp, char* key);
int CheckKey(char *key);
int CleanEnvironment();
struct HashTable *environmentVariables;

int retVal = E_OK;

int 
main(int argc, char *argv[])
{
    char *workingDirectory;
    char *user;
    if(CreateEnvironment())
    {
        goto CLEANUP;
    }
    char inputCommand[MAX_SIZE];
    struct utsname info;

    if (uname(&info) == 0) {
        hostName = info.nodename;
    }
    while(1)
    {
        RESTART:
        workingDirectory = getcwd(workingDirectory, MAX_SIZE);
        if (workingDirectory == NULL)
            goto RESTART;
        user = getlogin();
        // printf("%s@%s:%s$ ", user, host, workingDirectory);
        printf("\x1b[32m\033[1m%s@%s\x1b[0m:\x1b[34m\033[1m%s\x1b[0m\033[0m$ ", user, hostName, workingDirectory);
        fgets(inputCommand, MAX_SIZE, stdin);
        inputCommand[strlen(inputCommand) - 1] = '\0';
        ec = ProcessCommandLine(inputCommand);
        if (ec == E_EXIT)
            break;
    }
    CLEANUP:
    CleanEnvironment();
}

int CleanEnvironment()
{
    free(environmentVariables);
}

int CreateEnvironment()
{
    environment = getenv("PATH");
    if (environment == NULL)
        return 1;
    environmentVariables = (struct HashTable *) malloc(sizeof(struct HashTable));
    if (environmentVariables == NULL)
        return 1;
    environmentVariables -> capacity = 15;
    environmentVariables -> numberOfElements = 0;
    return 0;
}

int 
ProcessCommandLine(char *commandLine)
{
    char **commandArray;
    const char *commaRegEx = "[^,]+ *|(\"[^\"]*\")";
    int numberOfCommands = TokenizeString(commandLine, &commandArray, commaRegEx, FALSE);
    if (numberOfCommands < 0)
        return numberOfCommands;
    for (int i = 0; i < numberOfCommands; i ++)
    {
        char **pipes;
        int numberOfPipes = ProcessPipes(commandArray[i], &pipes);
        if (numberOfPipes < 0)
            return numberOfPipes;
        else if (numberOfPipes == 1)
        {
            ec = ProcessSingleCommand(pipes[0]);
            if (ec == E_EXIT)
            {
                free(pipes);
                free(commandArray);
                return E_EXIT;
            }
        }
        else 
        {
            ec = ProcessMultiplePipes(pipes, numberOfPipes);
            free(pipes);
        }
    }
    free(commandArray);
}

int
ProcessMultiplePipes(char **pipes, int numberOfPipes)
{
    char ***pipeCommands = (char ***) malloc((numberOfPipes + 1) * sizeof(char **));
    int *numberOfCommands = (int *)malloc(numberOfPipes * sizeof(int));
    int *commandCountArray = numberOfCommands;
    for (int i = 0; i < numberOfPipes; i ++)
    {

        char **commandOptions = PreprocessCommandsForPipe(pipes[i], commandCountArray);
        if (commandOptions == NULL)
        {
            free(pipeCommands);
            free(numberOfCommands);
            return -1;
        }
        else
        {
            pipeCommands[i] = commandOptions;
        }
        commandCountArray++;
    }
    pipeCommands[numberOfPipes] = NULL;
     
    int err = PipedExecution(pipeCommands, numberOfPipes, numberOfCommands);
    free(pipeCommands);
    free(numberOfCommands);
    return err;
}

int PipedExecution(char ***pipeCommandList, int numberOfPipes, int *numberOfCommands)
{
    int fd[2];
	pid_t pid;
	int fdd = 0;				/* Backup */

	while (*pipeCommandList != NULL) {
        // int outfd = STDOUT_FILENO;
        // int infd = STDIN_FILENO;
        // int errfd = STDERR_FILENO;
        // char **arguments = RedirectionCheck(*pipeCommandList, &outfd, &infd, &errfd, *numberOfCommands);
		pipe(fd);				/* Sharing bidiflow */
		if ((pid = fork()) == -1) {
			perror("fork");
            exit(errno);
		}
		else if (pid == 0) {

			dup2(fdd, 0);
			if (*(pipeCommandList + 1) != NULL) {
				dup2(fd[1], 1);
			}
            
			close(fd[0]);
			execv(*pipeCommandList[0], *pipeCommandList);
			exit(errno);
		}
		else 
        {
            char buffer[MAX_SIZE];
            int signalCode;
            int wstatusg;
            if (*(pipeCommandList + 1) == NULL)
            {
                int w = waitpid(pid, &wstatusg, WUNTRACED);
                if (w == E_GENERAL)
                    return errno;

                if (&wstatusg != NULL)
                {
                    if (WIFEXITED(wstatusg))
                    {
                        retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0
                        if (retVal == E_OK)
                            return E_OK;
                        snprintf(buffer, MAX_SIZE, "%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", retVal);
                        write(STDOUT_FILENO, buffer, strlen(buffer));
                        return E_OK; //Design choice to print child exit status and return parent exit code
                    }
                    else if (WIFSIGNALED(wstatusg))
                    {
                        retVal = -6;
                        signalCode = WTERMSIG(wstatusg);
                        snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                        write(STDOUT_FILENO, buffer, strlen(buffer));
                        return E_OK;
                    }
                    else if (__WCOREDUMP(wstatusg))
                    {
                        retVal = -7;
                        snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                        return E_OK;
                    }
                }
                close(fd[1]);
                fdd = fd[0];
                pipeCommandList++;
                numberOfCommands++;
		    }
            else
            {
                wait(NULL);
                close(fd[1]);
                fdd = fd[0];
                pipeCommandList++;
                numberOfCommands++;
            }
	    }
    }
    return E_OK;
}

char **PreprocessCommandsForPipe(char *command, int *numberOfCommands)
{
    char **commandOptions;
    char *spaceRegEx = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")";
    int numCommands = TokenizeString(command, &commandOptions, spaceRegEx, TRUE);
    *numberOfCommands = numCommands;
    if (numberOfCommands < 0)
    {
        return NULL;
    }
    if(strcmp(commandOptions[0], EXIT) == 0 && *numberOfCommands == 1)
    {
        perror("\nCannot exit while attempting to pipe.\n");
        return NULL;
    }
    else if (strcmp(commandOptions[0], CD) == 0 && *numberOfCommands == 2)
    {
        perror("\nCannot change directory while attempting to pipe.\n");
        return NULL;
    }
    commandOptions = (char **) realloc(commandOptions, (3) * sizeof(char *));
    commandOptions[numCommands] = NULL;
    
    commandOptions = GetEnvPath(commandOptions);  

    if (strcmp(commandOptions[numCommands - 1], HASH) == 0) //TODO: Regex instead of comparison
    {
        perror("\nUnexpected pipe symbol while attempting to run in background\n");
        return NULL;
    }
    return commandOptions;
}

int
ProcessSingleCommand(char *command)
{
    char **commandOptions;
    char *spaceRegEx = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")|([^ ]+=((([^ ]+([\\] )*)+)|(\"[^\"]*\")))";
    int numberOfCommands = TokenizeString(command, &commandOptions, spaceRegEx, TRUE);
    if (numberOfCommands < 0)
        return numberOfCommands;
    else if (numberOfCommands == 0)
        return E_GENERAL;
    if(strcmp(commandOptions[0], EXIT) == 0 && numberOfCommands == 1)
        return E_EXIT;
    else if (strcmp(commandOptions[0], SET) == 0)
    {
        if (numberOfCommands == 2)
        {
            ec = SetEnvironmentVariable(commandOptions[1]);
            return ec;
        }
        else
            return -4;
    }
    else if (strcmp(commandOptions[0], GET) == 0)
    {
        if (numberOfCommands == 2)
        {
            ec = GetEnvironmentVariable(commandOptions[1]);
            return ec;
        }
        else
            return -4;
    }
    else if (strcmp(commandOptions[0], CD) == 0 && numberOfCommands == 2)
    {
        char currentWorkingDirectory[1024];

        int result = chdir(commandOptions[1]);

        if (result == -1)
        {
            return errno;
        }
        return E_OK;
    }
    commandOptions = (char **) realloc(commandOptions, (3) * sizeof(char *));
    if (commandOptions == NULL)
        return MEMORY_ALLOC_FAILURE;
    commandOptions[numberOfCommands] = NULL;
    
    commandOptions = GetEnvPath(commandOptions);  

    if (strcmp(commandOptions[numberOfCommands - 1], HASH) == 0)
    {
        commandOptions[numberOfCommands - 1] = NULL;
        ExecuteCommandInBackground(commandOptions, numberOfCommands);
    }
    else
    {
        int processReturnValue;
 
        int returnValue = ExecuteCommandInForeground(commandOptions, &processReturnValue, numberOfCommands + 1);
        if (returnValue != 0)
        {
            return returnValue;
        }
    }
   
    return E_OK;
}

int
ProcessPipes(char *command, char ***outputSplit)
{
    const char *pipingRegex = "[^|]+";
    int numberOfPipes = TokenizeString(command, outputSplit, pipingRegex, FALSE);
    if (numberOfPipes < 0)
        return numberOfPipes;
}

/// @brief Splits an array based on regular expression specified by the re parameter
/// @param str string to parse
/// @param arr array to store the result
/// @param re regular expression to use for parsing
/// @param removeSpace 
/// @return int length of array. If any error is encountered, the error value is returned
int 
TokenizeString(const char *const str, char ***arr, const char *re, int removeSpace)
{
    //static const char *const re = "(([^ ,]+([\\] )*)+)|(\"[^\"]*\")";
    //static const char *const re = "([^,]+([,] )*)+";
    const char *s = str;
    regex_t     regex;
    regmatch_t  pmatch[1];
    regoff_t    off, len;
    int arraySize = 0;

    if (regcomp(&regex, re, REG_NEWLINE | REG_EXTENDED))
        return -1;

    char **array = (char **) malloc(sizeof(char *));
    for (int i = 0; ; i++) {
        if (regexec(&regex, s, ARRAY_SIZE(pmatch), pmatch, 0))
            break;
        arraySize++;
        array = (char **) realloc(array, arraySize * sizeof(char *));
        
        off = pmatch[0].rm_so + (s - str);
        len = pmatch[0].rm_eo - pmatch[0].rm_so;
        int start = pmatch[0].rm_so + 1;

        char *buf = (char *) malloc(len);
        snprintf(buf, 1024, "%.*s", len, s + pmatch[0].rm_so);
        if (buf[0] == '"')
        {
            buf += 1;
            buf[strlen(buf) - 1] = '\0';
        }
        if (removeSpace)
            RemoveEscapeSpace(buf);
        if (buf[0] == ' ' && strlen(buf) == 1)
        {
            arraySize --;
            s += pmatch[0].rm_eo;
            continue;
        }
        if (buf != " ")
            array[arraySize - 1] = buf;
        
        s += pmatch[0].rm_eo;
    }
    *arr = array;
    return arraySize;
}

char ** GetEnvPath(char **options)
{
    if(strchr(options[0], '/')!= NULL)
    {
        return options;
    }
    else
    {
        char *command = options[0];
        int found = 0;
        char *token, *saveptr;
        char envPath[strlen(environment)];
        strcpy(envPath, environment);
        token = strtok(envPath, ":");
        while(token!=NULL)
        {
            int commandLength = strlen(token) + strlen(command) + 2;
            char *fullCommmand = (char *) malloc(commandLength);
            snprintf(fullCommmand, commandLength, "%s/%s", token, command);
            if (access(fullCommmand, X_OK) == 0)
            {
                found = 1;
                options[0] = fullCommmand;
                return options;
            }
            else
            {
                free(fullCommmand);
            }
            token = strtok(NULL, ":");
        }
        return options;
    }
}

void RemoveEscapeSpace(char *str) 
{
    int i, j;
    for (i = 0, j = 0; str[i] != '\0'; i++, j++) {
        if (str[i] == '\\' && str[i+1] == ' ') {
            i++;
        }
        str[j] = str[i]; 
    }
    str[j] = '\0';
}

int
ExecuteCommandInBackground(char **arguments, int numberOfArguments)
{
    int pid = fork();
    if (pid == -1)
        return errno;
    else if (pid == 0)
    {
        int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments);

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                return errno;
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                return errno;
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                return errno;
            }
        }

        if (arguments == NULL)
            return -3;
        
        char *path = arguments[0];
        ec = execv(path, arguments);
        printf("Could not find any such command: %s\n", path);
        exit(errno);
    }
    else
    {
        return E_OK;
    }
}
int
ExecuteCommandInForeground(char **arguments, int *returnValue, int numberOfArguments)
{

    int pid = fork();
    if (pid == -1)
        return errno;
    else if (pid == 0)
    {
        
        int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
        
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments);
        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                return errno;
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                return errno;
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                return errno;
            }
        }

        if (arguments == NULL)
            return -3;
        char *path = arguments[0];
        ec = execv(path, arguments);
        printf("Could not find any such command: %s\n", path);
        exit(errno);
    }
    else
    {
        char buffer[MAX_SIZE];
        int signalCode;
        int wstatusg;
        int w = waitpid(pid, &wstatusg, WUNTRACED);
        if (w == E_GENERAL)
            return errno;

        if (&wstatusg != NULL)
        {
            if (WIFEXITED(wstatusg))
            {
                retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0
                if (retVal == E_OK)
                    return E_OK;
                snprintf(buffer, MAX_SIZE, "%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", retVal);
                printf("%s", buffer);
                return E_OK; //Design choice to print child exit status and return parent exit code
            }
            else if (WIFSIGNALED(wstatusg))
            {
                retVal = -6;
                signalCode = WTERMSIG(wstatusg);
                snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                printf("%s", buffer);
                return E_OK;
            }
            else if (__WCOREDUMP(wstatusg))
            {
                retVal = -7;
                snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                printf("%s", buffer);
                return E_OK;
            }
        }
        return E_OK;
    }
}


// TODO:Remove this function before submission
/// @brief:This function executes a given generator binary specified by a generator path and pipes
///        its standard output to the standard input of consumer binary specified by consumer path
/// @param pipeCommands pointer to array of strings representing commands
/// @return 0 if successful or errno value
int
PipeExecutables(char ***pipeCommands)
{
    char **generatorArguments = pipeCommands[0];
    char **consumerArguments = pipeCommands[1];
    char *consumerExecutablePath = consumerArguments[0];
    char *generatorExecutablePath = generatorArguments[0];
    int fd[2];
    ec = pipe(fd);
    if (ec == E_GENERAL)
        return errno;

    int pidc = fork();
    if (pidc == E_GENERAL)
        return errno; 
    else if (pidc == 0)
    {
        ec = dup2(fd[0], STDIN_FILENO);
        if (ec == E_GENERAL)
            return errno;

        ec = close(fd[1]);
        if (ec == E_GENERAL)
            return errno;
        
        ec = execv(consumerExecutablePath, consumerArguments);

        exit(errno);
        return errno; //only returns if error occurred in execv() system call
    }
    else
    {
        int pidg = fork();
        if (pidg == -1)
            return errno;
        else if (pidg == 0)
        {
            ec = dup2(fd[1], STDOUT_FILENO);
            if (ec == E_GENERAL)
                return errno;
            
            ec = close(fd[0]);
            if (ec == E_GENERAL)
                return errno;

            ec = execv(generatorExecutablePath, generatorArguments);
            exit(errno);
        }
        else
        {
            close(fd[0]);
            close(fd[1]);
            int retVal = 0;
            char buffer[MAX_SIZE];
            int signalCode;
            int wstatusg;
            int w = waitpid(pidg, &wstatusg, WUNTRACED);
            if (w == E_GENERAL)
                return errno;

            if (&wstatusg != NULL)
            {
                if (WIFEXITED(wstatusg))
                {
                    retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0
                    if (retVal == E_OK)
                        return E_OK;
                    snprintf(buffer, MAX_SIZE, "\n%s: %d %s - %d\n", "The process with pid", pidg, "exited with error code", retVal);
                    write(STDOUT_FILENO, buffer, strlen(buffer));
                    return E_OK; //Design choice to print child exit status and return parent exit code
                }
                else if (WIFSIGNALED(wstatusg))
                {
                    signalCode = WTERMSIG(wstatusg);
                    snprintf(buffer, MAX_SIZE,  "\n%s: %d %s - %d\n", "The process with pid", pidg, "signalled with signal code", signalCode);
                    write(STDOUT_FILENO, buffer, strlen(buffer));
                    return E_OK;
                }
                else if (__WCOREDUMP(wstatusg))
                {
                    snprintf(buffer, MAX_SIZE, "\n%s: %d %s\n", "The process with pid", pidg, "was core dumped");
                    return E_OK;
                }
            }
            return E_OK;
        }
    }
}

/// @brief This function checks if there user wants to redirect standard I/O, opens appropriate file and sets 
/// file numbers appropriately
/// @param arguments input arguments
/// @param outfd redirected output file descriptor
/// @param infd redirected input file descriptor
/// @param errfd redirected error file descriptor
/// @param numberOfArguments number of input arguments
/// @return character final command array with redirection symbols and paths removed

char **
RedirectionCheck(char **arguments, int *outfd, int *infd, int *errfd, int numberOfArguments)
{
    char **finalArguments = (char **) malloc (numberOfArguments * sizeof(char *));
    if (finalArguments == NULL)
        return NULL;
    int j = 0;
    //TODO: replace this with a switch case on a hashmap and enum
    if (numberOfArguments == 1)
    {
        finalArguments[0] = arguments[0];
        finalArguments[1] = NULL;
        return finalArguments;
    }
    for (int i = 0; i < numberOfArguments - 1;)
    {
        if (strcmp(arguments[i], OUTPUT_REDIRECTION) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *outfd = open(arguments[i + 1], O_WRONLY);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], OUTPUT_REDIRECTION_APPEND) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *outfd = open(arguments[i + 1], O_WRONLY | O_APPEND);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], INPUT_REDIRECTION) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *infd = open(arguments[i + 1], O_RDONLY);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], INPUT_REDIRECTION_APPEND) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *infd = open(arguments[i + 1], O_RDONLY | O_APPEND);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], ERROR_REDIRECTION) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *errfd = open(arguments[i + 1], O_WRONLY);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], ERROR_REDIRECTION_APPEND) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *errfd = open(arguments[i + 1], O_WRONLY | O_APPEND);
                i += 2;
            }
            else
            {
                perror("Syntax error: please mention path to redirect to");
                return NULL;
            }
        }
        else
        {
            finalArguments[j] = arguments[i];
            i++;
            j++;
        }
    }
    finalArguments[j] = NULL;
    return finalArguments;
}


int GetEnvironmentVariable(char *getCommand)
{
    if (strcmp(getCommand, RET_VAL_VAR) == 0)
        printf("%d\n", retVal);
    else if (CheckKey(getCommand))
    {
        char *value = search(environmentVariables, getCommand);
        if (value !=NULL)
        {
            printf("\n%s\n", value);
        }
    }
}
int SetEnvironmentVariable(char *setCommand)
{
    char *regex = "[^=]+|\"*[^\"]\"* ";
    char **result;
    int numberOfTokens = TokenizeString(setCommand, &result, regex, 0);
    if (numberOfTokens != 2)
        return -5;
    else
    {
        char *key = result[0];
        char *value = result[1];
        if (strlen(value) > 240 || !CheckKey(key))
            return -5;
        insert(environmentVariables, key, value);
        return E_OK;
    }
}

int CheckKey(char *key)
{
    for (int i = 0; i < strlen(key); i++)
    {
        if (key[i] < ASCII_UPPER_A || key[i] > ASCII_UPPER_Z)
            return 0;
    }
    return 1;
}

void setNode(struct Node* node, char* key, char* value)
{
    node->key = key;
    node->value = value;
    node->next = NULL;
    return;
};

// void initializeHashMap(struct HashTable* mp)
// {
 
//     // Default capacity in this case
//     mp->capacity = 15;
//     mp->numberOfElements = 0;
//     return;
// }

 
int hashFunction(struct HashTable* mp, char* key)
{
    int bucketIndex;
    int sum = 0, factor = 31;
    for (int i = 0; i < strlen(key); i++) {
 
        // sum = sum + (ascii value of
        // char * (primeNumber ^ x))...
        // where x = 1, 2, 3....n
        sum = ((sum % mp->capacity)
               + (((int)key[i]) * factor) % mp->capacity)
              % mp->capacity;
 
        // factor = factor * prime
        // number....(prime
        // number) ^ x
        factor = ((factor % __INT16_MAX__)
                  * (31 % __INT16_MAX__))
                 % __INT16_MAX__;
    }
 
    bucketIndex = sum;
    return bucketIndex;
}
 
void insert(struct HashTable* mp, char* key, char* value)
{
 
    // Getting bucket index for the given
    // key - value pair
    int bucketIndex = hashFunction(mp, key);
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    if (newNode = NULL)
        return;
 
    // Setting value of node
    setNode(newNode, key, value);
 
    // Bucket index is empty....no collision
    if (mp->HashTable[bucketIndex] == NULL) {
        mp->HashTable[bucketIndex] = newNode;
    }
 
    // Collision
    else {
 
        // Adding newNode at the head of
        // linked list which is present
        // at bucket index....insertion at
        // head in linked list
        newNode->next = mp->HashTable[bucketIndex];
        mp->HashTable[bucketIndex] = newNode;
    }
    return;
}
 
void delete (struct HashTable* mp, char* key)
{
 
    // Getting bucket index for the
    // given key
    int bucketIndex = hashFunction(mp, key);
 
    struct Node* prevNode = NULL;
 
    // Points to the head of
    // linked list present at
    // bucket index
    struct Node* currNode = mp->HashTable[bucketIndex];
 
    while (currNode != NULL) {
 
        // Key is matched at delete this
        // node from linked list
        if (strcmp(key, currNode->key) == 0) {
 
            // Head node
            // deletion
            if (currNode == mp->HashTable[bucketIndex]) {
                mp->HashTable[bucketIndex] = currNode->next;
            }
 
            // Last node or middle node
            else {
                prevNode->next = currNode->next;
            }
            free(currNode);
            break;
        }
        prevNode = currNode;
        currNode = currNode->next;
    }
    return;
}
 
char* search(struct HashTable* mp, char* key)
{
 
    // Getting the bucket index
    // for the given key
    int bucketIndex = hashFunction(mp, key);
 
    // Head of the linked list
    // present at bucket index
    struct Node* bucketHead = mp->HashTable[bucketIndex];
    while (bucketHead != NULL) {
 
        // Key is found in the hashMap
        if (strcmp(bucketHead->key, key) == 0) {
            return bucketHead->value;
        }
        bucketHead = bucketHead->next;
    }
 
    // If no key found in the hashMap
    // equal to the given key
    char* errorMssg = "Oops! No data found.";
    return errorMssg;
}
 