#include <stdio.h>
#include <semaphore.h>
#include <stdbool.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

#define N 4
sem_t sems[N];
bool ok = true;
int x = 0;
void* f(void* arg){
int nr = *(int*)arg;
while(ok){
sem_wait(&sems[nr]);
x+=1;
if(x%7 == 0){
int t = random()%3;
if(t==0){
printf("Missed at %d\n",x);
ok=false;}
}
if(ok)
printf("thread %d says x is %d\n",nr,x);
if(nr+1 == N)
sem_post(&sems[0]);
else
sem_post(&sems[nr+1]);
}
printf("thread %d ended at %d\n",nr,x);
return NULL;
}

int main(int argc, char** argv){
int i;
pthread_t threads[N];
srandom(time(0));
for( i =0;i<N;i++){
sem_init(&sems[i],0,0);
}
sem_post(&sems[0]);
for(i=0;i<N;i++){
pthread_create(&threads[i],NULL,f,&i);
}
for( i = 0;i<N;i++)
pthread_join(threads[i],NULL);

return 0;
}
