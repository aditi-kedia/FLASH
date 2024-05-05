# FLASH

## Usage
```Bash
    make
    ./bin/flash
```

## Description

FLASH is a simple shell that supports basic redirection, piping, and simple command esecution. It also has support for storing environment variables and getting the value of the stored variables.

As a design choice, I chose to use regular expressions to parse the given input string. For this parsing, I created a heirarchy starting with commas for separate command lines followed by pipes and lastly spaces. To provide convenience, the space parser also has support for inverted commas `" "`and escape character and space `\ `, letting the user include strings that contain spaces in their arguments. 

This also allowed us to parse for and pipe multiple command lines, and hence our program can be used to parse, for example, `ls -l | head -n 5 | wc`. While executing multiple pipes, our program implements killing of processes that do not need to run. For example, if the 3rd process in the pipe has ended but the 2nd has not, the 2nd process will be killed. This does not affect the 4th process if any.

We also have support for redirection of an input/output allong with the append version of the same as specified by `<<` or `>>` and the stderror version as well. We can also redirect output of the get command for the environment variable. Similarly, redirection can also be used within pipes when appropriate. 

In out shell, the names of default commands can be used rather than the full path. This is because I have used the PATH environment variable to obtain the final paths for these commands.

Our program also supports background execution with the use of `#` at the end of a single command line. Please not that both the `#` and the redirection operators need to be separated by at least one or more spaces from other parts of the command line. Due to lack of time, I could not implement regular expressions for these parts.
