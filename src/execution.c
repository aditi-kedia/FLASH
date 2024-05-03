#include "execution.h"

int
ExecuteCommandInForeground(char **arguments, int *returnValue, int numberOfArguments, int *retVal, const char *environment)
{
    int pid = fork();
    if (pid == -1)
        return errno;
    else if (pid == 0)
    {
        int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
            
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments);
        arguments = GetEnvPath(arguments, environment);  

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                exit(errno);
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                exit(errno);
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                exit(errno);
            }
        }

        if (arguments == NULL)
            exit(-3);
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
                *retVal = WEXITSTATUS(wstatusg); //finds exit status of child if not 0
                if (*retVal == E_OK)
                    return E_OK;
                snprintf(buffer, MAX_SIZE, "\n%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", *retVal);
                printf("%s", buffer);
                return E_OK; //Design choice to print child exit status and return parent exit code
            }
            else if (WIFSIGNALED(wstatusg))
            {
                *retVal = -6;
                signalCode = WTERMSIG(wstatusg);
                snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                printf("%s", buffer);
                return E_OK;
            }
            else if (__WCOREDUMP(wstatusg))
            {
                *retVal = -7;
                snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                printf("%s", buffer);
                return E_OK;
            }
        }
        return E_OK;
    }
}



int PipedExecution(char ***pipeCommandList, int numberOfPipes, int *numberOfCommands, int *retVal, const char *environment)
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
		if ((pid = fork()) == -1) 
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
            arguments = GetEnvPath(arguments, environment);  

            if (outfd != STDOUT_FILENO)
            {
                if (i != numberOfPipes - 1)
                {
                    printf("%s\n", "Cannot redirect output in this part of the pipe");
                    if (close(outfd))
                        exit(errno);
                    exit(-1);
                }
                else if (dup2(outfd, STDOUT_FILENO) == -1)
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
                    exit(-1);

                }
                else if (dup2(infd, STDIN_FILENO) == -1)
                {
                    exit(errno);
                }
            }
            if (errfd != STDERR_FILENO)
            {
                if (dup2(errfd, STDERR_FILENO) == -1)
                {
                    exit(errno);
                }
            }

            if (arguments == NULL)
                exit(-3);
            
			dup2(fdd, 0);
			if (*(pipeCommandList + 1) != NULL) 
            {
				dup2(fd[1], 1);
			}
            
			close(fd[0]);
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
                return errno;
            int k = 0;
            while(pipedPids[k] != w)
            {
                if (kill(pipedPids[k], SIGKILL))
                {
                    if (errno != ESRCH)
                    {
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
                        write(STDOUT_FILENO, buffer, strlen(buffer));
                        return E_OK; //Design choice to print child exit status and return parent exit code
                    }
                }
                else if (WIFSIGNALED(wstatusg))
                {
                    *retVal = -6;
                    signalCode = WTERMSIG(wstatusg);
                    snprintf(buffer, MAX_SIZE,  "%s: %d %s - %d\n", "The process with pid", pid, "signalled with signal code", signalCode);
                    write(STDOUT_FILENO, buffer, strlen(buffer));
                    return E_OK;
                }
                else if (__WCOREDUMP(wstatusg))
                {
                    *retVal = -7;
                    snprintf(buffer, MAX_SIZE, "%s: %d %s\n", "The process with pid", pid, "was core dumped");
                    return E_OK;
                }
            }
            close(fd[1]);
            fdd = fd[0];
            pipeCommandList++;
            numberOfCommands++;       
	    }
    }
    return E_OK;
}


int
ExecuteCommandInBackground(char **arguments, int numberOfArguments, const char *environment)
{
     int outfd = STDOUT_FILENO;
        int infd = STDIN_FILENO;
        int errfd = STDERR_FILENO;
        arguments[numberOfArguments - 1] = NULL;
        arguments = RedirectionCheck(arguments, &outfd, &infd, &errfd, numberOfArguments - 1);
        arguments = GetEnvPath(arguments, environment);  
    int pid = fork();
    if (pid == -1)
        return errno;
    else if (pid == 0)
    {
       

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                exit(errno);
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                exit(errno);
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                exit(errno);
            }
        }

        if (arguments == NULL)
            exit(-3);
        
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


