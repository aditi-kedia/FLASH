#ifndef EXECUTION_

    #define EXECUTION_

    #include <errno.h>
    #include <unistd.h>
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <signal.h>

    #ifndef BASE_
        #include "base.h"
    #endif

    #ifndef ERRORS_
        #include "errors.h"
    #endif
    #ifndef PREPROCESSING_
        #include "preprocessing.h"
    #endif
    #ifndef REDIRECTION_
        #include "redirection.h"
    #endif

    #define MAX_SIZE 1024

    /// @brief Given an input command, it executes this and stores the return value. In case of errors, appropriate message is displayed.
    /// @param arguments The array of arguments (Null terminated) to be executed
    /// @param returnValue The pointer to an integer variable to store the return value of the program
    /// @param numberOfArguments Number of arguments passed to the program
    /// @param retVal The pointer to an integer variable to store the return value of the program
    /// @param environment A string containing the value of the PATH environment variable
    /// @return 0 if successful else appropriate value of errno or defined error code
    extern int ExecuteCommandInForeground(char **, int *, int, int *retVal, const char *environment);

    /// @brief Takes in an array of array of commands and pipes them together, executing them all
    /// @param pipeCommandList Pointer to the array of array of commands
    /// @param numberOfPipes Number of pipe command lines
    /// @param numberOfCommands Pointer to array of number of commands for every pipe command line
    /// @param retVal The pointer to an integer variable to store the return value of the program
    /// @param environment A string containing the value of the PATH environment variable
    /// @return 0 in case of success or errno or defined error code
    extern int PipedExecution(char ***, int, int *, int *retVal, const char *environment);

    /// @brief Executes a simple command line in the background
    /// @param arguments array of arguments for the command line
    /// @param numberOfArguments number of arguments in the command line
    /// @param environment A string containing the value of the PATH environment variable
    /// @return 0 if successful else value of errno or defined error codes
    extern int ExecuteCommandInBackground(char **arguments, int numberOfArguments, const char *environment);

#endif