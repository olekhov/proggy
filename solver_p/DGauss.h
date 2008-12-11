#ifndef __DGAUSS__
#define __DGAUSS__


/*
 метод гаусса приспособленный для решения систем с ленточными матрицами

 коэффициенты задаются след. образом:

   реальный вид матрицы           параметр A

  * * * d a b c                   * * * d a b c              
    * * e d a b c                 * * e d a b c            
      * f e d a b c               * f e d a b c          
        g f e d a b c             g f e d a b c        
          g f e d a b c       ==> g f e d a b c      
            g f e d a b *         g f e d a b *    
              g f e d a * *       g f e d a * *  
                g f e d * * *     g f e d * * *

  коэффициенты, отмеченные "*", не используются.
  в данном примере ширина диагонали равна 3, размерность матрицы - 8
*/

//  С помощью этого макроса можно легко адресовать элементы. IndexConvert
//#define IC(i,j,D)  ( (i)*(2*D+1)+((j)-(i)+(D)) )
int IC(int i,int j,int D);

int DiagGSolve(double *A,int N,int D,double *X,double *B);

// печатать матрицу в удобном виде
void PM(double *A,int N,int D,double *B);


extern int WasIndexViolation;
#endif




