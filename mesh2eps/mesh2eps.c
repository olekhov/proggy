#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "minmax.h"

typedef struct 
{ 
   double x,y;
} Point;

typedef struct
{
   int i,j;
   int mark;
} Side;

typedef struct
{
  int i,j,k,mark;
} Elem;



char epsfname[80];
Side BBox[2]={{0,0,0},{400,400,0}};
Point viewport[2];
int hasviewport=0;
void writeleadin(FILE *fp);
void writeleadout(FILE *fp);

int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE);


int main(int argc,char *argv[])
{
 FILE *fp;
 Point *P; 
 Side *S;
 Elem *E;
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
  sscanf(argv[2],"%lf",&viewport[0].x);
  sscanf(argv[3],"%lf",&viewport[0].y);
  sscanf(argv[4],"%lf",&viewport[1].x);
  sscanf(argv[5],"%lf",&viewport[1].y);
  printf("viewport: (%+6.3lf,%+6.3lf)-(%+6.3lf,%+6.3lf)\n",viewport[0].x,viewport[0].y,viewport[1].x,viewport[1].y);
  hasviewport=1;
 }

 sprintf(epsfname,"%s.eps",fname);
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
 for(i=0;i<nS;i++) fscanf(fp,"%d %d %d %d %lf %lf %d",&S[i].i,&S[i].j,&idummy,&idummy,&ddummy,&ddummy,&S[i].mark);
 fclose(fp);
 printf("Sides...\n");
 E=NULL;
 }
 WriteEPS(P,nP,S,E,nS,nE);
 free(P);free(S);
 return 0;
}



void writeleadin(FILE *fp)
{
//  int x=BBox[1].i,y=BBox[1].j;
  fprintf(fp,"%s\n","%!PS");
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


int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE)
{
  FILE *fp;
  double maxx,maxy,minx,miny,Rx,Ry;
  int s,p; 
  int x,y,flag;
  double lastwidth,width;
  const char *color[]=
  {
    "0 0 0 0 k",             // белый
    "0.33 0.33 0.25 0.00 k", // фиолетовый
    "0.33 0.02 0.00 0.00 k", // зелёный
    "0.05 0.00 0.33 0.00 k", // жёлтый
    "0.15 0.33 0.33 0.00 k"  // красный
  };

  fp=fopen(epsfname,"w");
  flag=0;
  for(p=0;p<nP;p++)
  {
   if(hasviewport)
   {
    if(P[p].x<viewport[0].x) continue;
    if(P[p].x>viewport[1].x) continue;
    if(P[p].y<viewport[0].y) continue;
    if(P[p].y>viewport[1].y) continue;
   }
   if(!flag)
   {
    maxx=minx=P[p].x;
    maxy=miny=P[p].y;
    flag=1;
   }
//   printf("point %d not rejected\n",p);
   maxx=max(maxx,P[p].x);
   minx=min(minx,P[p].x);

   maxy=max(maxy,P[p].y);
   miny=min(miny,P[p].y);
  }
  BBox[1].j=BBox[1].i/((maxx-minx)/(maxy-miny));
//  R=sqrt(10.0)*1000.0;
  Rx=BBox[1].i*10;
  Ry=BBox[1].j*10;
  writeleadin(fp);
  fprintf(fp,"%14.13lf %14.13lf scale\n",0.1,0.1); // масштабирование - координаты целые
  lastwidth=-1;
  width=0.5;

  if(!E)
  for(s=0;s<nS;s++)
  {
   p=S[s].i;
   if(hasviewport)
   {
    if(P[p].x<viewport[0].x) continue;
    if(P[p].x>viewport[1].x) continue;
    if(P[p].y<viewport[0].y) continue;
    if(P[p].y>viewport[1].y) continue;
   }
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   fprintf(fp,"%4d %4d m\n",x,y); // moveto
   p=S[s].j;
   if(hasviewport)
   {
    if(P[p].x<viewport[0].x) continue;
    if(P[p].x>viewport[1].x) continue;
    if(P[p].y<viewport[0].y) continue;
    if(P[p].y>viewport[1].y) continue;
   }
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   if(S[s].mark!=0)
     width=15.0;
   else  width=1.5;
   if(fabs(lastwidth-width)>0)
    fprintf(fp,"%4.2lf setlinewidth\n",width); // толщина линий. на толщину влияет масштаб
//   if (S[s].mark==0) fprintf(fp,"%s ","%");
   fprintf(fp,"%4d %4d l\n",x,y); // lineto 
   fprintf(fp,"s\n"); // stroke
   lastwidth=width;
  }
  else // Elements!
  for(s=0;s<nE;s++)
  {
   fprintf(fp,"%s\n",color[E[s].mark]);
   p=E[s].i;
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   fprintf(fp,"%4d %4d m\n",x,y); // moveto
   p=E[s].j;
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   fprintf(fp,"%4d %4d l\n",x,y); // moveto
   p=E[s].k;
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   fprintf(fp,"%4d %4d l\n",x,y); // moveto
   p=E[s].i;
   x=(P[p].x-minx)/(maxx-minx)*Rx;
   y=(P[p].y-miny)/(maxy-miny)*Ry;
   fprintf(fp,"%4d %4d l\n",x,y); // moveto
   fprintf(fp,"B\n");
  }
//  fprintf(fp,"s\n"); // stroke
  writeleadout(fp);
  fclose(fp);
  return 0;
}
