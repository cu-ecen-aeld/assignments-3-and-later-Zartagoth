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
        syslog(LOG_ERR, "No arguments provided or they are null.");

        return 1;
    }

    FILE* fd = fopen(writefile, "w");

    if (fd == NULL) {
        printf("Error opening file.\n");
        // Log error to syslog
        syslog(LOG_ERR, "Error opening file.");

        return 1;
    } else {
        fprintf(fd, "%s", writestr);
        // Write to log file
        syslog(LOG_DEBUG, "Writing %s to %s.", writestr, writefile);
        printf("Writing %s to %s.", writestr, writefile);
        fclose(fd);
    }

    return 0;
}
