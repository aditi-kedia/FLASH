#ifndef PIPING_
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


    extern char **PreprocessCommandsForPipe(char *, int *, const char *environment);
    extern int ProcessPipes(char *, char ***);
    extern int ProcessMultiplePipes(char **, int, const char *environment, int *retVal);

    #define PIPING_

#endif