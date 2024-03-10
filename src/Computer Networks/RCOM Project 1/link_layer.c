// Link layer protocol implementation

#include "include/link_layer.h"

struct termios oldtio;

unsigned char BCC2(unsigned char * data, int dataSize, int startingByte) {
    unsigned char bcc = data[startingByte];

    for(int i = startingByte + 1; i < dataSize; i++)
        bcc = bcc ^ data[i];

    return bcc;
}

int messageDestuffing(unsigned char * buffer, int startingByte, int lenght, unsigned char * destuffedMessage) {
    int messageSize = 0;

    for (int i = 0; i < startingByte; i++) {
        destuffedMessage[messageSize++] = buffer[i];
    }

    for (int i = startingByte; i < lenght; i++) {
        if (buffer[i] == ESCAPE) {
            destuffedMessage[messageSize++] = buffer[i + 1] ^ 0x20;
            i++;
        }
        else {
            destuffedMessage[messageSize++] = buffer[i];
        }
    }

    return messageSize;
}

int llopen(LinkLayer connectionParameters) {
    int fd = open(connectionParameters.serialPort, O_RDWR | O_NOCTTY);
    if (fd < 0) {
        perror("Error opening port");
        return -1;
    }

    struct termios newtio;

    if (tcgetattr(fd, &oldtio) == -1) { 
        perror("tcgetattr failed");
        return -1;
    }

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = connectionParameters.baudRate | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
 
    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;
 
    newtio.c_cc[VTIME]    = 1;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 0;   /* blocking read until 5 chars received */
 
    tcflush(fd, TCIOFLUSH);
 
    if (tcsetattr(fd, TCSANOW, &newtio) == -1) {
        perror("tcsetattr failed to set new termios struct");
        return -1;
    }
 
    printf("New termios structure set\n");

    (void)signal(SIGALRM, alarm_handler);

    int ok;
    if(connectionParameters.role == LlRx){
            setStateMachineRole(LlRx);
            unsigned char message[5];
        if (readMessage(fd, message, COMMAND_SET) < 0) return -1;
        ok = prepareSupervisionMessage(fd, MSG_A_RECV_RESPONSE, MSG_CTRL_UA, NO_RESPONSE);
        if(ok == -1)
            return ok;
        }
    else if(connectionParameters.role == LlTx){
            setStateMachineRole(LlTx);
            ok = prepareSupervisionMessage(fd, MSG_A_TRANS_COMMAND, MSG_CTRL_SET, RESPONSE_UA);
            if(ok == -1)
            return ok;
    }
    else
            return -1;

    return fd;
}

int llwrite(int fd, unsigned char * buffer, int lenght) {
    static int packet = 0;
    
    int ret;
    int numTries = 0;

    while (numTries < TIMEOUT) {
        numTries++;
        if ((ret = prepareDataMessage(fd, buffer, lenght, packet)) > -1) {
            packet = (packet + 1) % 2;
            return ret;
        }
        fprintf(stderr, "sendDataMessage failed\n");
    }

    return -1;
}

int llread(int fd, unsigned char * buffer) {
    static int packet = 0;
    unsigned char stuffedMessage[MAX_BUFFER_SIZE], unstuffedMessage[MAX_PACKET_SIZE + 7];
    int numBytesRead;
    if ((numBytesRead = readMessage(fd, stuffedMessage, COMMAND_DATA)) < 0) {
        fprintf(stderr, "Read operation failed\n");
        return -1;
    }
    int res = messageDestuffing(stuffedMessage, 1, numBytesRead - 1, unstuffedMessage);
    
    unsigned char receivedBCC2 = unstuffedMessage[res - 1];
    unsigned char receivedDataBCC2 = BCC2(unstuffedMessage, res - 1, 4);

    if (receivedBCC2 == receivedDataBCC2 && unstuffedMessage[2] == MSG_CTRL_S(packet)) {
        packet = (packet + 1) % 2;
        if (prepareSupervisionMessage(fd, MSG_A_RECV_RESPONSE, MSG_CTRL_RR(packet), NO_RESPONSE) < 0) return -1;
        memcpy(buffer, &unstuffedMessage[4], res-5);
        return res - 5;
    }
    else if (receivedBCC2 == receivedDataBCC2) {
        prepareSupervisionMessage(fd, MSG_A_RECV_RESPONSE, MSG_CTRL_RR(packet), NO_RESPONSE);
        fprintf(stderr, "Duplicate Packet!\n");
        tcflush(fd, TCIFLUSH);
        return -1;
    } else {
        prepareSupervisionMessage(fd, MSG_A_RECV_RESPONSE, MSG_CTRL_REJ(packet), NO_RESPONSE);
        fprintf(stderr, "Error in BCC2, sent REJ!\n");
        tcflush(fd, TCIFLUSH);
        return -1;
    }
}

int llclose(int fd) {
    switch (getRole()) {
        case LlRx:
            printf("Closing Reciever\n");
    unsigned char message[5];
    if (readMessage(fd, message, COMMAND_DISC) < 0) return -1;
    prepareSupervisionMessage(fd, MSG_A_RECV_COMMAND, MSG_CTRL_DISC, RESPONSE_UA);
            break;
        case LlTx:
            printf("Closing transmitter\n");
    if (prepareSupervisionMessage(fd, MSG_A_TRANS_COMMAND, MSG_CTRL_DISC, COMMAND_DISC) < 0) return -1;
    prepareSupervisionMessage(fd, MSG_A_TRANS_RESPONSE, MSG_CTRL_UA, NO_RESPONSE);
            break;
        default:
            return -1;
    }
    if (tcsetattr(fd, TCSANOW, &oldtio) == -1) {
        perror("tcsetattr failed to set old termios struct");
        exit(-1);
    }
 
    return close(fd);
}