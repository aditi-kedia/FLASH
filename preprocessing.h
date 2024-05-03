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

    extern int CleanEnvironment(struct HashTable **environmentVariables);
    extern int CreateEnvironment(char **environment, struct HashTable **environmentVariables);
    extern int ProcessCommandLine(char *, const char *environment, int *retVal, struct HashTable **environmentVariables);
    extern int ProcessSingleCommand(char *command, const char *environment, int *retVal, struct HashTable **environmentVariables);
    extern char **GetEnvPath(char **options, const char *environment);

#endif