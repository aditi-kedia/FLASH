#ifndef REDIRECTION_
    
    #define REDIRECTION_

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>


    #ifndef BASE_
        #include "base.h"
    #endif

    #define OUTPUT_REDIRECTION ">"
    #define INPUT_REDIRECTION "<"
    #define ERROR_REDIRECTION "2>"

    #define OUTPUT_REDIRECTION_APPEND ">>"
    #define INPUT_REDIRECTION_APPEND "<<"
    #define ERROR_REDIRECTION_APPEND "2>>"

    extern char **RedirectionCheck(char **arguments, int *outfd, int *infd, int *errfd, int numberOfArguments);

#endif