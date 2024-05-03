#ifndef PIPING_

    #define PIPING_

    #ifndef BASE_
        #include "base.h"
    #endif

    #ifndef PARSING_
        #include "parsing.h"
    #endif

    #ifndef EXECUTION_
        #include "execution.h"
    #endif

    #ifndef PREPROCESSING_
        #include "preprocessing.h"
    #endif

    /// @brief Splits a string to be piped into separate command lines and processes it for execution
    /// @param command The string to be parsed
    /// @param numberOfCommands pointer to variable where number of commands will be saved
    /// @param environment string containing the value of PATH environment variable
    /// @return pointer to array of parsed commands

    extern char **PreprocessCommandsForPipe(char *, int *, const char *environment);

    /// @brief Splits a string to be piped into separate command lines and processes it for execution
    /// @param command The command line to be split
    /// @param outputSplit The pointer to the array of pipe command lines
    /// @return number of pipes found

    extern int ProcessPipes(char *, char ***);

    /// @brief Processes an array of command lines to be piped and then executes the string
    /// @param pipes the array of command lines
    /// @param numberOfPipes the number of pipes found
    /// @param environment string containing the value of PATH environment variable
    /// @param retVal The pointer to the return value after execution
    /// @return 0 in case of successful execution, errno value or specifed error value.

    extern int ProcessMultiplePipes(char **, int, const char *environment, int *retVal);

#endif