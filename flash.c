#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#define MAX_SIZE 1024
#define EXIT "exit"

#define ENABLE 1
#define DISABLE 0


int fBackground = DISABLE;

// int ProcessCommandLine(char *);

int 
main(int argc, char *argv[])
{
    char inputCommand[MAX_SIZE];
    while(1)
    {

        printf("> ");
        fgets(inputCommand, MAX_SIZE, stdin);
        inputCommand[strlen(inputCommand) - 1] = '\0';
        if (strcmp(inputCommand, EXIT) == 0)
            break;
        else if (strcmp(strtok(inputCommand, " "), "set") == 0)
        {
            printf("\nset loop entered\n");
        }
        else if(strcmp(strtok(inputCommand, " "), "get") == 0)
        {
            printf("\nget loop entered\n");
        }
        // ProcessCommandLine(inputCommand);

        printf("This is what you entered: %s\n", inputCommand);
    }
}

int
ProcessCommandLine(char *input)
{
    if(input[strlen(input) - 1] == '#')
    {
        fBackground = ENABLE;
    }
    char **executableArray;
    int numberOfExecutables = TokenizeString(input, ",", &executableArray);
    if (executableArray[0] != NULL)
    {
        for (int i = 0; i < numberOfExecutables; i ++)
        {   
            ExecuteCommandLine(executableArray[i]);
        }   
    }

}

int ExecuteCommandLine(char *commandLine)
{
    char **pipes;
    int numberOfPipes = TokenizeString(commandLine, "—", &pipes);
    switch (numberOfPipes)
    {
    case 1:
        SingleProgramExecution(commandLine);
        break;
    case 2:
        PipedExecution(pipes);
        break;
    default:
        printf("Too many pipes given in program");
        break;
    }
}

int SingleProgramExecution(char* commandLine)
{
    char path[MAX_SIZE];
    int i = 0;
    while (i < strlen(commandLine) && commandLine[i] == ' ') //Ignore whitespace at the start unless specified by '\'
        i++;
    
    for (i; i < strlen(commandLine); i ++)
    {
        if (commandLine[i] = ' ' && commandLine[i-1] )
            path[i] = commandLine[i];
    }

}


//  function: VectorizeString
//      This function takes a string of character options as well as executable path and
//      constructs a null terminated array of strings that can be passed to the execv() 
//      system call. The format of the array is similar to the command line options received
//      by processes as command line arguments. 
//  @param: pointer to a character array containing options string
//  @param: pointer to a character array containing an executable path
//  @return: pointer to the vectorized array of strings
char ** 
VectorizeString(char *optionsString, char *path)
{
    if (optionsString == "none")
    {
        char **options = (char **) calloc(2, sizeof(char *)); //gets a pointer to an array of pointers
        options[0] = path;
        options[1] = NULL;
        return options;
    }
    int i = 0;
    int elementCount = 1; //Set to one because an array without spaces still has one element
    int length = strlen(optionsString + 1); // 
    for (i = 0; i < length; i ++)
    {
        if(optionsString[i] == ' ')
            elementCount++; //checks for number of spaces in the array
    }

    char **options = (char **) calloc(elementCount + 2, sizeof(char *)); // Is + 2 because of the addition of the path at the start and the null character at the end
    options[0] = path;
    char * token = strtok(optionsString, " "); //splits the string on spaces and appends to argument array
    i = 1;
    while( token != NULL ) {
        options[i++] = token; 
        token = strtok(NULL, " "); 
    }
    options[i] = NULL; //terminates array with null character
    return options;
}


int
TokenizeString(char *inputString, char *delimiter, char ***outputArray)
{
    int i = 0;
    int elementCount = 1; //Set to one because an array without delimiters still has one element
    int length = strlen(inputString);
    for (i = 0; i < length; i ++)
    {
        if (i != length - 1)
        {
            if(inputString[i] == delimiter[0])
                elementCount++; //checks for number of delimiters in the array
        }
    }
    
    char **tokens = (char **) calloc(elementCount, sizeof(char *));
    if (tokens == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return -1;
    }
    i = 0;
    char *token = strtok(inputString, delimiter);
    while (token != NULL && i < elementCount) {
        tokens[i++] = token; 
        token = strtok(NULL, delimiter); 
    }
    (*outputArray) = tokens;
    return elementCount;
}


int TokenizeString(const char *const str, char ***arr)
{
    //static const char *const re = "(([^ ]+([\\] )*)+)|(\"[^\"]*\")";
    static const char *const re = " *, *";
    const char *s = str;
    regex_t     regex;
    regmatch_t  pmatch[1];
    regoff_t    off, len;
    int arraySize = 0;

    if (regcomp(&regex, re, REG_NEWLINE | REG_EXTENDED))
        return -1;

    char **array = (char **) malloc(sizeof(char *));
    for (int i = 0; ; i++) {
        if (regexec(&regex, s, ARRAY_SIZE(pmatch), pmatch, 0))
            break;
        arraySize++;
        array = (char **) realloc(array, arraySize * sizeof(char *));
        
        off = pmatch[0].rm_so + (s - str);
        len = pmatch[0].rm_eo - pmatch[0].rm_so;
       
        char *buf = (char *) malloc(len);
        snprintf(buf, 1024, "%.*s", len, s + pmatch[0].rm_so);
        if (buf[0] == '"')
        {
            buf += 1;
            buf[strlen(buf) - 1] = '\0';
        }
        remove_escape_space(buf);
        array[arraySize - 1] = buf;
        s += pmatch[0].rm_eo;
    }
    *arr = array;
    return arraySize;
}