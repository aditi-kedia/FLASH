#include "base.h"
#include "errors.h"
#include "parsing.h"
#include "execution.h"
#include "envvar.h"
#include "preprocessing.h"



int 
main(int argc, char *argv[])
{
    int retVal = 0;
    char *workingDirectory;
    char *user;
    int ec = E_OK;
    char *hostName;
    char *environment;
    struct HashTable *environmentVariables;

    if(CreateEnvironment(&environment, &environmentVariables))
    {
        goto CLEANUP;
    }
    char inputCommand[MAX_SIZE];
    struct utsname info;

    if (uname(&info) == 0) {
        hostName = info.nodename;
    }
    while(1)
    {
        RESTART:
        workingDirectory = getcwd(workingDirectory, MAX_SIZE);
        if (workingDirectory == NULL)
            goto RESTART;
        user = getlogin();
        // printf("%s@%s:%s$ ", user, host, workingDirectory);
        printf("\x1b[32m\033[1m%s@%s\x1b[0m:\x1b[34m\033[1m%s\x1b[0m\033[0m$ ", user, hostName, workingDirectory);
        fgets(inputCommand, MAX_SIZE, stdin);
        inputCommand[strlen(inputCommand) - 1] = '\0';
        ec = ProcessCommandLine(inputCommand, environment, &retVal, &environmentVariables);
        if (ec == E_EXIT)
            break;
    }
    CLEANUP:
    CleanEnvironment(&environmentVariables, &environment);
}