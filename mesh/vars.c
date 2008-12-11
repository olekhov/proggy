#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "vars.h"


struct ele elem[MAX_NODES*2];


struct sid side[MAX_NODES*3];


struct nod node[MAX_NODES], point[MAX_NODES/2];
struct seg *segment;
struct chai  *chain;
int Ne, Nn, Ns, Nc;             /* number of: elements, nodes, sides, chains */
/*=========================================================================*/
int save(char *name)
{
 int  e, s, n, r_Nn=0, r_Ns=0, r_Ne=0,len;

 struct nod *r_node;
 struct ele *r_elem;
 struct sid *r_side;
 double Xi,Yi,Xj,Yj,Xk,Yk,L;

 FILE *out;
 len=strlen(name);

 r_node=(struct nod *) calloc(Nn, sizeof(struct nod));
 r_elem=(struct ele *) calloc(Ne, sizeof(struct ele));
 r_side=(struct sid *) calloc(Ns, sizeof(struct sid));
 if(r_side==NULL)
  {fprintf(stderr, "Sorry, cannot allocate enough memory !\n");
   return 1;}
 printf("saving..\n");
 for(n=0; n<Nn; n++)
   if(node[n].mark!=OFF && node[n].new_numb!=OFF)
    {
     r_Nn++;
     r_node[node[n].new_numb].x    = node[n].x;
     r_node[node[n].new_numb].y    = node[n].y;
     r_node[node[n].new_numb].mark = node[n].mark;
    }

 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF && elem[e].new_numb!=OFF)
    {
     r_Ne++;
     r_elem[elem[e].new_numb].i  = node[elem[e].i].new_numb;
     r_elem[elem[e].new_numb].j  = node[elem[e].j].new_numb;
     r_elem[elem[e].new_numb].k  = node[elem[e].k].new_numb;
     r_elem[elem[e].new_numb].si = side[elem[e].si].new_numb;
     r_elem[elem[e].new_numb].sj = side[elem[e].sj].new_numb;
     r_elem[elem[e].new_numb].sk = side[elem[e].sk].new_numb;
     r_elem[elem[e].new_numb].xv = elem[e].xv;
     r_elem[elem[e].new_numb].yv = elem[e].yv;
     r_elem[elem[e].new_numb].material = elem[e].material;

     if(elem[e].ei != -1)
       r_elem[elem[e].new_numb].ei = elem[elem[e].ei].new_numb;
     else
       r_elem[elem[e].new_numb].ei = -1;

     if(elem[e].ej != -1)
       r_elem[elem[e].new_numb].ej = elem[elem[e].ej].new_numb;
     else
       r_elem[elem[e].new_numb].ej = -1;

     if(elem[e].ek != -1)
       r_elem[elem[e].new_numb].ek = elem[elem[e].ek].new_numb;
     else
       r_elem[elem[e].new_numb].ek = -1;
    }

 for(s=0; s<Ns; s++)
   if(side[s].mark!=OFF && side[s].new_numb!=OFF)
    {
     r_Ns++;
     r_side[side[s].new_numb].c    = node[side[s].c].new_numb;
     r_side[side[s].new_numb].d    = node[side[s].d].new_numb;
     r_side[side[s].new_numb].mark = side[s].mark;

     if(side[s].a != OFF)
      {
       r_side[side[s].new_numb].a  = node[side[s].a].new_numb;
       r_side[side[s].new_numb].ea = elem[side[s].ea].new_numb;
      }
     else
      {r_side[side[s].new_numb].a  = OFF;
       r_side[side[s].new_numb].ea = OFF;}

     if(side[s].b != OFF)
      {r_side[side[s].new_numb].b  = node[side[s].b].new_numb;
       r_side[side[s].new_numb].eb = elem[side[s].eb].new_numb;}
     else
      {r_side[side[s].new_numb].b  = OFF;
       r_side[side[s].new_numb].eb = OFF;}
    }

/*------------+
|             |
|  Node data  |
|             |
+------------*/
 name[len-1] = 'n';

 if((out=fopen(name, "w"))==NULL)
  {fprintf(stderr, "Cannot save file %s !\n", name);
   return 1;}

 printf("nodes..");
 fprintf(out, "%d\n", r_Nn);
 for(n=0; n<r_Nn; n++)
   fprintf(out, "%+18.15e %+18.15e  %d\n",
                 r_node[n].x, r_node[n].y, r_node[n].mark);
// fprintf(out, "----------------------------------------------------------\n");
// fprintf(out, "   n:  x                      y                       mark\n");

 fclose(out);
 printf("Ok.\n");

/*---------------+
|                |
|  Element data  |
|                |
+---------------*/
 name[len-1] = 'e';

 if((out=fopen(name, "w"))==NULL)
  {fprintf(stderr, "Cannot save file %s !\n", name);
   return 1;}

 // Вычисление функций формы
 //    |1 Xi Yi|
 // A= |1 Xj Yj|
 //    |1 Xk Yk|
 //
 //
 //
 for(e=0;e<r_Ne;e++)
 {
  Xi=r_node[r_elem[e].i].x;
  Yi=r_node[r_elem[e].i].y;
  Xj=r_node[r_elem[e].j].x;
  Yj=r_node[r_elem[e].j].y;
  Xk=r_node[r_elem[e].k].x;
  Yk=r_node[r_elem[e].k].y;

  r_elem[e].A=0.5*(Xj*Yk-Xk*Yj-(Xi*Yk-Xk*Yi)+Xi*Yj-Xj*Yi);

  r_elem[e].ai=Xj*Yk-Xk*Yj;
  r_elem[e].bi=Yj-Yk;
  r_elem[e].ci=Xk-Xj;

  r_elem[e].aj=Xk*Yi-Xi*Yk;
  r_elem[e].bj=Yk-Yi;
  r_elem[e].cj=Xi-Xk;

  r_elem[e].ak=Xi*Yj-Xj*Yi;
  r_elem[e].bk=Yi-Yj;
  r_elem[e].ck=Xj-Xi;
 }

 printf("elemens..");
 fprintf(out, "%d\n", r_Ne);
 for(e=0; e<r_Ne; e++)
 {
//   fprintf(out,"%3d : ",e);
   fprintf(out, "%4d %4d %4d  " // i,j,k
                "%4d %4d %4d  " // ei,ej,ek
                "%4d %4d %4d  " // si,sj,sk
//                "%+18.15e %+18.15e  " // xv,yv
                "%4d  " // material
                // Функции формы:
                "%+17.16e  " // A
                "%+17.16e %+17.16e %+17.16e  " // ai,bi,ci
                "%+17.16e %+17.16e %+17.16e  " // aj,bj,cj
                "%+17.16e %+17.16e %+17.16e  " // ak,bk,ck
/*                "%+4.2lf  " // A
                "%+4.2lf %+4.2lf %+4.2lf   " // ai,bi,ci
                "%+4.2lf %+4.2lf %+4.2lf   " // aj,bj,cj
                "%+4.2lf %+4.2lf %+4.2lf   " // ak,bk,ck */
                "\n",
                    r_elem[e].i,  r_elem[e].j,  r_elem[e].k,
                    r_elem[e].ei, r_elem[e].ej, r_elem[e].ek,
                    r_elem[e].si, r_elem[e].sj, r_elem[e].sk,
//                    r_elem[e].xv, r_elem[e].yv,
                    r_elem[e].material,
                    r_elem[e].A,
                    r_elem[e].ai,
                    r_elem[e].bi,
                    r_elem[e].ci,
                    r_elem[e].aj,
                    r_elem[e].bj,
                    r_elem[e].cj,
                    r_elem[e].ak,
                    r_elem[e].bk,
                    r_elem[e].ck
                    );
 }
 fclose(out);
 printf("Ok\n");

/*------------+
|             |
|  Side data  |
|             |
+------------*/
 name[len-1] = 's';

 if((out=fopen(name, "w"))==NULL)
  {fprintf(stderr, "Cannot save file %s !\n", name);
   return 1;}

 printf("sides..");
 fprintf(out, "%d\n", r_Ns);
 for(s=0; s<r_Ns; s++)
 {
  if(r_side[s].ea>=0 && r_side[s].eb>=0)
  {
   if(r_elem[r_side[s].ea].material<r_elem[r_side[s].eb].material)
   {
     int saven;
     saven=r_side[s].c;
     r_side[s].c=r_side[s].d;
     r_side[s].d=saven;
     saven=r_side[s].ea;
     r_side[s].ea=r_side[s].eb;
     r_side[s].eb=saven;
   }
/*   if((s==539)||(s==536))
   {
    printf("[%d] c,d: %d, %d\n",s,r_side[s].c,r_side[s].d);
   }
   */
  } else 
  if (r_side[s].ea<0)
  {
     int saven;
     saven=r_side[s].c;
     r_side[s].c=r_side[s].d;
     r_side[s].d=saven;
     saven=r_side[s].ea;
     r_side[s].ea=r_side[s].eb;
     r_side[s].eb=saven;
  }
  r_side[s].nx=r_node[r_side[s].d].y-r_node[r_side[s].c].y;
  r_side[s].ny=r_node[r_side[s].c].x-r_node[r_side[s].d].x;
  L=r_side[s].nx*r_side[s].nx+r_side[s].ny*r_side[s].ny;
  L=SQRT(L);
//  r_side[s].nx/=L;
//  r_side[s].ny/=L;
   fprintf(out, "%4d %4d "       // узлы
                "%4d %4d "       // соседние элементы
                "%+17.16e %+17.16e " // нормаль
                "%d " // маркер
                "\n",
                 r_side[s].c,  r_side[s].d, 
                 r_side[s].ea, r_side[s].eb, 
                 r_side[s].nx, r_side[s].ny, 
                 r_side[s].mark
                 );
 }
// fprintf(out, "--------------------------------\n");
// fprintf(out, "   s:    c    d   ea   eb   mark\n");

 fclose(out);
 printf("Ok\n");

 return 0;
}
/*-save--------------------------------------------------------------------*/
double SQRT(double x)
{
 double y;
 if(x>1e40) return 1e20; else
 if(x<0) printf("DOMAIN ERROR!\n"); else
 if(x>0)
 {
//  printf("a, x=%lf",x);
  y=sqrt(x);
//  printf("b\n");
  return y;
 }else
 return 0;

}
