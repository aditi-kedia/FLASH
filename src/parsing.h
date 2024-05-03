#ifndef PARSING_
    #define PARSING_

    #include <regex.h>

    #ifndef BASE_
        #include <stdlib.h>
        #include <string.h>
        #include <stdio.h>
    #endif

    #define ARRAY_SIZE(arr) (sizeof((arr)) / sizeof((arr)[0]))


    extern int TokenizeString(const char *const , char ***, const char *, int);
    extern void RemoveEscapeSpace(char *);
#endif
