#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "DGauss.h"


#ifndef max
#define max(a,b) ( (a) > (b) ? (a) : (b) )
#endif

#ifndef min
#define min(a,b) ( (a) < (b) ? (a) : (b) )
#endif


typedef struct
{
  double x,y;
  int mark;
} TPoint;

typedef struct
{
  int i,j,k;
  int ei,ej,ek; // elements
  int si,sj,sk; // sides
  int mark;
  double ai,aj,ak,bi,bj,bk,ci,cj,ck,A;
} TElement;

typedef struct
{
  int i,j;
  int ea,eb;
  double nx,ny,l;
  int mark;
} TSide;

typedef struct
{
  double D11,D12,D21,D22;
} TMaterial;


void CalculateDiff(TElement *E,int nE, TPoint *P, int nP, double *cell,double *X, double *dXx, double *dXy);

double len(double x,double y) {return sqrt(x*x+y*y);}
int main(int argc,char *argv[])
{
 FILE *fp;
 int i,j,k,e;
 int nP,nE,nS;
 TPoint *P;
 TElement *E;
 TSide *S;
 int Diag=0;
 char fname[80],buf[200];
 double invar1,invar2,l1,l2;
 double ma1,ma2,mb1,mb2;

 double *K,*F,*X,maxn, *a1, *a2,*dXx, *dXy, *cell;
 int ea,eb;

// double D11o=0,D12o=0,D21o=0,D22o=1.0/10; // outside
// double D11i=0,D12i=0,D21i=0,D22i=1.0/40; // inside
 int nMat;
 double D11,D12,D21,D22,A,Q,mul,x,y;

 if(argc==1) { printf("argument missing\n"); return -1; }
 sscanf(argv[1],"%s",fname);
 fname[strlen(fname)-2]=0;

 sprintf(buf,"%s.d.eff",fname);
 fp=fopen(buf,"r");
 if(fp==NULL)
 {
  printf("Не найден файл с эффективными характеристиками\n");
  return -1;
 }
 fscanf(fp,"%le %le %le %le",&D11,&D12,&D21,&D22);
 fclose(fp);

 sprintf(buf,"%s.n",fname);
 fp=fopen(buf,"r");
 if(!fp)
 {
  printf("Триангуляция не построена! используйте Mesh.exe\n");
  return -1;
 }
 fscanf(fp,"%d",&nP);
 P=malloc(nP*sizeof(TPoint));
 for(i=0;i<nP;i++)
   fscanf(fp,"%le %le %d",&P[i].x,&P[i].y,&P[i].mark);
 fclose(fp);

 sprintf(buf,"%s.e",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nE);
 E=malloc(nE*sizeof(TElement));
 cell=malloc(nP*sizeof(double)); for(i=0;i<nP;i++) cell[i]=0;
 for(i=0;i<nE;i++)
 {
   fscanf(fp,"%d %d %d",&E[i].i,&E[i].j,&E[i].k);
   fscanf(fp,"%d %d %d",&E[i].ei,&E[i].ej,&E[i].ek);
   fscanf(fp,"%d %d %d",&E[i].si,&E[i].sj,&E[i].sk);
   fscanf(fp,"%d",&E[i].mark);
   fscanf(fp,"%lf",&E[i].A);
   fscanf(fp,"%lf %lf %lf",&E[i].ai,&E[i].bi,&E[i].ci);
   fscanf(fp,"%lf %lf %lf",&E[i].aj,&E[i].bj,&E[i].cj);
   fscanf(fp,"%lf %lf %lf",&E[i].ak,&E[i].bk,&E[i].ck);
   Diag=max(Diag,abs(E[i].i-E[i].j));
   Diag=max(Diag,abs(E[i].i-E[i].k));
   Diag=max(Diag,abs(E[i].k-E[i].j));

   cell[E[i].i]+=E[i].A;
   cell[E[i].j]+=E[i].A;
   cell[E[i].k]+=E[i].A;
  
 }
 fclose(fp);
 
 sprintf(buf,"%s.s",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nS);
 S=malloc(nS*sizeof(TSide));
 a1=malloc(nS*sizeof(double));
 a2=malloc(nS*sizeof(double));
 for(i=0;i<nS;i++)
 {
   fscanf(fp,"%d %d %d %d %le %le %d",&S[i].i,&S[i].j,&S[i].ea,&S[i].eb,&S[i].nx,&S[i].ny,&S[i].mark);
   x=P[S[i].j].x-P[S[i].i].x;
   y=P[S[i].j].y-P[S[i].i].y;
   S[i].l=sqrt(x*x+y*y);
 }
 fclose(fp);

 printf("B: %d\n",Diag);
 printf("N: %d\n",nP);
 /*
 ddummy=1-Diag*1.0/nP;
 printf("Memory   economy: %4.2lf\n",ddummy*100);
 ddummy=1-1.0*Diag/nP*Diag/nP;
 printf("CPU Time enocomy: %4.2lf\n",ddummy*100);
 */
 // [K]{X}={F}
 K=malloc(nP*(2*Diag+1)*sizeof(double));
 F=malloc(nP*sizeof(double));
 X=malloc(nP*sizeof(double));
 dXx=malloc(nP*sizeof(double));
 dXy=malloc(nP*sizeof(double));
 if(!K || !F || !X || !dXx || !dXy)
 {
   printf("Ошибка выделения памяти.\n");
   return -1;
 }
 invar1=invar2=0;
 l1=l2=0;
 // ===============================================
 // Решение для N1
 for(i=0;i<nP*(2*Diag+1);i++) K[i]=0;
 for(i=0;i<nP;i++) F[i]=0;
 for(i=0;i<nP;i++) X[i]=0;
 // построение матрицы жёсткости
 for(e=0;e<nE;e++)
 {
  i=E[e].i; j=E[e].j; k=E[e].k;
  A=E[e].A;

  if(E[e].mark<0)
  {
   printf("Не все подобласти имеют материал!\n");
   return -1;
  }


  K[IC(i,i,Diag)]+=1/(4*A)*(D11*E[e].bi*E[e].bi+0.5*(D12+D21)*(E[e].bi*E[e].ci+E[e].ci*E[e].bi)+D22*E[e].ci*E[e].ci);
  K[IC(i,j,Diag)]+=1/(4*A)*(D11*E[e].bi*E[e].bj+0.5*(D12+D21)*(E[e].bi*E[e].cj+E[e].ci*E[e].bj)+D22*E[e].ci*E[e].cj);
  K[IC(i,k,Diag)]+=1/(4*A)*(D11*E[e].bi*E[e].bk+0.5*(D12+D21)*(E[e].bi*E[e].ck+E[e].ci*E[e].bk)+D22*E[e].ci*E[e].ck);
                                                                                                  
  K[IC(j,i,Diag)]+=1/(4*A)*(D11*E[e].bj*E[e].bi+0.5*(D12+D21)*(E[e].bj*E[e].ci+E[e].cj*E[e].bi)+D22*E[e].cj*E[e].ci);
  K[IC(j,j,Diag)]+=1/(4*A)*(D11*E[e].bj*E[e].bj+0.5*(D12+D21)*(E[e].bj*E[e].cj+E[e].cj*E[e].bj)+D22*E[e].cj*E[e].cj);
  K[IC(j,k,Diag)]+=1/(4*A)*(D11*E[e].bj*E[e].bk+0.5*(D12+D21)*(E[e].bj*E[e].ck+E[e].cj*E[e].bk)+D22*E[e].cj*E[e].ck);
                                                                                                  
  K[IC(k,i,Diag)]+=1/(4*A)*(D11*E[e].bk*E[e].bi+0.5*(D12+D21)*(E[e].bk*E[e].ci+E[e].ck*E[e].bi)+D22*E[e].ck*E[e].ci);
  K[IC(k,j,Diag)]+=1/(4*A)*(D11*E[e].bk*E[e].bj+0.5*(D12+D21)*(E[e].bk*E[e].cj+E[e].ck*E[e].bj)+D22*E[e].ck*E[e].cj);
  K[IC(k,k,Diag)]+=1/(4*A)*(D11*E[e].bk*E[e].bk+0.5*(D12+D21)*(E[e].bk*E[e].ck+E[e].ck*E[e].bk)+D22*E[e].ck*E[e].ck);

  F[i]+=2.0/3.0*A;
  F[j]+=2.0/3.0*A;
  F[k]+=2.0/3.0*A;

 }

 // задание краевого условия
 for(i=0;i<nP;i++)
 {
  if(P[i].mark==1)
  {
  for(j=-Diag;j<=Diag;j++)
   K[IC(i,i+j,Diag)]=0;
   K[IC(i,i,Diag)]=1.0; F[i]=0;
  }/* else F[i]=-2.0;*/
 }


 // ===============================================
// PM(K,nP,Diag,F);
 // ===============================================

 printf("Нахождение решения Psi0..");
 DiagGSolve(K,nP,Diag,X,F);
 printf("Ok\n");
 sprintf(buf,"%s.psi0",fname);
 printf("opening: [%s]\n",buf);
 fp=fopen(buf,"w");
 if(!fp)
 {
   printf("Unable to open: [%s]\n",buf);
   return -1;
 }
 fprintf(fp,"%d\n",nP);
 printf("printed... [%s]\n",buf);
 maxn=X[0];
 for(i=0;i<nP;i++)
 {
   fprintf(fp,"%+17.10le\n",X[i]);
   maxn=max(maxn,fabs(X[i]));
 }
 printf("Max psi0: %le\n",maxn);
 fclose(fp);

 printf("Нахождение решения dPsi0..");
 CalculateDiff(E,nE,P,nP,cell,X,dXx,dXy);


 sprintf(buf,"%s.dpsi0",fname);
 printf("opening: [%s]\n",buf);
 fp=fopen(buf,"w");
 if(!fp)
 {
   printf("Unable to open: [%s]\n",buf);
   return -1;
 }
 fprintf(fp,"%d\n",nP);
 for(i=0;i<nP;i++)
 {
   fprintf(fp,"%+17.10le %+17.10le\n",dXx[i],dXy[i]);
 }
 fclose(fp);


 free(P);
 free(E);
 free(K);
 return 0;
}


void CalculateDiff(TElement *E,int nE, TPoint *P, int nP, double *cell,double *X,double *dXx, double *dXy)
{
 int e,n;
 double *dEx, *dEy;

 
 for(n=0;n<nP;n++) dXx[n]=dXy[n]=0;
 dEx=malloc(nE*sizeof(double));
 dEy=malloc(nE*sizeof(double));

 // Вычисление значений производных на элементах
 for(e=0;e<nE;e++)
 {
  dEx[e]=(X[E[e].i]*E[e].bi+X[E[e].j]*E[e].bj+X[E[e].k]*E[e].bk)/2/E[e].A;
  dEy[e]=(X[E[e].i]*E[e].ci+X[E[e].j]*E[e].cj+X[E[e].k]*E[e].ck)/2/E[e].A;
 }
 // выставление производных

 for(e=0;e<nE;e++)
 {
  dXx[E[e].i]+=dEx[e]*E[e].A;
  dXx[E[e].j]+=dEx[e]*E[e].A;
  dXx[E[e].k]+=dEx[e]*E[e].A;

  dXy[E[e].i]+=dEy[e]*E[e].A;
  dXy[E[e].j]+=dEy[e]*E[e].A;
  dXy[E[e].k]+=dEy[e]*E[e].A;

 }

 for(n=0;n<nP;n++)
 {
  dXx[n]/=cell[n];
  dXy[n]/=cell[n];
 }
}
