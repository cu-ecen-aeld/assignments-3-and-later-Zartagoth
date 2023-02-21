#include <stdio.h>
#include <syslog.h>

enum {
    WRITEFILE = 1,
    WRITESTR
};


int main (int argc, char *argv[]) {
     // Arguments
     char *writefile = argv[WRITEFILE];
     char *writestr = argv[WRITESTR];

    // Open syslog
    openlog(NULL, 0, LOG_USER);

    if (argc  < 2 || writefile == NULL || writestr == NULL) {
        printf("No arguments provided or they are null.\n");
        // Log error to syslog
        syslog(LOG_ERR, "No arguments provided or they are null.");

        return 1;
    } else {
        printf("Write %s on %s.\n", writestr, writefile);
    }

    // Write to log file
    syslog(LOG_DEBUG, "Writing %s to %s.", writestr, writefile);

    return 0;
}
