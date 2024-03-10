#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
int n;
int m;

if(argc!=2)
{
printf("give argument!!! >:( >:( ");
	return 1;
}
FILE * f;
f = fopen(argv[1],"r");
fscanf(f,"%d",&n);
fscanf(f,"%d",&m);
printf("%d \n",n);
printf("%d \n",m);
int ** matrix;
matrix = (int**)malloc(sizeof(int*) * n);
for(int i=0;i<n;i++)
{
matrix[i] = (int*)malloc(sizeof(int) * m);
for(int j=0;j<m;j++)
	fscanf(f,"%d", &matrix[i][j]);
}
for(int i=0; i<n; i++)
{
for(int j = 0;j<m;j++)
{
printf("%d", matrix[i][j]);
}
printf("\n");
}

	for(int i=0;i<n;i++)
		free(matrix[i]);
	free(matrix);
fclose(f);
	return 0;
}
