#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include    <unistd.h>
#include    <sys/types.h>
#include    <sys/wait.h>
#include    <errno.h>
#include    <string.h>



#define MAX_SIZE 1024
#define EXIT "exit"
#define ARRAY_SIZE(arr) (sizeof((arr)) / sizeof((arr)[0]))

#define ENABLE 1
#define TRUE 1
#define FALSE 0
#define DISABLE 0
#define E_OK 0
#define E_GENERAL -1
#define E_EXIT -2


int fBackground = DISABLE;
int ec = E_OK;

int TokenizeString(const char *const str, char ***arr, const char * re, int);
int ProcessCommandLine(char *commandLine);
int ProcessSingleCommand(char *command);
int ProcessPipes(char *command, char ***outputSplit);
int CreateEnvironment();

int ExecuteCommandInBackground(char **arguments, int *returnValue);
char ** GetEnvPath(char **options);
char * environment;
void RemoveEscapeSpace(char *str);

int 
main(int argc, char *argv[])
{
    CreateEnvironment();
    char inputCommand[MAX_SIZE];
    while(1)
    {
        printf("> ");
        fgets(inputCommand, MAX_SIZE, stdin);
        inputCommand[strlen(inputCommand) - 1] = '\0';
        ec = ProcessCommandLine(inputCommand);
        if (ec == E_EXIT)
            break;

    }
}

int CreateEnvironment()
{
    environment = getenv("PATH");
}

int 
ProcessCommandLine(char *commandLine)
{
    char **commandArray;
    const char *commaRegEx = "[^,]+ *";
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
                return E_EXIT;
        }
    }
    

}

int
ProcessSingleCommand(char *command)
{
    char **commandOptions;
    char *spaceRegEx = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")";
    int numberOfCommands = TokenizeString(command, &commandOptions, spaceRegEx, TRUE);
    if (numberOfCommands < 0)
        return numberOfCommands;
    if(strcmp(commandOptions[0], EXIT) == 0)
        return E_EXIT;
    commandOptions = (char **) realloc(commandOptions, (3) * sizeof(char *));
    commandOptions[numberOfCommands] = NULL;
    int processReturnValue;
    commandOptions = GetEnvPath(commandOptions);        
    int returnValue = ExecuteCommandInBackground(commandOptions, &processReturnValue);
    if (returnValue != 0)
    {
        return returnValue;
    }
    return E_OK;
}

int
ProcessPipes(char *command, char ***outputSplit)
{
    const char *pipingRegex = "[^—]+ *";
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
ExecuteCommandInBackground(char **arguments, int *returnValue)
{
    char *path = arguments[0];
    int pid = fork();
    if (pid == -1)
        return errno;
    else if (pid == 0)
    {
        ec = execv(path, arguments);
        return errno;
    }
    else
    {
        int retVal = 0;
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
                    snprintf(buffer, MAX_SIZE, "%s: %d %s - %d", "The process with pid", pid, "exited with error code", retVal);
                    write(STDOUT_FILENO, buffer, strlen(buffer));
                    return E_OK; //Design choice to print child exit status and return parent exit code
                }
                else if (WIFSIGNALED(wstatusg))
                {
                    signalCode = WTERMSIG(wstatusg);
                    snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d", "The process with pid", pid, "signalled with signal code", signalCode);
                    write(STDOUT_FILENO, buffer, strlen(buffer));
                    return E_OK;
                }
                else if (__WCOREDUMP(wstatusg))
                {
                    snprintf(buffer, MAX_SIZE, "%s: %d %s", "The process with pid", pid, "was core dumped");
                    return E_OK;
                }
            }
            return E_OK;
    }
}
