#ifndef __VARS_AND_TYPES__
#define __VARS_AND_TYPES__


#ifndef max
#define max(a,b) ( (a) > (b) ? (a) : (b) )
#endif

#ifndef min
#define min(a,b) ( (a) < (b) ? (a) : (b) )
#endif


#ifndef PI
#define PI    3.14159265359
#endif

#define SMALL 1e-30
#define GREAT 1e+30

#define ON      0 
#define OFF    -1       /* element is switched off */
#define WAIT   -2       /* node is waiting (it is a corner node) */
#define ACTIVE  3
#define DONE    4
#define WAITING 5


#define MAX_NODES 50000
/*-----------------------------+
|  definitions for the chains  |
+-----------------------------*/
#define CLOSED 0
#define OPEN   1
#define INSIDE 2


struct ele
 {
  int i,  j,  k;
  int ei, ej, ek;
  int si, sj, sk;

  int mark;             /* is it off (ON or OFF) */
  int state;            /* is it (D)one, (A)ctive or (W)aiting */
  int material;

  double xv, yv, xin, yin, R, r, Det;

  double ai,aj,ak,bi,bj,bk,ci,cj,ck,A;

  int new_numb;         /* used for renumeration */
 };



struct sid
 {
  int ea, eb;           /* left and right element */
  int a, b, c, d;       /* left, right, start and end point */

  int mark;             /* is it off, is on the boundary */

  double nx,ny;

  double s;

  int new_numb;         /* used for renumeration */
 };



struct nod
 {
  double x, y, F;
            
  double sumx, sumy;
  int    Nne;

  int mark;             /* is it off */

  int next;             /* next node in the boundary chain */
  int chain;            /* on which chains is the node */
  int inserted;

  int new_numb;         /* used for renumeration */
  int pair;
 };



struct seg
  {int n0, n1;
   int N; int chain; int bound; int mark;};

 
struct chai {int s0, s1, type;};

extern struct sid side[];
extern struct nod node[], point[];
extern struct ele elem[];
extern struct chai *chain;
extern struct seg *segment;

extern int periodic;

extern int Ne, Nn, Ns, Nc;             /* number of: elements, nodes, sides */
int save(char *name);

double SQRT(double x);

#endif
