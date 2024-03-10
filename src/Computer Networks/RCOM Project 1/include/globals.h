#pragma once

#define FALSE 0
#define TRUE 1

#define BAUDRATE 9600
#define N_TRIES 3
#define TIMEOUT 4

#define MAX_PACKET_SIZE 256 
#define MAX_BUFFER_SIZE (MAX_PACKET_SIZE * 2 + 7)

#define NO_RESPONSE -1

#define MSG_FLAG 0x7e
#define ESCAPE 0x7d

#define MSG_A_TRANS_COMMAND 0x03
#define MSG_A_RECV_RESPONSE 0x03
#define MSG_A_TRANS_RESPONSE 0x01
#define MSG_A_RECV_COMMAND 0x01

#define MSG_CTRL_SET 0x03
#define MSG_CTRL_UA 0x07
#define MSG_CTRL_RR(r) ((r == 0) ? 0x05 : 0x85)
#define MSG_CTRL_REJ(r) ((r == 0) ? 0x01 : 0x81)
#define MSG_CTRL_DISC 0x0b
#define MSG_CTRL_S(r) ((r == 0) ? 0x00 : 0x40)

#define BCC(addr, ctrl) (addr^ctrl)

#define DATA_PACKET 1
#define START_PACKET 2
#define END_PACKET 3