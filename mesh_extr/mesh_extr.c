//
//
// Модификация триангуляции для "периодичности"
// ============================================

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

double max(double a,double b)
{
  if(a>b) return a;
  return b;
}

double min(double a,double b)
{
  if(a<b) return a;
  return b;
}


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

int nP,nE,nS;
TPoint *P;
TElement *E;
TSide *S;

TPoint viewport[2];

double len(double x,double y) {return /*sqrt*/(x*x+y*y);}

int Inside(double x, double a, double b)
{
 return x<=b && x>=a;
}

int main(int argc, char * argv[])
{
 FILE *fp;
 int i,j,k,e;
 int Diag=0;
 char fname[80],buf[200];
 double invar1,invar2,l1,l2;
 double ma1,ma2,mb1,mb2;

 double *K,*F,*X,maxn, *a1, *a2, *N1, *N2;
 int ea,eb;
 int *mapP, *mapS, *mapE, numP, numS, numE;

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

 if(argc>2)
 {
  sscanf(argv[2],"%lf",&viewport[0].x);
  sscanf(argv[3],"%lf",&viewport[0].y);
  sscanf(argv[4],"%lf",&viewport[1].x);
  sscanf(argv[5],"%lf",&viewport[1].y);
  printf("window: (%+6.3lf,%+6.3lf)-(%+6.3lf,%+6.3lf)\n",viewport[0].x,viewport[0].y,viewport[1].x,viewport[1].y);
 } else
 {
  printf("window not defined. exiting..\n");
  return 0;
 }
 mapP=malloc(sizeof(int)*nP); for(i=0;i<nP;i++) mapP[i]=-1;
 mapS=malloc(sizeof(int)*nS); for(i=0;i<nS;i++) mapS[i]=-1;
 mapE=malloc(sizeof(int)*nE); for(i=0;i<nE;i++) mapE[i]=-1;
 N1=malloc(sizeof(double)*nP);
 N2=malloc(sizeof(double)*nP);

 sprintf(buf,"%s.n1",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&i);
 for(i=0;i<nP;i++)
   fscanf(fp,"%le",&N1[i]);
 fclose(fp);
 sprintf(buf,"%s.n2",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&i);
 for(i=0;i<nP;i++)
   fscanf(fp,"%le",&N2[i]);
 fclose(fp);

 printf("data read, pool allocated, finding matches..\n");
 numP=0;
 for(i=0;i<nP;i++)
 {
   if ( !Inside(P[i].x, viewport[0].x, viewport[1].x) || 
        !Inside(P[i].y, viewport[0].y, viewport[1].y)) continue;
   mapP[i]=numP;
   numP++;
 }
 printf("nodes found: %d\n",numP);

 numS=0;
 for(i=0;i<nS;i++)
 {
   if ( mapP[S[i].i]<0) continue;
   if ( mapP[S[i].j]<0) continue;

   mapS[i]=numS;
   numS++;
 }
 printf("sides found: %d\n",numS);

 numE=0;
 for(i=0;i<nE;i++)
 {
   if ( mapP[E[i].i]<0) continue;
   if ( mapP[E[i].j]<0) continue;
   if ( mapP[E[i].k]<0) continue;
   mapE[i]=numE;
   numE++;
 }
 printf("elems found: %d\n",numE);

 printf("saving..\n");

 sprintf(buf,"extr/%s.n",fname);
 fp=fopen(buf,"w");
  fprintf(fp,"%d\n",numP);
 for(i=0;i<nP;i++)
  if(mapP[i]>=0) fprintf(fp,"%le %le %d\n",P[i].x,P[i].y, P[i].mark);
 fclose(fp);

 printf("Nodes saved\n");

 sprintf(buf,"extr/%s.s",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",numS);
 for(i=0;i<nS;i++)
 {
  if(mapS[i]<0) continue;
  fprintf(fp,"%d %d ",mapP[S[i].i],mapP[S[i].j]);
  fprintf(fp,"%4d %4d "       // соседние элементы
             "%+17.16e %+17.16e " // нормаль
             "%d \n " // маркер
             ,
             S[i].ea<0? -1:mapE[S[i].ea],
             S[i].eb<0? -1:mapE[S[i].eb],
             S[i].nx, S[i].ny,
             S[i].mark);
 }
 fclose(fp);
 printf("Sides saved\n");

 sprintf(buf,"extr/%s.e",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",numE);
 for(i=0;i<nE;i++)
 {
  if(mapE[i]<0) continue;
  fprintf(fp,   "%4d %4d %4d  " // i,j,k
                "%4d %4d %4d  " // ei,ej,ek
                "%4d %4d %4d  " // si,sj,sk
                "%4d  " // material
                // Функции формы:
                "%+17.16e  " // A
                "%+17.16e %+17.16e %+17.16e  " // ai,bi,ci
                "%+17.16e %+17.16e %+17.16e  " // aj,bj,cj
                "%+17.16e %+17.16e %+17.16e  " // ak,bk,ck
                "\n",
                    mapP[E[i].i], mapP[E[i].j], mapP[E[i].k],
                    E[i].ei<0?-1:mapE[E[i].ei], 
                    E[i].ej<0?-1:mapE[E[i].ej], 
                    E[i].ek<0?-1:mapE[E[i].ek], 

                    E[i].si<0?-1:mapS[E[i].si], 
                    E[i].sj<0?-1:mapS[E[i].sj], 
                    E[i].sk<0?-1:mapS[E[i].sk], 

//                    r_elem[e].xv, r_elem[e].yv,
                    E[i].mark,
                    E[i].A,
                    E[i].ai,
                    E[i].bi,
                    E[i].ci,
                    E[i].aj,
                    E[i].bj,
                    E[i].cj,
                    E[i].ak,
                    E[i].bk,
                    E[i].ck
                    );
 }
 fclose(fp);
 printf("Elems saved\n");

 sprintf(buf,"extr/%s.n1",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",numP);
 for(i=0;i<nP;i++)
 {
  if(mapP[i]<0) continue;
  fprintf(fp,"%le\n",N1[i]);
 }
 fclose(fp);

 sprintf(buf,"extr/%s.n2",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",numP);
 for(i=0;i<nP;i++)
 {
  if(mapP[i]<0) continue;
  fprintf(fp,"%le\n",N2[i]);
 }
 fclose(fp);

 return 0;
}
