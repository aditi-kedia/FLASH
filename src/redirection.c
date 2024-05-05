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
    char **finalArguments = (char **) malloc ((numberOfArguments + 1) * sizeof(char *));
    if (finalArguments == NULL)
        return NULL;
    int j = 0;
    if (numberOfArguments == 1)
    {
        finalArguments[0] = arguments[0];
        finalArguments[1] = NULL;
        return finalArguments;
    }
    for (int i = 0; i < numberOfArguments;)
    {
        if (strcmp(arguments[i], OUTPUT_REDIRECTION) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *outfd = open(arguments[i + 1], O_WRONLY);
                if (*outfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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
                if (*outfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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
                if (*infd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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
                if (*infd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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
                if (*errfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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
                if (*errfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
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

/// @brief Takes a get command line and obtains the variable name. Also redirects the output to specified file
/// @param arguments array of arguments in the get command line
/// @param outfd pointer to the output file descriptor
/// @param numberOfArguments The number of arguments present in the command line
/// @return String name of the environment variable requested by the user
char *
EnvironmentVariableRedirection(char **arguments, int *outfd, int numberOfArguments)
{
    int j = 0;
    char *finalArguments = (char *) malloc (numberOfArguments * 16);
    if (finalArguments == NULL)
        return NULL;   
    for (int i = 0; i < numberOfArguments;)
    {
        if (strcmp(arguments[i], OUTPUT_REDIRECTION) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *outfd = open(arguments[i + 1], O_WRONLY | O_CREAT);
                if (*outfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
                i += 2;
            }
            else
            {
                perror("Syntax error - please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], OUTPUT_REDIRECTION_APPEND) == 0)
        {
            if (i + 1 < numberOfArguments)
            {
                *outfd = open(arguments[i + 1], O_WRONLY | O_CREAT | O_APPEND);
                if (*outfd == E_GENERAL)
                {
                    perror("Could not open the redirection file");
                    return NULL;
                }
                i += 2;
            }
            else
            {
                perror("Syntax error - please mention path to redirect to");
                return NULL;
            }
        }
        else if (strcmp(arguments[i], GET) == 0)
        {
            if (i + 1 < numberOfArguments)
                finalArguments = arguments[i + 1];
            i += 2;
        }
        else
        {
            i++;
        }
    }
    return finalArguments;
}