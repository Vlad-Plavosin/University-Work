#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv){
mkfifo("p2c",600);
mkfifo("c2p",600);
int p2c = open("p2c",O_WRONLY);
int c2p = open("c2p",O_RDONLY);
char* finalString = malloc(100*sizeof(char));
char* currentString = malloc(100*sizeof(char));
for(int i = 1; i<argc;i++){
currentString = argv[i];
int a = strlen(currentString);
printf("P sent %d\n",a);
write(p2c,&a,sizeof(int));
printf("P sent %s\n",currentString);
write(p2c,currentString,sizeof(char) * (strlen(currentString)+1));
read(c2p,currentString, sizeof(char) * (strlen(currentString)+1));
printf("P read %s\n",currentString);
strcat(finalString,currentString);
}
printf("%s\n",finalString);
close(c2p);
close(p2c);
unlink("p2c");
unlink("c2p");
return 0;
}
