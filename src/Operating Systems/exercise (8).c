#include <semaphore.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <time.h>

int nr = -1;
sem_t sem1;
sem_t sem2;
void* f1(){
if(nr ==-1)
{
while(nr<50)
nr = random()%201;
}
while(nr > 5){
sem_wait(&sem1);
if(nr == 5)
break;
printf("1 says nr is %d\n",nr);
if(nr%2==1)
nr+=1;
sem_post(&sem2);
}
printf("semafoooooooooooor %d \n", *(int*)&sem2);
return NULL;
}
void* f2(){
while(nr>5){
printf("semaphore %d\n",*(int*)&sem2);
sem_wait(&sem2);
printf("2 says nr is %d\n",nr);
nr = nr/2;
sem_post(&sem1);
}
return NULL;
}

int main(int argc, char** argv){
srandom(time(0));
pthread_t t1,t2;
sem_init(&sem1,0,1);
sem_init(&sem2,0,0);
pthread_create(&t1,NULL,f1,NULL);
pthread_create(&t2,NULL,f2,NULL);
pthread_join(t1,NULL);
pthread_join(t2,NULL);
printf("final value is %d \n",nr);
return 0;
}
