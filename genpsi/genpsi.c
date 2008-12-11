#include <stdio.h>
#include <math.h>
#include <string.h>


int main(int argc, char * argv[])
{
 FILE *fnodes, *fn1, *fn2, *fdiff, *fpsi0, *fpsi;
 int i,j,k,N;
 double x,y,z,mz;
 double n1, n2, psi0, psi0dx, psi0dy;
 char fname[200];

 argv[1][strchr(argv[1],'.')-argv[1]]=0;
 printf("argv: %s\n",argv[1]);

 sprintf(fname,"%s.n",argv[1]);
 fnodes=fopen(fname,"r");
 fscanf(fnodes,"%d",&N);

 sprintf(fname,"%s.psi0",argv[1]);
 fpsi0=fopen(fname,"r");
 fscanf(fpsi0,"%d",&N);

 sprintf(fname,"%s.dpsi0",argv[1]);
 fdiff=fopen(fname,"r");
 fscanf(fdiff,"%d",&N);

 sprintf(fname,"%s.n1",argv[1]);
 fn1=fopen(fname,"r");
 fscanf(fn1,"%d",&N);

 sprintf(fname,"%s.n2",argv[1]);
 fn2=fopen(fname,"r");
 fscanf(fn2,"%d",&N);

 sprintf(fname,"%s.psi",argv[1]);
 fpsi=fopen(fname,"w");
 fprintf(fpsi,"%d\n",N);

 mz=0;
 for (i=0;i<N;i++)
 {
  fscanf(fnodes,"%lf %lf %d",&x,&y,&j);
  fscanf(fn1,"%lf",&n1);
  fscanf(fn2,"%lf",&n2);
  fscanf(fpsi0,"%lf",&psi0);
  fscanf(fdiff,"%lf %lf",&psi0dx, &psi0dy);

  z=psi0+n1*psi0dx+n2*psi0dy;


  fprintf(fpsi,"%le\n", z);
 }
 fclose(fnodes);
 fclose(fn1);
 fclose(fn2);
 fclose(fdiff);
 fclose(fpsi);
 fclose(fpsi0);

 return 0;
}
