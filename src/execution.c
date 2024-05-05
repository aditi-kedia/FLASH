#include "execution.h"

/// @brief Given an input command, it executes this and stores the return value. In case of errors, appropriate message is displayed.
/// @param arguments The array of arguments (Null terminated) to be executed
/// @param returnValue The pointer to an integer variable to store the return value of the program
/// @param numberOfArguments Number of arguments passed to the program
/// @param retVal The pointer to an integer variable to store the return value of the program
/// @param environment A string containing the value of the PATH environment variable
/// @return 0 if successful else appropriate value of errno or defined error code
int
ExecuteCommandInForeground(char **arguments, int *returnValue, int numberOfArguments, int *retVal, const char *environment)
{
    int pid = fork();
    if (pid == E_GENERAL)
        return errno;
    else if (pid == 0)
    {
        int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
            
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments); //changes stdout and stdin of the first and last pipe command line to the one specified by the user
        arguments = GetEnvPath(arguments, environment);  // Appending default paths from the environment if applicable

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }

        if (arguments == NULL)
            exit(E_INCORRECT_ARGS);
        char *path = arguments[0];
        int error = execv(path, arguments);
        printf("Could not find any such command: %s\n", path);
        exit(errno);
    }
    else
    {
        char buffer[MAX_SIZE];
        int signalCode;
        int wstatusg;
        int w = waitpid(pid, &wstatusg, WUNTRACED);
        if (w == E_GENERAL)
            return errno;

        if (&wstatusg != NULL)
        {
            if (WIFEXITED(wstatusg))
            {
                *retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0, stores it in return environment variable
                if (*retVal == E_OK)
                    return E_OK;
                snprintf(buffer, MAX_SIZE, "\n%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", *retVal);
                printf("%s", buffer);
                return E_OK; //Design choice to print child exit status and return parent exit code
            }
            else if (WIFSIGNALED(wstatusg)) //checks for possible signals
            {
                *retVal = SIGNALED;
                signalCode = WTERMSIG(wstatusg);
                snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                printf("%s", buffer);
                return E_OK;
            }
            else if (__WCOREDUMP(wstatusg)) //checks for possible core dumps
            {
                *retVal = CORE_DUMPED;
                snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                printf("%s", buffer);
                return E_OK;
            }
        }
        return E_OK;
    }
}


/// @brief Takes in an array of array of commands and pipes them together, executing them all
/// @param pipeCommandList Pointer to the array of array of commands
/// @param numberOfPipes Number of pipe command lines
/// @param numberOfCommands Pointer to array of number of commands for every pipe command line
/// @param retVal The pointer to an integer variable to store the return value of the program
/// @param environment A string containing the value of the PATH environment variable
/// @return 0 in case of success or errno or defined error code
int 
PipedExecution(char ***pipeCommandList, int numberOfPipes, int *numberOfCommands, int *retVal, const char *environment)
{
    int fd[2];
	pid_t pid;
	int fdd = 0;	
    int i = 0;
    char **arguments;
    int *pipedPids = (int *) malloc(numberOfPipes * sizeof(int));
    if (pipedPids == NULL)
        return MEMORY_ALLOC_FAILURE;

	while (*pipeCommandList != NULL) {
		pipe(fd);	
		if ((pid = fork()) == E_GENERAL) 
        {
			perror("fork");
            exit(errno);
		}
		else if (pid == 0) 
        {
            int outfd = STDOUT_FILENO;
            int infd = STDIN_FILENO;
            int errfd = STDERR_FILENO;
            
            arguments = RedirectionCheck(*pipeCommandList, &outfd, &infd, &errfd, *numberOfCommands);
            arguments = GetEnvPath(arguments, environment);  // Appending default paths from the environment if applicable

            if (outfd != STDOUT_FILENO)
            {
                if (i != numberOfPipes - 1)
                {
                    printf("%s\n", "Cannot redirect output in this part of the pipe");
                    if (close(outfd))
                        exit(errno);
                    exit(E_GENERAL);
                }
                else if (dup2(outfd, STDOUT_FILENO) == E_GENERAL) //To support redirection in the last command
                {
                    exit(errno);
                }
            }
            if (infd != STDIN_FILENO)
            {
                if (i != 0)
                {
                    printf("%s\n", "Cannot redirect input in this part of the pipe\n");
                    if (close(infd))
                        exit(errno);
                    exit(E_GENERAL);

                }
                else if (dup2(infd, STDIN_FILENO) == E_GENERAL) //To support redirection in the first command
                {
                    exit(errno);
                }
            }
            if (errfd != STDERR_FILENO)
            {
                if (dup2(errfd, STDERR_FILENO) == E_GENERAL)
                {
                    exit(errno);
                }
            }

            if (arguments == NULL)
                exit(E_INCORRECT_ARGS);
            
			if(dup2(fdd, 0) == E_GENERAL)
                exit(errno);

			if (*(pipeCommandList + 1) != NULL) 
            {
				if(dup2(fd[1], 1) == E_GENERAL)
                    exit(E_GENERAL);
			}
            
			if(close(fd[0]) == E_GENERAL)
                exit(errno);
			execv(arguments[0], arguments);
			exit(errno);
		}
		else 
        {
            char buffer[MAX_SIZE];
            int signalCode;
            int wstatusg;
            pipedPids[i] = pid;
            i++;
        
            int w = waitpid(-1, &wstatusg, WUNTRACED);
            if (w == E_GENERAL)
            {
                free(pipedPids);
                return errno;
            }
            int k = 0;
            while(pipedPids[k] != w) //In case a process terminates, kill all the processes before this process in the pipeline
            {
                if (kill(pipedPids[k], SIGKILL) == E_GENERAL)
                {
                    if (errno != ESRCH)
                    {
                        free(pipedPids);
                        perror("Could not kill child process\n");
                        return E_OK;
                    }
                }
                k++;
            }
            if (&wstatusg != NULL)
            {
                if (WIFEXITED(wstatusg))
                {
                    *retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0
                    if (*retVal != E_OK)
                    {
                        snprintf(buffer, MAX_SIZE, "%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", *retVal);
                        if(write(STDOUT_FILENO, buffer, strlen(buffer)) == E_GENERAL)
                        {
                            free(pipedPids);
                            return errno;
                        }
                        free(pipedPids);
                        return E_OK; //Design choice to print child exit status and return parent exit code
                    }
                }
                else if (WIFSIGNALED(wstatusg))
                {
                    *retVal = SIGNALED;
                    signalCode = WTERMSIG(wstatusg);
                    free(pipedPids);
                    snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                    if(write(STDOUT_FILENO, buffer, strlen(buffer)) == E_GENERAL)
                        return errno;
                    return E_OK;
                }
                else if (__WCOREDUMP(wstatusg))
                {
                    *retVal = CORE_DUMPED;
                    free(pipedPids);
                    snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                    if(write(STDOUT_FILENO, buffer, strlen(buffer)) == E_GENERAL)
                        return errno;
                    return E_OK;
                }
            }
            if(close(fd[1]) == E_GENERAL)
            {
                free(pipedPids);
                return errno;                
            }
            fdd = fd[0];
            pipeCommandList++;
            numberOfCommands++;       
	    }
    }
    free(pipedPids);
    return E_OK;
}

/// @brief Executes a simple command line in the background
/// @param arguments Array of arguments for the command line
/// @param numberOfArguments number of arguments in the command line
/// @param environment A string containing the value of the PATH environment variable
/// @return 0 if successful else value of errno or defined error codes
int
ExecuteCommandInBackground(char **arguments, int numberOfArguments, const char *environment)
{
     
    int pid = fork();
    if (pid == E_GENERAL)
        return errno;
    else if (pid == 0)
    {
        int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
        arguments[numberOfArguments - 1] = NULL; //removes extra hash
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments - 1); //checking for redirections and opening appropriate files
        arguments = GetEnvPath(arguments, environment);  // Appending default paths from the environment if applicable

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == E_GENERAL)
            {
                exit(errno);
            }
        }

        if (arguments == NULL)
            exit(E_INCORRECT_ARGS);
        
        char *path = arguments[0];
        execv(path, arguments);
        printf("Could not find any such command: %s\n", path);
        exit(errno);
    }
    else
    {
        return E_OK;
    }
}


