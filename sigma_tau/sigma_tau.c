#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


#ifndef max
#define max(a,b) ( (a) > (b) ? (a) : (b) )
#endif

#ifndef min
#define min(a,b) ( (a) < (b) ? (a) : (b) )
#endif


typedef struct
{
  double x,y;
  double cluster_area;
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
 double tau,M;

 double *Dx,*Dy,*Func,diff;
 double *Sigma13, *Sigma23;
 int ea,eb,ei,ej,ek;


 if(argc==1) { printf("argument missing\n"); return -1; }
 sscanf(argv[1],"%s",fname);
 fname[strchr(fname,'.')-fname]=0;
 printf("fname=%s\n",fname);

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
 {
   fscanf(fp,"%le %le %d",&P[i].x,&P[i].y,&P[i].mark);
   P[i].cluster_area=0;
 }
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

   P[E[i].i].cluster_area+=E[i].A;
   P[E[i].j].cluster_area+=E[i].A;
   P[E[i].k].cluster_area+=E[i].A;
 }
 fclose(fp);

 sprintf(buf,"%s.psi",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nP);
 Func=malloc(nP*sizeof(double));
 for(i=0;i<nP;i++)
 {
  fscanf(fp,"%lf",& Func[i]);
 }
 fclose(fp);


 Dx=malloc(nP*sizeof(double));
 Dy=malloc(nP*sizeof(double));

 for(i=0;i<nP;i++) Dx[i]=Dy[i]=0;

 for(i=0;i<nE;i++)
 {

   ei=E[i].i; ej=E[i].j; ek=E[i].k;

   diff=1/(2*E[i].A)*(E[i].bi*Func[ei]+E[i].bj*Func[ej]+E[i].bk*Func[ek]);

   Dx[ei]+=diff*E[i].A;
   Dx[ej]+=diff*E[i].A;
   Dx[ek]+=diff*E[i].A;

   diff=1/(2*E[i].A)*(E[i].ci*Func[ei]+E[i].cj*Func[ej]+E[i].ck*Func[ek]);

   Dy[ei]+=diff*E[i].A;
   Dy[ej]+=diff*E[i].A;
   Dy[ek]+=diff*E[i].A;
 }

 for(i=0;i<nP;i++)
 {
  Dx[i]/=P[i].cluster_area;
  Dy[i]/=P[i].cluster_area;
 }

 tau=0;M=1000;

 for(i=0;i<nE;i++)
 {
  ei=E[i].i; ej=E[i].j; ek=E[i].k;
  tau+= E[i].A*(Func[ei]+Func[ej]+Func[ek])/3;
 }
 printf("D=%le\n",2*tau);
 tau=M/(2*tau);
 printf("tau=%le\n",tau);

 Sigma13=malloc(nP*sizeof(double));
 Sigma23=malloc(nP*sizeof(double));

 for(i=0;i<nP;i++)
 {
  Sigma13[i]=tau*Dy[i];
  Sigma23[i]=-tau*Dx[i];
 }

 sprintf(buf,"%s.sigma",fname);
 fp=fopen(buf,"w");
 fprintf(fp,"%d\n",nP);
 for(i=0;i<nP;i++)
 {
  fprintf(fp,"%le %le\n", Sigma13[i],Sigma23[i]);
 }
 fclose(fp);

 
 free(Sigma13);
 free(Sigma23);
 free(E);
 free(P);
 free(Dx);
 free(Dy);
 free(Func);
 
 return 0;
}
