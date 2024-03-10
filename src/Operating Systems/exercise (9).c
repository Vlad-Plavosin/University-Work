#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>

int number = 0;
sem_t sem1;
sem_t sem2;

void* f1(void* arg){
while(number!=10){
sem_wait(&sem1);
printf("%d from %d\n",number,*(int*)arg);
number = random()%11;
sem_post(&sem2);
}
sem_destroy(&sem1);
return NULL;
}
void* f2(void* arg){
while(number!=10){
sem_wait(&sem2);
printf("%d from %d\n",number,*(int*)arg);
number = random()%11;
sem_post(&sem2);
}
sem_destroy(&sem1);
return NULL;
}

int main(int argc, char** argv){
srandom(time(0));
int a=1,b=2;
pthread_t c1,c2;
sem_init(&sem1,0,1);
sem_init(&sem2,0,0);
pthread_create(&c1,NULL,f1,&a);
pthread_create(&c2,NULL,f2,&b);
pthread_join(c1,NULL);
pthread_join(c2,NULL);
return 0;
}
