#include "preprocessing.h"

int CleanEnvironment(struct HashTable **environmentVariables)
{
    free(*environmentVariables);
}

int CreateEnvironment(char **environment, struct HashTable **environmentVariables)
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

int 
ProcessCommandLine(char *commandLine, const char *environment, int *retVal, struct HashTable **environmentVariables)
{
    char **commandArray;
    int ec = E_OK;
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


int
ProcessSingleCommand(char *command, const char *environment, int *retVal, struct HashTable **environmentVariables)
{
    int ec = E_OK;
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
            ec = GetEnvironmentVariable(commandOptions[1], retVal, environmentVariables);
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
    
    commandOptions = GetEnvPath(commandOptions, environment);  

    if (strcmp(commandOptions[numberOfCommands - 1], HASH) == 0)
    {
        commandOptions[numberOfCommands - 1] = NULL;
        ExecuteCommandInBackground(commandOptions, numberOfCommands);
    }
    else
    {
        int processReturnValue;
 
        int returnValue = ExecuteCommandInForeground(commandOptions, &processReturnValue, numberOfCommands + 1, retVal);
        if (returnValue != 0)
        {
            return returnValue;
        }
    }
   
    return E_OK;
}


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
