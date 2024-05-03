#ifndef PREPROCESSING_

    #define PREPROCESSING_

    #ifndef ENVVAR_
        #include "envvar.h"
    #endif

    #ifndef ERRORS_ 
        #include "errors.h"
    #endif

    #ifndef BASE_
        #include "base.h"
    #endif

    #ifndef PIPING_
        #include "piping.h"
    #endif

    /// @brief Frees the environment variables
    /// @param environmentVariables Hashtable of environment variables
    /// @param environment String containing the value of the PATH environment variable
    /// @return 0 if successful
    extern int CleanEnvironment(struct HashTable **environmentVariables, char **environment);

    /// @brief Creates the environment for the program by allocating memory to environment and environment hash table
    /// @param environment Pointer to the string where the value of PATH environment variable will be stored.
    /// @param environmentVariables Pointer to the hashtable that will be created
    /// @return 0 if the allocations are successful else 1
    extern int CreateEnvironment(char **environment, struct HashTable **environmentVariables);

    /// @brief Processes the input command line, parsing it according to the design decisions and executing the commands as required.
    /// @param commandLine The command line received from the user
    /// @param environment String containing the value of the PATH environment variable
    /// @param retVal Pointer to the return value of the previously executed program
    /// @param environmentVariables Hashtable containing the environment variables
    /// @return 0 if successful, errno in case of errors and -2 in case of exit request by the user
    extern int ProcessCommandLine(char *, const char *environment, int *retVal, struct HashTable **environmentVariables);
    
    /// @brief Processes a single command, splitting it on spaces and ignoring inverted commas and escape characters. Also accounts for setting variables
    ///        by parsing the form a="" or a=b\ . Executes this command or sets/gets the environment variable.
    /// @param command The command string to be parsed and executed
    /// @param environment String containing the value of the PATH environment variable
    /// @param retVal Pointer to the return value of the previously executed program
    /// @param environmentVariables Hashtable containing the environment variables
    /// @return 0 in case of successful execution, errno in case of failures and pre-defined error codes
    extern int ProcessSingleCommand(char *command, const char *environment, int *retVal, struct HashTable **environmentVariables);

    /// @brief Takes an array of arguments for a command line and checks whether the command requested is present in the PATH environment paths. 
    ///        If yes then this path is apended to the command
    /// @param options The array of commands
    /// @param environment String contianing the value of the PATH environment variable
    /// @return Pointet to the array of arguments with the PATH environment path attached if present
    extern char **GetEnvPath(char **options, const char *environment);

#endif