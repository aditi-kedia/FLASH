#include "redirection.h"

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