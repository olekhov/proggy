#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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

char epsfname[80];
Side BBox[2]={{0,0},{400,400}};
Point viewport[2];
int hasviewport=0;
void writeleadin(FILE *fp);
void writeleadout(FILE *fp);

int WriteEPS(Point *P,int nP, Side *S,int nS);


int main(int argc,char *argv[])
{
 FILE *fp;
 Point *P; 
 Side *S;
 int nP,nS;
 int i,idummy;
 char fname[80],buf[200];
 double ddummy;
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

 sprintf(epsfname,"%s-domain.eps",fname);
 sprintf(buf,"%s.n",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nP); // количество точек
 P=malloc(nP*sizeof(Point));
 for(i=0;i<nP;i++) fscanf(fp,"%lf %lf %d",&P[i].x,&P[i].y,&idummy);
 fclose(fp);
 sprintf(buf,"%s.s",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nS); // количество отрезков
 S=malloc(nS*sizeof(Side));
 for(i=0;i<nS;i++) fscanf(fp,"%d %d %d %d %lf %lf %d",&S[i].i,&S[i].j,&idummy,&idummy,&ddummy,&ddummy,&S[i].mark);
 fclose(fp);
 WriteEPS(P,nP,S,nS);
 free(P);free(S);
}



void writeleadin(FILE *fp)
{
  int x=BBox[1].i,y=BBox[1].j;
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


int WriteEPS(Point *P,int nP, Side *S,int nS)
{
  FILE *fp;
  double maxx,maxy,minx,miny,Rx,Ry;
  int s,p; 
  int x,y,flag;
  double lastwidth,width;

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
  fprintf(fp,"15.0 setlinewidth\n",width); // толщина линий. на толщину влияет масштаб
  for(s=0;s<nS;s++)
  {
   if (S[s].mark==0) continue;
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
   fprintf(fp,"%4d %4d l\n",x,y); // lineto 
   fprintf(fp,"s\n"); // stroke
   lastwidth=width;
  }
//  fprintf(fp,"s\n"); // stroke
  writeleadout(fp);
  fclose(fp);
}
