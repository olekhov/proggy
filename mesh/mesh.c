#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "vars.h"
#include "misc.h"
#include "renum.h"

int ugly;                       /* mora li biti globalna ??? */


int insert_node(double x, double y, int spac,
     int prev_n, int prev_s_mark, int mark, int next_s_mark, int next_n);
int insert_node(double x, double y, int spac,
     int prev_n, int prev_s_mark, int mark, int next_s_mark, int next_n)
{
 int    i,j,k, e,ei,ej,ek, s,si,sj,sk;
 double sx, sy;

// printf("inserting node..\n");
 Nn++;          /* one new node */
 
 node[Nn-1].x = x;
 node[Nn-1].y = y;
 node[Nn-1].mark = mark;

/* find the element which contains new node */ 
// printf("finding element\n");
 e = in_elem(&node[Nn-1]);

/* calculate the spacing function in the new node */
// printf("spacing\n");

 if(spac==ON)
   spacing(e, Nn-1);

 i =elem[e].i;  j =elem[e].j;  k =elem[e].k;
 ei=elem[e].ei; ej=elem[e].ej; ek=elem[e].ek; 
 si=elem[e].si; sj=elem[e].sj; sk=elem[e].sk; 
 
 Ne+=2;
 Ns+=3;

/*---------------+
|  new elements  |
+---------------*/ 
 elem[Ne-2].i=Nn-1;  elem[Ne-2].j=k;     elem[Ne-2].k=i;
 elem[Ne-1].i=Nn-1;  elem[Ne-1].j=i;     elem[Ne-1].k=j; 
 
 elem[Ne-2].ei=ej;   elem[Ne-2].ej=Ne-1; elem[Ne-2].ek=e;
 elem[Ne-1].ei=ek;   elem[Ne-1].ej=e;    elem[Ne-1].ek=Ne-2;
 
 elem[Ne-2].si=sj;   elem[Ne-2].sj=Ns-2; elem[Ne-2].sk=Ns-3;
 elem[Ne-1].si=sk;   elem[Ne-1].sj=Ns-1; elem[Ne-1].sk=Ns-2;
 
/*------------+ 
|  new sides  |
+------------*/ 
 side[Ns-3].c =k;    side[Ns-3].d =Nn-1;     /* c-d */
 side[Ns-3].a =j;    side[Ns-3].b =i;        /* a-b */
 side[Ns-3].ea=e;    side[Ns-3].eb=Ne-2;
 
 side[Ns-2].c =i;    side[Ns-2].d =Nn-1;     /* c-d */
 side[Ns-2].a =k;    side[Ns-2].b =j;        /* a-b */
 side[Ns-2].ea=Ne-2; side[Ns-2].eb=Ne-1;
 
 side[Ns-1].c =j;    side[Ns-1].d =Nn-1;     /* c-d */
 side[Ns-1].a =i;    side[Ns-1].b =k;        /* a-b */
 side[Ns-1].ea=Ne-1; side[Ns-1].eb=e;       

// printf("before for \n");

 for(s=1; s<=3; s++)
  {sx = node[side[Ns-s].c].x - node[side[Ns-s].d].x;
   sy = node[side[Ns-s].c].y - node[side[Ns-s].d].y;
   side[Ns-s].s = SQRT(sx*sx+sy*sy);}

 elem[e].i  = Nn-1;
 elem[e].ej = Ne-2;
 elem[e].ek = Ne-1;
 elem[e].sj = Ns-3;
 elem[e].sk = Ns-1;

 if(side[si].a==i) {side[si].a=Nn-1; side[si].ea=e;}
 if(side[si].b==i) {side[si].b=Nn-1; side[si].eb=e;}
 
 if(side[sj].a==j) {side[sj].a=Nn-1; side[sj].ea=Ne-2;}
 if(side[sj].b==j) {side[sj].b=Nn-1; side[sj].eb=Ne-2;}
 
 if(side[sk].a==k) {side[sk].a=Nn-1; side[sk].ea=Ne-1;} 
 if(side[sk].b==k) {side[sk].b=Nn-1; side[sk].eb=Ne-1;} 

 if(ej!=-1)
  {if(elem[ej].ei==e) {elem[ej].ei=Ne-2;}
   if(elem[ej].ej==e) {elem[ej].ej=Ne-2;}
   if(elem[ej].ek==e) {elem[ej].ek=Ne-2;}}

 if(ek!=-1)
  {if(elem[ek].ei==e) {elem[ek].ei=Ne-1;}
   if(elem[ek].ej==e) {elem[ek].ej=Ne-1;}
   if(elem[ek].ek==e) {elem[ek].ek=Ne-1;}}

/* Find circumenters for two new elements, 
   and for the one who's segment has changed */
// printf("before circles\n");
 circles(e);
 circles(Ne-2);
 circles(Ne-1);

// printf("before bowyer\n");

 bowyer(Nn-1, spac);

/*-------------------------------------------------+
|  NEW ! Insert boundary conditions for the sides  |
+-------------------------------------------------*/
 for(s=3; s<Ns; s++)
  {
   if(side[s].c==prev_n && side[s].d==Nn-1)  side[s].mark=prev_s_mark;
   if(side[s].d==prev_n && side[s].c==Nn-1)  side[s].mark=prev_s_mark;
   if(side[s].c==next_n && side[s].d==Nn-1)  side[s].mark=next_s_mark;
   if(side[s].d==next_n && side[s].c==Nn-1)  side[s].mark=next_s_mark;
  }
// printf("\r new node inserted, :%d",Nn);
 return e;
}
/*-insert_node-------------------------------------------------------------*/

/*=========================================================================*/
void new_node(void);
void new_node(void)
/*---------------------------------------------------+
|  This function is very important.                  |
|  It determines the position of the inserted node.  |
+---------------------------------------------------*/
{
 int    s=OFF, n;
 double xM, yM, p,  q, qx, qy, rhoM, rho_M, d;

 struct nod Ca;

/*-------------------------------------------------------------------------+
|  It's obvious that elements which are near the boundary, will come into  |
|  play first.                                                             |
|                                                                          |
|  However, some attention has to be payed for the case when two accepted  |
|  elements surround the ugly one                                          |
|                                                                          |
|  What if new points falls outside the domain                             |
+-------------------------------------------------------------------------*/
 if(elem[elem[ugly].ei].state==DONE)    {s=elem[ugly].si; n=elem[ugly].i;}
 if(elem[elem[ugly].ej].state==DONE)    {s=elem[ugly].sj; n=elem[ugly].j;}
 if(elem[elem[ugly].ek].state==DONE)    {s=elem[ugly].sk; n=elem[ugly].k;}
 if(side[elem[ugly].si].mark > 0)    {s=elem[ugly].si; n=elem[ugly].i;}
 if(side[elem[ugly].sj].mark > 0)    {s=elem[ugly].sj; n=elem[ugly].j;}
 if(side[elem[ugly].sk].mark > 0)    {s=elem[ugly].sk; n=elem[ugly].k;}
 if(s==OFF) return;

 xM  = 0.5*(node[side[s].c].x + node[side[s].d].x);
 yM  = 0.5*(node[side[s].c].y + node[side[s].d].y);

 Ca.x = elem[ugly].xv;
 Ca.y = elem[ugly].yv;

 p  = 0.5*side[s].s;    /* not checked */

 qx = Ca.x-xM;
 qy = Ca.y-yM;
 q  = SQRT(qx*qx+qy*qy);

 rhoM = 0.577 *  0.5*(node[side[s].c].F + node[side[s].d].F);

 rho_M = min( max( rhoM, p), 0.5*(p*p+q*q)/q );

 if(rho_M < p) d=rho_M;
 else          d=rho_M+SQRT(rho_M*rho_M-p*p); 

/*---------------------------------------------------------------------+
|  The following line check can the new point fall outside the domain. |
|  However, I can't remember how it works, but I believe that it is    |
|  still a weak point of the code, particulary when there are lines    |
|  inside the domain                                                   |
+---------------------------------------------------------------------*/

 if( area(&node[side[s].c], &node[side[s].d], &Ca) *
     area(&node[side[s].c], &node[side[s].d], &node[n]) > 0.0 )
   insert_node(xM + d*qx/q,  yM + d*qy/q, ON, OFF, 0, 0, 0, OFF);
/*
 else
  {
   node[n].x = xM - d*qx/q;
   node[n].y = yM - d*qy/q;
   node[n].mark=6;   
   for(e=0; e<Ne; e++) 
     if(elem[e].i==n || elem[e].j==n || elem[e].k==n)
       circles(e);
  }
*/
}
/*-new_node----------------------------------------------------------------*/



char name[80]; int len;



/*=========================================================================*/
int load(void);
int load(void)
{
 int  c, n, s, Fl, M, chains, NMat;
 double xmax=-GREAT, xmin=+GREAT, ymax=-GREAT, ymin=+GREAT, xt, yt, gab;

 FILE *in;

 int m;
 double xO, yO, xN, yN,  L, Lx, Ly, dLm, ddL, L_tot;
 
 int *inserted;

/*----------+
|           |
|  Loading  |
|           |
+----------*/
 if((in=fopen(name, "r"))==NULL)
  {fprintf(stderr, "Cannot load file %s !\n", name);
   return 1;}

 fscanf(in,"%d",&Nc);
 fscanf(in,"%d",&Fl);
 fscanf(in,"%d",&NMat);
 Nc+=NMat;

 inserted=(int *) calloc(Nc, sizeof(int)); 
 for(n=0; n<Nc-NMat; n++)
  {
   fscanf(in,"%lf", &point[n].x);
   fscanf(in,"%lf", &point[n].y);
   fscanf(in,"%lf", &point[n].F);
   fscanf(in,"%d", &point[n].mark);

   xmax=max(xmax, point[n].x); ymax=max(ymax, point[n].y);
   xmin=min(xmin, point[n].x); ymin=min(ymin, point[n].y);

   point[n].inserted=0; /* it is only loaded */
  }
 printf("calcing chains\n");
// load_i(in, &Fl);
 segment=(struct seg *) calloc(Fl+1, sizeof(struct seg));
 chain  =(struct chai *) calloc(Fl+1, sizeof(struct chai)); /* approximation */
 segment[Fl].n0=-1;
 segment[Fl].n1=-1;

 for(s=0; s<Fl; s++)
  {
   fscanf(in,"%d",&segment[s].n0);
   fscanf(in,"%d",&segment[s].n1);
   fscanf(in,"%d",&segment[s].mark);
  }

 // загрузка материальных меток
 for(n=Nc-NMat;n<Nc;n++)
 {
   fscanf(in,"%lf", &point[n].x);
   fscanf(in,"%lf", &point[n].y);
//   fscanf(in,"%lf", &point[n].F);
   fscanf(in,"%d", &point[n].mark);
   xmax=max(xmax, point[n].x); ymax=max(ymax, point[n].y);
   xmin=min(xmin, point[n].x); ymin=min(ymin, point[n].y);

   point[n].inserted=0; /* it is only loaded */
 }
 fclose(in);

/*----------------------+
   counting the chains
+----------------------*/
 chains=0;
 chain[chains].s0=0;
 for(s=0; s<Fl; s++)
  {
   point[segment[s].n0].inserted++;
   point[segment[s].n1].inserted++;

   segment[s].chain           = chains;

   if((segment[s].n1!=segment[s+1].n0) || (segment[s].mark!=segment[s+1].mark))
    {chain[chains].s1=s;
     chains++;
     chain[chains].s0=s+1;}
  }
 printf("Chains: %d\n",chains);
/*-------------------------------------+
   counting the nodes on each segment
+-------------------------------------*/
 for(s=0; s<Fl; s++)
  {
   xO=point[segment[s].n0].x; yO=point[segment[s].n0].y;
   xN=point[segment[s].n1].x; yN=point[segment[s].n1].y; 

   Lx=(xN-xO); Ly=(yN-yO); L=SQRT(Lx*Lx+Ly*Ly);

   if( (point[segment[s].n0].F+point[segment[s].n1].F > L ) &&
       (segment[s].n0 != segment[s].n1) )
    {point[segment[s].n0].F = min(point[segment[s].n0].F,L/2);
     point[segment[s].n1].F = min(point[segment[s].n1].F,L/2);}
  }

/*-------------------------------------+
   counting the nodes on each segment
+-------------------------------------*/
 for(s=0; s<Fl; s++)
  {
   xO=point[segment[s].n0].x; yO=point[segment[s].n0].y;
   xN=point[segment[s].n1].x; yN=point[segment[s].n1].y; 

   Lx=(xN-xO); Ly=(yN-yO); L=SQRT(Lx*Lx+Ly*Ly);

   if(point[segment[s].n1].F+point[segment[s].n0].F<=L)
    {dLm=0.5*(point[segment[s].n0].F+point[segment[s].n1].F);
     segment[s].N=ceil(L/dLm);}
   else
     segment[s].N=1;
  }


 for(n=0; n<chains; n++)
  {
   if( segment[chain[n].s0].n0 == segment[chain[n].s1].n1 )
    {chain[n].type=CLOSED;}

   if( segment[chain[n].s0].n0 != segment[chain[n].s1].n1 )
    {chain[n].type=OPEN;}

   if( (point[segment[chain[n].s0].n0].inserted==1) &&
       (point[segment[chain[n].s1].n1].inserted==1) )
    {chain[n].type=INSIDE;}
   printf("Chain: %d: %d->%d type: %d\n",n,chain[n].s0,chain[n].s1, chain[n].type);
  }
 printf("inserting domain points\n");
/*------------+
|             |
|  Inserting  |
|             |
+------------*/
 xt = 0.5*(xmax+xmin);
 yt = 0.5*(ymax+ymin);

 gab=max((xmax-xmin),(ymax-ymin));
 
 Nn = 3;
 node[2].x = xt;                node[2].y = yt + 2.8*gab; 
 node[0].x = xt - 2.0*gab;      node[0].y = yt - 1.4*gab; 
 node[1].x = xt + 2.0*gab;      node[1].y = yt - 1.4*gab; 
 node[2].inserted=2;
 node[1].inserted=2;
 node[0].inserted=2;
/*
 node[2].type=;
 node[1].type=;
 node[0].type=;
*/
 node[2].next=1;
 node[1].next=0;
 node[0].next=2;

 Ne=1;
 elem[0].i =0;  elem[0].j = 1; elem[0].k = 2;
 elem[0].ei=-1; elem[0].ej=-1; elem[0].ek=-1;
 elem[0].si= 1; elem[0].sj= 2; elem[0].sk= 0;
 
 Ns=3;
 side[0].c=0; side[0].d=1; side[0].a=2; side[0].b=-1; 
 side[1].c=1; side[1].d=2; side[1].a=0; side[1].b=-1; 
 side[2].c=0; side[2].d=2; side[2].a=-1; side[2].b=1;  
 side[0].ea= 0; side[0].eb=-1;
 side[1].ea= 0; side[1].eb=-1; 
 side[2].ea=-1; side[2].eb= 0;


 for(n=0; n<Nc; n++)
   point[n].new_numb=OFF;

 for(c=0; c<chains; c++)
  {
   printf("%d chain\n",c);

   for(s=chain[c].s0; s<=chain[c].s1; s++)
    {
     xO=point[segment[s].n0].x; yO=point[segment[s].n0].y;
     xN=point[segment[s].n1].x; yN=point[segment[s].n1].y; 
      printf("first point\n");
/*===============
*  first point  *
===============*/
     if( point[segment[s].n0].new_numb == OFF )
      {
       if(s==chain[c].s0) /* first segment in the chain */
     insert_node(xO, yO, OFF,
     OFF,  OFF, point[segment[s].n0].mark, OFF, OFF);

       else if(s==chain[c].s1 && segment[s].N==1)
     insert_node(xO, yO, OFF,
     Nn-1, segment[s-1].mark,
     point[segment[s].n0].mark,
     segment[s].mark, point[segment[chain[c].s0].n0].new_numb);

       else
    {
     insert_node(xO, yO, OFF,
     Nn-1, segment[s-1].mark, point[segment[s].n0].mark, OFF, OFF);
    }
//     printf("we're in the middle\n");
       node[Nn-1].next     = Nn;     /* Nn-1 is index of inserted node */
       node[Nn-1].chain    = segment[s].chain;
       node[Nn-1].F        = point[segment[s].n0].F;
       point[segment[s].n0].new_numb=Nn-1;
      }

     Lx=(xN-xO);  Ly=(yN-yO);  L=SQRT(Lx*Lx+Ly*Ly);
     dLm=L/segment[s].N;

     if(point[segment[s].n0].F + point[segment[s].n1].F <= L)
      { 
       if(point[segment[s].n0].F > point[segment[s].n1].F)
    {M=-segment[s].N/2; ddL=(point[segment[s].n1].F-dLm)/M;}
       else
    {M=+segment[s].N/2; ddL=(dLm-point[segment[s].n0].F)/M;}
      }
//      printf("middle points: %d stuk\n",abs(segment[s].N)-1);

//     printf("%7.5lf+%7.5lf<=%7.5lf\n",point[segment[s].n0].F,point[segment[s].n1].F,L);
/*=================
*  middle points  *
=================*/
     L_tot=0;
     if(point[segment[s].n0].F + point[segment[s].n1].F <= L)
     {
       for(m=1; m<abs(segment[s].N); m++)
    {
//     printf("middle point being inserted (%lf):\n",L_tot);
     L_tot+=(dLm-M*ddL);
  
     if(point[segment[s].n0].F > point[segment[s].n1].F)
      {M++; if(M==0 && segment[s].N%2==0) M++;}
     else
      {M--; if(M==0 && segment[s].N%2==0) M--;}

     if(s==chain[c].s1 && m==(abs(segment[s].N)-1))
      {insert_node(xO+Lx/L*L_tot, yO+Ly/L*L_tot, OFF,
       Nn-1, segment[s].mark, segment[s].mark, segment[s].mark, point[segment[s].n1].new_numb);
       node[Nn-1].next = Nn;
//       printf("last segment on side inserted: %le,%le...\n", node[Nn-1].x, node[Nn-1].y);
       }
     
     else if(m==1)
      {insert_node(xO+Lx/L*L_tot, yO+Ly/L*L_tot, OFF,
       point[segment[s].n0].new_numb, segment[s].mark, segment[s].mark, OFF, OFF);
       node[Nn-1].next = Nn;}

     else
      {insert_node(xO+Lx/L*L_tot, yO+Ly/L*L_tot, OFF,
       Nn-1, segment[s].mark, segment[s].mark, OFF, OFF);
       node[Nn-1].next = Nn;}

     node[Nn-1].chain    = segment[s].chain;
     node[Nn-1].F        = 0.5*(node[Nn-2].F + (dLm-M*ddL));
    }
    }
//     printf("last point\n");

/*==============
*  last point  * -> just for the inside chains
==============*/
     if( (point[segment[s].n1].new_numb == OFF) && (s==chain[c].s1) )
      {
       insert_node(xN, yN, OFF,
       Nn-1, segment[s].mark, point[segment[s].n1].mark, OFF, OFF);
       node[Nn-1].next     = OFF;
       node[Nn-1].chain    = segment[s].chain;
       node[Nn-1].F        = point[segment[s].n1].F;
      }

     if( chain[c].type==CLOSED && s==chain[c].s1)
       node[Nn-1].next     = point[segment[chain[c].s0].n0].new_numb;

     if( chain[c].type==OPEN && s==chain[c].s1)
       node[Nn-1].next     = OFF;
    }
  }

 free(segment);
 free(inserted);
 printf("done with domain points\n");

 return 0;
}
/*-load--------------------------------------------------------------------*/

int main(int argc, char *argv[])
{
 int arg, d=ON, r=ON, s=ON, m=ON, g=ON, exa=OFF, Nn0;

 if(argc<2)
  {printf("\n*********************************************************");
   return 0;}
 else
  {if(strcmp(argv[1], "+example")==0) exa=ON;
   strcpy(name,     argv[1]);
   len=strlen(name);
   if(name[len-2]=='.')
     if(name[len-1]=='d' || name[len-1]=='D' )
       name[len-2]='\0';
  }

/*-----------------------+
|  command line options  |
+-----------------------*/
 for(arg=2; arg<argc; arg++)
  {
   if(strcmp(argv[arg],"-d")      ==0) {d=OFF; r=OFF; s=OFF;}
   if(strcmp(argv[arg],"+example")==0) exa=ON;
   if(strcmp(argv[arg],"-g")      ==0) g=OFF;
   if(strcmp(argv[arg],"-r")      ==0) r=OFF;
   if(strcmp(argv[arg],"-s")      ==0) s=OFF;
   if(strcmp(argv[arg],"-m")      ==0) m=OFF;
   if(strcmp(argv[arg],"-p")      ==0) periodic=1;
  }
/*
 MAX_NODES=4000;
 printf("allocating dynamic memory\n");
 elem=malloc(MAX_NODES*2*sizeof(struct ele));
 side=malloc(MAX_NODES*3*sizeof(struct sid));
 node=malloc(MAX_NODES*sizeof(struct nod));
 point=malloc(MAX_NODES/2*sizeof(struct nod));
 if(!elem || !side || !node || !point)
 {
  printf("Memory allocation error\n");
  return -1;
 } else printf("memory allocated\n");
*/
 printf("allocating dynamic memory...\n");
 init_vars();
 printf("ok.\n");
 strcat(name, ".d");
 len=strlen(name);

 if(load()!=0)
   return 1;
 printf("Data loaded\n");
 erase();
 ugly=classify();

 if(m==ON)
   printf("Working.  Please wait !\n"); fflush(stdout);

 if(d==ON)
   do
    {
     Nn0=Nn;
     new_node();
     ugly=classify();
     if(Nn%100==0) printf("\r %05d nodes in mesh, ratio: %10.8lf",Nn,g_ratio);
     if(Nn==MAX_NODES-1) break;
     if(Nn==Nn0) break;
    }
   while(ugly!=OFF);

 // подготовка к smooth и relax
 neighbours();
 
 if(r==ON || s==ON)
   if(m==ON)
     printf("Improving the grid quality.  Please wait !\n"); fflush(stdout);
 if(r==ON)           relax();
 if(r==ON || s==ON) smooth();

 if(m==ON)
   printf("Renumerating nodes, elements and sides. Please wait !\n"); fflush(stdout);
 renum();

 if(m==ON)
   printf("Processing material marks. Please wait !\n"); fflush(stdout);
 materials();


 save(name);

 return 0;
}
