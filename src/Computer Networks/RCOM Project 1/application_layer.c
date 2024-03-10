// Application layer protocol implementation
#include "include/application_layer.h"

void applicationLayer(const char *serialPort, const char *role, int baudRate,
                      int nTries, int timeout, const char *filename)
{
    LinkLayer linkLayer;
    strcpy(linkLayer.serialPort, serialPort);
    linkLayer.nRetransmissions = nTries;
    linkLayer.timeout = timeout;
    if (!strcmp(role, "tx")) {
            linkLayer.role = LlTx;
        }
        else if (!strcmp(role, "rx")) {
            linkLayer.role = LlRx;
        }
        else {
            fprintf(stderr, "Wrong role input\n");
            return;
        }

    printf("App initialized!\nPort: %s\n", linkLayer.serialPort);

    int fd;

    if ((fd = llopen(linkLayer)) < 0) {
        fprintf(stderr, "llopen failed\n");
        return;
    }

    if (linkLayer.role == LlTx) {
        if (transmitterApplication(fd, filename) < 0) {
            fprintf(stderr, "Transmitter Application failed\n");
            return;
        }
    }
    else {
        if (receiverApplication(fd, filename) < 0) {
            fprintf(stderr, "Receiver Application failed\n");
            return;
        }
    }
    
    if (llclose(fd) < 0){
        fprintf(stderr, "llclose failed\n");
        return;
    }
}
