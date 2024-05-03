#ifndef REDIRECTION_
    
    #define REDIRECTION_

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>


    #ifndef BASE_
        #include "base.h"
    #endif

    #ifndef ERRORS_
        #include "errors.h"
    #endif

    #define OUTPUT_REDIRECTION ">"
    #define INPUT_REDIRECTION "<"
    #define ERROR_REDIRECTION "2>"

    #define OUTPUT_REDIRECTION_APPEND ">>"
    #define INPUT_REDIRECTION_APPEND "<<"
    #define ERROR_REDIRECTION_APPEND "2>>"

    /// @brief This function checks if there user wants to redirect standard I/O, opens appropriate file and sets 
    /// file numbers appropriately
    /// @param arguments input arguments
    /// @param outfd redirected output file descriptor
    /// @param infd redirected input file descriptor
    /// @param errfd redirected error file descriptor
    /// @param numberOfArguments number of input arguments
    /// @return character final command array with redirection symbols and paths removed

    extern char **RedirectionCheck(char **arguments, int *outfd, int *infd, int *errfd, int numberOfArguments);


    
    extern char *EnvironmentVariableRedirection(char **arguments, int *outfd, int numberOfArguments);

#endif