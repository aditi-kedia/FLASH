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

    extern int ExecuteCommandInForeground(char **, int *, int, int *retVal, const char *environment);
    extern int PipedExecution(char ***, int, int *, int *retVal, const char *environment);
    extern int ExecuteCommandInBackground(char **arguments, int numberOfArguments, const char *environment);

#endif