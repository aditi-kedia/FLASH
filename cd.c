#include <unistd.h>
#include <stdio.h>

int main()
{
    char currentWorkingDirectory[1024];
    printf("%s\n", getcwd(currentWorkingDirectory, 1024));
    chdir("..");
    printf("%s\n", getcwd(currentWorkingDirectory, 1024));
}