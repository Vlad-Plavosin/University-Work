#pragma once

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

void alarm_handler();

int prepareSupervisionMessage(int fd, unsigned char address, unsigned char control, mode responseType);

int prepareDataMessage(int fd, unsigned char * data, int dataSize, int packet);

int sendMessage(int fd, unsigned char * msg, int messageSize, mode responseType);

int readMessage(int fd, unsigned char * message, mode responseType);