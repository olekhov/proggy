#include <math.h>
#include <stdio.h>
#include <stdlib.h>
 
#include "vars.h"
#include "misc.h"
 
 
//
// Площадь треугольника (na,nb,nc) через векторное произведение, со знаком
double area(struct nod *na, struct nod *nb, struct nod *nc)
{
 return 0.5 * (   ((*nb).x-(*na).x)*((*nc).y-(*na).y)
                - ((*nb).y-(*na).y)*((*nc).x-(*na).x));
}
//
// расстояние между узлами
double dist(struct nod *na, struct nod *nb)
{
 return SQRT(   ((*nb).x-(*na).x)*((*nb).x-(*na).x)
              + ((*nb).y-(*na).y)*((*nb).y-(*na).y) );
}
//
// Поиск элемента, которому может принадлежать узел (внутри треугольника)
int in_elem(struct nod *n)
{
 int e;
// printf("in elem: %d\n",Ne);
 for(e=0; e<Ne; e++)    /* This must search through all elements ?? */
  {
   if(    area(n, &node[elem[e].i], &node[elem[e].j]) >= 0.0
       && area(n, &node[elem[e].j], &node[elem[e].k]) >= 0.0
       && area(n, &node[elem[e].k], &node[elem[e].i]) >= 0.0 )
   
   break;
  }
 return e;
}
//
// Вычисление радиусов вписанной и описанной окружностей
void circles(int e)
/*---------------------------------------------------+
|  This function calculates radii of inscribed and   |
|  circumscribed circle for a given element (int e)  |
+---------------------------------------------------*/
{
 double x, y, xi, yi, xj, yj, xk, yk, xij, yij, xjk, yjk, num, den;
 double si, sj, sk, O;

 xi=node[elem[e].i].x; yi=node[elem[e].i].y;
 xj=node[elem[e].j].x; yj=node[elem[e].j].y;
 xk=node[elem[e].k].x; yk=node[elem[e].k].y;
   
 xij=0.5*(xi+xj); yij=0.5*(yi+yj);
 xjk=0.5*(xj+xk); yjk=0.5*(yj+yk);

 num = (xij-xjk)*(xj-xi) + (yij-yjk)*(yj-yi);
 den = (xj -xi) *(yk-yj) - (xk -xj) *(yj-yi);

 if(den>0)
  {
   elem[e].xv = x = xjk + num/den*(yk-yj);
   elem[e].yv = y = yjk - num/den*(xk-xj);

   elem[e].R  = SQRT( (xi-x)*(xi-x) + (yi-y)*(yi-y) );
  }

 si=side[elem[e].si].s;
 sj=side[elem[e].sj].s;
 sk=side[elem[e].sk].s;
 O =si+sj+sk;
 elem[e].Det = xi*(yj-yk) - xj*(yi-yk) + xk*(yi-yj);

 elem[e].xin = ( xi*si + xj*sj + xk*sk ) / O;
 elem[e].yin = ( yi*si + yj*sj + yk*sk ) / O;

 elem[e].r   = elem[e].Det / O;
}
/*-circles-----------------------------------------------------------------*/
 
//
// "Релаксация":
// Выравнивание количества элементов в узлах
void relax(void)
{
 int s, T, E;
 
 for(T=6; T>=3; T--)
   for(s=0; s<Ns; s++)
     if(side[s].mark==0)
       if( (node[side[s].a].mark==0) &&
           (node[side[s].b].mark==0) &&
           (node[side[s].c].mark==0) &&
           (node[side[s].d].mark==0) )
      {
       E =   node[side[s].c].Nne + node[side[s].d].Nne
           - node[side[s].a].Nne - node[side[s].b].Nne;
 
       if(E==T)
        {node[side[s].a].Nne++; node[side[s].b].Nne++;
         node[side[s].c].Nne--; node[side[s].d].Nne--;
         swap_side(s);}
      }
}
 
//
// смена ролей (a,b)<->(c,d). см. рисунок output2.gif
void swap_side(int s)
{
 int    a, b, c, d, ea, eb, eac, ead, ebc, ebd, sad, sac, sbc, sbd;
 double sx, sy;
 
 ea=side[s].ea; 
 eb=side[s].eb;
 a=side[s].a; b=side[s].b; c=side[s].c; d=side[s].d;

 if(elem[ea].ei==eb) {ead=elem[ea].ej; eac=elem[ea].ek; 
              sad=elem[ea].sj; sac=elem[ea].sk;}
 
 if(elem[ea].ej==eb) {ead=elem[ea].ek; eac=elem[ea].ei; 
              sad=elem[ea].sk; sac=elem[ea].si;}   
 
 if(elem[ea].ek==eb) {ead=elem[ea].ei; eac=elem[ea].ej;
              sad=elem[ea].si; sac=elem[ea].sj;}

 if(elem[eb].ei==ea) {ebc=elem[eb].ej; ebd=elem[eb].ek;
              sbc=elem[eb].sj; sbd=elem[eb].sk;}

 if(elem[eb].ej==ea) {ebc=elem[eb].ek; ebd=elem[eb].ei;
              sbc=elem[eb].sk; sbd=elem[eb].si;}
 
 if(elem[eb].ek==ea) {ebc=elem[eb].ei; ebd=elem[eb].ej;
              sbc=elem[eb].si; sbd=elem[eb].sj;}

 elem[ea].i =a;   elem[ea].j =b;   elem[ea].k =d;  
 elem[ea].ei=ebd; elem[ea].ej=ead; elem[ea].ek=eb;  
 elem[ea].si=sbd; elem[ea].sj=sad; elem[ea].sk=s;  
  
 elem[eb].i =a;   elem[eb].j =c;   elem[eb].k =b;  
 elem[eb].ei=ebc; elem[eb].ej=ea;  elem[eb].ek=eac;  
 elem[eb].si=sbc; elem[eb].sj=s;   elem[eb].sk=sac;  

 if(eac!=-1)
  {
   if(elem[eac].ei==ea) elem[eac].ei=eb;
   if(elem[eac].ej==ea) elem[eac].ej=eb;
   if(elem[eac].ek==ea) elem[eac].ek=eb; 
  }
 
 if(ebd!=-1)
  {
   if(elem[ebd].ei==eb) elem[ebd].ei=ea;
   if(elem[ebd].ej==eb) elem[ebd].ej=ea;
   if(elem[ebd].ek==eb) elem[ebd].ek=ea; 
  }
 
 if(side[sad].ea==ea) {side[sad].a=b;}
 if(side[sad].eb==ea) {side[sad].b=b;}

 if(side[sbc].ea==eb) {side[sbc].a=a;}
 if(side[sbc].eb==eb) {side[sbc].b=a;}

 if(side[sbd].ea==eb) {side[sbd].ea=ea; side[sbd].a=a;}
 if(side[sbd].eb==eb) {side[sbd].eb=ea; side[sbd].b=a;}
 
 if(a<b)
  {side[s].c=a; side[s].d=b; side[s].a=d; side[s].b=c;
   side[s].ea=ea; side[s].eb=eb;}
 else 
  {side[s].c=b; side[s].d=a; side[s].a=c; side[s].b=d;
   side[s].ea=eb; side[s].eb=ea;}

 sx = node[side[s].c].x - node[side[s].d].x;
 sy = node[side[s].c].y - node[side[s].d].y;
 side[s].s = SQRT(sx*sx+sy*sy);

 if(side[sac].ea==ea) {side[sac].ea=eb; side[sac].a=b;}
 if(side[sac].eb==ea) {side[sac].eb=eb; side[sac].b=b;}
 
 if(side[sad].ea==ea) {side[sad].a=b;}
 if(side[sad].eb==ea) {side[sad].b=b;}

 if(side[sbc].ea==eb) {side[sbc].a=a;}
 if(side[sbc].eb==eb) {side[sbc].b=a;}

 if(side[sbd].ea==eb) {side[sbd].ea=ea; side[sbd].a=a;}
 if(side[sbd].eb==eb) {side[sbd].eb=ea; side[sbd].b=a;}

 circles(ea);
 circles(eb);
}
/*-swap_side---------------------------------------------------------------*/
 
//
// Вычисление параметра F для нового узла путем линейной интерполяции
// по значениям F в узлах элемента
void spacing(int e, int n)
{
 double dxji, dxki, dyji, dyki, dx_i, dy_i, det, a, b;

 dxji = node[elem[e].j].x - node[elem[e].i].x;
 dyji = node[elem[e].j].y - node[elem[e].i].y;
 dxki = node[elem[e].k].x - node[elem[e].i].x;
 dyki = node[elem[e].k].y - node[elem[e].i].y;
 dx_i = node[n].x - node[elem[e].i].x;
 dy_i = node[n].y - node[elem[e].i].y;

 det = dxji*dyki - dxki*dyji;

 a = (+ dyki*dx_i - dxki*dy_i)/det;
 b = (- dyji*dx_i + dxji*dy_i)/det;

 node[n].F = node[elem[e].i].F + 
         a*(node[elem[e].j].F - node[elem[e].i].F) +
         b*(node[elem[e].k].F - node[elem[e].i].F);
}
 
//
// Diamond-check:
// если два соседних элемента окружены четырмя хорошими (или отсутствующими),
// то оба помечаются как хорошие.
void diamond(void)
{
 int ea, eb, eac, ead, ebc, ebd, s;
 
 for(s=0; s<Ns; s++)
   if(side[s].mark!=OFF)
    {
     ea=side[s].ea;
     eb=side[s].eb;
 
     if(elem[ea].ei==eb) {ead=elem[ea].ej; eac=elem[ea].ek;}
     if(elem[ea].ej==eb) {ead=elem[ea].ek; eac=elem[ea].ei;}
     if(elem[ea].ek==eb) {ead=elem[ea].ei; eac=elem[ea].ej;}
 
     if(elem[eb].ei==ea) {ebc=elem[eb].ej; ebd=elem[eb].ek;}
     if(elem[eb].ej==ea) {ebc=elem[eb].ek; ebd=elem[eb].ei;}
     if(elem[eb].ek==ea) {ebc=elem[eb].ei; ebd=elem[eb].ej;}
 
     if( (eac==OFF || elem[eac].state==DONE) &&
         (ebc==OFF || elem[ebc].state==DONE) &&
         (ead==OFF || elem[ead].state==DONE) &&
         (ebd==OFF || elem[ebd].state==DONE) )
      {
       elem[ea].state=DONE;
       elem[eb].state=DONE;
      }
    }
}
//
// Стирание элементов, сторон и узлов, помеченных как OFF
void erase(void)
{
 int s, n, e;
 
 int a, b, c ;
 
/*--------------------------+
|                           |
|  Negative area check for  |
|  elimination of elements  |
|                           |
+--------------------------*/
 for(e=0; e<Ne; e++)
   if( (node[elem[e].i].chain==node[elem[e].j].chain) &&
       (node[elem[e].j].chain==node[elem[e].k].chain) &&
       (chain[node[elem[e].i].chain].type==CLOSED) )
  {
   a = min( min(elem[e].i, elem[e].j), elem[e].k );
   c = max( max(elem[e].i, elem[e].j), elem[e].k );
   b = elem[e].i+elem[e].j+elem[e].k - a - c;
 
   if(a<3)
     elem[e].mark=OFF;
 
   else if(area(&node[a], &node[b], &node[c]) < 0.0)
     elem[e].mark=OFF;
  }
 
 for(e=0; e<Ne; e++)
  {if(elem[elem[e].ei].mark==OFF) elem[e].ei=OFF;
   if(elem[elem[e].ej].mark==OFF) elem[e].ej=OFF;
   if(elem[elem[e].ek].mark==OFF) elem[e].ek=OFF;}
 
/*-----------------------+
|                        |
|  Elimination of sides  |
|                        |
+-----------------------*/
 for(s=0; s< 3; s++)
   side[s].mark=OFF;
 
 for(s=3; s<Ns; s++)
   if( (elem[side[s].ea].mark==OFF) && (elem[side[s].eb].mark==OFF) )
     side[s].mark=OFF;
 
 for(s=3; s<Ns; s++)
   if(side[s].mark!=OFF)
    {
     if(elem[side[s].ea].mark==OFF) {side[s].ea=OFF; side[s].a=OFF;}
     if(elem[side[s].eb].mark==OFF) {side[s].eb=OFF; side[s].b=OFF;}
    }
 
/*-----------------------+
|                        |
|  Elimination of nodes  |
|                        |
+-----------------------*/
 for(n=0; n< 3; n++)
   node[n].mark=OFF;
}
//
// Вычисление количества смежных элементов для каждого узла
// для relax и smooth
void neighbours(void)
{
 int s;
 
 for(s=0; s<Ns; s++)
   if(side[s].mark==0)
    {
     if(node[side[s].c].mark==0)
       node[side[s].c].Nne++;
 
     if(node[side[s].d].mark==0)
       node[side[s].d].Nne++;
    }
}
 
//
// Сглаживание: каждый узел перемещается в центр своей ячейки, 10 раз
void smooth(void)
{
 int it, s, n, e;
 
 for(it=0; it<10; it++)
  {
   for(s=0; s<Ns; s++)
     if(side[s].mark==0)
      {
       if(node[side[s].c].mark==0)
        {node[side[s].c].sumx += node[side[s].d].x;
         node[side[s].c].sumy += node[side[s].d].y;}
 
       if(node[side[s].d].mark==0)
        {node[side[s].d].sumx += node[side[s].c].x;
         node[side[s].d].sumy += node[side[s].c].y;}
      }
 
   for(n=0; n<Nn; n++)
     if(node[n].mark==0)
      {node[n].x=node[n].sumx/node[n].Nne; node[n].sumx=0.0;
       node[n].y=node[n].sumy/node[n].Nne; node[n].sumy=0.0;}
  }
 
 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF)
     circles(e);
}
double g_ratio;
//
// Классификация элементов
int classify(void)
/*----------------------------------------------------------+
|  This function searches through all elements every time.  |
|  Some optimisation will definitely bee needed             |
|                                                           |
|  But it also must me noted, that this function defines    |
|  the strategy for insertion of new nodes                  |
|                                                           |
|  It's MUCH MUCH better when the ugliest element is found  |
|  as one with highest ratio of R/r !!! (before it was      |
|  element with greater R)                                  |
+----------------------------------------------------------*/
{
 int e, ei, ej, ek,si,sj,sk,ugly;
 double ratio=-GREAT, F;

 ugly=OFF;

 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF)
    {
     ei=elem[e].ei; ej=elem[e].ej; ek=elem[e].ek;

     F=(node[elem[e].i].F + node[elem[e].j].F + node[elem[e].k].F)/3.0;

     elem[e].state=WAITING;

/*--------------------------+
|  0.577 is ideal triangle  |
+--------------------------*/
     if(elem[e].R < 0.700*F) elem[e].state=DONE; /* 0.0866; 0.07 */

/*------------------------+
|  even this is possible  |
+------------------------*/
     if(ei!=OFF && ej!=OFF && ek!=OFF)
       if(elem[ei].state==DONE && elem[ej].state==DONE && elem[ek].state==DONE)
     elem[e].state=DONE;
    }

/*--------------------------------------+
|  Diamond check. Is it so important ?  |
+--------------------------------------*/
   diamond();   

/*------------------------------------------------+
|  First part of the trick:                       |
|    search through the elements on the boundary  |
+------------------------------------------------*/
 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF && elem[e].state!=DONE)
    {
     si=elem[e].si; sj=elem[e].sj; sk=elem[e].sk;

     if(side[si].mark!=0) elem[e].state=ACTIVE;
     if(side[sj].mark!=0) elem[e].state=ACTIVE;
     if(side[sk].mark!=0) elem[e].state=ACTIVE;
  
     if(elem[e].state==ACTIVE && elem[e].R/elem[e].r > ratio)
      {ratio=max(ratio, elem[e].R/elem[e].r);
       ugly=e;}
    }

/*-------------------------------------------------+
|  Second part of the trick:                       |
|    if non-acceptable element on the boundary is  |
|    found, ignore the elements inside the domain  |
+-------------------------------------------------*/
 if(ugly==OFF)
   for(e=0; e<Ne; e++)
     if(elem[e].mark!=OFF)
      {
       if(elem[e].state!=DONE)
    {
     ei=elem[e].ei; ej=elem[e].ej; ek=elem[e].ek;

     if(ei!=OFF)
       if(elem[ei].state==DONE) elem[e].state=ACTIVE;
  
     if(ej!=OFF)
       if(elem[ej].state==DONE) elem[e].state=ACTIVE;
  
     if(ek!=OFF)
       if(elem[ek].state==DONE) elem[e].state=ACTIVE;
  
     if(elem[e].state==ACTIVE && elem[e].R/elem[e].r > ratio)
      {ratio=max(ratio, elem[e].R/elem[e].r);
       ugly=e;}
    }
      }
 g_ratio=ratio;
 return ugly;
}

//
// Пометка элементов согласно материалам.
void materials(void)
{
 int e, c, mater, over;
 int ei, ej, ek, si, sj, sk;

 for(e=0; e<Ne; e++)
   if(elem[e].mark!=OFF)   
     elem[e].material=OFF;

 for(c=0; c<Nc; c++)
  {
   if(point[c].inserted==0)
    {
     elem[in_elem(&point[c])].material=point[c].mark;
     mater=ON;
    }
  }

 if(mater==ON)
  {
   for(;;) 
    {      
     over=ON;

     for(e=0; e<Ne; e++)
       if(elem[e].mark!=OFF && elem[e].material==OFF)
    {
     ei=elem[e].ei;
     ej=elem[e].ej;
     ek=elem[e].ek;

     si=elem[e].si;
     sj=elem[e].sj;
     sk=elem[e].sk;

   
     if(ei!=OFF)
       if(elem[ei].material!=OFF && side[si].mark==0)
        {
         elem[e].material=elem[ei].material;
         over=OFF;
        }

     if(ej!=OFF)
       if(elem[ej].material!=OFF && side[sj].mark==0)
        {
         elem[e].material=elem[ej].material;
         over=OFF;
        }

     if(ek!=OFF)
       if(elem[ek].material!=OFF && side[sk].mark==0)
        {
         elem[e].material=elem[ek].material;
         over=OFF;
        }

    }

     if(over==ON) break;

    } /* for(iter) */

  }
}
//
// проверка и приведение триангуляции к виду Делоне
void bowyer(int n, int spac)
{
 int e, s, swap;
 struct nod vor;
 spac=spac;

 do
  {
   swap=0;
   for(s=0; s<Ns; s++)
   if(side[s].mark==0)
   {
    if(side[s].a==n)
    {
     e=side[s].eb;
     if(e!=OFF)
     {
      vor.x=elem[e].xv;
      vor.y=elem[e].yv;
      if( dist(&vor, &node[n]) < elem[e].R )
      {
       swap_side(s);
       swap=1;
      }
     }
    } else // side[s].a==n
    if(side[s].b==n)
    {
     e=side[s].ea;
     if(e!=OFF)
     {
      vor.x=elem[e].xv;
      vor.y=elem[e].yv;
      if( dist(&vor, &node[n]) < elem[e].R )
      {
       swap_side(s);
       swap=1;
      }
     }
    }
   }
  }
 while(swap==1);
}
