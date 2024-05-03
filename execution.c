#include "execution.h"
#include "errors.h"

int
ExecuteCommandInForeground(char **arguments, int *returnValue, int numberOfArguments, int *retVal)
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
        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                return errno;
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                return errno;
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                return errno;
            }
        }

        if (arguments == NULL)
            return -3;
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
                snprintf(buffer, MAX_SIZE, "%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", *retVal);
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



int PipedExecution(char ***pipeCommandList, int numberOfPipes, int *numberOfCommands, int *retVal)
{
    int fd[2];
	pid_t pid;
	int fdd = 0;				/* Backup */

	while (*pipeCommandList != NULL) {
        // int outfd = STDOUT_FILENO;
        // int infd = STDIN_FILENO;
        // int errfd = STDERR_FILENO;
        // char **arguments = RedirectionCheck(*pipeCommandList, &outfd, &infd, &errfd, *numberOfCommands);
		pipe(fd);				/* Sharing bidiflow */
		if ((pid = fork()) == -1) {
			perror("fork");
            exit(errno);
		}
		else if (pid == 0) {

			dup2(fdd, 0);
			if (*(pipeCommandList + 1) != NULL) {
				dup2(fd[1], 1);
			}
            
			close(fd[0]);
			execv(*pipeCommandList[0], *pipeCommandList);
			exit(errno);
		}
		else 
        {
            char buffer[MAX_SIZE];
            int signalCode;
            int wstatusg;
            if (*(pipeCommandList + 1) == NULL)
            {
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
                        snprintf(buffer, MAX_SIZE, "%s: %d %s - %d\n", "The process with pid", pid, "exited with error code", *retVal);
                        write(STDOUT_FILENO, buffer, strlen(buffer));
                        return E_OK; //Design choice to print child exit status and return parent exit code
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
            else
            {
                wait(NULL);
                close(fd[1]);
                fdd = fd[0];
                pipeCommandList++;
                numberOfCommands++;
            }
	    }
    }
    return E_OK;
}


int
ExecuteCommandInBackground(char **arguments, int numberOfArguments)
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

        if (outfd != STDOUT_FILENO)
        {
            if (dup2(outfd, STDOUT_FILENO) == -1)
            {
                return errno;
            }
        }
        if (infd != STDIN_FILENO)
        {
            if (dup2(infd, STDIN_FILENO) == -1)
            {
                return errno;
            }
        }
        if (errfd != STDERR_FILENO)
        {
            if (dup2(errfd, STDERR_FILENO) == -1)
            {
                return errno;
            }
        }

        if (arguments == NULL)
            return -3;
        
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


