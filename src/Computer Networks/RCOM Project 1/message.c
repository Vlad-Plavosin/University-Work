#include "include/message.h"

int alarm_flag = FALSE;

void alarm_handler() {
    alarm_flag = TRUE;
}

int messageStuffing(unsigned char * buffer, int startingByte, int length, unsigned char * stuffedMessage) {
    int messageSize = 0;

    for (int i = 0; i < startingByte; i++)
        stuffedMessage[messageSize++] = buffer[i];

    for (int i = startingByte; i < length; i++) {
        if (buffer[i] == MSG_FLAG || buffer[i] == ESCAPE) {
            stuffedMessage[messageSize++] = 0x7d;
            stuffedMessage[messageSize++] = buffer[i] ^ 0x20;
        }
        else {
            stuffedMessage[messageSize++] = buffer[i];
        }
    }

    return messageSize;
}

int prepareSupervisionMessage(int fd, unsigned char address, unsigned char control, mode responseType) {
    unsigned char msg[5] = {
        MSG_FLAG, 
        address, 
        control, 
        BCC(address, control), 
        MSG_FLAG
    };

    if (responseType != NO_RESPONSE) {
        if (sendMessage(fd, msg, 5, responseType) < 0)
            return -1;

        return 0;
    }
    else {
        if (write(fd, msg, 5) == -1) {
        fprintf(stderr, "Write failed\n");
    }
    
        return 0;
    }
}

int prepareDataMessage(int fd, unsigned char * data, int dataSize, int packet) {
    int msgSize = dataSize + 5;

    unsigned char msg[msgSize];

    msg[0] = MSG_FLAG;
    msg[1] = MSG_A_TRANS_COMMAND;
    msg[2] = MSG_CTRL_S(packet);
    msg[3] = BCC(MSG_A_TRANS_COMMAND, MSG_CTRL_S(packet));
    unsigned char bcc2 = data[0];
    for (int i = 0; i < dataSize; i++) {
        msg[i + 4] = data[i];
        if (i > 0) bcc2 ^= data[i];
    }
    msg[dataSize + 4] = bcc2;

    unsigned char stuffedData[msgSize * 2];
    msgSize = messageStuffing(msg, 1, msgSize, stuffedData);
    stuffedData[msgSize] = MSG_FLAG;
    msgSize++;

    int numTries = 0;
    int receivedACK = FALSE;
    int ret;

    do {
        numTries++;
        ret = sendMessage(fd, stuffedData, msgSize, RESPONSE_RR_REJ);

        response_type response = getLastResponse();

        if (ret > 0 && ((packet == 0 && response == R_RR1) || (packet == 1 && response == R_RR0))) {
            receivedACK = TRUE;
        } else if (ret > 0) {
            fprintf(stderr, "Received response is invalid. Trying again...\n");
        }
    } while (numTries < N_TRIES && !receivedACK);

    if (!receivedACK) {
        fprintf(stderr, "Failed to get ACK\n");
        return -1;
    }
    else
        return ret;
}
int sendMessage(int fd, unsigned char * msg, int messageSize, mode responseType) {
    configStateMachine(responseType);

    int numTries = 0;
    int ret;

    do {
        numTries++;
        alarm_flag = FALSE;

        if ((ret = write(fd, msg, messageSize)) == -1) {
        fprintf(stderr, "Write failed\n");
    }

        alarm(TIMEOUT);

        int res;
        unsigned char buf[MAX_BUFFER_SIZE];
        while (getState() != STOP && !alarm_flag) {
            res = read(fd, buf, 1);
            if (res == 0) continue;
            updateState(buf[0]);
        }

    } while (numTries < N_TRIES && getState() != STOP);

    if (getState() != STOP) {
        fprintf(stderr, "Failed to get response!\n");
        return -1;
    }

    return ret;
}

int readMessage(int fd, unsigned char * message, mode responseType) {
    configStateMachine(responseType);
    int res, numBytesRead = 0;
    unsigned char buf[MAX_BUFFER_SIZE];
    alarm_flag = FALSE;

    alarm(TIMEOUT);
    
    while (getState() != STOP && !alarm_flag && numBytesRead < MAX_BUFFER_SIZE) {
        res = read(fd, buf, 1);
        if (res == 0) continue;
        alarm(0);
        message[numBytesRead++] = buf[0];
        updateState(buf[0]);
        alarm(TIMEOUT);
    }

    if (alarm_flag) {
        fprintf(stderr, "Alarm fired. readMessage took too long\n");
        return -1;
    }

    if (getState() != STOP) {
        fprintf(stderr, "Failed to read message\n");
        return -1;
    }

    return numBytesRead;
}