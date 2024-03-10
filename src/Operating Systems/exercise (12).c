#include <stdio.h>
#include <pthread.h>
#include<stdlib.h>

void* f(void* arg){
printf("Perhaps i am %d \n",*(int*)arg);
return NULL;
}

int main(int argc, char** argv){
int p=4;
pthread_t th[p];
int v[p];
for(int i=0; i<p;i++){
v[i] = i;
pthread_create(&th[i],NULL,f,(void*)&v[i]);
}
for(int i=0;i<p;i++){
pthread_join(th[i],NULL);
}

return 0;
}
