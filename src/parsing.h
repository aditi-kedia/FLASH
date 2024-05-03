#ifndef PARSING_
    #define PARSING_

    #include <regex.h>

    #ifndef BASE_
        #include <stdlib.h>
        #include <string.h>
        #include <stdio.h>
    #endif

    #ifndef ERRORS_
        #include "errors.h"
    #endif

    #define ARRAY_SIZE(arr) (sizeof((arr)) / sizeof((arr)[0]))

    /// @brief Splits an array based on regular expression specified by the re parameter
    /// @param str string to parse
    /// @param arr array to store the result
    /// @param re regular expression to use for parsing
    /// @param removeSpace 
    /// @return int length of array. If any error is encountered, the error value is returned


    extern int TokenizeString(const char *const , char ***, const char *, int);

    /// @brief Removes escape characters from a given string
    /// @param str The input string
    /// @return void

    extern void RemoveEscapeSpace(char *);
#endif
