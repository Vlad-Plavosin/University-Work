#pragma once

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#include "link_layer.h"
#include "globals.h"

int receiverApplication(int fd, const char* path);

int parsePacket(unsigned char * buffer, const char* path);