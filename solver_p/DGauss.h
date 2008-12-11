#ifndef __DGAUSS__
#define __DGAUSS__


/*
 ��⮤ ����� ��ᯮᮡ����� ��� �襭�� ��⥬ � �����묨 ����栬�

 �����樥��� �������� ᫥�. ��ࠧ��:

   ॠ��� ��� ������           ��ࠬ��� A

  * * * d a b c                   * * * d a b c              
    * * e d a b c                 * * e d a b c            
      * f e d a b c               * f e d a b c          
        g f e d a b c             g f e d a b c        
          g f e d a b c       ==> g f e d a b c      
            g f e d a b *         g f e d a b *    
              g f e d a * *       g f e d a * *  
                g f e d * * *     g f e d * * *

  �����樥���, �⬥祭�� "*", �� �ᯮ�������.
  � ������ �ਬ�� �ਭ� ��������� ࠢ�� 3, ࠧ��୮��� ������ - 8
*/

//  � ������� �⮣� ����� ����� ����� ���ᮢ��� ������. IndexConvert
//#define IC(i,j,D)  ( (i)*(2*D+1)+((j)-(i)+(D)) )
int IC(int i,int j,int D);

int DiagGSolve(double *A,int N,int D,double *X,double *B);

// ������ ������ � 㤮���� ����
void PM(double *A,int N,int D,double *B);


extern int WasIndexViolation;
#endif




