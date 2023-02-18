#include "stdio.h"

enum {
    WRITEFILE = 1,
    WRITESTR
};


int main (int argc, char *argv[]) {
    if (argc  < 2 || argv[WRITEFILE] == NULL || argv[WRITESTR] == NULL) {
        printf("No arguments provided or they are null.\n");
        return 1;
    } else {
        char *writefile = argv[WRITEFILE];
        char *writestr = argv[WRITESTR];

        printf("Write %s on %s\n", writestr, writefile);
    }

    return 0;
}