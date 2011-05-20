#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "vars.h"
#include "renum.h"
#include "matching.h"

int periodic=0;
//
// Перенумерация узлов, сторон и элементов
void renum(void)
{
 int n, s, e, c, d, i, j, k, pi,pc=0,ai,bi,ci,di;
 int new_elem=0, new_node=0, new_side=0, next_e, next_s, lowest;
 int total;

 for(n=0; n<Nn; n++) {node[n].new_numb=OFF; node[n].pair=OFF;}

 for(e=0; e<Ne; e++) elem[e].new_numb=OFF;
 for(s=0; s<Ns; s++) side[s].new_numb=OFF;
printf("renum..\n");

 if(periodic)
 {
 // Поиск парных узлов
   // угловые точки
   // b-----c
   // |     |
   // |     |
   // |     |
   // a-----d
 printf("Matching pairs\n");
 
 for(n=0;n<Nn;n++)
 {
  pi=MatchNode(n);
  if(pi!=n)
  { 
    
    node[n].pair=pi;
    pc++;
    printf("Pair %d -- %d: (%lf,%lf)--(%lf,%lf)\n",n,pi,node[n].x,node[n].y,node[pi].x,node[pi].y);
  } else node[n].pair=OFF;
  if(fabs(node[n].x+1)+fabs(node[n].y+1)<=1e-9) ai=n;
  if(fabs(node[n].x+1)+fabs(node[n].y-1)<=1e-9) bi=n;
  if(fabs(node[n].x-1)+fabs(node[n].y+1)<=1e-9) di=n;
  if(fabs(node[n].x-1)+fabs(node[n].y-1)<=1e-9) ci=n;
 }
 node[ai].pair=bi;
 node[bi].pair=ci;
 node[ci].pair=di;
 node[di].pair=ai;

 printf("done, %d pairs matched\n",pc);

  for(n=0;n<Nn;n++)
  {
    if(node[n].pair!=OFF)
    {
      pi=node[n].pair;
      printf("%d -- %d -- %d\n", n,pi, node[pi].pair);
    }


  }
 }

/*-------------------------------+
|  Searching the first element.  |
|  It is the first which is ON   |
+-------------------------------*/
 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF)
     break;

/*----------------------------------------------------------+
|  Assigning numbers 0 and 1 to the nodes of first element  |
+----------------------------------------------------------*/
 node[elem[e].i].new_numb  = new_node; new_node++;
 node[elem[e].j].new_numb  = new_node; new_node++;

/*%%%%%%%%%%%%%%%%%%%%%%%%%
%                         %
%  Renumeration of nodes  %
%                         %
%%%%%%%%%%%%%%%%%%%%%%%%%*/
 total=0;
 do
  {
   total++;
   if(total%1000==0) printf("total: %dk\n",total/1000);
   lowest = Nn+Nn;
   next_e = OFF;

   for(e=0; e<Ne; e++)
     if(elem[e].mark!=OFF && elem[e].new_numb==OFF)
      {
       i=node[elem[e].i].new_numb;
       j=node[elem[e].j].new_numb;
       k=node[elem[e].k].new_numb;


       // Условие -- ровно один из i, j, k == -1, т.е. 
       // ровно одна вершина нуждается в номере
       // кроме того - ищется элемент, где разница между двумя узлами минимально
       if( i+j+k+2 == abs(i) + abs(j) + abs(k) )
        {
         if( (i==OFF) && (j+k) < lowest) {next_e=e; lowest=j+k;}
         if( (j==OFF) && (i+k) < lowest) {next_e=e; lowest=i+k;}
         if( (k==OFF) && (i+j) < lowest) {next_e=e; lowest=i+j;}
        }
      }


   // Если такой элемент (один из узлов не имеет нового номера)
   // среди таких ищется с минимальой разницей между двумя другими индексами
   if(next_e!=OFF)
    {
     i=node[elem[next_e].i].new_numb;
     j=node[elem[next_e].j].new_numb;
     k=node[elem[next_e].k].new_numb;

/*----------------------------------+
|  Assign a new number to the node  |
+----------------------------------*/
     if(i==OFF) 
     { 
       node[elem[next_e].i].new_numb = new_node++;
       pi= node[elem[next_e].i].pair;
       if( pi  != OFF )
       {
        if(node[pi].new_numb == OFF)
        {
          node[pi].new_numb = new_node++;
          printf("node %d has pair %d. their new indexes: %d, %d\n",pi,elem[next_e].i, new_node-2, new_node-1);
        } else
        {
         printf("Mystericall pair of %d was already numbered as %d\n",pi,node[pi].new_numb-1);
        }
         printf("%d--%d--%d\n", pi,node[pi].pair, node[node[pi].pair].pair);
       }
     }
     if(j==OFF) 
     { 
       node[elem[next_e].j].new_numb = new_node++;
       pi= node[elem[next_e].j].pair;
       if( pi  != OFF )
       {
        if(node[pi].new_numb == OFF)
        {
         node[pi].new_numb = new_node++;
         printf("node %d has pair %d. their new indexes: %d, %d\n",pi,elem[next_e].j, new_node-2, new_node-1);
        }  else
        {
         printf("Mystericall pair of %d was already numbered as %d\n",pi,node[pi].new_numb-1);
        }
         printf("%d--%d--%d\n", pi,node[pi].pair, node[node[pi].pair].pair);
       }
     }
     if(k==OFF) 
     { 
       node[elem[next_e].k].new_numb = new_node++;
       pi= node[elem[next_e].k].pair;
       if( pi  != OFF )
       {
        if(node[pi].new_numb == OFF)
        { 
          node[pi].new_numb = new_node++;
          printf("node %d has pair %d. their new indexes: %d, %d\n",pi,elem[next_e].k, new_node-2, new_node-1);
        } else
        {
         printf("Mystericall pair of %d was already numbered as %d\n",pi,node[pi].new_numb-1);
        }
         printf("%d--%d--%d\n", pi,node[pi].pair, node[node[pi].pair].pair);
       }
     }

    
    }
  }
 // до тех пор, пока элементы есть
 while(next_e != OFF);
 printf("done with nodes, total:%d\n",total);

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%  Renumeration of triangles  %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
total=0;
 do
  {
   total++;
   if(total%1000==0) printf("total: %dk\n",total/1000);
   lowest = Nn+Nn+Nn;
   next_e = OFF;

   for(e=0; e<Ne; e++)
     if(elem[e].mark!=OFF && elem[e].new_numb==OFF)
      {
       i=node[elem[e].i].new_numb;
       j=node[elem[e].j].new_numb;
       k=node[elem[e].k].new_numb;

       if( (i+j+k) < lowest )
        {
         next_e=e;
         lowest=i+j+k;
        }
      }

   if(next_e!=OFF)
    {
     elem[next_e].new_numb=new_elem; new_elem++;
    }
  }
 while(next_e != OFF);
 printf("done with triangles, total:%d\n",total);



/*%%%%%%%%%%%%%%%%%%%%%%%%%
%                         %
%  Renumeration of sides  %
%                         %
%%%%%%%%%%%%%%%%%%%%%%%%%*/
total=0;
 do
  {
   total++;
   if(total%1000==0) printf("total: %dk\n",total/1000);
   lowest = Nn+Nn;
   next_s = OFF;

   for(s=0; s<Ns; s++)
     if(side[s].mark!=OFF && side[s].new_numb==OFF)
      {
       c=node[side[s].c].new_numb;
       d=node[side[s].d].new_numb;

       if( (c+d) < lowest)
        {
         lowest=c+d; next_s=s;
        }
      }

   if(next_s!=OFF)
    {
     side[next_s].new_numb=new_side;
     new_side++;
    }

  }
 while(next_s != OFF);
 printf("done with sides, total:%d\n",total);

}
