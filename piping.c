#include "piping.h"


char **
PreprocessCommandsForPipe(char *command, int *numberOfCommands, const char *environment)
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
    else if (strcmp(commandOptions[0], SET) == 0 && *numberOfCommands == 2)
    {
        perror("\nCannot set environment variable while attempting to pipe.\n");
        return NULL;
    }
    else if (strcmp(commandOptions[0], GET) == 0 && *numberOfCommands == 2)
    {
        perror("\nCannot get environment variable while attempting to pipe.\n");
        return NULL;
    }

    commandOptions = (char **) realloc(commandOptions, (3) * sizeof(char *));
    commandOptions[numCommands] = NULL;
    
    commandOptions = GetEnvPath(commandOptions, environment);  

    if (strcmp(commandOptions[numCommands - 1], HASH) == 0) //TODO: Regex instead of comparison
    {
        perror("\nUnexpected pipe symbol while attempting to run in background\n");
        return NULL;
    }
    return commandOptions;
}


int
ProcessPipes(char *command, char ***outputSplit)
{
    const char *pipingRegex = "[^|]+";
    int numberOfPipes = TokenizeString(command, outputSplit, pipingRegex, FALSE);
    if (numberOfPipes < 0)
        return numberOfPipes;
}


int
ProcessMultiplePipes(char **pipes, int numberOfPipes, const char *environment, int *retVal)
{
    char ***pipeCommands = (char ***) malloc((numberOfPipes + 1) * sizeof(char **));
    int *numberOfCommands = (int *)malloc(numberOfPipes * sizeof(int));
    int *commandCountArray = numberOfCommands;
    for (int i = 0; i < numberOfPipes; i ++)
    {

        char **commandOptions = PreprocessCommandsForPipe(pipes[i], commandCountArray, environment);
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
     
    int err = PipedExecution(pipeCommands, numberOfPipes, numberOfCommands, retVal);
    free(pipeCommands);
    free(numberOfCommands);
    return err;
}
