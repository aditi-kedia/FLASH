#ifndef ENVVAR_
    #define ENVVAR_

    #define RET_VAL_VAR "?"
    #define ASCII_UPPER_A 65
    #define ASCII_UPPER_Z 90

    #ifndef BASE_
        /// @brief Struct to store a hashtable
        struct HashTable {
        struct Node *HashTable[15];
        int numberOfElements, capacity;
        };

        /// @brief Struct to represent a node in the hashtable
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

    /// @brief Function to set the key and value for a newly created node
    /// @param node Pointer to the node you want to set
    /// @param key The key you want to set
    /// @param value The value you want to set
    /// @return void

    extern void SetNode(struct Node* node, char* key, char* value);

    /// @brief Hashes the given key and finds appropriate index
    /// @param mp Pointer to hashmap to be used
    /// @param key Key to be hashed
    /// @return index for the new node

    extern int HashFunction(struct HashTable* mp, char* key);

    /// @brief Inserts a new node into the hashmap based on hash index
    /// @param mp Pointer to hashmap to be used
    /// @param key Key to be hashed
    /// @param value Value to be stored
    /// @return void

    extern void Insert(struct HashTable* mp, char* key, char* value);

    /// @brief Deleted a node based on given key from hashmap
    /// @param mp Pointer to hashmap to be used
    /// @param key Key to be hashed
    /// @return void

    extern void DeleteNode(struct HashTable* mp, char* key);

    /// @brief Searches for a given key in hashmap
    /// @param mp Pointer to hashmap to be used
    /// @param key Key to be hashed
    /// @return the value associated with the key or an error message

    extern char* Search(struct HashTable* mp, char* key);

    /// @brief Function that searches for and retrieves an environment variable if it has been stored
    /// @param getCommand The command associated with the get request
    /// @param retVal Pointer to the return value of the previously executed program. Special environment variable
    /// @param environmentVariables Hashmap of environment variables
    /// @param outFd file descriptor dor final output
    /// @return 0 if successful else returns value of errno

    extern int GetEnvironmentVariable(char *getCommand, int *, struct HashTable **environmentVariables, int outFd);

    /// @brief Sets upto 16 environment variables with value of length upto 240 characters. Succesful only if name is all capitals
    /// @param setCommand The command given to set the variable
    /// @param environmentVariables Hashmap of enviroment variables
    /// @return -5 in case of incorrect number / format of tokens else 0

    extern int SetEnvironmentVariable(char *setCommand, struct HashTable **environmentVariables);

    /// @brief Helper function to check if all the letters are uppercase
    /// @param key The key to be checked
    /// @return 1 if the key has all upercase letters else 0

    extern int CheckKey(char *key);
#endif

