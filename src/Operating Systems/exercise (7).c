#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <time.h>

int main(int argc, char** argv){
int n,pid1,pid2;
int p2a[2],a2b[2],b2p[2];
pipe(p2a);pipe(a2b);pipe(b2p);
pid1 = fork();
if(pid1==0)
{
close(p2a[1]);close(a2b[0]);close(b2p[0]);close(b2p[1]);
srandom(time(0));
int p;
while(p<2) p = random()%5;
while(1){
if(read(p2a[0],&n,sizeof(int))<0)break;
printf("A read %d \n",n);
n+=p;
printf("A wrote %d \n",n);
write(a2b[1],&n,sizeof(int));
}
printf("closed a");
close(p2a[0]);close(a2b[1]);
exit(0);
}
pid2 = fork();
if(pid2 == 0){
int sum = 0;
close(p2a[1]);close(p2a[0]);close(b2p[0]);close(a2b[1]);
while(1){
if(read(a2b[0],&n,sizeof(int)) < 0) break;
printf("B received %d \n",n);
sum=sum+n;
}
printf("B wrote %d \n",sum);
write(b2p[1],&sum,sizeof(int));
close(b2p[1]);close(a2b[0]);
exit(0);
}
close(a2b[1]);close(a2b[0]);close(p2a[0]);close(b2p[1]);
int a;
for(int i = 1; i<argc;i++){
a = atoi(argv[i]);
printf("P wrote %d \n",a);
write(p2a[1],&a,sizeof(int));
}
close(p2a[1]);
read(b2p[0],&n,sizeof(int));
printf("Received %d \n",n);
close(b2p[0]);
wait(0);
return 0;
}
