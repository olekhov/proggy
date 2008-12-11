#ifndef __MISC_FUNCTIONS__
#define __MISC_FUNCTIONS__
 
//
// �㭪樨, �� ����騥 ��אַ�� �⭮襭�� � ����஥���
// �ਠ����樨. � �᭮����, �� ��������᪨� ���᫥���
 
#include "vars.h"
 
//
// ���頤� ��㣮�쭨�� (na,nb,nc) �१ ����୮� �ந��������, � ������
double area(struct nod *na, struct nod *nb, struct nod *nc);
//
// ����ﭨ� ����� 㧫���
double dist(struct nod *na, struct nod *nb);
//
// ���� �����, ���஬� ����� �ਭ�������� 㧥� (����� ��㣮�쭨��)
int in_elem(struct nod *n);
//
// ���᫥��� ࠤ��ᮢ ���ᠭ��� � ���ᠭ��� ���㦭��⥩
void circles(int e);
//
// "��������":
// ��ࠢ������� ������⢠ ����⮢ � 㧫��
void relax();
//
// ᬥ�� ஫�� (a,b)<->(c,d). �. ��㭮� output2.gif
void swap_side(int s);
//
// ���᫥��� ��ࠬ��� F ��� ������ 㧫� ��⥬ �������� ���௮��樨
// �� ���祭�� F � 㧫�� �����
void spacing(int e, int n);
//
// Diamond-check:
// �᫨ ��� �ᥤ��� ����� ���㦥�� ����� ��訬� (��� ���������騬�),
// � ��� ��������� ��� ��訥.
void diamond();
//
// ��࠭�� ����⮢, ��஭ � 㧫��, ����祭��� ��� OFF
void erase();
//
// ���᫥��� ������⢠ ᬥ���� ����⮢ ��� ������� 㧫�
// ��� relax � smooth
void neighbours();
//
// �����������: ����� 㧥� ��६�頥��� � 業�� ᢮�� �祩��, 10 ࠧ
void smooth();
//
// ����⪠ ����⮢ ᮣ��᭮ ���ਠ���.
void materials();
//
// �����䨪��� ����⮢: ���� ᠬ��� ���宣�
int classify();
//
// �஢�ઠ � �ਢ������ �ਠ����樨 � ���� ������
void bowyer(int n, int spac);

extern double g_ratio; 
#endif
