#include "preprocessing.h"

/// @brief Frees the environment variables
/// @param environmentVariables Hashtable of environment variables
/// @param environment String containing the value of the PATH environment variable
/// @return 0 if successful
int 
CleanEnvironment(struct HashTable **environmentVariables, char **environment)
{
    free(*environmentVariables);
    free(*environment);
    return E_OK;
}

/// @brief Creates the environment for the program by allocating memory to environment and environment hash table
/// @param environment Pointer to the string where the value of PATH environment variable will be stored.
/// @param environmentVariables Pointer to the hashtable that will be created
/// @return 0 if the allocations are successful else 1
int 
CreateEnvironment(char **environment, struct HashTable **environmentVariables)
{
    char *env = getenv("PATH");
     if (env == NULL)
        return 1;
    *environment = (char *) malloc(strlen(env));
    strcpy(*environment, env);
    if (*environment == NULL)
        return 1;
    *environmentVariables = (struct HashTable *) malloc(sizeof(struct HashTable));
    if (environmentVariables == NULL)
        return 1;
    (*environmentVariables) -> capacity = 15;
    (*environmentVariables) -> numberOfElements = 0;
    return 0;
}

/// @brief Processes the input command line, parsing it according to the design decisions and executing the commands as required.
/// @param commandLine The command line received from the user
/// @param environment String containing the value of the PATH environment variable
/// @param retVal Pointer to the return value of the previously executed program
/// @param environmentVariables Hashtable containing the environment variables
/// @return 0 if successful, errno in case of errors and -2 in case of exit request by the user
int 
ProcessCommandLine(char *commandLine, const char *environment, int *retVal, struct HashTable **environmentVariables)
{
    char **commandArray;
    int ec = E_OK;
    const char *commaRegEx = "[^,]+ *|(\"[^\"]*\")"; //regex to split a string on comma while ignoring double inverted commas
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
            ec = ProcessSingleCommand(pipes[0], environment, retVal, environmentVariables);
            if (ec == E_EXIT)
            {
                free(pipes);
                free(commandArray);
                return E_EXIT;
            }
        }
        else 
        {
            ec = ProcessMultiplePipes(pipes, numberOfPipes, environment, retVal);
            free(pipes);
        }
    }
    free(commandArray);
    return ec;
}

/// @brief Processes a single command, splitting it on spaces and ignoring inverted commas and escape characters. Also accounts for setting variables
///        by parsing the form a="" or a=b\ . Executes this command or sets/gets the environment variable.
/// @param command The command string to be parsed and executed
/// @param environment String containing the value of the PATH environment variable
/// @param retVal Pointer to the return value of the previously executed program
/// @param environmentVariables Hashtable containing the environment variables
/// @return 0 in case of successful execution, errno in case of failures and pre-defined error codes
int
ProcessSingleCommand(char *command, const char *environment, int *retVal, struct HashTable **environmentVariables)
{
    int ec = E_OK;
    char **commandOptions;
    char *spaceRegEx = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")|([^ ]+=((([^ ]+([\\] )*)+)|(\"[^\"]*\")))"; //regex to parse on space and ignoring escape characters and inverted commas
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
            ec = SetEnvironmentVariable(commandOptions[1], environmentVariables);
            return ec;
        }
        else
            return -4;
    }
    else if (strcmp(commandOptions[0], GET) == 0)
    {
        if (numberOfCommands == 2)
        {
            ec = GetEnvironmentVariable(commandOptions[1], retVal, environmentVariables, STDOUT_FILENO);
            return ec;
        }
        else if (numberOfCommands > 2)
        {
            int outFd = STDOUT_FILENO;
            char *name = EnvironmentVariableRedirection(commandOptions, &outFd, numberOfCommands);

            ec = GetEnvironmentVariable(name, retVal, environmentVariables, outFd);
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
    commandOptions = (char **) realloc(commandOptions, (numberOfCommands + 1) * sizeof(char *));
    if (commandOptions == NULL)
        return MEMORY_ALLOC_FAILURE;

    commandOptions[numberOfCommands] = NULL;
    
    commandOptions = GetEnvPath(commandOptions, environment);  

    if (strcmp(commandOptions[numberOfCommands - 1], HASH) == 0)
    {
        commandOptions[numberOfCommands - 1] = NULL;
        ExecuteCommandInBackground(commandOptions, numberOfCommands, environment);
    }
    else
    {
        int processReturnValue;
 
        int returnValue = ExecuteCommandInForeground(commandOptions, &processReturnValue, numberOfCommands, retVal, environment);
        if (returnValue != 0)
        {
            free(commandOptions);
            return returnValue;
        }
    }
    free(commandOptions);
    return E_OK;
}


/// @brief Takes an array of arguments for a command line and checks whether the command requested is present in the PATH environment paths. 
///        If yes then this path is apended to the command
/// @param options The array of commands
/// @param environment String contianing the value of the PATH environment variable
/// @return Pointet to the array of arguments with the PATH environment path attached if present
char ** 
GetEnvPath(char **options, const char *environment)
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
