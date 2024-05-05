#include "piping.h"

/// @brief 
/// @param command The string to be parsed
/// @param numberOfCommands pointer to variable where number of commands will be saved
/// @param environment string containing the value of PATH environment variable
/// @return pointer to array of parsed commands
char **
PreprocessCommandsForPipe(char *command, int *numberOfCommands, const char *environment)
{
    char **commandOptions;
    char *spaceRegEx = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")"; //regex to spilt on space and to ignore escape character spaces and double inverted commas
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

    commandOptions = (char **) realloc(commandOptions, (*numberOfCommands + 1) * sizeof(char *));
    if (commandOptions == NULL)
        return NULL;

    commandOptions[numCommands] = NULL;
    
    if (strcmp(commandOptions[numCommands - 1], HASH) == 0) //TODO: Regex instead of comparison
    {
        perror("\nUnexpected pipe symbol while attempting to run in background\n");
        return NULL;
    }
    return commandOptions;
}


/// @brief Splits a string to be piped into separate command lines and processes it for execution
/// @param command The command line to be split
/// @param outputSplit The pointer to the array of pipe command lines
/// @return number of pipes found
int
ProcessPipes(char *command, char ***outputSplit)
{
    const char *pipingRegex = "[^—]+"; //regex to split on pipe
    int numberOfPipes = TokenizeString(command, outputSplit, pipingRegex, FALSE);
    if (numberOfPipes < 0)
        return numberOfPipes;
}


/// @brief Processes an array of command lines to be piped and then executes the string
/// @param pipes the array of command lines
/// @param numberOfPipes the number of pipes found
/// @param environment string containing the value of PATH environment variable
/// @param retVal The pointer to the return value after execution
/// @return 0 in case of successful execution, errno value or specifed error value.
int
ProcessMultiplePipes(char **pipes, int numberOfPipes, const char *environment, int *retVal)
{
    char ***pipeCommands = (char ***) malloc((numberOfPipes + 1) * sizeof(char **));

    if (pipeCommands == NULL)
        return E_GENERAL; 

    int *numberOfCommands = (int *)malloc(numberOfPipes * sizeof(int));

    if (numberOfCommands == NULL)
    {
        free(pipeCommands);
        return E_GENERAL;
    }

    int *commandCountArray = numberOfCommands;

    for (int i = 0; i < numberOfPipes; i ++)
    {

        char **commandOptions = PreprocessCommandsForPipe(pipes[i], commandCountArray, environment);
        if (commandOptions == NULL)
        {
            free(pipeCommands);
            free(numberOfCommands);
            return E_GENERAL;
        }
        else
        {
            pipeCommands[i] = commandOptions;
        }
        commandCountArray++;
    }
    pipeCommands[numberOfPipes] = NULL;
     
    int err = PipedExecution(pipeCommands, numberOfPipes, numberOfCommands, retVal, environment);
    free(pipeCommands);
    free(numberOfCommands);
    return err;
}
