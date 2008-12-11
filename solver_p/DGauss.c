#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifndef min
#define min(a,b) ( (a)<(b)?(a):(b) )
#endif

#ifndef max
#define max(a,b) ( (a)>(b)?(a):(b) )
#endif

#include "DGauss.h"


int WasIndexViolation,MaxViolation=0;

int DiagGSolve(double *A,int N,int D,double *X,double *B)
{
 int i,j,k;

 double S;

 // прямой ход
 for(i=0;i<N-1;i++)
 {
  printf("%05d/%05d\r",i,N);
  for(j=i+1;j<=min(i+D,N-1);j++)
  {
    S=A[IC(j,i,D)]/A[IC(i,i,D)];  A[IC(j,i,D)]=0;

    for(k=i+1;k<=min(i+D,N-1);k++)
     A[IC(j,k,D)]-=S*A[IC(i,k,D)];

    B[j]-=S*B[i];
  }
  /*
  printf("----------%d--------",i);
  PM(A,N,D,B);
  */
 }
// printf("туда\n");
 // обратный ход
 X[N-1]=B[N-1]/A[IC(N-1,N-1,D)];

 for(i=N-2;i>=0;i--)
 {
   S=0;
   for(j=i+1;j<min(i+1+D,N);j++)
    S+=A[IC(i,j,D)]*X[j];

   X[i]=(B[i]-S)/A[IC(i,i,D)];
 }
 return 0;
}
int IC(int i,int j,int D)
{
 if(abs(i-j)>D)
 {
  MaxViolation=max(MaxViolation,abs(i-j));
  printf("Index violation: |%d-%d|>%d, max so far=%d\n",i,j,D,MaxViolation);
  WasIndexViolation=1;
//  exit(1);
  return 0;
 }
// printf("good\n");
 return ( (i)*(2*D+1)+((j)-(i)+(D)) );
}
void PM(double *A,int N,int D,double *B)
{
 int P;
 char buf[1024];
 int i,j;
 printf(">>\n");
 P=11;
 for(i=0;i<N;i++)
  printf("%10d ",i);
 printf("\n");

 for(i=0;i<N;i++)
 {
  sprintf(buf,"%%%ds",max(i-D,0)*P);
  printf(buf,"");
  for(j=0;j<2*D+1;j++)
  {
   if(j-D+i<max(i-D,0) || j-D+i>min(i+D,N-1)) continue;
   printf("%+10.4lf ",A[i*(2*D+1)+j]);
  }
  sprintf(buf,"%%%ds",((N-min(i+D,N-1))*P));
  printf(buf,"");
  printf("%+10.4lf",B[i]);
  printf("\n");
 }
 for(i=0;i<N;i++)
  printf("%10d ",i);
 printf("\n");
}