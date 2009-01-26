#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef struct 
{ 
   double x,y;
} Point;


double a1scale=100, a2scale=100;

typedef struct
{
   int i,j;
   double nx,ny;
   int mark;
} Side;

typedef struct
{
  int i,j,k,mark;
} Elem;

char epsfname[80];
Side BBox[2]={{0,0},{400,400}};
Point viewport[2];
int hasviewport=0;
void writeleadin(FILE *fp);
void writeleadout(FILE *fp);

int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE, double *a1, double *a2);


int main(int argc,char *argv[])
{
 FILE *fp;
 Point *P; 
 Side *S;
 Elem *E;
 double *a1,*a2;
 int nP,nS, nE;
 int i,idummy,j;
 char fname[80],buf[200];
 double ddummy;
 int fillmat=0;

 if(argc<2)
 {
  printf("argument missing\n");
  return -1;
 }
 if(!strcmp(argv[1],"-f"))
 {
   fillmat=1;
   printf("filling as material!\n");
   argv++; argc--;
 }
 if(argc<2)
 {
  printf("argument missing\n");
  return -1;
 }
 sprintf(fname,"%s",argv[1]);
 fname[strlen(fname)-2]=0;
 if(argc>2)
 {
  sscanf(argv[2],"%lf",&a1scale); a2scale=a1scale;
 }
 if(argc>3)
 {
  sscanf(argv[3],"%lf",&a2scale);
 }

 sprintf(epsfname,"%s_e.eps",fname);
 sprintf(buf,"%s.n",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nP); // количество точек
 P=malloc(nP*sizeof(Point));
 for(i=0;i<nP;i++) fscanf(fp,"%lf %lf %d",&P[i].x,&P[i].y,&idummy);
 fclose(fp);
 printf("Points...\n");
 if(fillmat)
 {
 sprintf(buf,"%s.e",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nE); // количество элементов
 E=malloc(nE*sizeof(Elem));
 for(i=0;i<nE;i++) 
 {
  fscanf(fp,"%d %d %d",&E[i].i,&E[i].j,&E[i].k);
  for(j=0;j<6;j++) fscanf(fp,"%d",&idummy);
  fscanf(fp,"%d",&E[i].mark);
  for(j=0;j<10;j++) fscanf(fp,"%lf",&ddummy);

 } 
 fclose(fp);
 printf("Elements...\n");
 S=NULL;
 } else
 {
 sprintf(buf,"%s.s",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nS); // количество отрезков
 S=malloc(nS*sizeof(Side));
 for(i=0;i<nS;i++) fscanf(fp,"%d %d %d %d %lf %lf %d",&S[i].i,&S[i].j,&idummy,&idummy,&S[i].nx,&S[i].ny,&S[i].mark);
 fclose(fp);
 printf("Sides...\n");
 E=NULL;
 }
 printf("A..\n");
 a1=malloc(nS*sizeof(double));
 a2=malloc(nS*sizeof(double));
 sprintf(buf,"%s.a1",fname);
 fp=fopen(buf,"r");
 for(i=0;i<nS;i++) fscanf(fp,"%lf",&a1[i]);
 fclose(fp);
 sprintf(buf,"%s.a2",fname);
 fp=fopen(buf,"r");
 for(i=0;i<nS;i++) fscanf(fp,"%lf",&a2[i]);
 fclose(fp);

 WriteEPS(P,nP,S,E,nS,nE,a1,a2);
 free(P);free(S);
 return 0;
}



void writeleadin(FILE *fp)
{
  int x=BBox[1].i,y=BBox[1].j;
  fprintf(fp,"%s\n","%!");
  fprintf(fp,"%s\n","%%Creator: - Created by Mesh2EPS mesh converter Copyright 2002, 2003 Basilio");
  fprintf(fp,"%s %s\n","%%Title:",epsfname);
  fprintf(fp,"%s","%%Pages: 1\n");
  fprintf(fp,"%%%%BoundingBox: %d %d %d %d\n",BBox[0].i,BBox[0].j,BBox[1].i,BBox[1].j);
  fprintf(fp,"%%%%EndComments\n");
  fprintf(fp,"/m {moveto} def\n");
  fprintf(fp,"/l {lineto} def\n");
  fprintf(fp,"/s {stroke} def\n");
  fprintf(fp,"/n {newpath} def\n");
  fprintf(fp,"/F {fillC fillM fillY fillK setcmykcolor eofill} def\n");
  fprintf(fp,"/S {strokeC strokeM strokeY strokeK setcmykcolor stroke} def\n");
  fprintf(fp,"/B {gsave F grestore S} bind def\n");
  fprintf(fp,"/K { /strokeK exch def /strokeY exch def /strokeM exch def /strokeC exch def } bind def\n");
  fprintf(fp,"/k { /fillK   exch def /fillY   exch def /fillM   exch def /fillC   exch def } bind def\n");
  fprintf(fp,"0.00 0.00 0.00 1.00 K\n");
  fprintf(fp,"0 setlinejoin\n"); // Miter join - форма стыка двух отрезков
  // прямоугольная рамка по BoundingBox
 // fprintf(fp,"n 0 0 m %d 0 l %d %d l 0 %d l 0 0 l s\n",x,x,y,y); 
}
void writeleadout(FILE *fp)
{
 fprintf(fp,"\nshowpage\n");
// fprintf(fp,"%%%%EndDocument\n");
// fprintf(fp,"%%%%EOF\n");
}


int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE, double *a1,double *a2)
{
  FILE *fp;
  double maxx,maxy,minx,miny,Rx,Ry;
  int s,p1,p2; 
  int sx,sy,ex,ey,flag;
  int srx1,srx2,sry1,sry2;
  double lastwidth,width;
  double reclen, rx1,ry1,rx2,ry2;
  double normx, normy, nlen;
  char *color[]=
  {
    "0 0 0 0 k",             // белый
    "0.33 0.33 0.25 0.00 k", // фиолетовый
    "0.33 0.02 0.00 0.00 k", // зелёный
    "0.05 0.00 0.33 0.00 k", // жёлтый
    "0.15 0.33 0.33 0.00 k"  // красный
  };

  fp=fopen(epsfname,"w");
  flag=0;
  for(p1=0;p1<nP;p1++)
  {
   if(!flag)
   {
    maxx=minx=P[p1].x;
    maxy=miny=P[p1].y;
    flag=1;
   }
//   printf("point %d not rejected\n",p);
   maxx=max(maxx,P[p1].x);
   minx=min(minx,P[p1].x);

   maxy=max(maxy,P[p1].y);
   miny=min(miny,P[p1].y);
  }
  BBox[1].j=BBox[1].i/((maxx-minx)/(maxy-miny));
//  R=sqrt(10.0)*1000.0;
  Rx=BBox[1].i*10;
  Ry=BBox[1].j*10;
  writeleadin(fp);
  fprintf(fp,"%14.13lf %14.13lf scale\n",0.1,0.1); // масштабирование - координаты целые
  lastwidth=-1;
  width=0.5;

  for(s=0;s<nS;s++)
  {
   if(! S[s].mark) continue;

   p1=S[s].i;
   normx=S[s].nx; normy=S[s].ny;

   nlen=sqrt(normx*normx+normy*normy);
   normx/=nlen;
   normy/=nlen;
//   printf("%lf %lf\n",normx,normy);

   sx=(P[p1].x-minx)/(maxx-minx)*Rx;
   sy=(P[p1].y-miny)/(maxy-miny)*Ry;

   p2=S[s].j;
   ex=(P[p2].x-minx)/(maxx-minx)*Rx;
   ey=(P[p2].y-miny)/(maxy-miny)*Ry;

   if(fabs(a1[s])>1e-15)
   {
    reclen=a1[s]/nlen/a1scale;
    rx1=P[p1].x;ry1=P[p1].y;
    rx2=P[p2].x;ry2=P[p2].y;
    rx1+=normx*reclen; rx2+=normx*reclen;
    ry1+=normy*reclen; ry2+=normy*reclen;

    srx1=(rx1-minx)/(maxx-minx)*Rx;
    sry1=(ry1-miny)/(maxy-miny)*Ry;
    srx2=(rx2-minx)/(maxx-minx)*Rx;
    sry2=(ry2-miny)/(maxy-miny)*Ry;

    fprintf(fp,"%4.2lf setlinewidth\n",1.0); 
    fprintf(fp,"%4d %4d m\n",ex,ey); // moveto
    fprintf(fp,"%4d %4d l\n",sx,sy); // moveto
    fprintf(fp,"%4d %4d l\n",srx1,sry1); // moveto
    fprintf(fp,"%4d %4d l\n",srx2,sry2); // moveto
    fprintf(fp,"%4d %4d l\n",ex,ey); // moveto
    fprintf(fp,"%s B\n",color[2]);
   }

   if(fabs(a2[s])>1e-15)
   {
    reclen=(a2[s])/nlen/a2scale;
//    rx1=P[p1].x;ry1=P[p1].y;
//    rx2=P[p2].x;ry2=P[p2].y;
    rx2=rx1=(P[p1].x+P[p2].x)/2;
    ry2=ry1=(P[p1].y+P[p2].y)/2;

    rx1+=normx*reclen; rx2+=normx*reclen;
    ry1+=normy*reclen; ry2+=normy*reclen;

    srx1=(rx1-minx)/(maxx-minx)*Rx;
    sry1=(ry1-miny)/(maxy-miny)*Ry;
    srx2=(rx2-minx)/(maxx-minx)*Rx;
    sry2=(ry2-miny)/(maxy-miny)*Ry;

    fprintf(fp,"%4.2lf setlinewidth\n",1.0); 
    fprintf(fp,"%4d %4d m\n",ex,ey); // moveto
    fprintf(fp,"%4d %4d l\n",sx,sy); // moveto
    fprintf(fp,"%4d %4d l\n",srx1,sry1); // moveto
    fprintf(fp,"%4d %4d l\n",srx2,sry2); // moveto
    fprintf(fp,"%4d %4d l\n",ex,ey); // moveto
    fprintf(fp,"%s B\n",color[3]);
   }


   fprintf(fp,"%4.2lf setlinewidth\n",15.0); 
   fprintf(fp,"%4d %4d m\n",sx,sy); // moveto
   fprintf(fp,"%4d %4d l\n",ex,ey); // moveto

   fprintf(fp,"s\n"); // stroke
   lastwidth=width;
  }
  writeleadout(fp);
  fclose(fp);
  return 0;
}
