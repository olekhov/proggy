#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "vars.h"
#include "matching.h"


double Distance(double x,double y) ;
double Distance(double x,double y) 
{return (x*x+y*y);}

int FindMirrorNode(int Node,enum dir d)
{
 int n;
 double dist;

 switch(d)
 {
  case UPDOWN:
  {
   for(n=0;n<Nn;n++)
   {
     dist=Distance(node[Node].x-node[n].x,node[Node].y+node[n].y);
     if(dist<1e-10) return n;
   }
  }
  break;
  case LEFTRIGHT:
  {
   for(n=0;n<Nn;n++)
   {
     dist=Distance(node[Node].x+node[n].x,node[Node].y-node[n].y);
     if(dist<1e-10) return n;
   }
  }
  break;
  default:
  printf("Wooopes!\n");
  }

  printf("Wooopes!\n");
  return -1;

}


int MatchNode(int nd)
{

  if( fabs(node[nd].x+1)+fabs(node[nd].y+1)<1e-10)
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( fabs(node[nd].x+1)+fabs(node[nd].y-1)<1e-10)
  {
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( fabs(node[nd].x-1)+fabs(node[nd].y+1)<1e-10)
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( fabs(fabs(node[nd].x)-1)<1e-10)
  {
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( fabs(fabs(node[nd].x)-1)<1e-10)
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } 

  return nd;
}
