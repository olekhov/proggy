unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons,math, ActnList, AppEvnts,
  XPMan;

type

//  PDrawFunc =  ^TDrawFunc;
  TDrawFunc = function (x,y:double):double of object;

  TMyPoint = record
    X,Y: Double;
    mark:integer;
    F:double;
  end;

  TSide = record
    N1,N2:integer;
    ea,eb:integer;
    nx,ny:double;
    mark:integer;
  end;

  TMark = record
    X,Y: Double;
    M:integer;
  end;

  TMaterial=record
    d11,d12,d21,d22:double;
    delta:double;
  end;

  TElement=record
   i,j,k     // Номера образующих вершин, против часовой стрелки
             :  Integer;
   si,sj,sk  // Номера образующих сторон, si - противоположна i-той вершине
             :  Integer;
   mark      // Метка материала
             :  Integer;
   ei,ej,ek  // Номера соседних элементов: e_* - по ту сторону от стороны s_*
             :  Integer;
   ai,aj,ak, // Коэффициенты функции формы:
   bi,bj,bk, // F_# = 1/2A * (a_# + x*b_# + y*c_#)
   ci,cj,ck, // Чтобы вычислить значение функции внутри элемента, надо:
             // G = G_i*F_i(x,y)+G_j*F_k(x,y)+G_k*F_k(x,y) 
   A         // Площадь элемента
             :  double;
   mx,my:double;
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Image1: TImage;
    ZoomIn: TBitBtn;
    ZoomOut: TBitBtn;
    ToLeft: TBitBtn;
    ToRight: TBitBtn;
    ToUp: TBitBtn;
    ToDown: TBitBtn;
    N12: TMenuItem;
    SB: TStatusBar;
    OpenDialog1: TOpenDialog;
    MenuShowMat: TMenuItem;
    MenuShowN1: TMenuItem;
    MenuShowN2: TMenuItem;
    MenuShowNorm: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    MenuVertCut: TMenuItem;
    N9: TMenuItem;
    EPS1: TMenuItem;
    SaveDialog1: TSaveDialog;
    N10: TMenuItem;
    MenuShowPsi: TMenuItem;
    Psi2: TMenuItem;
    Batch1: TMenuItem;
    ShowSigma13: TMenuItem;
    ShowSigma23: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    SDMP: TSaveDialog;
    MP1: TMenuItem;
    PB: TProgressBar;
    XPManifest1: TXPManifest;
    lRead: TLabel;
    procedure N4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShowData;
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ToLeftClick(Sender: TObject);
    procedure ToRightClick(Sender: TObject);
    procedure ToUpClick(Sender: TObject);
    procedure ToDownClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure MenuShowMatClick(Sender: TObject);
    procedure MenuShowNormClick(Sender: TObject);
    procedure MenuShowN1Click(Sender: TObject);
    procedure MenuShowN2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure MenuVertCutClick(Sender: TObject);
    procedure EPS1Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure MenuShowPsiClick(Sender: TObject);
    procedure Psi2Click(Sender: TObject);
    procedure Batch1Click(Sender: TObject);
    procedure ShowSigma13Click(Sender: TObject);
    procedure ShowSigma23Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MP1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    mcolors:array of Tcolor;
    { Private declarations }
    Domain : record
     Points   : array of TMyPoint;
     Sides    : array of TSide;
     NumPoints,
     NumSides: integer;
    end;
    
    minV,maxV{,PN2}:double;

    showmin,showmax:double;

    Mesh : record
     Points   // Список точек, 1 .. NumPoints
              :  array of TMyPoint;
     Sides    // Список сторон, 1 .. NumSides
              :  array of TSide;
     Elements // Список элементов, 1 .. NumElements
              :  array of TElement;
     NumPoints,   // Количество точек
     NumSides,    // Количество сторон
     NumElements  // Количество элементов
                  :  Integer;

     N1R,         // Считанные значения N1, 1 .. NumPoints
     N2R          // Считанные значения N2, 1 .. NumPoints
                  :  array of double;

     Psi,
     Psi0,
     Sigma13,
     Sigma23      //
                  :  array of double;
     dN1dx,       // Средневзвешенные значения производных в точках триангуляции
     dN1dy,       // 1 .. NumPoints
     dN2dx,       //
     dN2dy        //
                  :  array of double;
     edN1dx,      // Значения производных на элементах триангуляции
     edN1dy,      // 1 .. NumElements
     edN2dx,      //
     edN2dy       //
                  :  array of double;

     cell         // Объём ячейки вокруг точки триангуляции, 1 .. NumPoints
                  :  array of double;
     materials    // Материалы, 1 .. NumMaterials
                  :  array of TMaterial;
     nummaterials // Количество материалов
                  :  Integer;
     Volume       // Полная площадь триангуляции
                  :  Double;
    end;

    ViewX, ViewY : double;
    Zoom : double;
    ShowNorm,
    ShowMat,
    showN1,
    ShowN2   :boolean;
    Cut:double;
    minx,miny,maxx,maxy:double;
    Gmaxn1,Gmaxn2,Gminn1,Gminn2:double;
    M,tau:double;
    D0_11,D0_22:double;
    NowDraw: TDrawFunc;
    function N_1(x,y:double):double;
    function N_2(x,y:double):double;
    function dN_1dx(x,y:double):double;
    function dN_1dy(x,y:double):double;
    function dN_2dx(x,y:double):double;
    function dN_2dy(x,y:double):double;
    function sigma_13(x,y:double):double;
    function sigma_23(x,y:double):double;
    function eps_13(x,y:double):double;
    function eps_23(x,y:double):double;
    function InElement(n:TMyPoint):integer;
    function area(na,nb,nc:TMyPoint):double;
    function PPsi(x,y:double):double;
    function dPsidx(x,y:double):double;
    function dPsidy(x,y:double):double;
//    function CPsi(x,y:double):double;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}
var G1,G2:double;

function precise_ppsi(x,y:double):double;
begin
 if y < -1/6 then result:=10*y+5 else
 if y<1/6 then result:=-60*y*y+5 else
 result:=-10*y+5;
end;

function ppsi_0(x,y:double):double;
begin
 result:=-20*sqr(y)+5;
end;

function pdpsi_0dy(x,y:double):double;
begin
 result:=-40*y;
end;

function pdpsi_0dx(x,y:double):double;
begin
 result:=0;
end;

function cpsi_0(x,y:double):double;
begin
 result:=2*G1*G2/(G1+G2)*(4-sqr(x)-sqr(y));
end;

function cdpsi_0dx(x,y:double):double;
begin
 result:=2*G1*G2/(G1+G2)*(-2*x);
end;

function cdpsi_0dy(x,y:double):double;
begin
 result:=2*G1*G2/(G1+G2)*(-2*y)
end;

function cd2psi_0dy2(x,y:double):double;
begin
 result:=-4*G1*G2/(G1+G2);
end;

function cd2psi_0dxdy(x,y:double):double;
begin
 result:=0;
end;

function cd2psi_0dx2(x,y:double):double;
begin
 result:=-4*G1*G2/(G1+G2);
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
 Self.Close;
end;

procedure TMainForm.N2Click(Sender: TObject);
var Fname:string;
    f:TextFile;
    Elem,
    Side,
    Point,
    Mat   :integer;
//    si,sj,sk:integer;
    Ve:double;
//    h,x,y:double;
//    p:TMyPoint;
begin
 if ParamCount>=1 then FName:=ParamStr(1) else
 begin
  if not OpenDialog1.Execute then exit;
  Fname:=OpenDialog1.FileName;
 end;
 Fname:=copy(fname,1,length(fname)-2);

 AssignFile(f,fname+'.n'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.Points,Mesh.NumPoints);
 lRead.Caption:='Точки';
 PB.Max:=Mesh.NumPoints;
 for Point:=0 to Mesh.NumPoints-1 do
 begin
  readln(f,Mesh.Points[Point].x,Mesh.Points[Point].y,Mesh.points[Point].mark);
  if Point=0 then begin maxx:=Mesh.Points[Point].x; maxy:=Mesh.Points[Point].y; minx:=maxx; miny:=maxy; end;
  maxx:=max(Mesh.Points[Point].x,maxx);
  maxy:=max(Mesh.Points[Point].y,maxy);
  minx:=min(Mesh.Points[Point].x,minx);
  miny:=min(Mesh.Points[Point].y,miny);
  PB.Position :=Point;
  Application.ProcessMessages;
 end;
 closefile(f);

 AssignFile(f,fname+'.s'); Reset(f);
 Readln(f,Mesh.NumSides);
 SetLength(Mesh.Sides,Mesh.NumSides);
 for Side:=0 to Mesh.NumSides-1 do
  readln(f,Mesh.Sides[Side].n1,Mesh.Sides[Side].n2,Mesh.Sides[Side].ea,Mesh.Sides[Side].eb,Mesh.Sides[Side].nx,Mesh.Sides[Side].ny,
   Mesh.sides[Side].mark);
 closefile(f);


 AssignFile(f,fname+'.e'); Reset(f);
 Readln(f,Mesh.NumElements);
 SetLength(Mesh.Elements,Mesh.NumElements);
 setlength(Mesh.cell,mesh.numpoints);
 lRead.Caption:='Элементы'; PB.Max:=Mesh.NumElements; PB.Position :=0;
 for Point:=0 to mesh.numpoints-1 do mesh.cell[Point]:=0;
 for Elem:=0 to Mesh.NumElements -1 do
 with Mesh.Elements[Elem] do
 begin
   PB.StepIt;
   Application.ProcessMessages;
   read(f,i,j,k);
   read(f,ei,ej,ek);
   read(f,si,sj,sk);
   read(f,mark);
   read(f,A);
   read(f,ai,bi,ci);
   read(f,aj,bj,cj);
   read(f,ak,bk,ck);
   mx:=1/3*(Mesh.Points[i].x+Mesh.Points[j].x+Mesh.Points[k].x);
   my:=1/3*(Mesh.Points[i].y+Mesh.Points[j].y+Mesh.Points[k].y);
   if Mesh.Sides[sk].N1=i then Mesh.Sides[sk].ea:=Elem else Mesh.Sides[sk].eb:=Elem;
   if Mesh.Sides[sj].N1=k then Mesh.Sides[sj].ea:=Elem else Mesh.Sides[sj].eb:=Elem;
   if Mesh.Sides[si].N1=j then Mesh.Sides[si].ea:=Elem else Mesh.Sides[si].eb:=Elem;
   Mesh.cell[i]:=mesh.cell[i]+A;
   Mesh.cell[j]:=mesh.cell[j]+A;
   Mesh.cell[k]:=mesh.cell[k]+A;
   {
   Mesh.cell[Mesh.elements[i].i]:=mesh.cell[mesh.elements[i].i]+1;
   Mesh.cell[Mesh.elements[i].j]:=mesh.cell[mesh.elements[i].j]+1;
   Mesh.cell[Mesh.elements[i].k]:=mesh.cell[mesh.elements[i].k]+1;
   }
 end;
 closefile(f);

 AssignFile(f,fname+'.n1'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.N1R,Mesh.NumPoints);
 lRead.Caption:='N1'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 for Point:=0 to Mesh.NumPoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  readln(f,Mesh.N1R[Point]);
  if Point=0 then begin Gmaxn1:=Mesh.N1R[Point]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(Mesh.N1R[Point],Gmaxn1);
  Gminn1:=min(Mesh.N1R[Point],GminN1);
 end;
 closefile(f);

 AssignFile(f,fname+'.n2'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.N2R,Mesh.NumPoints);
 lRead.Caption:='N2'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 for Point:=0 to Mesh.NumPoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  readln(f,Mesh.N2R[Point]);
  if Point=0 then begin Gmaxn2:=Mesh.N2R[Point]; Gminn2:=Gmaxn2; end;
  Gmaxn2:=max(Mesh.N2R[Point],Gmaxn2);
  Gminn2:=min(Mesh.N2R[Point],GminN2);
 end;
 closefile(f);

 try
 AssignFile(f,fname+'.psi0'); Reset(f);
 Readln(f,Mesh.NumPoints);
 lRead.Caption:='PSI0'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 SetLength(Mesh.Psi0,Mesh.NumPoints);
 for Point:=0 to Mesh.NumPoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  readln(f,Mesh.Psi0[Point]);
  {
  if Point=0 then begin Gmaxn1:=Mesh.N1R[Point]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(Mesh.N1R[Point],Gmaxn1);
  Gminn1:=min(Mesh.N1R[Point],GminN1);
  }
 end;
 closefile(f);

 AssignFile(f,fname+'.psi'); Reset(f);
 Readln(f,Mesh.NumPoints);
 lRead.Caption:='PSI'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 SetLength(Mesh.Psi,Mesh.NumPoints);
 for Point:=0 to Mesh.NumPoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  readln(f,Mesh.Psi[Point]);
  {
  if Point=0 then begin Gmaxn1:=Mesh.N1R[Point]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(Mesh.N1R[Point],Gmaxn1);
  Gminn1:=min(Mesh.N1R[Point],GminN1);
  }
 end;
 closefile(f);

 AssignFile(f,fname+'.sigma'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.Sigma13,Mesh.NumPoints);
 SetLength(Mesh.Sigma23,Mesh.NumPoints);
 lRead.Caption:='Sigma'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 for Point:=0 to Mesh.NumPoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  readln(f,Mesh.Sigma13[Point],Mesh.Sigma23[Point]);
  {
  if Point=0 then begin Gmaxn1:=Mesh.N1R[Point]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(Mesh.N1R[Point],Gmaxn1);
  Gminn1:=min(Mesh.N1R[Point],GminN1);
  }
 end;
 closefile(f);
 except
 end;
 AssignFile(f,fname+'.m'); reset(f);
 Readln(f,Mesh.NumMaterials);
 SetLength(Mesh.Materials,Mesh.NumMaterials);
 for Mat:=0 to Mesh.NumMaterials-1 do
 begin
  readln(f,Mesh.Materials[Mat].d11,Mesh.Materials[Mat].d12,Mesh.Materials[Mat].d21,Mesh.Materials[Mat].d22)
 end;
 closefile(f);

 // Вычисление значений производных на элементах
 SetLength(Mesh.edN1dx,Mesh.NumElements);
 SetLength(Mesh.edN1dy,Mesh.NumElements);
 SetLength(Mesh.edN2dx,Mesh.NumElements);
 SetLength(Mesh.edN2dy,Mesh.NumElements);
 lRead.Caption:='Производные'; PB.Max:=Mesh.NumElements; PB.Position :=0;
 for Elem:=0 to Mesh.NumElements-1 do
 with Mesh.Elements[Elem], Mesh do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  edN1dx[Elem]:=(N1R[i]*bi+N1R[j]*bj+N1R[k]*bk)/2/A;
  edN1dy[Elem]:=(N1R[i]*ci+N1R[j]*cj+N1R[k]*ck)/2/A;
  edN2dx[Elem]:=(N2R[i]*bi+N2R[j]*bj+N2R[k]*bk)/2/A;
  edN2dy[Elem]:=(N2R[i]*ci+N2R[j]*cj+N2R[k]*ck)/2/A;
 end;

 // выставление производных
 setlength(Mesh.dN1dx,mesh.numpoints);
 setlength(Mesh.dN1dy,mesh.numpoints);
 setlength(Mesh.dN2dx,mesh.numpoints);
 setlength(Mesh.dN2dy,mesh.numpoints);
 for Point:=0 to mesh.numpoints-1 do
 begin
  mesh.dn1dx[Point]:=0;
  mesh.dn1dy[Point]:=0;
  mesh.dn2dx[Point]:=0;
  mesh.dn2dy[Point]:=0;
 end;
 lRead.Caption:='Производные-2'; PB.Max:=Mesh.NumElements; PB.Position :=0;
 for Elem:=0 to mesh.numelements-1 do
 with Mesh, Mesh.Elements[Elem] do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  dN1dx[i]:=dN1dx[i]+edN1dx[Elem]*A;
  dN1dx[j]:=dN1dx[j]+edN1dx[Elem]*A;
  dN1dx[k]:=dN1dx[k]+edN1dx[Elem]*A;

  dN1dy[i]:=dN1dy[i]+edN1dy[Elem]*A;
  dN1dy[j]:=dN1dy[j]+edN1dy[Elem]*A;
  dN1dy[k]:=dN1dy[k]+edN1dy[Elem]*A;

  dN2dx[i]:=dN2dx[i]+edN2dx[Elem]*A;
  dN2dx[j]:=dN2dx[j]+edN2dx[Elem]*A;
  dN2dx[k]:=dN2dx[k]+edN2dx[Elem]*A;

  dN2dy[i]:=dN2dy[i]+edN2dy[Elem]*A;
  dN2dy[j]:=dN2dy[j]+edN2dy[Elem]*A;
  dN2dy[k]:=dN2dy[k]+edN2dy[Elem]*A;
(*
  // dn1/dx
  mesh.dN1dx[mesh.Elements[i].i]:=mesh.dN1dx[mesh.Elements[i].i]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2; {/(2A)*A}
  mesh.dN1dx[mesh.Elements[i].j]:=mesh.dN1dx[mesh.Elements[i].j]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2;
  mesh.dN1dx[mesh.Elements[i].k]:=mesh.dN1dx[mesh.Elements[i].k]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2;

  // dn1/dy
  mesh.dN1dy[mesh.Elements[i].i]:=mesh.dN1dy[mesh.Elements[i].i]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;
  mesh.dN1dy[mesh.Elements[i].j]:=mesh.dN1dy[mesh.Elements[i].j]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;
  mesh.dN1dy[mesh.Elements[i].k]:=mesh.dN1dy[mesh.Elements[i].k]+
  (
   mesh.n1r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n1r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n1r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;

  // dn2/dx
  mesh.dN2dx[mesh.Elements[i].i]:=mesh.dN2dx[mesh.Elements[i].i]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2;
  mesh.dN2dx[mesh.Elements[i].j]:=mesh.dN2dx[mesh.Elements[i].j]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2;
  mesh.dN2dx[mesh.Elements[i].k]:=mesh.dN2dx[mesh.Elements[i].k]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].bi+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].bj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].bk)*1/2;

  // dn2/dy
  mesh.dN2dy[mesh.Elements[i].i]:=mesh.dN2dy[mesh.Elements[i].i]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;
  mesh.dN2dy[mesh.Elements[i].j]:=mesh.dN2dy[mesh.Elements[i].j]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;
  mesh.dN2dy[mesh.Elements[i].k]:=mesh.dN2dy[mesh.Elements[i].k]+
  (
   mesh.n2r[mesh.Elements[i].i]*mesh.elements[i].ci+
   mesh.n2r[mesh.Elements[i].j]*mesh.elements[i].cj+
   mesh.n2r[mesh.Elements[i].k]*mesh.elements[i].ck)*1/2;
  *)
 end;

 lRead.Caption:='Производные-3'; PB.Max:=Mesh.NumPoints; PB.Position :=0;
 for Point:=0 to mesh.numpoints-1 do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  mesh.dN1dx[Point]:=mesh.dN1dx[Point]/mesh.cell[Point];
  mesh.dN1dy[Point]:=mesh.dN1dy[Point]/mesh.cell[Point];
  mesh.dN2dx[Point]:=mesh.dN2dx[Point]/mesh.cell[Point];
  mesh.dN2dy[Point]:=mesh.dN2dy[Point]/mesh.cell[Point];
 end;

 D0_11:=0; D0_22:=0;
 {
 p.x:=0; p.y:=-0.5; h:=0.01;
 while p.y<0.5 do
 begin
  e:=InElement(p);
  if e<0 then begin p.y:=p.y+h;continue;end;
  D0_11:=D0_11+mesh.materials[mesh.elements[e].mark].d11*(dn_1dx(p.x,p.y)+1)*h;
  D0_22:=D0_22+mesh.materials[mesh.elements[e].mark].d22*(dn_2dy(p.x,p.y)+1)*h;
  p.y:=p.y+h;
 end;
 (*}
 lRead.Caption:='Объём'; PB.Max:=Mesh.NumElements; PB.Position :=0;
 Mesh.Volume :=0;
 for Elem:=0 to Mesh.NumElements-1 do
 with Mesh.Elements[Elem] do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  Ve:=Mesh.Materials[mark].d11*(Mesh.edN1dx[Elem]+1); (*
   Ve:=Mesh.Materials[mark].d11*
      (Mesh.N1R[i]*bi+
       Mesh.N1R[j]*bj+
       Mesh.N1R[k]*bk)/2/A+
       Mesh.Materials[mark].d11;
// *)
  D0_11:=D0_11+A*Ve;

  Ve:=Mesh.Materials[mark].d22*(Mesh.edN2dy[Elem]+1); (*

   Ve:=Mesh.Materials[mark].d22*
      (Mesh.N2R[i]*ci+
       Mesh.N2R[j]*cj+
       Mesh.N2R[k]*ck)/2/A+
       Mesh.Materials[mark].d22;
//*)
  D0_22:=D0_22+A*Ve;

  Mesh.Volume:=Mesh.Volume+A;
 end;

 D0_11:=D0_11/Mesh.Volume ;
 D0_22:=D0_22/Mesh.Volume ;
 //*)
 if abs(D0_22)>1e-15 then G1:=1/D0_22;
 if abs(D0_11)>1e-15 then G2:=1/D0_11;
 if Mesh.Psi<>nil then
 begin
 // подсчет тау
 tau:=0;
 M:=50; Ve:=0;
 {
 p.x:=0; p.y:=-0.5; h:=0.01;
 while p.y<0.5 do
 begin
  e:=InElement(p);
  if e<0 then begin p.y:=p.y+h;continue;end;
  Ve:=Ve+PPsi(p.x,p.y)*h;
  p.y:=p.y+h;
 end;
 (*}
 lRead.Caption:='Вычисление тау'; PB.Max:=Mesh.NumElements; PB.Position :=0;
 for Elem:=0 to Mesh.NumElements-1 do
 with Mesh.Elements[Elem] do
 begin
   PB.StepIt;
   Application.ProcessMessages;
  Ve:=Ve+PPsi(
   (Mesh.Points[i].X+Mesh.Points[j].X+Mesh.Points[k].X)/3,
   (Mesh.Points[i].Y+Mesh.Points[j].Y+Mesh.Points[k].Y)/3)*
   A;
 end;
  tau:=M/2/Ve;
 end;
 // *)
 if ParamCount=0 then
 begin
  Showdata;
 end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
 Image1.Canvas.FloodFill(0,0,clWhite,fsSurface);
 Zoom:= 100;
 ViewX:=0; ViewY:=0; Cut:=0.0;
 Image1.Canvas.Font.name:='sans serif';
 Image1.Canvas.Font.size:=6;
 setlength(mcolors,12);
 mcolors[0]:=clLtGray; mcolors[1]:=clblue;  mcolors[2]:=clGreen;
 mcolors[3]:=clYellow; mcolors[4]:=clPurple; mcolors[5]:=clTeal;
 mcolors[6]:=clGray; mcolors[7]:=clFuchsia; mcolors[8]:=clLime;
 mcolors[9]:=clNavy; mcolors[10]:=clOlive; mcolors[11]:=clMaroon;
end;


procedure TMainForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var NewX,NewY:double;
    T:string;
begin
// if MaxV=MinV then Exit;
// if ShowMin=ShowMax then Exit;
 if not MenuVertCut.Checked then
 begin
  NewX:=(x/Image1.Width)*(Maxx-Minx)+Minx;
 end else
 NewX:=(x/Image1.Width)*(Maxy-Miny)+Miny;

 NewY:=(-y/Image1.Height)*(ShowMin-ShowMax)+ShowMin;
 str(NewX:7:5,T); SB.Panels[3].text:='X:'+T;
 str(NewY:7:5,T); SB.Panels[4].text:='Y:'+T;
end;

function PreciseN2(x1:double):double;
begin
 if x1<-1/6 then result:=-1/4*(2*x1+1) else
 if x1<1/6 then result:=x1 else
    result:=-1/4*(2*x1-1);
end;

// Определение делений шкалы, кратной степени десяти, такой
// чтобы делений было в диапозоне 4..10 
procedure GetRoughMark(a,b:double;var base,h:double);
var MarkSize:integer;
begin
 MarkSize:=Floor(log10((b-a)/5));
// writeln('marksize:',marksize);
 h:=power(10,MarkSize);
 base:=trunc(a/h)*h;
end;

procedure TMainForm.ShowData;
var i:integer;
    x,y,x2,y2,e:integer;
//    s:string;
    Newx,newy:double;
    P1,P2:TMyPoint;
    v:array of double;
    c:array of integer;
    prevc,discr:integer;
//  bnd:array of TPoint;
    cl,pcl:TColor;
    flag:boolean;
    base,h:double;
    ZeroMarked:boolean;
    FlagVert : boolean;
begin
 Image1.Canvas.Brush.Color:=clWhite;
 Image1.Canvas.FillRect(Image1.ClientRect);
 ShowMin:=-1; ShowMax:=1;
 MinV:=0;MaxV:=0; ZeroMarked:=False;
{
 for i:=0 to Mesh.NumPoints-1 do
 begin
   X:=Round((Points[i].x-ViewX)*Zoom+Image1.Width/2);
   Y:=Round(-(Points[i].y-ViewY)*Zoom+Image1.Height/2);
   if i=NowPoint then Image1.Canvas.Brush.Color:=clRed;
   Image1.Canvas.Ellipse(X-2,y-2,x+2,y+2);
   Image1.Canvas.Brush.Color:=clWhite;
   if ShowPNum then
   begin
     s:=inttostr(i);
     Image1.Canvas.TextOut(x+2,y-6,s);
   end;
 end;
}
 if MenuShowPsi.checked or MenuShowN1.checked or MenuShowN2.checked or ShowSigma13.checked
 or ShowSigma23.checked then
 begin
  discr:=3;
  setlength(v,Image1.Width div discr+1);
  setlength(c,Image1.Width div discr+1);
  prevc:=-1; cl:=clBlue; pcl:=clRed;
  flag:=false;
  for x:=0 to Image1.Width div discr do
  begin
//   P1.X:=(x-Image1.Width/2)/Zoom+ViewX;
   if not MenuVertCut.Checked then
   begin
    P1.X:=minx+x*discr*(maxx-minx)/Image1.width;
    P1.Y:=cut;
   end else
   begin
    P1.X:=cut;
    P1.Y:=miny+x*discr*(maxy-miny)/Image1.width;
   end;
   e:=InElement(P1);
   c[x]:=e;
   if e<0 then continue;
   v[x]:=NowDraw(p1.x,p1.y);
//   if shown2 then
//   v[x]:=N_2(p1.x,p1.y);
//   V[x]:=V[x]
   if N10.Checked then V[x]:=V[x]-PreciseN2(P1.y);
   if psi2.checked then v[x]:=v[x]-precise_ppsi(p1.x,p1.y);
   if not flag then begin flag:=true; minV:=v[x]; maxV:=minV; end;
   maxV:=max(maxV,v[x]);
   minV:=min(minV,v[x]);
  // x:=round((v-minn2)/(maxn2-minn2)*image1.height);
//   if y=0 then Image1.Canvas.MoveTo(y*10,x) else Image1.Canvas.LineTo(y*10,x);
  end;

  Edit1.text:=FloatToStr(minV);
  if (not CheckBox1.checked) and (MenuShowN1.checked or MenuShowN2.checked) then
   begin
    if MenuShowN1.Checked then
     showmin:=Gminn1-(Gmaxn1-Gminn1)*0.1 else
    if MenuShowN2.checked then
     showmin:=Gminn2-(Gmaxn2-Gminn2)*0.1
   end else
   showmin:=minV-(maxV-minV)*0.1;

  Edit2.text:=FloatToStr(maxV);
  if (not CheckBox1.checked) and (MenuShowN1.checked or MenuShowN2.checked) then
   begin
    if MenuShowN1.checked then
     showmax:=Gmaxn1+(Gmaxn1-Gminn1)*0.1 else
    if MenuShowN2.checked then
     showmax:=Gmaxn2+(Gmaxn2-Gminn2)*0.1
   end else
   showmax:=maxV+(maxV-minV)*0.1;

  Edit3.text:=floattostr(cut);

  Image1.canvas.pen.color:=clBlack;

  // горизонтальная ось
  Image1.Canvas.Font.Handle:=CreateFont(12,0,3000,0,400,0,0,0,0,0,0,0,0,'Serif');
  if showmin*showmax<0 then
  begin
   y:=round((0-showmin)/(showmax-showmin)*image1.height);
   image1.canvas.MoveTo(0,y);
   image1.canvas.LineTo(image1.width,y);
   if MenuVertCut.Checked then
   begin
    GetRoughMark(miny,maxy,base,h);
    newx:=base;
    while newx<maxy do
    begin
     x:=round((newx-miny)/(maxy-miny)*image1.width);
     image1.canvas.MoveTo(x,y-3);
     image1.canvas.LineTo(x,y+3);
     if abs(newx)<h/100 then begin newx:=0; ZeroMarked:=true; end;
     Image1.canvas.textout(x,y+4,Format('%4.2e',[newx]));
//     Image1.Canvas.Font.
     newx:=newx+h;
    end;
   end else
   begin
    GetRoughMark(minx,maxx,base,h);
    newx:=base;
    while newx<maxx do
    begin
     x:=round((newx-minx)/(maxx-minx)*image1.width);
     image1.canvas.MoveTo(x,y-3);
     image1.canvas.LineTo(x,y+3);
     if abs(newx)<h/100 then begin newx:=0; ZeroMarked:=true; end;
     Image1.canvas.textout(x,y+4,Format('%4.2e',[newx]));
     newx:=newx+h;
    end;
   end;
  end;

  // вертикальная ось
  Image1.Canvas.Font.Handle:=CreateFont(12,0,0,0,400,0,0,0,0,0,0,0,0,'Serif');
  FlagVert := False;
  
  if (minx*maxx<0) and  not MenuVertCut.Checked then FlagVert:=True;
  if (minY*maxY<0) and  MenuVertCut.Checked then FlagVert:=True;

  if FlagVert then
  begin
   if not MenuVertCut.Checked then
    x:=round((0-minx)/(maxx-minx)*image1.width) else
    x:=round((0-miny)/(maxy-miny)*image1.width);
   image1.canvas.MoveTo(x,0);
   image1.canvas.LineTo(x,image1.height);
   GetRoughMark(showmin,showmax,base,h);
   newy:=base;
   while newy<showmax do
   begin
    y:=round((newy-showmin)/(showmax-showmin)*image1.height);
    image1.canvas.MoveTo(x-3,y);
    image1.canvas.LineTo(x+3,y);
    if abs(newy)<h/100 then begin newy:=0; if ZeroMarked then begin newy:=newy+h; continue;  end;end;

    Image1.canvas.textout(x+3,y,Format('%4.2e',[newy]));
    newy:=newy+h;
   end;
  end;

  Image1.Canvas.Pen.color:=cl;
  for x:=0 to Image1.Width div discr do
  begin
{
   P1.X:=cutx;
   P1.Y:=miny+y*10*(maxy-miny)/Image1.width;
   e:=InElement(P1);
   with Mesh.Elements[e] do
   begin
    v:=Mesh.N2R[i]*(ai+bi*P1.x+ci*P1.y)+
       Mesh.N2R[j]*(aj+bj*P1.x+cj*P1.y)+
       Mesh.N2R[k]*(ak+bk*P1.x+ck*P1.y);
   end;
   }
   y:=round((v[x]-showmin)/(showmax-showmin)*image1.height);

   if prevc<>c[x] then
   begin
    cl:=Image1.Canvas.Pen.color;
    Image1.Canvas.Pen.color:=pcl;
    pcl:=cl;
   end;
   prevc:=c[x];
   if x=0 then Image1.Canvas.MoveTo(x*discr,y) else Image1.Canvas.LineTo(x*discr,y);
  end;

  exit;
 end;

 Image1.Refresh;
 Image1.Canvas.Pen.Color:=clBlack;
 Image1.canvas.brush.color:=clred;

 for i:=0 to Mesh.NumSides-1 do
 begin
//   Image1.update;
   P1:=Mesh.Points[Mesh.Sides[i].N1];
   P2:=Mesh.Points[Mesh.Sides[i].N2];
   X:=Round((P1.x-ViewX)*Zoom+Image1.Width/2);
   Y:=Round(-(P1.y-ViewY)*Zoom+Image1.Height/2);
   X2:=Round((P2.x-ViewX)*Zoom+Image1.Width/2);
   Y2:=Round(-(P2.y-ViewY)*Zoom+Image1.Height/2);

   Image1.Canvas.MoveTo(x,y);
   Image1.Canvas.LineTo(x2,y2);
 end;
   if shownorm then
   for i:=0 to Mesh.NumSides-1 do
   if Mesh.Sides[i].mark=2 then
   begin
    X:=Round((Mesh.Elements[Mesh.Sides[i].eb].mx-ViewX)*Zoom+Image1.Width/2);
    Y:=Round(-(Mesh.Elements[Mesh.Sides[i].eb].my-ViewY)*Zoom+Image1.Height/2);
    if x<0 then continue;
    if x>image1.width then continue;
    if y<0 then continue;
    if y>image1.height then continue;
    Image1.Canvas.FloodFill(x,y,clWhite,fsSurface);
   end;


 if ShowMat then
 begin
  for i:=0 to Mesh.NumElements-1 do
  begin
   X:=Round((Mesh.Elements[i].mx-ViewX)*Zoom+Image1.Width/2);
   Y:=Round(-(Mesh.Elements[i].my-ViewY)*Zoom+Image1.Height/2);
   if x<0 then continue;
   if x>image1.width then continue;
   if y<0 then continue;
   if y>image1.height then continue;
   Image1.Canvas.Brush.color:=mcolors[Mesh.Elements[i].mark mod 12];
   Image1.Canvas.FloodFill(x,y,clWhite,fsSurface);
  end;
 end;
end;

procedure TMainForm.ZoomInClick(Sender: TObject);
begin
 Zoom:=Zoom*1.2;
 ShowData;
end;

procedure TMainForm.ZoomOutClick(Sender: TObject);
begin
 Zoom:=Zoom/1.2;
 ShowData;
end;

procedure TMainForm.ToLeftClick(Sender: TObject);
begin
 ViewX:=ViewX+100/Zoom;
 ShowData;
end;

procedure TMainForm.ToRightClick(Sender: TObject);
begin
 ViewX:=ViewX-100/Zoom;
 ShowData;
end;

procedure TMainForm.ToUpClick(Sender: TObject);
begin
 ViewY:=ViewY-100/Zoom;
 ShowData;
end;

procedure TMainForm.ToDownClick(Sender: TObject);
begin
 ViewY:=ViewY+100/Zoom;
 ShowData;
end;


procedure TMainForm.MenuShowMatClick(Sender: TObject);
begin
 ShowMat:=not ShowMat;
 MenuShowMat.checked:=ShowMat;
 ShowN1:=false; MenuShowN1.checked:=false;
 ShowN2:=false; MenuShowN2.Checked:=false;
 ShowData;
end;

procedure TMainForm.MenuShowNormClick(Sender: TObject);
begin
 ShowN1:=false; MenuShowN1.checked:=false;
 ShowN2:=false; MenuShowN2.Checked:=false;
 ShowNorm:=not ShowNorm;
 MenuShowNorm.checked:=ShowNorm;
 showdata;
end;

procedure TMainForm.MenuShowN1Click(Sender: TObject);
begin
 NowDraw:=N_1;
 ShowNorm:=false;
 MenuShowMat.Checked:=false;
 ShowMat:=false;
 MenuShowNorm.Checked:=false;
// ShowN2:=false;
 MenuShowN2.Checked:=false;
// ShowN1:=true;
 MenuShowN1.checked:=true;
 ShowData;
end;

procedure TMainForm.MenuShowN2Click(Sender: TObject);
begin
 NowDraw:=N_2;
 ShowNorm:=false;
 MenuShowNorm.Checked:=false;
 ShowMat:=false;
 MenuShowMat.Checked:=false;
// ShowN2:=true;
 MenuShowN2.Checked:=true;
// ShowN1:=false;
 MenuShowN1.checked:=false;
 ShowData;
end;
(*
//
// Площадь треугольника (na,nb,nc) через векторное произведение, со знаком
double area(struct nod *na, struct nod *nb, struct nod *nc)
{
 return 0.5 * (   ((*nb).x-(*na).x)*((*nc).y-(*na).y)
                - ((*nb).y-(*na).y)*((*nc).x-(*na).x));
}
//
// Поиск элемента, которому может принадлежать узел (внутри треугольника)
int in_elem(struct nod *n)
{
 int e;

 for(e=0; e<Ne; e++)    /* This must search through all elements ?? */
  {
   if(    area(n, &node[elem[e].i], &node[elem[e].j]) >= 0.0
       && area(n, &node[elem[e].j], &node[elem[e].k]) >= 0.0
       && area(n, &node[elem[e].k], &node[elem[e].i]) >= 0.0 )

   break;
  }
 return e;
}
*)


function TMainForm.area(na,nb,nc:TMyPoint): double;
begin
 Result:=0.5* ((nb.x-na.x)*(nc.y-na.y)-(nb.y-na.y)*(nc.x-na.x));
end;

function TMainForm.InElement(n:TMyPoint): integer;
var e:integer;
begin
 result:=-1;
 for e:=0 to  Mesh.NumElements-1 do
 begin
   if  (area(n,
             Mesh.points[Mesh.Elements[e].i],
             Mesh.points[Mesh.Elements[e].j]) >= 0.0) and
       (area(n,
             Mesh.points[Mesh.Elements[e].j],
             Mesh.points[Mesh.Elements[e].k]) >= 0.0) and
      (area(n,
             Mesh.points[Mesh.Elements[e].k],
             Mesh.points[Mesh.Elements[e].i]) >= 0.0) 
   then begin result:=e;exit; end;
 end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
 Cut:=Cut+0.01;
 ShowData;
 Image1.Refresh;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
 Cut:=Cut-0.01;
 ShowData;
 Image1.Refresh;
end;

procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
 ShowData;
end;

procedure TMainForm.MenuVertCutClick(Sender: TObject);
begin
 MenuVertCut.checked:=not MenuVertCut.Checked;
 showdata;
end;

procedure TMainForm.EPS1Click(Sender: TObject);
var //i:integer;
    x,y{,x2,y2},e:integer;
//    s:string;
    Newx,newy:double;
    P1{,P2}:TMyPoint;
    v:array of double;
//    c:array of integer;
    {prevc,}discr:integer;
//  bnd:array of TPoint;
//    cl,pcl:TColor;
    flag:boolean;
    minV,maxV{,PN2}:double;
    showmin,showmax:double;
    base,h:double;
    ZeroMarked:boolean;
    fname:string;
    f:textfile;
begin
 ShowMin:=-1; ShowMax:=1;
 MinV:=0;MaxV:=0; ZeroMarked:=False;
 SaveDialog1.FileName:=Format('%4.3f.eps',[cut]);
 if not SaveDialog1.Execute then exit;
 Fname:=SaveDialog1.FileName;
 assignfile(f,fname); rewrite(f);
 writeln(f,'%!');
 writeln(f,'%%Creator: - Created by Postprocessor');
 writeln(f,'%%Title: ',fname);
 writeln(f,'%%Pages: 1');
 writeln(f,'%%BoundingBox: 0 0 ',image1.width,' ',image1.height);
 writeln(f,'%%EndComments');
 writeln(f,'/m {moveto} def');
 writeln(f,'/l {lineto} def');
 writeln(f,'/s {stroke} def');
 writeln(f,'/n {newpath} def');
 writeln(f,'/Times-Italic findfont 16 scalefont setfont');

 if MenuShowPsi.checked or MenuShowN1.checked or MenuShowN2.checked or ShowSigma13.checked
 or ShowSigma23.checked then
 begin
  discr:=3;
  setlength(v,Image1.Width div discr+1);
//  setlength(c,Image1.Width div discr+1);
//  prevc:=-1; cl:=clBlue; pcl:=clRed;
  flag:=false;
  for x:=0 to Image1.Width div discr do
  begin
//   P1.X:=(x-Image1.Width/2)/Zoom+ViewX;
   if not MenuVertCut.Checked then
   begin
    P1.X:=minx+x*discr*(maxx-minx)/Image1.width;
    P1.Y:=cut;
   end else
   begin
    P1.X:=cut;
    P1.Y:=miny+x*discr*(maxy-miny)/Image1.width;
   end;
   e:=InElement(P1);
  // c[x]:=e;
   if e<0 then continue;
   v[x]:=NowDraw(p1.x,p1.y);
//   if shown2 then
//   v[x]:=N_2(p1.x,p1.y);
//   V[x]:=V[x]
   if N10.Checked then V[x]:=V[x]-PreciseN2(P1.y);
   if psi2.checked then v[x]:=v[x]-precise_ppsi(p1.x,p1.y); 
   if not flag then begin flag:=true; minV:=v[x]; maxV:=minV; end;
   maxV:=max(maxV,v[x]);
   minV:=min(minV,v[x]);
  // x:=round((v-minn2)/(maxn2-minn2)*image1.height);
//   if y=0 then Image1.Canvas.MoveTo(y*10,x) else Image1.Canvas.LineTo(y*10,x);
  end;

  Edit1.text:=FloatToStr(minV);
  if (not CheckBox1.checked) and (MenuShowN1.checked or MenuShowN2.checked) then
   begin
    if MenuShowN1.Checked then
     showmin:=Gminn1-(Gmaxn1-Gminn1)*0.1 else
    if MenuShowN2.checked then
     showmin:=Gminn2-(Gmaxn2-Gminn2)*0.1
   end else
   showmin:=minV-(maxV-minV)*0.1;

  Edit2.text:=FloatToStr(maxV);
  if (not CheckBox1.checked) and (MenuShowN1.checked or MenuShowN2.checked) then
   begin
    if MenuShowN1.checked then
     showmax:=Gmaxn1+(Gmaxn1-Gminn1)*0.1 else
    if MenuShowN2.checked then
     showmax:=Gmaxn2+(Gmaxn2-Gminn2)*0.1
   end else
   showmax:=maxV+(maxV-minV)*0.1;

  Edit3.text:=floattostr(cut);

//  Image1.canvas.pen.color:=clBlack;

  // горизонтальная ось
  if showmin*showmax<0 then
  begin
   y:=round((0-showmin)/(showmax-showmin)*image1.height);
   writeln(f,0,' ',y,' m');   //   image1.canvas.MoveTo(0,y);
   writeln(f,image1.width,' ',y,' l'); // image1.canvas.LineTo(image1.width,y);
   if MenuVertCut.Checked then
   begin
    GetRoughMark(miny,maxy,base,h);
    newx:=base;
    while newx<maxy do
    begin
     x:=round((newx-miny)/(maxy-miny)*image1.width);
     writeln(f,x,' ',y-3,' m');   // image1.canvas.MoveTo(x,y-3);
     writeln(f,x,' ',y+3,' l'); //  image1.canvas.LineTo(x,y+3);
     if abs(newx)<h/100 then begin newx:=0; ZeroMarked:=true; end;
     writeln(f,x,' ',y+4,' m');
     writeln(f,'(',Format('%4.2e',[newx]),') show');
     newx:=newx+h;
    end;
   end else
   begin
    GetRoughMark(minx,maxx,base,h);
    newx:=base;
    while newx<maxx do
    begin
     x:=round((newx-minx)/(maxx-minx)*image1.width);
     writeln(f,x,' ',y-3,' m');//image1.canvas.MoveTo(x,y-3);
     writeln(f,x,' ',y+3,' l');//image1.canvas.LineTo(x,y+3);
     if abs(newx)<h/100 then begin newx:=0; ZeroMarked:=true; end;
     writeln(f,x,' ',y+4,' m');
     writeln(f,'(',Format('%4.2e',[newx]),') show');
//     Image1.canvas.textout(x,y+4,floattostr(newx));
     newx:=newx+h;
    end;
   end;
  end;

  // вертикальная ось
  if minx*maxx<0 then
  begin
   x:=round((0-minx)/(maxx-minx)*image1.width);
  // image1.canvas.MoveTo(x,0);
  writeln(f,x,' 0 m');
  // image1.canvas.LineTo(x,image1.height);
  writeln(f,x,' ',image1.height,' l');
   GetRoughMark(showmin,showmax,base,h);
   newy:=base;
   while newy<showmax do
   begin
    y:=round((newy-showmin)/(showmax-showmin)*image1.height);
    writeln(f,x-3,' ',y,' m');//    image1.canvas.MoveTo(x-3,y);
    writeln(f,x+3,' ',y,' l');//    image1.canvas.LineTo(x+3,y);
    if abs(newy)<h/100 then begin newy:=0; if ZeroMarked then begin newy:=newy+h; continue;  end;end;
     writeln(f,x+3,' ',y,' m');
     writeln(f,'(',Format('%4.2e',[newy]),') show');
//    Image1.canvas.textout(x+3,y,floattostr(newy));
    newy:=newy+h;
   end;
  end;

//  Image1.Canvas.Pen.color:=cl;
  for x:=0 to Image1.Width div discr do
  begin
{
   P1.X:=cutx;
   P1.Y:=miny+y*10*(maxy-miny)/Image1.width;
   e:=InElement(P1);
   with Mesh.Elements[e] do
   begin
    v:=Mesh.N2R[i]*(ai+bi*P1.x+ci*P1.y)+
       Mesh.N2R[j]*(aj+bj*P1.x+cj*P1.y)+
       Mesh.N2R[k]*(ak+bk*P1.x+ck*P1.y);
   end;
   }
   y:=round((v[x]-showmin)/(showmax-showmin)*image1.height);

   if x=0 then
   writeln(f,x*discr,' ',y,' m') else
   writeln(f,x*discr,' ',y,' l');
  end;
  writeln(f,'s');
  writeln(f,'showpage');
  closefile(f);
  exit;
 end;

 (*
 Image1.Refresh;
 Image1.Canvas.Pen.Color:=clBlack;
 Image1.canvas.brush.color:=clred;

 for i:=0 to Mesh.NumSides-1 do
 begin
//   Image1.update;
   P1:=Mesh.Points[Mesh.Sides[i].N1];
   P2:=Mesh.Points[Mesh.Sides[i].N2];
   X:=Round((P1.x-ViewX)*Zoom+Image1.Width/2);
   Y:=Round(-(P1.y-ViewY)*Zoom+Image1.Height/2);
   X2:=Round((P2.x-ViewX)*Zoom+Image1.Width/2);
   Y2:=Round(-(P2.y-ViewY)*Zoom+Image1.Height/2);

   Image1.Canvas.MoveTo(x,y);
   Image1.Canvas.LineTo(x2,y2);
 end;
   if shownorm then
   for i:=0 to Mesh.NumSides-1 do
   if Mesh.Sides[i].mark=2 then
   begin
    X:=Round((Mesh.Elements[Mesh.Sides[i].eb].mx-ViewX)*Zoom+Image1.Width/2);
    Y:=Round(-(Mesh.Elements[Mesh.Sides[i].eb].my-ViewY)*Zoom+Image1.Height/2);
    if x<0 then continue;
    if x>image1.width then continue;
    if y<0 then continue;
    if y>image1.height then continue;
    Image1.Canvas.FloodFill(x,y,clWhite,fsSurface);
   end;


 if ShowMat then
 begin
  for i:=0 to Mesh.NumElements-1 do
  begin
   X:=Round((Mesh.Elements[i].mx-ViewX)*Zoom+Image1.Width/2);
   Y:=Round(-(Mesh.Elements[i].my-ViewY)*Zoom+Image1.Height/2);
   if x<0 then continue;
   if x>image1.width then continue;
   if y<0 then continue;
   if y>image1.height then continue;
   Image1.Canvas.Brush.color:=mcolors[Mesh.Elements[i].mark mod 12];
   Image1.Canvas.FloodFill(x,y,clWhite,fsSurface);
  end;
 end;
end;

   *)
 closefile(f);
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
 N10.Checked:=not N10.Checked;
 showdata;
end;

procedure TMainForm.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 begin
  cut:=strtofloat(edit3.text);
  showdata;
 end;
end;

function TMainForm.PPsi(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
//   result:=CPsi_0(x,y)+cdpsi_0dx(x,y)*N_1(x,y)+cdpsi_0dy(x,y)*N_2(x,y);
// result:=PPsi_0(x,y)+pdpsi_0dx(x,y)*N_1(x,y)+pdpsi_0dy(x,y)*N_2(x,y);
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=(
     Mesh.Psi[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Psi[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Psi[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;

end;

//function TMainForm.CPsi(x, y: double): double;
//begin
 //result:=CPsi_0(x,y)+cdpsi_0dx(x,y)*N_1(x,y)+cdpsi_0dy(x,y)*N_2(x,y);
// Result:=0;
//end;

function TMainForm.N_1(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=(
     Mesh.N1R[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.N1R[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.N1R[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

function TMainForm.N_2(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=(
     Mesh.N2R[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.N2R[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.N2R[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

procedure TMainForm.MenuShowPsiClick(Sender: TObject);
begin
 MenuShowPsi.checked:=not MenuShowPsi.checked;
 NowDraw:=PPsi;
 ShowData;
end;

procedure TMainForm.Psi2Click(Sender: TObject);
begin
 Psi2.checked:=not psi2.checked;
 showdata;
end;


procedure TMainForm.Batch1Click(Sender: TObject);
begin
{
 cut:=2/3;
 while cut>=-2/3-0.01 do
 begin
  ShowData;
  Eps1Click(sender);
  cut:=cut-1/6;
 end;
 }
 cut:=0;
 while cut<=2 do
 begin
  ShowData;
  MP1Click(sender);
  cut:=cut+1/6;
 end;
end;

function TMainForm.dPsidx(x, y: double): double;
begin
//   result:=0;
//  psi:=   CPsi_0(x,y)+cdpsi_0dx(x,y)*   N_1(x,y)+cdpsi_0dy(x,y)*   N_2(x,y);
//  psi:=   PPsi_0(x,y)+pdpsi_0dx(x,y)*   N_1(x,y)+pdpsi_0dy(x,y)*   N_2(x,y);
{
 result:=cdpsi_0dx(x,y)+cdpsi_0dx(x,y)*dN_1dx(x,y)+cdpsi_0dy(x,y)*dN_2dx(x,y)
         +N_1   ;
}
   {
   result:=pdpsi_0dx(x,y)+pdpsi_0dx(x,y)*dN_1dx(x,y)+pdpsi_0dy(x,y)*dN_2dx(x,y)
   +N_1(x,y)*pdpsi0_dx2(x,y)
   +N_2(x,y)*pdpsi0_dx(x,y)
   ;
    }

// для круга
   result:=cdpsi_0dx(x,y)+
   N_1(x,y)*cd2psi_0dx2(x,y) +dN_1dx(x,y)*cdpsi_0dx(x,y)+
   N_2(x,y)*cd2psi_0dxdy(x,y)+dN_2dx(x,y)*cdpsi_0dy(x,y);
end;

function TMainForm.dPsidy(x, y: double): double;
begin
// result:=0;
//  psi:=   CPsi_0(x,y)+cdpsi_0dx(x,y)*   N_1(x,y)+cdpsi_0dy(x,y)*   N_2(x,y);
// result:=cdpsi_0dy(x,y)+cdpsi_0dx(x,y)*dN_1dy(x,y)+cdpsi_0dy(x,y)*dN_2dy(x,y);
{
   result:=pdpsi_0dy(x,y)+pdpsi_0dx(x,y)*dN_1dy(x,y)+pdpsi_0dy(x,y)*dN_2dy(x,y)
   +N_2(x,y)*(-2/D0_22);
   ;
}

// для круга
   result:=cdpsi_0dy(x,y)+
   N_1(x,y)*cd2psi_0dxdy(x,y)+dN_1dy(x,y)*cdpsi_0dx(x,y)+
   N_2(x,y)*cd2psi_0dy2 (x,y)+dN_2dy(x,y)*cdpsi_0dy(x,y);
end;

function TMainForm.dN_1dx(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 {
 Result:=(
     Mesh.dN1dx[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.dN1dx[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.dN1dx[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
 }
 result:=(
     Mesh.N1R[Mesh.Elements[e].i]*(Mesh.Elements[e].bi)+
     Mesh.N1R[Mesh.Elements[e].j]*(Mesh.Elements[e].bj)+
     Mesh.N1R[Mesh.Elements[e].k]*(Mesh.Elements[e].bk)
    )/Mesh.Elements[e].A/2;
end;

function TMainForm.dN_1dy(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;
{
 Result:=(
     Mesh.dN1dy[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.dN1dy[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.dN1dy[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
 }
 result:=(
     Mesh.N1R[Mesh.Elements[e].i]*(Mesh.Elements[e].ci)+
     Mesh.N1R[Mesh.Elements[e].j]*(Mesh.Elements[e].cj)+
     Mesh.N1R[Mesh.Elements[e].k]*(Mesh.Elements[e].ck)
    )/Mesh.Elements[e].A/2;

end;

function TMainForm.dN_2dx(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;
{
 Result:=(
     Mesh.dN2dx[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.dN2dx[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.dN2dx[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
 }
 result:=(
     Mesh.N2R[Mesh.Elements[e].i]*(Mesh.Elements[e].bi)+
     Mesh.N2R[Mesh.Elements[e].j]*(Mesh.Elements[e].bj)+
     Mesh.N2R[Mesh.Elements[e].k]*(Mesh.Elements[e].bk)
    )/Mesh.Elements[e].A/2;

end;

function TMainForm.dN_2dy(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;
{
 Result:=(
     Mesh.dN2dy[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.dN2dy[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.dN2dy[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
 }
 result:=(
     Mesh.N2R[Mesh.Elements[e].i]*(Mesh.Elements[e].ci)+
     Mesh.N2R[Mesh.Elements[e].j]*(Mesh.Elements[e].cj)+
     Mesh.N2R[Mesh.Elements[e].k]*(Mesh.Elements[e].ck)
    )/Mesh.Elements[e].A/2;

end;


function TMainForm.eps_13(x, y: double): double;
begin
result:=sigma_13(x,y)/2/G1;
end;

function TMainForm.eps_23(x, y: double): double;
begin
result:=sigma_23(x,y)/2/G2;
end;

procedure TMainForm.ShowSigma13Click(Sender: TObject);
begin
 ShowSigma13.Checked:=not ShowSigma13.Checked;
 NowDraw:=sigma_13;
 showdata;
end;


procedure TMainForm.ShowSigma23Click(Sender: TObject);
begin
 ShowSigma23.Checked:=not ShowSigma23.Checked;
 NowDraw:=sigma_23;
 Showdata;
end;

procedure TMainForm.N8Click(Sender: TObject);
var D_ast : array[1..2,1..2] of Double;
    e     : Integer;
    i,j   : Integer;
    Int   : Double;
    D11, D12, D21, D22 : Double;
    s:string;
    f: textFile;
begin
 for i:=1 to 2 do for j:=1 to 2 do D_ast[i,j]:=0;
 for e:=0 to Mesh.NumElements-1 do
 begin
  D11:=Mesh.materials[Mesh.Elements[e].mark].d11;
  D12:=Mesh.materials[Mesh.Elements[e].mark].d12;
  D21:=Mesh.materials[Mesh.Elements[e].mark].d21;
  D22:=Mesh.materials[Mesh.Elements[e].mark].d22;
  
  {D*_I1_I2+= D1_I1*dN_I1dx+D2_I2*dN_I1dy+DI1I2}
  {I1=1, I2=1}
  Int:=D11*Mesh.edN1dx[e]+D21*Mesh.edN1dy[e]+D11;
  D_ast[1,1]:=D_ast[1,1]+Int*Mesh.Elements[e].A;
  {I1=1, I2=2}
  Int:=D12*Mesh.edN1dx[e]+D22*Mesh.edN1dy[e]+D12;
  D_ast[1,2]:=D_ast[1,2]+Int*Mesh.Elements[e].A;
  {I1=2, I2=1}
  Int:=D11*Mesh.edN2dx[e]+D21*Mesh.edN2dy[e]+D21;
  D_ast[2,1]:=D_ast[2,1]+Int*Mesh.Elements[e].A;
  {I1=2, I2=2}
  Int:=D12*Mesh.edN2dx[e]+D22*Mesh.edN2dy[e]+D22;
  D_ast[2,2]:=D_ast[2,2]+Int*Mesh.Elements[e].A;
 end;

 for i:=1 to 2 do for j:=1 to 2 do D_ast[i,j]:=D_ast[i,j]/Mesh.Volume;
// s:=FloatToStr(D_ast[1,1]);
s:=Format('%10.8f %10.8f'^M^J'%10.8f %10.8f',[
   D_ast[1,1],
   D_ast[1,2],
   D_ast[2,1],
   D_ast[2,2]]);

 assignfile(f,OpenDialog1.FileName+'.eff');
 rewrite(f);
 writeln(f,s);
 closefile(f);
// ShowMessage(s);

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 if ParamCount>=1 then
 begin
  OpenDialog1.FileName := ParamStr(1);
  N2.Click;
  N8.Click;
  Close;
 end;
end;

procedure TMainForm.MP1Click(Sender: TObject);
var F:TextFile;
    t,h: double;
    P: TMyPoint;
begin
 SDMP.FileName:=Format('%4.3f.dat',[cut]);
 if not SDMP.Execute then exit;
 AssignFile(F,SDMP.FileName);
 Rewrite(F);
 if not MenuVertCut.Checked then
 begin // Вертикальный разрез
   t:=minx;
   h:=(maxx-minx)/100;
   while t<maxx do
   begin
    P.X:=t;
    P.Y:=cut;
    if InElement(P) >0 then
    writeln(F,Format('%8.6f %8.6f',[t,NowDraw(p.x,p.y)]));
    t:=t+h;
   end;
 end else
 begin // Горизонтальный разрез
   t:=miny;
   h:=(maxy-miny)/100;
   while t<maxy do
   begin
    P.X:=cut;
    P.Y:=t;
    if InElement(P) >0 then
    writeln(F,Format('%8.6f %8.6f',[t,NowDraw(p.x,p.y)]));
    t:=t+h;
   end;
 end;
 writeln(f);
 CloseFile(F);
end;

procedure TMainForm.Image1Click(Sender: TObject);
begin
 ActiveControl:=nil;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
 Image1.Picture.Bitmap.Width:=Image1.Width;
 Image1.Picture.Bitmap.Height:=Image1.Height;
end;

function TMainForm.Sigma_13(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=(
     Mesh.Sigma13[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Sigma13[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Sigma13[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

function TMainForm.Sigma_23(x, y: double): double;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=(
     Mesh.Sigma23[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Sigma23[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Sigma23[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;


end.
