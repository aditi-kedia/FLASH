#ifndef ENVVAR_
    #define ENVVAR_

    #define RET_VAL_VAR "?"
    #define ASCII_UPPER_A 65
    #define ASCII_UPPER_Z 90

    #ifndef BASE_
        struct HashTable {
        struct Node *HashTable[15];
        int numberOfElements, capacity;
        };

        struct Node{
            char *key;
            char *value;
            struct Node *next;
        };
        #include <string.h>
        #include <stdio.h>
        #include <stdlib.h>
    #endif

    #ifndef PREPROCESSING_
        #include "preprocessing.h"
    #endif
    extern void SetNode(struct Node* node, char* key, char* value);
    extern int HashFunction(struct HashTable* mp, char* key);
    extern void Insert(struct HashTable* mp, char* key, char* value);
    extern void DeleteNode(struct HashTable* mp, char* key);
    extern char* Search(struct HashTable* mp, char* key);
    extern int GetEnvironmentVariable(char *getCommand, int *, struct HashTable **environmentVariables, int outFd);
    extern int SetEnvironmentVariable(char *setCommand, struct HashTable **environmentVariables);
    extern int CheckKey(char *key);
#endif

