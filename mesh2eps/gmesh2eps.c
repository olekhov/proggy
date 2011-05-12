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


typedef struct
{ 
  double R,G,B;
} TRGBColor;

TRGBColor *palette,cur_color;
int PalSize;
int palx=410, paly=10,palsx=40,palsy=35,palspace=40,scale=10;

TRGBColor black={0,0,0}, white={1,1,1};


char epsfname[580];
Side BBox[2]={{0,0},{400,400}};
Point viewport[2];
int hasviewport=0;
void writeleadin(FILE *fp);
void writeleadout(FILE *fp);
double *Data,minn,maxn;


int noshade=0,bw=0, discrete=0, levels;

int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE);
void ShowPalette(FILE *fp);


int main(int argc,char *argv[])
{
 FILE *fp;
 Point *P; 
 Side *S;
 Elem *E;
 int nP,nS, nE;
 int i,idummy,j;
 char fname[580],buf[200];
 double ddummy;
 int fillmat=0;
 int arg=0;
 char *basefilename=argv[0];
 printf("%s\n",argv[0]);
 for(i=strlen(argv[0])-1;i>0;i--) if(argv[0][i]=='\\') break;
 argv[0][i+1]=0;
 printf("%s\n",argv[0]);


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
 if(!strcmp(argv[1],"-noshade"))
 {
   noshade=1;
   printf("No shading!\n");
   argv++; argc--;
 }
 if(!strcmp(argv[1],"-bw"))
 {
   bw=1;
   printf("black & white!\n");
   argv++; argc--;
 }
 if(!strcmp(argv[1],"-discrete"))
 {
   discrete=1;
   printf("discrete\n");
   argv++; argc--;
 }

 if(bw)
 {
  ReadPalette(strcat(basefilename,"bw.pal"));
 } else
 {
  ReadPalette(strcat(basefilename,"palette.pal"));
 }
 if(discrete) levels=PalSize;

 if(argc<2)
 {
  printf("argument missing\n");
  return -1;
 }
 sprintf(fname,"%s",argv[1]);
 fname[strlen(fname)-2]=0;

 printf("Points...\n");
 sprintf(buf,"%s.n",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nP); // количество точек
 P=malloc(nP*sizeof(Point));
 for(i=0;i<nP;i++) fscanf(fp,"%lf %lf %d",&P[i].x,&P[i].y,&idummy);
 fclose(fp);


 printf("Data...\n");

 arg=0;
 if(!strcmp(argv[2],"-n1"))
 {
   sprintf(buf,"%s.n1",fname);
 } else
 if(!strcmp(argv[2],"-n2"))
 {
   sprintf(buf,"%s.n2",fname);
 } else
 if(!strcmp(argv[2],"-psi"))
 {
   sprintf(buf,"%s.psi",fname);
 } else
 if(!strcmp(argv[2],"-ppsi-psi"))
 {
   sprintf(buf,"%s.psi",fname);
 } else
 if(!strcmp(argv[2],"-ppsi"))
 {
   sprintf(buf,"%s.psi",fname);
 } else
 if(!strcmp(argv[2],"-psi0"))
 {
   sprintf(buf,"%s.psi0",fname);
 } else
 if(!strcmp(argv[2],"-sigma13"))
 {
   sprintf(buf,"%s.sigma",fname);
   arg=1;
 } else
 if(!strcmp(argv[2],"-sigma23"))
 {
   sprintf(buf,"%s.sigma",fname);
   arg=2;
 } else
 if(!strcmp(argv[2],"-sigma"))
 {
   sprintf(buf,"%s.sigma",fname);
   arg=3;
 } else
 {
  printf("Не указана функция\n");
  return -1;
 }




 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nP); // количество точек
 Data=malloc(nP*sizeof(double));

 for(i=0;i<nP;i++) 
 {
   if(arg==0) fscanf(fp,"%lf",&Data[i]); else
   if(arg==1) fscanf(fp,"%lf %lf",&Data[i],&ddummy); else
   if(arg==2) fscanf(fp,"%lf %lf",&ddummy,&Data[i]); else
   {
    fscanf(fp,"%lf %lf",&ddummy,&Data[i]);
    Data[i]=sqrt(ddummy*ddummy+Data[i]*Data[i]);
   }
   if(i==0) minn=maxn=Data[0];
   minn=min(minn,Data[i]);
   maxn=max(maxn,Data[i]);
 
 }
 fclose(fp);
 printf("data read\n");


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

 sprintf(buf,"%s.s",fname);
 fp=fopen(buf,"r");
 fscanf(fp,"%d",&nS); // количество отрезков
 S=malloc(nS*sizeof(Side));
 for(i=0;i<nS;i++) fscanf(fp,"%d %d %d %d %lf %lf %d",&S[i].i,&S[i].j,&idummy,&idummy,&ddummy,&ddummy,&S[i].mark);
 fclose(fp);
 printf("Sides...\n");

 sprintf(epsfname,"%s%s.eps",fname,argv[2]);
 WriteEPS(P,nP,S,E,nS,nE);
 free(P);free(S);
 return 0;
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
  fprintf(fp,"/rl {rlineto} def\n");
  fprintf(fp,"/s {stroke} def\n");
  fprintf(fp,"/n {newpath} def\n");
  fprintf(fp,"/F {fillR fillG fillB setrgbcolor eofill} def\n");
  fprintf(fp,"/S {strokeR strokeG strokeB setrgbcolor stroke} def\n");
  fprintf(fp,"/B {gsave F grestore S} bind def\n");
  fprintf(fp,"/K { /strokeB exch def /strokeG exch def /strokeR exch def } bind def\n");
  fprintf(fp,"/k { /fillB   exch def /fillG   exch def /fillR   exch def } bind def\n");
  fprintf(fp,"/SHF {\n");
  fprintf(fp,"/b1 exch def /g1 exch def /r1 exch def /y1 exch def /x1 exch def\n");
  fprintf(fp,"/b2 exch def /g2 exch def /r2 exch def /y2 exch def /x2 exch def\n");
  fprintf(fp,"/b3 exch def /g3 exch def /r3 exch def /y3 exch def /x3 exch def\n");
  fprintf(fp,"gsave << /ShadingType 4 /ColorSpace [/DeviceRGB]\n");
  fprintf(fp,"/DataSource [ 0 x1 y1 r1 g1 b1 0 x2 y2 r2 g2 b2 0 x3 y3 r3 g3 b3 ] >>\n");
  fprintf(fp,"shfill grestore } bind def\n");


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

void ShowDomain(FILE *fp,Point*P,int nP, Side*S,int nS,double minx, double miny, double maxx, double maxy,
    double Rx, double Ry)
{
  int s,p,x,y;

  fprintf(fp,"5.0 setlinewidth\n"); // толщина линий. на толщину влияет масштаб
  for(s=0;s<nS;s++)
  {
   if (S[s].mark==0) continue;
//   if (S[s].mark==3) continue;
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
  }

}




void WriteContour(FILE*fp,Point*P,int nP, Elem*E,int nE,double *Data, double h, 
    double minx, double miny, double maxx, double maxy,
    double Rx, double Ry)

{
 int e,i,j,k,x,y;
 double di,dj,dk,ij,jk,ki;
 double sx,sy,ex,ey;

 for(e=0;e<nE;e++)
 {

  i=E[e].i; j=E[e].j; k=E[e].k;
  di=Data[i]-h; dj=Data[j]-h; dk=Data[k]-h;

  ij=di*dj; jk=dj*dk; ki=dk*di;

  // Если элемент не пересекается c уровнем - пропускаем
  if(ij>=0 && jk>=0 && ki>=0) continue;

  if(ij>0) // j--k, k--i
  {
   sx=(P[k].x*dj-P[j].x*dk)/(dj-dk);
   sy=(P[k].y*dj-P[j].y*dk)/(dj-dk);
   ex=(P[i].x*dk-P[k].x*di)/(dk-di);
   ey=(P[i].y*dk-P[k].y*di)/(dk-di);
  } else
  if(jk>0) // i--j, k--i
  {
   sx=(P[j].x*di-P[i].x*dj)/(di-dj);
   sy=(P[j].y*di-P[i].y*dj)/(di-dj);

   ex=(P[i].x*dk-P[k].x*di)/(dk-di);
   ey=(P[i].y*dk-P[k].y*di)/(dk-di);
  } else
  if(ki>0) // i--j, j--k,
  {
   sx=(P[j].x*di-P[i].x*dj)/(di-dj);
   sy=(P[j].y*di-P[i].y*dj)/(di-dj);
   ex=(P[k].x*dj-P[j].x*dk)/(dj-dk);
   ey=(P[k].y*dj-P[j].y*dk)/(dj-dk);
  }


  x=(sx-minx)/(maxx-minx)*Rx;
  y=(sy-miny)/(maxy-miny)*Ry;
  fprintf(fp,"%d %d m ",x,y);
  x=(ex-minx)/(maxx-minx)*Rx;
  y=(ey-miny)/(maxy-miny)*Ry;
  fprintf(fp,"%d %d l\n",x,y);
 }

 fprintf(fp,"s\n");



}


void WriteContours(FILE*fp,Point*P,int nP, Elem*E,int nE,double *Data, double datamin, double datamax,
 int heights, 
    double minx, double miny, double maxx, double maxy,
    double Rx, double Ry)

{
 double h,step;

 step=(datamax-datamin)/heights;
 fprintf(fp,"1.0 setlinewidth\n"); // толщина линий. на толщину влияет масштаб
 for(h=step;h>=datamin;h-=step)
  WriteContour(fp,P,nP,E,nE,Data,h,minx,miny,maxx,maxy,Rx,Ry);
 for(h=step;h<=datamax;h+=step)
  WriteContour(fp,P,nP,E,nE,Data,h,minx,miny,maxx,maxy,Rx,Ry);
 fprintf(fp,"7.0 setlinewidth\n"); // толщина линий. на толщину влияет масштаб
 WriteContour(fp,P,nP,E,nE,Data,0,minx,miny,maxx,maxy,Rx,Ry);
}

TRGBColor BlendColor(double x,double min,double max,TRGBColor *palette, int N);

int WriteHeightMap(FILE *fp,Point *P,int nP, Elem*E, int nE, 
    double minx, double miny, double maxx, double maxy,
    double Rx, double Ry)
{
 int e,i,j,k,x,y;
 TRGBColor c1,c2,c3;
 double n1,n2,n3;

 for(e=0;e<nE;e++)
 {
  i=E[e].i;  j=E[e].j;  k=E[e].k;
  n1=Data[i]; n2=Data[j]; n3=Data[k];
  c1=BlendColor(n1,minn,maxn,palette,PalSize);
  c2=BlendColor(n2,minn,maxn,palette,PalSize);
  c3=BlendColor(n3,minn,maxn,palette,PalSize);

  x=(P[i].x-minx)/(maxx-minx)*Rx;
  y=(P[i].y-miny)/(maxy-miny)*Ry;
  fprintf(fp,"%d %d %4.3lf %4.3lf %4.3lf ",x,y,c1.R,c1.G,c1.B);
  x=(P[j].x-minx)/(maxx-minx)*Rx;
  y=(P[j].y-miny)/(maxy-miny)*Ry;
  fprintf(fp,"%d %d %4.3lf %4.3lf %4.3lf ",x,y,c2.R,c2.G,c2.B);
  x=(P[k].x-minx)/(maxx-minx)*Rx;
  y=(P[k].y-miny)/(maxy-miny)*Ry;
  fprintf(fp,"%d %d %4.3lf %4.3lf %4.3lf ",x,y,c3.R,c3.G,c3.B);
  fprintf(fp,"SHF\n");
 }
 return 0;
}


int WriteEPS(Point *P,int nP, Side *S,Elem *E,int nS, int nE)
{
  FILE *fp;
  double maxx,maxy,minx,miny,Rx,Ry;
  int s,p; 
  int x,y,flag;
  double lastwidth,width;
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
  fprintf(fp,"%14.13lf %14.13lf scale\n",1.0/scale,1.0/scale); // масштабирование - координаты целые
  lastwidth=-1;
  width=0.5;
  if(!noshade) WriteHeightMap(fp,P,nP,E,nE,minx,miny,maxx,maxy,Rx,Ry);
  fprintf(fp,"4 setlinewidth\n");
  WriteContours(fp,P,nP,E,nE,Data,minn,maxn,discrete?(PalSize-1):20,minx,miny,maxx,maxy,Rx,Ry);
  ShowDomain(fp,P,nP,S,nS,minx,miny,maxx,maxy,Rx,Ry);
  fprintf(fp,"8 setlinewidth\n");
  ShowPalette(fp);
  writeleadout(fp);
  fclose(fp);
  return 0;
}







TRGBColor BlendColor(double x,double min,double max,TRGBColor *palette, int N)
{
  int t;
  double tau,xn,h;
  TRGBColor c={0,0,0};
  if(x<-1e50) return cur_color;
  if(min==max) return palette[0];

//  if(max==min) return palette[N-1];
  h=(max-min)/(N-1);
//  for(xn=min,t=0;xn+h<x;x+=h,t++);
  t=(x-min)/h; 
  if(t<0) { printf("Warning!: %lf (%lf,%lf) --> %d\n",x,min,max,t); t=0; }
  if (t>=N-1) {printf("Warning!: %lf (%lf,%lf) --> %d\n",x,min,max,t); t=N-2; }
  xn=min+h*t;
  tau=(x-xn)/h;
  if (discrete) tau=0;
//  tau=(x-min-t*stripe)/(max-min);
//  printf("%le\n",tau);
  c.R=palette[t].R*(1-tau)+palette[t+1].R*tau;
  c.G=palette[t].G*(1-tau)+palette[t+1].G*tau;
  c.B=palette[t].B*(1-tau)+palette[t+1].B*tau;
  cur_color=c;
  return c;
}

int ReadRGBColor(FILE *fp,TRGBColor * c)
{
 unsigned int i;
 fscanf(fp,"%u",&i);
 c->R=i&0xFF;
 c->G=(i>>8)&0xFF;
 c->B=(i>>16)&0xFF;

 c->R/=255;
 c->G/=255;
 c->B/=255;
 return 0;
}


int ReadPalette(char *fname)
{
  FILE *fp=fopen(fname,"r");
  int i;
  if(fp==NULL)
  {
   printf("Невозможно открыть файл с палитрой [%s]\n",fname);
   return -1;
  }
//  printf("%s\n",fname);
  fscanf(fp,"%d",&PalSize);
  printf("palsize=%d\n",PalSize);
  palette=malloc(PalSize*sizeof(TRGBColor));
  for(i=0;i<PalSize;i++)
  {
//   printf("%d\n",i); 
   if(ReadRGBColor(fp,&palette[i])!=0) 
   {printf("Error!\n"); return -1;}
   }
  fclose(fp);
  return 0;
}


int SetFillColor(FILE *fp,TRGBColor c)
{
  return fprintf(fp,"%4.2lf %4.2lf %4.2lf k\n",c.R,c.G,c.B);
}
int SetStrokeColor(FILE *fp,TRGBColor c)
{
  return fprintf(fp,"%4.2lf %4.2lf %4.2lf K\n",c.R,c.G,c.B);
}

void ShowPalette(FILE *fp)
{
 int i;
 char szBuf[200];
 printf("palette..\n");
 fprintf(fp,"/Courier-Bold findfont %d scalefont setfont\n",25*scale);

 SetStrokeColor(fp,black);

 for(i=0;i<PalSize;i++)
 {
//  printf("starting palette[%d]\n",i);
  SetFillColor(fp,palette[i]);
//  printf("color set\n");

  if((discrete && i!=PalSize-1) || !discrete)
  fprintf(fp,"n %d %d m %d %d rl %d %d rl %d %d rl %d %d rl %c\n",
                palx*scale, (paly+palspace*i)*scale,
                        0,palsy*scale,
                                 palsx*scale, 0,
				 	  0, -palsy*scale,
					           -palsx*scale,0, (noshade?'S':'B'));

//  printf("path printed\n");
  sprintf(szBuf,"%+4.2lf",minn+(maxn-minn)/(PalSize-1)*i);
  
  fprintf(fp,"%d %d m (%s) show\n",(int)((palx+palsx*1.5)*scale), (paly+palspace*i+10)*scale,szBuf);
//  printf("done palette[%d]\n",i);
 }
/*
 SetFillColor(fp,white);
  fprintf(fp,"n %d %d m %d %d rl %d %d rl %d %d rl %d %d rl B\n",
                palx*scale, (paly+palspace*i)*scale,
                        0,palsy*scale,
                                 palsx*scale, 0,
				 	  0, -palsy*scale,
					           -palsx*scale,0);
*/

}









