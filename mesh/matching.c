#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "vars.h"
#include "matching.h"


double len(double x,double y) {return (x*x+y*y);}

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
     dist=len(node[Node].x-node[n].x,node[Node].y+node[n].y);
     if(dist<1e-10) return n;
   }
  }
  break;
  case LEFTRIGHT:
  {
   for(n=0;n<Nn;n++)
   {
     dist=len(node[Node].x+node[n].x,node[Node].y-node[n].y);
     if(dist<1e-10) return n;
   }
  }
  break;
  }

  printf("Wooopes!\n");
  return -1;

}


int MatchNode(int nd)
{

  if( (node[nd].x==-1) && (node[nd].y==-1))
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( (node[nd].x==-1) && (node[nd].y==1))
  {
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if( (node[nd].x==1) && (node[nd].y==-1))
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if (fabs(node[nd].x)==1)
  {
    nd=FindMirrorNode(nd,LEFTRIGHT);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } else
  if (fabs(node[nd].y)==1)
  {
    nd=FindMirrorNode(nd,UPDOWN);
    if(nd==-1) {printf("NodeLinking fails\n"); exit(1); }
  } 

  return nd;
}
