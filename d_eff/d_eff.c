#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


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

void CalculateDiff(TElement *E,int nE, TPoint *P, int nP, double *cell,double *X,double *dXx, double *dXy, double*dEx,double * dEy);

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

 double *K,*F,*N1,*N2,*dN1dx, *dN1dy,*dN2dx, *dN2dy, maxn, *a1, *a2, *cell;
 double effD11,effD12, effD21, effD22, Int;

 double *edN1dx,*edN1dy, *edN2dx,*edN2dy,Volume;

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
 cell=malloc(nP*sizeof(double));
 Volume=0;
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

   cell[E[i].i]+=E[i].A;
   cell[E[i].j]+=E[i].A;
   cell[E[i].k]+=E[i].A;
   Volume+=E[i].A;
 }
 fclose(fp);
 
 N1=malloc(nP*sizeof(double));
 sprintf(buf,"%s.n1",fname);
 fp=fopen(buf,"r"); fscanf(fp,"%d",&ea);
 for(i=0;i<nP;i++)
  fscanf(fp,"%lf",& N1[i]);
 fclose(fp);
 N2=malloc(nP*sizeof(double));
 sprintf(buf,"%s.n2",fname);
 fp=fopen(buf,"r"); fscanf(fp,"%d",&ea);
 for(i=0;i<nP;i++)
  fscanf(fp,"%lf",& N2[i]);
 fclose(fp);
 printf("Нахождение производных...\n");

 dN1dx=malloc(nP*sizeof(double));
 dN1dy=malloc(nP*sizeof(double));
 dN2dx=malloc(nP*sizeof(double));
 dN2dy=malloc(nP*sizeof(double));
 edN1dx=malloc(nE*sizeof(double));
 edN1dy=malloc(nE*sizeof(double));
 edN2dx=malloc(nE*sizeof(double));
 edN2dy=malloc(nE*sizeof(double));

 CalculateDiff(E,nE,P,nP,cell,N1,dN1dx,dN1dy,edN1dx,edN1dy);
 CalculateDiff(E,nE,P,nP,cell,N2,dN2dx,dN2dy,edN2dx,edN2dy);

 effD11=effD12=effD21=effD22=0;

 for(e=0;e<nE;e++)
 {
  
  D11=Mat[E[e].mark].D11;
  D12=Mat[E[e].mark].D12;
  D21=Mat[E[e].mark].D21;
  D22=Mat[E[e].mark].D22;

  Int=D11*edN1dx[e]+D21*edN1dy[e]+D11;
  effD11+=Int*E[e].A;

  Int=D12*edN1dx[e]+D22*edN1dy[e]+D12;
  effD12+=Int*E[e].A;

  Int=D11*edN2dx[e]+D21*edN2dy[e]+D21;
  effD21+=Int*E[e].A;

  Int=D12*edN2dx[e]+D22*edN2dy[e]+D22;
  effD22+=Int*E[e].A;

 }

 effD11/=Volume;
 effD12/=Volume;
 effD21/=Volume;
 effD22/=Volume;

 sprintf(buf,"%s.d.eff",fname);
 fp=fopen(buf,"w"); 
 fprintf(fp,"%le %le\n%le %le\n",effD11,effD12,effD21,effD22);
 fclose(fp);



 free(P);
 free(E);
 free(N1);
 free(N2);
 return 0;
}

void CalculateDiff(TElement *E,int nE, TPoint *P, int nP, double *cell,double *X,double *dXx, double *dXy, double*dEx, double *dEy)
{
 int e,n;

 for(n=0;n<nP;n++) dXx[n]=dXy[n]=0;

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
