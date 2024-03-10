#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <semaphore.h>

int v[10] = {0};
void* f(void* arg){
int val = *(int*)(char*)arg;
printf("val is %d \n",val);
int x;
while(val!=0){
x = val%10;
val/=10;
v[x]+=1;
}
return NULL;
}

int main(int argc, char** argv){
pthread_t threads[argc];
for(int i = 1; i<argc;i++)
{
pthread_create(&threads[i],NULL,f,(void*)argv[i]);}
for(int i=0;i<argc;i++) pthread_join(threads[i],NULL);
for(int i =0;i<9;i++)
printf("frequency of %d is %d\n",i,v[i]);
return 0;
}
