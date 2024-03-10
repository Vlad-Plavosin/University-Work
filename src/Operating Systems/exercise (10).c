#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv)
{
int p2a[2],a2b[2],b2p[2];
pipe(p2a);
pipe(a2b);
pipe(b2p);
int n;
int pida = fork();
if(pida ==0)
{
close(b2p[0]);
close(b2p[1]);
close(p2a[1]);
close(a2b[0]);
while(1){
if(read(p2a[0],&n,sizeof(int))<=0)
break;
if(n==0)
break;
n--;
printf("A: %d \n",n);
write(a2b[1],&n,sizeof(int));}
close(p2a[0]);
close(a2b[1]);
exit(0);
}
int pidb = fork();
if(pidb == 0)
{
close(p2a[0]);
close(p2a[1]);
close(b2p[0]);
close(a2b[1]);
while(1){
if(read(a2b[0],&n,sizeof(int))<=0)
break;
if(n==0)
break;
n--;
printf("B: %d \n",n);
write(b2p[1],&n,sizeof(int));}
close(b2p[1]);
close(a2b[0]);
exit(0);
}
close(a2b[0]);
close(a2b[1]);
close(p2a[0]);
close(b2p[1]);
n=100;
write(p2a[1],&n,sizeof(int));
printf("P: %d\n",n);
while(1){
if(read(b2p[0],&n,sizeof(int))<=0)
break;
if(n==0)
break;
n--;
printf("P: %d\n",n);
write(p2a[1],&n,sizeof(int));
}
close(p2a[1]);
close(b2p[0]);
wait(NULL);
wait(NULL);
return 0;
}
