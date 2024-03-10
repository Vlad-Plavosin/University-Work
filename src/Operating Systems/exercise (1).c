#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

int i = 1;
int d = 0;
sem_t sem1,sem2;
void* f1(void* arg){
int* args = (int*)arg;
while(i<args[0]){
sem_wait(&sem1);
while(d%2==0)
d = random() % 1000;
args[i] = d;
printf("1 Added %d\n",d);
i++;
sem_post(&sem2);}
return NULL;
}
void* f2(void* arg){
int* args = (int*)arg;
while(i<args[0]){
sem_wait(&sem2);
while(d%2==1)
d = random() % 1000;
printf("2 Added %d\n",d);
args[i] = d;
i++;
sem_post(&sem1);}
return NULL;
}

int main(int argc, char**argv){
srandom(time(0));
int n =atoi(argv[1]);
printf("%d\n",n);
int* v = malloc((n+1)*sizeof(int));
v[0] = n;
pthread_t t1,t2;
sem_init(&sem1,0,1);
sem_init(&sem2,0,0);
pthread_create(&t1,NULL,f1,v);
pthread_create(&t2,NULL,f2,v);
pthread_join(t1,NULL);
pthread_join(t2,NULL);
free(v);
return 0;
}
