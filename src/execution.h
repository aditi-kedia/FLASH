#ifndef EXECUTION_

    #define EXECUTION_

    #include <errno.h>
    #include <unistd.h>
    #include <sys/types.h>
    #include <sys/wait.h>

    #ifndef BASE_
        #include "base.h"
    #endif

    #ifndef ERRORS_
        #include "errors.h"
    #endif

    #ifndef REDIRECTION_
        #include "redirection.h"
    #endif

    #define MAX_SIZE 1024

    extern int ExecuteCommandInForeground(char **, int *, int, int *retVal);
    extern int PipedExecution(char ***, int, int *, int *retVal);
    extern int ExecuteCommandInBackground(char **arguments, int numberOfArguments);

#endif