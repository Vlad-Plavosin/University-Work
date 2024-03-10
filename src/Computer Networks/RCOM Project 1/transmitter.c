#include "include/transmitter.h"

int transmitterApplication(int fd, const char* path) {
    int input_fd;
    struct stat file_stat;

    if (stat(path, &file_stat)<0){//Stat used for getting file size in bytes
        perror("Error getting file information.");
        return -1;
    }

    if ((input_fd = open(path, O_RDONLY)) < 0){
        perror("Error opening file.");
        return -1;
    }
    

    if (sendControlPacket(fd, START_PACKET, file_stat.st_size, path) < 0) {
        fprintf(stderr, "Error sending START packet.\n");
        return -1;
    }

    unsigned char buf[MAX_PACKET_SIZE];
    unsigned bytes_to_send;
    unsigned sequenceNumber = 0;

    while ((bytes_to_send = read(input_fd, buf, MAX_PACKET_SIZE - 4)) > 0) {
        unsigned char dataPacket[MAX_PACKET_SIZE];
        dataPacket[0] = DATA_PACKET;
        dataPacket[1] = sequenceNumber % 255;
        dataPacket[2] = (bytes_to_send / 256);
        dataPacket[3] = (bytes_to_send % 256);
        memcpy(&dataPacket[4], buf, bytes_to_send);

        if (llwrite(fd, dataPacket, ((bytes_to_send + 4) < MAX_PACKET_SIZE)? (bytes_to_send + 4) : MAX_PACKET_SIZE) < 0) { // Only sends max packet if the last packet is of that size
            fprintf(stderr, "llwrite failed\n");
            return -1;
        }

        sequenceNumber++;
    }

    printf("Data packets sent: %d\n",sequenceNumber);

    if (sendControlPacket(fd, END_PACKET, file_stat.st_size, path) < 0) {
        fprintf(stderr, "Error sending END packet.\n");
        return -1;
    }
    printf("Total packets sent: %d\n",sequenceNumber+2);

    return close(input_fd);
}



int sendControlPacket(int fd, unsigned char ctrl_field, unsigned file_size, const char* file_name) {
    unsigned L1 = sizeof(file_size);
    unsigned L2 = strlen(file_name);
    unsigned packet_size = 5 + L1 + L2;

    unsigned char packet[packet_size];
    packet[0] = ctrl_field;
    packet[1] = 0;
    packet[2] = L1;
    memcpy(&packet[3], &file_size, L1);
    packet[3+L1] = 1;
    packet[4+L1] = L2;
    memcpy(&packet[5+L1], file_name, L2);

    return llwrite(fd, packet, packet_size);
}