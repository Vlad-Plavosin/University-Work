#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <semaphore.h>
#define N 4
typedef struct{
int nr;
int d;
int* l;
int* u;
}data;
sem_t sem[N];
int s=0;
void* f(void* arg){
int nr = *(int*)arg;
int cp = nr;
while(cp/10!=0)
cp/=10;
if(cp%2==0)
for(int i =0;i<N;i++)
{if(u[i]==0)u[i] = nr}
else
{for(int i =0;i<N;i++)
if(l[i]==0)
l[i] = nr;}
s+=nr;
printf("%d was added\n",nr);
return NULL;
}

int main(int argc, char** argv){
int size;
pthread_t t[N];
int l[N] = {0},u[N] = {0},nrs[N];
for(int i =0;i<N;i++)
scanf("%d",&nrs[i]);
for(int i =0;i<N;i++)
sem_init(&sem[i],0,0);
for(int i=0;i<N;i++)
pthread_create(&t[i],NULL,f,&nrs[i],u,l);
for(int i=0;i<N;i++)
sem_post(&sem[i]);
for(int i=0;i<N;i++)
pthread_join(t[i],NULL);
for(int i=0;i<N;i++)
if(u[i]!=-0)size++;
printf("Size of u is %d\n",size);
size=0;
for(int i=0;i<N;i++)
if(l[i]!=-0)size++;
printf("Size of l is %d\n",size);
size=0;
printf("s is %d\n",s);
return 0;
}
