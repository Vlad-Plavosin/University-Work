// Link layer header.
// NOTE: This file must not be changed.

#ifndef _LINK_LAYER_H_
#define _LINK_LAYER_H_


#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include "state.h"
#include "message.h"

#define _POSIX_SOURCE 1 /* POSIX compliant source */

typedef enum
{
    LlTx,
    LlRx,
} LinkLayerRole;

typedef struct
{
    char serialPort[50];
    LinkLayerRole role;
    int baudRate;
    int nRetransmissions;
    int timeout;
} LinkLayer;


int llopen(LinkLayer connectionParameters);
int llclose(int fd);
int llwrite(int fd, unsigned char * buffer, int lenght);
int llread(int fd, unsigned char * buffer);

#endif // _LINK_LAYER_H_