#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "DGauss.h"



int main()
{
  double *A,*X,*B,err;
  int i,j,N,D,P;

  printf("Размерность :");  scanf("%d",&N);
  printf("Кол-во диаг.:");  scanf("%d",&D);

  A=malloc(N*(2*D+1)*sizeof(double));
  B=malloc(N*sizeof(double));
  X=malloc(N*sizeof(double));
  if (!A || !B || !X)
  {
   printf("alloc failed\n");
   return -1;
  }
  for(i=0;i<N;i++)
  { 
    B[i]=0;
    for(j=max(i-D,0);j<=min(i+D,N-1);j++)
    {
     A[IC(i,j,D)]=max(i,j)+1;
     if(j%2==1) B[i]+=A[IC(i,j,D)];
    }

  }
//  PM(A,N,D,B);
  DiagGSolve(A,N,D,X,B);
  err=0;
  
  for(i=0;i<N;i++)
   err+=fabs(X[i]-(i%2)*1.0);
//  for(i=0;i<N;i++)
//   printf("%+6.2lf\n",X[i]);
   
  printf("err: %le\n",err);
  free(A);
  free(B);
  free(X);
}