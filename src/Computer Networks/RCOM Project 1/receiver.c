#include "include/receiver.h"

int receiverApplication(int fd, const char* path) {
    int res;
    int nump = 0;
    int numTries = 0;

    while (1) {
        unsigned char buf[MAX_PACKET_SIZE];
        if ((res = llread(fd, buf)) < 0) {
            if (numTries > N_TRIES) return -1;
            numTries++;
            continue;
        }

        numTries = 0;
        nump++;

        int ret;
        if ((ret = parsePacket(buf, path)) == END_PACKET) 
            break;
        else if (ret == -1)
            return -1;
    }

    printf("Received %d packets\n", nump);
    return 0;
}

int parsePacket(unsigned char * buffer, const char* path) {
    static int destinationFile;

    if (buffer[0] == START_PACKET) {
        if ((destinationFile = open(path, O_WRONLY | O_CREAT, 0777)) < 0) {
            perror("Error opening destination file!");
            return -1;
        }

        return 0;
    } else if (buffer[0] == END_PACKET) {
        if (close(destinationFile) < 0) {
            perror("Error closing destination file!");
            return -1;
        }

        return END_PACKET;
    } else if (buffer[0] == DATA_PACKET) {
        unsigned dataSize = buffer[3] + 256 * buffer[2];
        if (write(destinationFile, &buffer[4], dataSize) < 0) {
            perror("Error writing to destination file!");
            return -1;
        }
        return 0;
    } else {
        printf("Unmarked packet!\n");
        return -1;
    }
}