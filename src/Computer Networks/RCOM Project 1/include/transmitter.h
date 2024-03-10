#pragma once

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include "link_layer.h"
#include "globals.h"

int transmitterApplication(int fd, const char* path);

int sendControlPacket(int fd, unsigned char ctrl_field, unsigned file_size, const char* file_name);