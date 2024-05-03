#ifndef ERRORS_
    #define ERRORS_

    #include <errno.h>

    #define E_OK 0
    #define E_GENERAL -1
    #define E_EXIT -2
    #define E_INCORRECT_ARGS -3
    #define MEMORY_ALLOC_FAILURE -4
    #define SIGNALED -6
    #define CORE_DUMPED -7

#endif