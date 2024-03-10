#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv){
int p2c = open("p2c",O_RDONLY);
int c2p = open("c2p",O_WRONLY);
int a;
char* currentString = malloc(100*sizeof(char));
while(1){
if(read(p2c,&a,sizeof(int))<1)break;
read(p2c,currentString,(1+a)*sizeof(char));
for(int i=0;i<a;i++)
	currentString[i] = toupper(currentString[i]);
write(c2p,currentString,(1+a)*sizeof(char));
}
free(currentString);
close(c2p);
close(p2c);
return 0;
}




