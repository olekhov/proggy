#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "DGauss.h"

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

 double *K,*F,*X,maxn, *a1, *a2;
 int ea,eb;

// double D11o=0,D12o=0,D21o=0,D22o=1.0/10; // outside
// double D11i=0,D12i=0,D21i=0,D22i=1.0/40; // inside
 TMaterial *Mat;
 int nMat;
 double D11,D12,D21,D22,A,Q,mul,x,y;

 if(argc==1) { printf("argument missing\n"); return -1; }
 sscanf(argv[1],"%s",fname);
 fname[strlen(fname)-2]=0;

 sprintf(buf,"%s.m",fname);
 fp=fopen(buf,"r");
 if(fp==NULL)
 {
  printf("Не найден файл с описанием материалов\n");
  return -1;
 }
 fscanf(fp,"%d",&nMat);
 Mat=malloc(nMat*sizeof(TMaterial));
 for(i=0;i<nMat;i++)
 {
   fscanf(fp,"%le %le %le %le",&Mat[i].D11,&Mat[i].D12,&Mat[i].D21,&Mat[i].D22);
   printf("%le %le %le %le\n",Mat[i].D11,Mat[i].D12,Mat[i].D21,Mat[i].D22);
 }
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
 if(!K || !F || !X)
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

  D11=Mat[E[e].mark].D11;
  D12=Mat[E[e].mark].D12;
  D21=Mat[E[e].mark].D21;
  D22=Mat[E[e].mark].D22;


  K[IC(i,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bi+(D12+D21)*(E[e].bi*E[e].ci+E[e].ci*E[e].bi)+2*D22*E[e].ci*E[e].ci);
  K[IC(i,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bj+(D12+D21)*(E[e].bi*E[e].cj+E[e].ci*E[e].bj)+2*D22*E[e].ci*E[e].cj);
  K[IC(i,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bk+(D12+D21)*(E[e].bi*E[e].ck+E[e].ci*E[e].bk)+2*D22*E[e].ci*E[e].ck);
                                                                                                    
  K[IC(j,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bi+(D12+D21)*(E[e].bj*E[e].ci+E[e].cj*E[e].bi)+2*D22*E[e].cj*E[e].ci);
  K[IC(j,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bj+(D12+D21)*(E[e].bj*E[e].cj+E[e].cj*E[e].bj)+2*D22*E[e].cj*E[e].cj);
  K[IC(j,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bk+(D12+D21)*(E[e].bj*E[e].ck+E[e].cj*E[e].bk)+2*D22*E[e].cj*E[e].ck);
                                                                                                    
  K[IC(k,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bi+(D12+D21)*(E[e].bk*E[e].ci+E[e].ck*E[e].bi)+2*D22*E[e].ck*E[e].ci);
  K[IC(k,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bj+(D12+D21)*(E[e].bk*E[e].cj+E[e].ck*E[e].bj)+2*D22*E[e].ck*E[e].cj);
  K[IC(k,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bk+(D12+D21)*(E[e].bk*E[e].ck+E[e].ck*E[e].bk)+2*D22*E[e].ck*E[e].ck);

//  if(E[e].mark!=2) continue;

  if(S[E[e].sk].mark==2) // сторона i-j
  {
    ea=S[E[e].sk].ea; eb=S[E[e].sk].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D11 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D12 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D11 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D12 :0;

    if(ma1==0 || mb1==0)
    {
     printf("got 0\n");
    }

//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].sk].nx+
      (ma2-mb2)*S[E[e].sk].ny;
    printf("Q:%lf\n",Q);
    a1[E[e].sk]+=Q;

    if(Mat[E[S[E[e].sk].ea].mark].D11-Mat[E[S[E[e].sk].eb].mark].D11>0) 
    printf("1ACHTUNG: E: %d, S: %d\n",e,E[e].sk);
//    printf("%le\n",Mat[E[S[E[e].sk].ea].mark].D11-Mat[E[S[E[e].sk].eb].mark].D11);
    F[i]-=1.0/2*(2)*Q;
    F[j]-=1.0/2*(2)*Q;
    invar1+=Q;
    l1+=S[E[e].sk].nx;
  }
  if(S[E[e].si].mark==2) // сторона j-k
  {

    ea=S[E[e].si].ea; eb=S[E[e].si].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D11 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D12 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D11 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D12 :0;

    if(ma1==0 || mb1==0)
    {
     printf("got 0\n");
    }
//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].si].nx+
      (ma2-mb2)*S[E[e].si].ny;
    printf("Q:%lf\n",Q);
    a1[E[e].si]+=Q;

    if(Mat[E[S[E[e].si].ea].mark].D11-Mat[E[S[E[e].si].eb].mark].D11>0) 
    printf("2ACHTUNG: E: %d, S: %d\n",e,E[e].si);
    F[j]-=1.0/2*(2)*Q;
    F[k]-=1.0/2*(2)*Q;
    invar1+=Q;
    l1+=S[E[e].si].nx;
  }
  if(S[E[e].sj].mark==2) // сторона k-i
  {
    ea=S[E[e].sj].ea; eb=S[E[e].sj].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D11 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D12 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D11 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D12 :0;
    if(ma1==0 || mb1==0)
    {
     printf("got 0\n");
    }

//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].sj].nx+
      (ma2-mb2)*S[E[e].sj].ny;
    printf("Q:%lf\n",Q);
    a1[E[e].sj]+=Q;

    if(Mat[E[S[E[e].sj].ea].mark].D11-Mat[E[S[E[e].sj].eb].mark].D11>0) 
    printf("3ACHTUNG: E: %d, S: %d\n",e,E[e].sj);
    F[k]-=1.0/2*(2)*Q;
    F[i]-=1.0/2*(2)*Q;
    invar1+=Q;
    l1+=S[E[e].sj].nx;
  }
 }

 // задание краевого условия
 for(i=0;i<nP;i++)
 {
  if(P[i].mark==1)
  {
  for(j=0;j<2*Diag+1;j++)
   K[j+i*(2*Diag+1)]=0;
   K[IC(i,i,Diag)]=1.0; F[i]=0;
  }
 }

 sprintf(buf,"%s.a1",fname);
 fp=fopen(buf,"w");

 for(i=0;i<nS;i++)
 {
   fprintf(fp,"%+lf\n",a1[i]);
 }
 fclose(fp);

 // ===============================================
// PM(K,nP,Diag,F);
 // ===============================================

 printf("Нахождение решения N1..");
 DiagGSolve(K,nP,Diag,X,F);
 printf("Ok\n");
 sprintf(buf,"%s.n1",fname);
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
 printf("Max N1: %le\n",maxn);
 fclose(fp);

 // ===============================================
 // Решение для N2
 for(i=0;i<nP*(2*Diag+1);i++) K[i]=0;
 for(i=0;i<nP;i++) F[i]=0;
 for(i=0;i<nP;i++) X[i]=0;
 // построение матрицы жёсткости
 for(e=0;e<nE;e++)
 {
  i=E[e].i; j=E[e].j; k=E[e].k;
  A=E[e].A; 
//  A=0.5;
  if(E[e].mark<0)
  {
   printf("Не все подобласти имеют материал!\n");
   return -1;
  }

  D11=Mat[E[e].mark].D11;
  D12=Mat[E[e].mark].D12;
  D21=Mat[E[e].mark].D21;
  D22=Mat[E[e].mark].D22;

//  /*
  K[IC(i,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bi+(D12+D21)*(E[e].bi*E[e].ci+E[e].ci*E[e].bi)+2*D22*E[e].ci*E[e].ci);
  K[IC(i,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bj+(D12+D21)*(E[e].bi*E[e].cj+E[e].ci*E[e].bj)+2*D22*E[e].ci*E[e].cj);
  K[IC(i,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bi*E[e].bk+(D12+D21)*(E[e].bi*E[e].ck+E[e].ci*E[e].bk)+2*D22*E[e].ci*E[e].ck);
                                                                                                   
  K[IC(j,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bi+(D12+D21)*(E[e].bj*E[e].ci+E[e].cj*E[e].bi)+2*D22*E[e].cj*E[e].ci);
  K[IC(j,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bj+(D12+D21)*(E[e].bj*E[e].cj+E[e].cj*E[e].bj)+2*D22*E[e].cj*E[e].cj);
  K[IC(j,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bj*E[e].bk+(D12+D21)*(E[e].bj*E[e].ck+E[e].cj*E[e].bk)+2*D22*E[e].cj*E[e].ck);
                                                                                                    
  K[IC(k,i,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bi+(D12+D21)*(E[e].bk*E[e].ci+E[e].ck*E[e].bi)+2*D22*E[e].ck*E[e].ci);
  K[IC(k,j,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bj+(D12+D21)*(E[e].bk*E[e].cj+E[e].ck*E[e].bj)+2*D22*E[e].ck*E[e].cj);
  K[IC(k,k,Diag)]+=A*2/(4*A*A)*(2*D11*E[e].bk*E[e].bk+(D12+D21)*(E[e].bk*E[e].ck+E[e].ck*E[e].bk)+2*D22*E[e].ck*E[e].ck);
//  */
//  if(E[e].mark!=2) continue;

  if(S[E[e].sk].mark==2) // сторона i-j
  {
    ea=S[E[e].sk].ea; eb=S[E[e].sk].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D21 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D22 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D21 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D22 :0;

//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].sk].nx+
      (ma2-mb2)*S[E[e].sk].ny;
    a2[E[e].sk]+=Q;
    F[i]-=1.0/2*(2)*Q;
    F[j]-=1.0/2*(2)*Q;
    invar2+=Q;
    l2+=S[E[e].sk].ny;
  }
  if(S[E[e].si].mark==2) // сторона j-k
  {
    ea=S[E[e].si].ea; eb=S[E[e].si].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D21 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D22 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D21 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D22 :0;

//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].si].nx+
      (ma2-mb2)*S[E[e].si].ny;
    a2[E[e].si]+=Q;
    F[j]-=1.0/2*(2)*Q;
    F[k]-=1.0/2*(2)*Q;
    invar2+=Q;
    l2+=S[E[e].si].ny;
  }
  if(S[E[e].sj].mark==2) // сторона k-i
  {
    ea=S[E[e].sj].ea; eb=S[E[e].sj].eb;
    ma1=  ea >=0 ? Mat[E[ea].mark].D21 :0;
    ma2=  ea >=0 ? Mat[E[ea].mark].D22 :0;
    mb1=  eb >=0 ? Mat[E[eb].mark].D21 :0;
    mb2=  eb >=0 ? Mat[E[eb].mark].D22 :0;

//    printf("элем. %d сторона k %d: сам : %d, по ту сторону: %d\n",e,E[e].sk,E[e].mark,E[E[e].ek].mark);
    Q=(ma1-mb1)*S[E[e].sj].nx+
      (ma2-mb2)*S[E[e].sj].ny;
    a2[E[e].sj]+=Q;
    F[k]-=1.0/2*(2)*Q;
    F[i]-=1.0/2*(2)*Q;
    invar2+=Q;
    l2+=S[E[e].sj].ny;
  }
 }

 // задание краевого условия
// /*
 for(i=0;i<nP;i++)
 {
  if(P[i].mark==1)
  {
   for(j=0;j<2*Diag+1;j++)
   K[j+i*(2*Diag+1)]=0;
   K[IC(i,i,Diag)]=1.0; F[i]=0;
  }
 }
// */

 sprintf(buf,"%s.a2",fname);
 fp=fopen(buf,"w");

 for(i=0;i<nS;i++)
 {
   fprintf(fp,"%+lf\n",a2[i]);
 }
 fclose(fp);

 // ===============================================
// PM(K,nP,Diag,F);
 // ===============================================
 printf("Нахождение решения N2..");
 DiagGSolve(K,nP,Diag,X,F);
 printf("Ok\n");
 sprintf(buf,"%s.n2",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",nP);

 maxn=X[0];
 for(i=0;i<nP;i++)
 {
   fprintf(fp,"%+17.10le\n",X[i]);
   maxn=max(maxn,fabs(X[i]));
 }
 printf("Max N2: %le\n",maxn);

 fclose(fp);
 printf("I-I: %le\n",invar1-invar2);
 printf("l1,l2: %le,%le\n",l1,l2);
 printf("l-l: %le\n",l1-l2);


 free(P);
 free(E);
 free(K);
 return 0;
}