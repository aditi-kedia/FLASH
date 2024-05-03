#include "envvar.h"


int HashFunction(struct HashTable* mp, char* key)
{
    int bucketIndex;
    int sum = 0, factor = 31;
    for (int i = 0; i < strlen(key); i++) {
 
        // sum = sum + (ascii value of
        // char * (primeNumber ^ x))...
        // where x = 1, 2, 3....n
        sum = ((sum % mp->capacity)
               + (((int)key[i]) * factor) % mp->capacity)
              % mp->capacity;
 
        // factor = factor * prime
        // number....(prime
        // number) ^ x
        factor = ((factor % __INT16_MAX__)
                  * (31 % __INT16_MAX__))
                 % __INT16_MAX__;
    }
 
    bucketIndex = sum;
    return bucketIndex;
}
 
void Insert(struct HashTable* mp, char* key, char* value)
{
 
    // Getting bucket index for the given
    // key - value pair
    int bucketIndex = HashFunction(mp, key);
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    if (newNode == NULL)
        return;
 
    // Setting value of node
    SetNode(newNode, key, value);
 
    // Bucket index is empty....no collision
    if (mp->HashTable[bucketIndex] == NULL) {
        mp->HashTable[bucketIndex] = newNode;
    }
 
    // Collision
    else {
 
        // Adding newNode at the head of
        // linked list which is present
        // at bucket index....insertion at
        // head in linked list
        newNode->next = mp->HashTable[bucketIndex];
        mp->HashTable[bucketIndex] = newNode;
    }
    return;
}
 
void DeleteNode (struct HashTable* mp, char* key)
{
 
    // Getting bucket index for the
    // given key
    int bucketIndex = HashFunction(mp, key);
 
    struct Node* prevNode = NULL;
 
    // Points to the head of
    // linked list present at
    // bucket index
    struct Node* currNode = mp->HashTable[bucketIndex];
 
    while (currNode != NULL) {
 
        // Key is matched at delete this
        // node from linked list
        if (strcmp(key, currNode->key) == 0) {
 
            // Head node
            // deletion
            if (currNode == mp->HashTable[bucketIndex]) {
                mp->HashTable[bucketIndex] = currNode->next;
            }
 
            // Last node or middle node
            else {
                prevNode->next = currNode->next;
            }
            free(currNode);
            break;
        }
        prevNode = currNode;
        currNode = currNode->next;
    }
    return;
}
 
char* Search(struct HashTable* mp, char* key)
{
 
    // Getting the bucket index
    // for the given key
    int bucketIndex = HashFunction(mp, key);
 
    // Head of the linked list
    // present at bucket index
    struct Node* bucketHead = mp->HashTable[bucketIndex];
    while (bucketHead != NULL) {
 
        // Key is found in the hashMap
        if (strcmp(bucketHead->key, key) == 0) {
            return bucketHead->value;
        }
        bucketHead = bucketHead->next;
    }
 
    // If no key found in the hashMap
    // equal to the given key
    char* errorMssg = "Oops! No data found.";
    return errorMssg;
}
 

int GetEnvironmentVariable(char *getCommand, int *retVal, struct HashTable **environmentVariables, int outFd)
{
    char buffer[242];

    if (strcmp(getCommand, RET_VAL_VAR) == 0)
        snprintf(buffer, 241, "%d\n", *retVal);
    else if (CheckKey(getCommand))
    {
        char *value = Search(*environmentVariables, getCommand);
        if (value !=NULL)
        {
            snprintf(buffer, 241, "%s\n", value);
        }
    }
    if(write(outFd, buffer, strlen(buffer)) == E_GENERAL)
        return errno;
    return E_OK;
}

int SetEnvironmentVariable(char *setCommand, struct HashTable **environmentVariables)
{
    char *regex = "[^=]+|\"*[^\"]\"* ";
    char **result;
    int numberOfTokens = TokenizeString(setCommand, &result, regex, 0);
    if (numberOfTokens != 2)
        return -5;
    else
    {
        char *key = result[0];
        char *value = result[1];
        if (strlen(value) > 240 || !CheckKey(key))
            return -5;
        Insert(*environmentVariables, key, value);
        return E_OK;
    }
}

int CheckKey(char *key)
{
    for (int i = 0; i < strlen(key); i++)
    {
        if (key[i] < ASCII_UPPER_A || key[i] > ASCII_UPPER_Z)
            return 0;
    }
    return 1;
}

void SetNode(struct Node* node, char* key, char* value)
{
    node->key = key;
    node->value = value;
    node->next = NULL;
    return;
};