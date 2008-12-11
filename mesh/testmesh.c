#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "vars.h"

int main(int argc,char *argv[])
{
 FILE *fp;
 int i,j,k,N,nT,idummy,r;
 double ddummy=0.0; // or else compiler will eliminate floating-point support
// double ddummy;
 int maxD=0,minD=0;

 if(argc!=2)
 {
   printf("Использование: testmesh file.e\n");
   return -1;
 }
 fp=fopen(argv[1],"r");
 if(fp==NULL)
 {
   printf("Файл не найден\n");
   return -1;
 }
 fscanf(fp,"%d",&nT);
 for(N=0;N<nT;N++)
 {
   r=fscanf(fp,"%d %d %d %d %d %d %d %d %d %le %le %d",
    &i,&j,&k,                // номера узлов
    &idummy,&idummy,&idummy, // номера соседних элементов
    &idummy,&idummy,&idummy, // номера образующих сторон
    &ddummy,&ddummy,         // координаты центра опис. окружности
    &idummy); // метка материала
   if(r!=12)
   {
     printf("data was not read properly\n");
     break;
   }
   fscanf(fp,"%lf",&ddummy);
   fscanf(fp,"%lf %lf %lf",&ddummy,&ddummy,&ddummy);
   fscanf(fp,"%lf %lf %lf",&ddummy,&ddummy,&ddummy);
   fscanf(fp,"%lf %lf %lf",&ddummy,&ddummy,&ddummy);

   if(i>0 && j>0) maxD=max(maxD,(i-j));
   if(i>0 && k>0) maxD=max(maxD,(i-k));
   if(k>0 && j>0) maxD=max(maxD,(k-j));
   if(i>0 && j>0) minD=min(minD,(i-j));
   if(i>0 && k>0) minD=min(minD,(i-k));
   if(k>0 && j>0) minD=min(minD,(k-j));
   /*
   if(i>0) maxD=max(maxD,N-i);
   if(j>0) maxD=max(maxD,N-j);
   if(k>0) maxD=max(maxD,N-k);

   if(i>0) minD=min(minD,N-i);
   if(j>0) minD=min(minD,N-j);
   if(k>0) minD=min(minD,N-k);
   */
   printf("%d lines read\n",N);
 }
 fclose(fp);

 printf("ширина диагонали: %d+%d\n",maxD,-minD);
 return 0;
}
