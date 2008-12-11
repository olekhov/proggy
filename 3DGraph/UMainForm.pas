unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons,math, UGeometry, UClusterSearch;

type

//  PDrawFunc =  ^TDrawFunc;
  TDrawFunc = function (x,y:extended):extended of object;

  TMyPoint = record
    X,Y: extended;
    mark:integer;
    F:extended;
  end;

  TSide = record
    N1,N2:integer;
    ea,eb:integer;
    nx,ny:extended;
    mark:integer;
  end;

  TMark = record
    X,Y: extended;
    M:integer;
  end;

  TMaterial=record
    d11,d12,d21,d22:extended;
    delta:extended;
  end;

  TElement=record
   i,j,k : integer;
   si,sj,sk : integer;
   mark : integer;
   ei,ej,ek :integer;
   ai,aj,ak,bi,bj,bk,ci,cj,ck,A:extended;
   mx,my:extended;
  end;

  TScenePoint=record
   p: TVector;
//   dist : extended;
   color: TColor;
  end;

  TSceneTriangle = record
    v1,v2,v3: TScenePoint;
    Norm : TVector;
    color:TColor;
  end;
  
  TScreenPoint=record
    x,y:integer;
    dist:extended;
    valid:boolean;
  end;
  
  TScreenTriangle = record
    x1,y1,
    x2,y2,
    x3,y3: integer;
    dist: extended;
    valid:boolean;
    color:TColor;
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
    MenuShowN1: TMenuItem;
    MenuShowN2: TMenuItem;
    EPS1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Batch1: TMenuItem;
    MenuShowcube: TMenuItem;
    CamDown: TBitBtn;
    CamUp: TBitBtn;
    Label1: TLabel;
    edX: TEdit;
    edY: TEdit;
    Label2: TLabel;
    edZ: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edVX: TEdit;
    edVY: TEdit;
    Label5: TLabel;
    edVZ: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edUX: TEdit;
    edUY: TEdit;
    Label8: TLabel;
    edUZ: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edRX: TEdit;
    edRY: TEdit;
    Label11: TLabel;
    edRZ: TEdit;
    Label12: TLabel;
    CamLeft: TBitBtn;
    CamRight: TBitBtn;
    RoundLeft: TBitBtn;
    RoundRight: TBitBtn;
    Lift: TBitBtn;
    Sink: TBitBtn;
    pbar: TProgressBar;
    lpbar: TLabel;
    BMP1: TMenuItem;
    DAT1: TMenuItem;
    MenuShowPsi0: TMenuItem;
    MenuShowPsi: TMenuItem;
    MenuShowDiffPsi: TMenuItem;
    MenuShowSigma13: TMenuItem;
    MenuShowSigma23: TMenuItem;
    batch2: TMenuItem;
    mult1: TMenuItem;
    CheckBox1: TCheckBox;
    edAxisLength: TEdit;
    N21: TMenuItem;
    A1: TMenuItem;
    B1: TMenuItem;
    C1: TMenuItem;
    D1: TMenuItem;
    SceneInfo1: TMenuItem;
    cbLightning: TCheckBox;
    mLog: TMemo;
    procedure N4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowData;
    procedure FillUpData;
    procedure MakeCube;
    procedure ZoomOutClick(Sender: TObject);
    procedure ToLeftClick(Sender: TObject);
    procedure ToRightClick(Sender: TObject);
    procedure ToUpClick(Sender: TObject);
    procedure ToDownClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure MenuShowN1Click(Sender: TObject);
    procedure MenuShowN2Click(Sender: TObject);
    procedure EPS1Click(Sender: TObject);
    procedure MenuShowPsiClick(Sender: TObject);
    procedure Psi2Click(Sender: TObject);
    procedure ShowA1Click(Sender: TObject);
    procedure ShowA2Click(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure MenuShowcubeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CamDownClick(Sender: TObject);
    procedure CamUpClick(Sender: TObject);
    procedure CamLeftClick(Sender: TObject);
    procedure CamRightClick(Sender: TObject);
    procedure RoundLeftClick(Sender: TObject);
    procedure RoundRightClick(Sender: TObject);
    procedure LiftClick(Sender: TObject);
    procedure SinkClick(Sender: TObject);
    procedure BMP1Click(Sender: TObject);
    procedure DAT1Click(Sender: TObject);
    procedure MenuShowPsi0Click(Sender: TObject);
    procedure MenuShowDiffPsiClick(Sender: TObject);
    procedure MenuShowSigma13Click(Sender: TObject);
    procedure MenuShowSigma23Click(Sender: TObject);
    procedure mult1Click(Sender: TObject);
    procedure edAxisLengthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N21Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure SceneInfo1Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure cbLightningClick(Sender: TObject);
  private
    Clusters : TClusters;
    mcolors:array of Tcolor;
    { Private declarations }
    Domain : record
     Points   : array of TMyPoint;
     Sides    : array of TSide;
     NumPoints,
     NumSides: integer;
    end;
    Mesh,Mesh2 : record
     Points : array of TMyPoint;
     Sides  : array of TSide;
     Elements : array of TElement;
     NumPoints,
     NumSides,
     NumElements: integer;
     N1R,N2R: array of extended;
     Sigma13,Sigma23: array of extended;
     DiffPsi,Psi,Psi0: array of extended;
     dN1dx,dN1dy: array of extended;
     dN2dx,dN2dy: array of extended;
     cell :array of extended;
     materials:array of TMaterial;
     nummaterials:integer;
    end;

    LightSource : TVector;
    Alpha,Betta : Extended;

    ViewPoint: TVector;
    ViewDir: TVector;
    ViewUp,ViewRight:TVector;
    Basis:TMatrix;
    MidX,MidY : extended;
    phi:extended;
    Scale:Extended;
    fscale:extended;
    RotMat1,RotMat2 : TMatrix;
    Scene: array of TSceneTriangle;

    MinX,MinY,MaxX,MaxY : extended;
    D0_11,D0_22 :extended;
    ShowN1,
    ShowN2   :boolean;
    Gmaxn1,Gmaxn2,Gminn1,Gminn2:extended;
    M,tau:extended;
    NowDraw: TDrawFunc;
    NowDrawMin,
    NowDrawMax : extended;
    function N_1(x,y:extended):extended;
    function N_2(x,y:extended):extended;
    function N_1_p(x,y:extended):extended;
    function N_2_p(x,y:extended):extended;

    function diffA(x,y:extended):extended;
    function diffB(x,y:extended):extended;
    function diffC(x,y:extended):extended;
    function diffD(x,y:extended):extended;

    function Psi0(x,y:extended):extended;
    function DiffPsi(x,y:extended):extended;
    function Psi(x,y:extended):extended;
    function Sigma13(x,y:extended):extended;
    function Sigma23(x,y:extended):extended;
    function dN_1dx(x,y:extended):extended;
    function dN_1dy(x,y:extended):extended;
    function dN_2dx(x,y:extended):extended;
    function dN_2dy(x,y:extended):extended;
    function sigma_13(x,y:extended):extended;
    function sigma_23(x,y:extended):extended;
    function eps_13(x,y:extended):extended;
    function eps_23(x,y:extended):extended;
    function InElement(n:TMyPoint):integer;
    function InElement2(n:TMyPoint):integer;
    function area(na,nb,nc:TMyPoint):extended; overload;
    function area(na,nb,nc:TScenePoint):extended; overload;
    function PPsi(x,y:extended):extended;
    function dPsidx(x,y:extended):extended;
    function dPsidy(x,y:extended):extended;
    function CPsi(x,y:extended):extended;
    function IsInside(x,y:extended; e:integer):boolean;
    procedure DrawAxis;
//
// Рисование стрелки к элементу
// ============================
procedure DrawArrow
 (Canvas : TCanvas;
  Back,
  Head
          :  TPoint);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses MyBitmap;
{$R *.DFM}
var G1,G2:extended;
    LastFound,LastFound2
      : array of integer;
    LastLost,LastLost2
      : integer;


procedure QuickSort(var A: array of TScreenTriangle);

  procedure QuickSortSheet(var A: array of TScreenTriangle; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Mid:Extended;
    T:TScreenTriangle;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].Dist;
    repeat
      while A[Lo].Dist > Mid do Inc(Lo);
      while A[Hi].Dist < Mid do Dec(Hi);
      if Lo <= Hi then
      begin
//        VisualSwap(A[Lo], A[Hi], Lo, Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSortSheet(A, iLo, Hi);
    if Lo < iHi then QuickSortSheet(A, Lo, iHi);
  end;

begin
  if Length(a)=0 then exit;
  QuickSortSheet(A, Low(A), High(A));
end;



function precise_ppsi(x,y:extended):extended;
begin
 if y < -1/6 then result:=10*y+5 else
 if y<1/6 then result:=-60*y*y+5 else
 result:=-10*y+5;
end;

function ppsi_0(x,y:extended):extended;
begin
 result:=-20*sqr(y)+5;
end;

function pdpsi_0dy(x,y:extended):extended;
begin
 result:=-40*y;
end;

function pdpsi_0dx(x,y:extended):extended;
begin
 result:=0;
end;

function cpsi_0(x,y:extended):extended;
begin
 result:=2*G1*G2/(G1+G2)*(4-sqr(x)-sqr(y));
end;

function cdpsi_0dx(x,y:extended):extended;
begin
 result:=2*G1*G2/(G1+G2)*(-2*x);
end;

function cdpsi_0dy(x,y:extended):extended;
begin
 result:=2*G1*G2/(G1+G2)*(-2*y)
end;

function cd2psi_0dy2(x,y:extended):extended;
begin
 result:=-4*G1*G2/(G1+G2);
end;

function cd2psi_0dxdy(x,y:extended):extended;
begin
 result:=0;
end;

function cd2psi_0dx2(x,y:extended):extended;
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
    e,i:integer;
    si,sj,sk:integer;
    V,Ve:extended;
    h,x,y:extended;
    p:TMyPoint;
    ClusterSizeX,
    ClusterSizeY : Integer;
    cx,cy:integer;
begin
 if not OpenDialog1.Execute then exit;
 Fname:=OpenDialog1.FileName;
 Fname:=copy(fname,1,length(fname)-2);

 AssignFile(f,fname+'.n'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.Points,Mesh.NumPoints);
 lpbar.caption:='Считываем точки';lpbar.Refresh;
 pbar.max:=Mesh.NumPoints;pbar.Position :=0;
 for i:=0 to Mesh.NumPoints-1 do
 begin
  readln(f,Mesh.Points[i].x,Mesh.Points[i].y,Mesh.points[i].mark);
  if i=0 then begin maxx:=Mesh.Points[i].x; maxy:=Mesh.Points[i].y; minx:=maxx; miny:=maxy; end;
  maxx:=max(Mesh.Points[i].x,maxx);
  maxy:=max(Mesh.Points[i].y,maxy);
  minx:=min(Mesh.Points[i].x,minx);
  miny:=min(Mesh.Points[i].y,miny);
  pbar.StepIt ;
 end;
 closefile(f);

 SetLength(LastFound,round(sqrt(Mesh.NumPoints)*1.2));
 for i:=0 to Length(LastFound)-1 do LastFound[i]:=-1;
 LastLost:=0;

 AssignFile(f,fname+'.s'); Reset(f);
 Readln(f,Mesh.NumSides);
 SetLength(Mesh.Sides,Mesh.NumSides);
 lpbar.caption:='Считываем стороны';lpbar.Refresh;
 pbar.max:=Mesh.NumSides;pbar.Position :=0;
 for i:=0 to Mesh.NumSides-1 do
 begin
  pbar.StepIt;
  readln(f,Mesh.Sides[i].n1,Mesh.Sides[i].n2,Mesh.Sides[i].ea,Mesh.Sides[i].eb,Mesh.Sides[i].nx,Mesh.Sides[i].ny,
   Mesh.sides[i].mark);
 end;
 closefile(f);

 // Инициализация кластеров
 ClusterSizeX:=10;
 ClusterSizeY:=10;
 SetLength(Clusters,ClusterSizeX*ClusterSizeY);
 for cx:=0 to ClusterSizeX-1 do
 for cy:=0 to ClusterSizeY-1 do
 with Clusters[cx+cy*ClusterSizeX] do
 begin
  sx:=minx+cx*(maxx-minx)/ClusterSizeX;
  sy:=miny+cy*(maxy-miny)/ClusterSizey;
  ex:=minx+(cx+1)*(maxx-minx)/ClusterSizeX;
  ey:=miny+(cy+1)*(maxy-miny)/ClusterSizey;
  SetLength(Elements,0);
 end;

 AssignFile(f,fname+'.e'); Reset(f);
 Readln(f,Mesh.NumElements);
 SetLength(Mesh.Elements,Mesh.NumElements);
 setlength(Mesh.cell,mesh.numpoints);
 lpbar.caption:='Считываем элементы'; lpbar.refresh;
 pbar.max:=Mesh.NumElements;pbar.Position :=0;
 for i:=0 to mesh.numpoints-1 do mesh.cell[i]:=0;
 for i:=0 to Mesh.NumElements -1 do
 begin
   read(f,Mesh.Elements[i].i,Mesh.Elements[i].j,Mesh.Elements[i].k);
   read(f,Mesh.Elements[i].ei,Mesh.Elements[i].ej,Mesh.Elements[i].ek);
   read(f,Mesh.Elements[i].si,Mesh.Elements[i].sj,Mesh.Elements[i].sk);
   read(f,Mesh.Elements[i].mark);
   read(f,Mesh.Elements[i].A);
   read(f,Mesh.Elements[i].ai,Mesh.Elements[i].bi,Mesh.Elements[i].ci);
   read(f,Mesh.Elements[i].aj,Mesh.Elements[i].bj,Mesh.Elements[i].cj);
   read(f,Mesh.Elements[i].ak,Mesh.Elements[i].bk,Mesh.Elements[i].ck);
   Mesh.Elements[i].mx:=1/3*(
    Mesh.Points[Mesh.Elements[i].i].x+
    Mesh.Points[Mesh.Elements[i].j].x+
    Mesh.Points[Mesh.Elements[i].k].x);
   Mesh.Elements[i].my:=1/3*(
    Mesh.Points[Mesh.Elements[i].i].y+
    Mesh.Points[Mesh.Elements[i].j].y+
    Mesh.Points[Mesh.Elements[i].k].y);
   si:=Mesh.Elements[i].si;
   sj:=Mesh.Elements[i].sj;
   sk:=Mesh.Elements[i].sk;
   if Mesh.Sides[sk].N1=Mesh.Elements[i].i then Mesh.Sides[sk].ea:=i else Mesh.Sides[sk].eb:=i;
   if Mesh.Sides[sj].N1=Mesh.Elements[i].k then Mesh.Sides[sj].ea:=i else Mesh.Sides[sj].eb:=i;
   if Mesh.Sides[si].N1=Mesh.Elements[i].j then Mesh.Sides[si].ea:=i else Mesh.Sides[si].eb:=i;
   Mesh.cell[Mesh.elements[i].i]:=mesh.cell[mesh.elements[i].i]+Mesh.elements[i].A;
   Mesh.cell[Mesh.elements[i].j]:=mesh.cell[mesh.elements[i].j]+Mesh.elements[i].A;
   Mesh.cell[Mesh.elements[i].k]:=mesh.cell[mesh.elements[i].k]+Mesh.elements[i].A;
   {
   Mesh.cell[Mesh.elements[i].i]:=mesh.cell[mesh.elements[i].i]+1;
   Mesh.cell[Mesh.elements[i].j]:=mesh.cell[mesh.elements[i].j]+1;
   Mesh.cell[Mesh.elements[i].k]:=mesh.cell[mesh.elements[i].k]+1;
   }
   // заполнение кластеров
   x:=Mesh.Points[Mesh.Elements[i].i].x;
   y:=Mesh.Points[Mesh.Elements[i].i].y;
   AddToCluster(Clusters,x,y,i);
   x:=Mesh.Points[Mesh.Elements[i].j].x;
   y:=Mesh.Points[Mesh.Elements[i].j].y;
   AddToCluster(Clusters,x,y,i);
   x:=Mesh.Points[Mesh.Elements[i].k].x;
   y:=Mesh.Points[Mesh.Elements[i].k].y;
   AddToCluster(Clusters,x,y,i);
   pbar.StepIt;
 end;
 closefile(f);


 try
  MenuShowPsi0.Enabled := True;
  AssignFile(f,fname+'.psi0'); Reset(f);
  Readln(f,Mesh.NumPoints);
  SetLength(Mesh.Psi0,Mesh.NumPoints);
  lpbar.caption:='Считываем Psi0'; lpbar.refresh;
  pbar.max:=Mesh.NumPoints;pbar.Position :=0;
  for i:=0 to Mesh.NumPoints-1 do
  begin
   readln(f,Mesh.Psi0[i]);
   {
   if i=0 then begin Gmaxn1:=Mesh.N1R[i]; Gminn1:=Gmaxn1; end;
   Gmaxn1:=max(Mesh.N1R[i],Gmaxn1);
   Gminn1:=min(Mesh.N1R[i],GminN1);
   }
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowPsi0.Enabled := False;
 end;

 try
  MenuShowPsi.Enabled := True;
  AssignFile(f,fname+'.psi'); Reset(f);
  Readln(f,Mesh.NumPoints);
  SetLength(Mesh.Psi,Mesh.NumPoints);
  SetLength(Mesh.DiffPsi,Mesh.NumPoints);
  lpbar.caption:='Считываем Psi'; lpbar.refresh;
  pbar.max:=Mesh.NumPoints;pbar.Position :=0;
  for i:=0 to Mesh.NumPoints-1 do
  begin
   readln(f,Mesh.Psi[i]);
   Mesh.DiffPsi[i]:=Mesh.Psi[i]-Mesh.Psi0[i];
   {
   if i=0 then begin Gmaxn1:=Mesh.N1R[i]; Gminn1:=Gmaxn1; end;
   Gmaxn1:=max(Mesh.N1R[i],Gmaxn1);
   Gminn1:=min(Mesh.N1R[i],GminN1);
   }
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowPsi.Enabled := False;
 end;

 try
  MenuShowSigma13.Enabled := True;
  MenuShowSigma23.Enabled := True;
  AssignFile(f,fname+'.sigma'); Reset(f);
  Readln(f,Mesh.NumPoints);
  SetLength(Mesh.Sigma13,Mesh.NumPoints);
  SetLength(Mesh.Sigma23,Mesh.NumPoints);
  lpbar.caption:='Считываем Sigma'; lpbar.refresh;
  pbar.max:=Mesh.NumPoints;pbar.Position :=0;
  for i:=0 to Mesh.NumPoints-1 do
  begin
   readln(f,Mesh.Sigma13[i],Mesh.Sigma23[i]);
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowSigma13.Enabled := False;
  MenuShowSigma23.Enabled := False;
 end;

 AssignFile(f,fname+'.n1'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.N1R,Mesh.NumPoints);
 lpbar.caption:='Считываем N1'; lpbar.refresh;
 pbar.max:=Mesh.NumPoints;pbar.Position :=0;
 for i:=0 to Mesh.NumPoints-1 do
 begin
  readln(f,Mesh.N1R[i]);
  if i=0 then begin Gmaxn1:=Mesh.N1R[i]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(Mesh.N1R[i],Gmaxn1);
  Gminn1:=min(Mesh.N1R[i],GminN1);
  pbar.stepit;
 end;
 closefile(f);

 AssignFile(f,fname+'.n2'); Reset(f);
 Readln(f,Mesh.NumPoints);
 SetLength(Mesh.N2R,Mesh.NumPoints);
 lpbar.caption:='Считываем N2'; lpbar.refresh;
 pbar.max:=Mesh.NumPoints;pbar.Position :=0;
 for i:=0 to Mesh.NumPoints-1 do
 begin
  readln(f,Mesh.N2R[i]);
  if i=0 then begin Gmaxn2:=Mesh.N2R[i]; Gminn2:=Gmaxn2; end;
  Gmaxn2:=max(Mesh.N2R[i],Gmaxn2);
  Gminn2:=min(Mesh.N2R[i],GminN2);
  pbar.Stepit;
 end;
 closefile(f);

 AssignFile(f,fname+'.m'); reset(f);
 Readln(f,Mesh.NumMaterials);
 SetLength(Mesh.Materials,Mesh.NumMaterials);
 for i:=0 to Mesh.NumMaterials-1 do
 begin
  readln(f,Mesh.Materials[i].d11,Mesh.Materials[i].d12,Mesh.Materials[i].d21,Mesh.Materials[i].d22)
 end;
 closefile(f);

 // выставление производных
 setlength(Mesh.dN1dx,mesh.numpoints);
 setlength(Mesh.dN1dy,mesh.numpoints);
 setlength(Mesh.dN2dx,mesh.numpoints);
 setlength(Mesh.dN2dy,mesh.numpoints);
 for i:=0 to mesh.numpoints-1 do
 begin
  mesh.dn1dx[i]:=0;
  mesh.dn1dy[i]:=0;
  mesh.dn2dx[i]:=0;
  mesh.dn2dy[i]:=0;
 end;
 (*
 lpbar.caption:='Вычисление производных'; lpbar.refresh;
 pbar.max:=Mesh.NumElements;pbar.Position :=0;
 for i:=0 to mesh.numelements-1 do
 begin
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
   pbar.StepIt;
 end;

 for i:=0 to mesh.numpoints-1 do
 begin
  mesh.dN1dx[i]:=mesh.dN1dx[i]/mesh.cell[i];
  mesh.dN1dy[i]:=mesh.dN1dy[i]/mesh.cell[i];
  mesh.dN2dx[i]:=mesh.dN2dx[i]/mesh.cell[i];
  mesh.dN2dy[i]:=mesh.dN2dy[i]/mesh.cell[i];
 end;

// D0_11:=0; D0_22:=0;
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
 lpbar.caption:='Вычисление эфф.коэфф'; lpbar.refresh;
 pbar.max:=Mesh.NumElements;pbar.Position :=0;
 V:=0;
 for i:=0 to Mesh.NumElements-1 do
 begin
   Ve:=Mesh.Materials[Mesh.Elements[i].mark].d11*
      (Mesh.N1R[Mesh.Elements[i].i]*Mesh.Elements[i].bi+
       Mesh.N1R[Mesh.Elements[i].j]*Mesh.Elements[i].bj+
       Mesh.N1R[Mesh.Elements[i].k]*Mesh.Elements[i].bk)+
       Mesh.Materials[Mesh.Elements[i].mark].d11;
  D0_11:=D0_11+Mesh.Elements[i].A*Ve;

   Ve:=Mesh.Materials[Mesh.Elements[i].mark].d22*
      (Mesh.N2R[Mesh.Elements[i].i]*Mesh.Elements[i].ci+
       Mesh.N2R[Mesh.Elements[i].j]*Mesh.Elements[i].cj+
       Mesh.N2R[Mesh.Elements[i].k]*Mesh.Elements[i].ck)+
       Mesh.Materials[Mesh.Elements[i].mark].d22;
  D0_22:=D0_22+Mesh.Elements[i].A*Ve;

  V:=V+Mesh.Elements[i].A;
  pbar.StepIt;
 end;

 D0_11:=D0_11/V;
 D0_22:=D0_22/V;
 //*)
 if abs(D0_22)>1e-15 then G1:=1/D0_22;
 if abs(D0_11)>1e-15 then G2:=1/D0_11;
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
 (*
 lpbar.caption:='Вычисление объёма'; lpbar.refresh;
 pbar.max:=Mesh.NumElements;pbar.Position :=0;
 for i:=0 to Mesh.NumElements-1 do
 begin
  Ve:=Ve+PPsi(
   (Mesh.Points[Mesh.Elements[i].i].X+Mesh.Points[Mesh.Elements[i].j].X+Mesh.Points[Mesh.Elements[i].k].X)/3,
   (Mesh.Points[Mesh.Elements[i].i].Y+Mesh.Points[Mesh.Elements[i].j].Y+Mesh.Points[Mesh.Elements[i].k].Y)/3)*
   Mesh.Elements[i].A;
   pbar.stepit;
 end;
 // *)
// tau:=M/2/Ve;

 NowDraw:=N_1;
 NowDrawMin:=Gminn1;
 NowDrawMax:=Gmaxn1;
 FillUpData;
 ShowData;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
 Image1.Canvas.FloodFill(0,0,clWhite,fsSurface);
 ViewPoint:=Vector(-4,9,3);
 ViewDir:=Neg(ViewPoint); Norm(ViewDir);
 ViewUp:=Vector( 0.11687491,-0.26250536, 0.95782629);Norm(ViewUp);
 ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
 phi:=2*PI/360;
 Scale:=3450;
 fscale:=1e-2;

 Image1.Canvas.Font.name:='sans serif';
 Image1.Canvas.Font.size:=16;
 setlength(mcolors,12);

 mcolors[0]:=clLtGray; mcolors[1]:=clblue;  mcolors[2]:=clGreen;
// mcolors[0]:=clRed; mcolors[1]:=clYellow;  mcolors[2]:=clGreen;
 mcolors[3]:=clYellow; mcolors[4]:=clPurple; mcolors[5]:=clTeal;
 mcolors[6]:=clGray; mcolors[7]:=clFuchsia; mcolors[8]:=clLime;
 mcolors[9]:=clNavy; mcolors[10]:=clOlive; mcolors[11]:=clMaroon;

 with LightSource do
 begin
  X:=-20;
  Y:=10;
  Z:=20;
 end;
 Alpha:=0.0;
 Betta:=1.0;
end;


function PreciseN2(x1:extended):extended;
begin
 if x1<-1/6 then result:=-1/4*(2*x1+1) else
 if x1<1/6 then result:=x1 else
    result:=-1/4*(2*x1-1);
end;

function AdjustColor(c:TColor;g:extended):TColor;
begin
 Result:=RGB(Round(GetRValue(c)*g),Round(GetGValue(c)*g),Round(GetBValue(c)*g));
end;


procedure GetRoughMark(a,b:extended;var base,h:extended);
var MarkSize:integer;
begin
 MarkSize:=trunc(log10((b-a)/27));
// writeln('marksize:',marksize);
 h:=power(10,MarkSize);
 base:=trunc(a/h)*h;
end;

procedure TMainForm.ShowData;
var scrx,scry:extended;
    ScreenPlane:TPlane;
    Scr: array of TScreenTriangle;
//    ScrPoints:array of TScreenPoint;
    j,t,i,NTriangles: integer;
    p1,p2,p3:TVector;
    x,y:extended;
    d1,d2,d3:extended;
    tr:array of TPoint;
    LightDir: TVector;
    dis : extended;
begin
 Image1.Canvas.Brush.Color:=clWhite;
 Image1.Canvas.FillRect(Image1.ClientRect);
 DrawAxis;

 ScreenPlane:=Plane(Sum(ViewPoint,ViewDir),ViewDir);
 SetLength(scr,Length(Scene));
 {
 SetLength(ScrPoints,Mesh.NumPoints);
 for i:= 0 to Mesh.NumPoints-1 do
 begin
  ScrPoints[i].valid:=Intersect(ScreenPlane,Line(ViewPoint,ViewDir),p,ScrPoints[i].Dist);
  if not ScrPoints[i].valid then continue;
  x:=PScalar(ViewRight,Sum(p,neg(Sum(ViewPoint,ViewDir))));
  y:=PScalar(ViewUp,Sum(p,neg(Sum(ViewPoint,ViewDir))));
  ScrPoints[i].x:=round(image1.Width div 2 + x*scale);
  ScrPoints[i].y:=round(image1.Height div 2 + y*scale);
 end;
 }
 t:=0; i:=0; NTriangles:=Length(Scr);
 while t<NTriangles do
 begin
  Scr[t].valid:= Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v1.p,ViewPoint),p1,d1) and
                 Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v2.p,ViewPoint),p2,d2) and
                 Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v3.p,ViewPoint),p3,d3);
  if not scr[t].valid then begin inc(i); dec(NTriangles); continue; end;
  if (d1<0) or (d2<0) or (d3<0) then begin Scr[t].valid:=false; inc(i); dec(NTriangles); continue; end;

  x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
  Scr[t].x1:=round(image1.Width div 2 + x*scale);
  Scr[t].y1:=round(image1.Height div 2 - y*scale);

  x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
  Scr[t].x2:=round(image1.Width div 2 + x*scale);
  Scr[t].y2:=round(image1.Height div 2 - y*scale);

  x:=PScalar(ViewRight,Sub(p3,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p3,Sum(ViewPoint,ViewDir)));
  Scr[t].x3:=round(image1.Width div 2 + x*scale);
  Scr[t].y3:=round(image1.Height div 2 - y*scale);
//  Scr[t].Dist:=-max(d1,max(d2,d3));
  Scr[t].Dist:=-(d1+d2+d3)/3;
//  Scr[t].Dist:=-min(d1,min(d2,d3));
  Scr[t].Color:=mColors[Scene[i].Color];
  LightDir:=Sub(LightSource,Scene[i].v1.p);
  Norm(LightDir);
  dis:=PScalar(LightDir,Scene[i].Norm);
  if dis<0 then dis:=-dis;
  if cbLightning.Checked then Scr[t].color:=AdjustColor(Scr[t].Color,dis);
  inc(t);
  inc(i);
 end;
 SetLength(Scr,NTriangles);
 QuickSort(Scr);
 setLength(tr,4);
 Image1.Canvas.Brush.style:=bsSolid;
 Image1.Canvas.Pen.Color:=clBlack;
 for i:=0 to NTriangles-1 do
 begin
  tr[0].x:=Scr[i].x1; tr[0].y:=Scr[i].y1;
  tr[1].x:=Scr[i].x2; tr[1].y:=Scr[i].y2;
  tr[2].x:=Scr[i].x3; tr[2].y:=Scr[i].y3;
  tr[3]:=tr[0];
  if cbLightning.Checked then  Image1.Canvas.Pen.color:=Scr[i].color;
//  Image1.Canvas.Pen.width:=12-i;
  Image1.Canvas.Brush.color:=Scr[i].color;
  Image1.Canvas.Polygon(tr);
//  Image1.Canvas.MoveTo(tr[0].x,tr[0].y);
//  for j:=1 to 3 do image1.canvas.lineto(tr[j].x,tr[j].y);
 end;


 edX.text:=Format('%12.8f',[ViewPoint.x]);
 edY.text:=Format('%12.8f',[ViewPoint.y]);
 edZ.text:=Format('%12.8f',[ViewPoint.z]);

 edVX.text:=Format('%12.8f',[ViewDir.x]);
 edVY.text:=Format('%12.8f',[ViewDir.y]);
 edVZ.text:=Format('%12.8f',[ViewDir.z]);

 edUX.text:=Format('%12.8f',[ViewUp.x]);
 edUY.text:=Format('%12.8f',[ViewUp.y]);
 edUZ.text:=Format('%12.8f',[ViewUp.z]);

 edRX.text:=Format('%12.8f',[ViewRight.x]);
 edRY.text:=Format('%12.8f',[ViewRight.y]);
 edRZ.text:=Format('%12.8f',[ViewRight.z]);
 Image1.Refresh;
end;

procedure TMainForm.ZoomInClick(Sender: TObject);
begin
 Scale:=Scale*1.1;
 ShowData;
end;

procedure TMainForm.ZoomOutClick(Sender: TObject);
begin
 Scale:=Scale/1.1;
 ShowData;
end;

procedure TMainForm.ToLeftClick(Sender: TObject);
begin
// ViewDir:=Mul(RotMatrix(ViewUp,phi),ViewDir);
// ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
 Basis.vdata[1]:=ViewDir; Basis.vdata[2]:=ViewRight; Basis.vdata[3]:=ViewUp;
 RotateBasis(Basis,phi);
 ViewDir:=Basis.Vdata[1]; ViewRight:=Basis.vdata[2]; ViewUp:=Basis.vdata[3];
 ShowData;
end;

procedure TMainForm.ToRightClick(Sender: TObject);
var m:TMatrix;
begin
// M:=RotMatrix(ViewUp,-phi);
// ViewDir:=Mul(m,ViewDir);
// ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
 Basis.vdata[1]:=ViewDir; Basis.vdata[2]:=ViewRight; Basis.vdata[3]:=ViewUp;
 RotateBasis(Basis,-phi);
 ViewDir:=Basis.Vdata[1]; ViewRight:=Basis.vdata[2]; ViewUp:=Basis.vdata[3];
 ShowData;
end;

procedure TMainForm.ToUpClick(Sender: TObject);
begin
// ViewDir:=Mul(RotMatrix(ViewRight,phi),ViewDir);
 Add(ViewPoint,PScalar(ViewDir,0.1));
 ShowData;
end;

procedure TMainForm.ToDownClick(Sender: TObject);
begin
 Add(ViewPoint,PScalar(ViewDir,-0.1));
 ShowData;
end;

procedure TMainForm.MenuShowN1Click(Sender: TObject);
begin
 NowDraw:=N_1;
 NowDrawMin:=GMinn1;
 NowDrawMax:=Gmaxn1;
 MenuShowN2.Checked:=false;
 MenuShowN1.checked:=true;
 FillUpData;
 ShowData;
end;

procedure TMainForm.MenuShowN2Click(Sender: TObject);
begin
 NowDraw:=N_2;
 NowDrawMin:=GMinn2;
 NowDrawMax:=Gmaxn2;
 MenuShowN1.Checked:=false;
 MenuShowN2.checked:=true;
 FillUpData;
 ShowData;
end;
(*
//
// Площадь треугольника (na,nb,nc) через векторное произведение, со знаком
extended area(struct nod *na, struct nod *nb, struct nod *nc)
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


function TMainForm.area(na,nb,nc:TMyPoint): extended;
begin
 Result:=0.5* ((nb.x-na.x)*(nc.y-na.y)-(nb.y-na.y)*(nc.x-na.x));
end;


function TMainForm.InElement(n:TMyPoint): integer;
var i,e:integer;

begin
 result:=-1;
 Result:=ClusterSearch(Clusters,n.X,n.y,IsInside); {
 for i:=0 to Length(LastFound)-1 do
 begin
  E:=LastFound[i];
  if e>0 then
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
             Mesh.points[Mesh.Elements[e].i]) >= 0.0) then
   begin
    LastFound[LastLost]:=e;
    inc(LastLost);
    if LastLost>=Length(LastFound) then LastLost:=0;
    result:=e;
    exit;
   end;
 end;
{ }
end;
type CMYKColor=record
       c,m,y,k:extended;
     end;
const
  CMYKBlack:CMYKColor=(c:0;m:0;y:0;k:1);
  CMYKWhite:CMYKColor=(c:0;m:0;y:0;k:0);
  CMYKPalette:array[0..11] of CMYKColor =
(
(c:0   ; m:0   ; y:0   ; k:0.3),
(c:0   ; m:0   ; y:0   ; k:0),
(c:0.08; m:0.89; y:0   ; k:0),
(c:0.38; m:0.77; y:0   ; k:0),
(c:0.79; m:0.43; y:0   ; k:0),
(c:0.99; m:0.10; y:0   ; k:0),
(c:0.48; m:0   ; y:0.05; k:0),
(c:0.92; m:0   ; y:0.45; k:0),
(c:0.28; m:0   ; y:0.77; k:0),
(c:0.05; m:0   ; y:0.84; k:0),
(c:0   ; m:0.08; y:0.94; k:0),
(c:0   ; m:0.32; y:0.88; k:0)
);

procedure EPSSetColor(var f:TextFile;c:CMYKColor);
begin writeln(f,c.c:6:5,' ',c.m:6:5,' ',c.y:6:5,' ',c.k:6:5,' K'); end;
procedure EPSSetFillColor(var f:TextFile;c:CMYKColor);
begin writeln(f,c.c/3:6:5,' ',c.m/3:6:5,' ',c.y/3:6:5,' ',c.k/3:6:5,' k'); end;
procedure EPSDrawText(var f:Textfile;x,y:integer; s:string);
begin
 writeln(f,x,' ',y,' m');
 writeln(f,'(',s,') show');
end;
procedure EPSFillPoly(var f:TextFile;var a: array of TPoint;border,fill:CMYKColor);
var i:integer;
begin
 EPSSetColor(f,border); EPSSetFillColor(f,fill);
 writeln(f,'n');
 writeln(f,a[0].x,' ',a[0].y,' m');
 for i:=1 to length(a)-1 do
 begin
  writeln(f,a[i].x,' ',a[i].y,' l');
 end;
 writeln(f,'c B');
end;

procedure EPSLine(var f:TextFile;a,b:TPoint;Color:CMYKColor);
var i:integer;
begin
 EPSSetColor(f,Color);
 writeln(f,a.x,' ',a.y,' m');
 writeln(f,b.x,' ',b.y,' l');
 writeln(f,'S');
end;

procedure EPSArrow
 (var f:TextFile;
  Back,
  Head
          :  TPoint;
  Color,Fill:CMYKColor);
const
AHAngle  // ArrowHead angle, rad
         :  Double = 0.3;
AHLength // ArrowHead Length
         :  Double = 15;
var
x1, y1, x2, y2: Integer;
al,
adx,
ady,
x,
y,
sina,
cosa  //
      :  Double;
Arrow // К
      :  array [0..2] of TPoint;
begin
x1:=Back.X;
y1:=Back.Y;
x2:=Head.X;
y2:=Head.Y;
adx:=x1-x2;
ady:=y1-y2;
al:=sqrt(sqr(adx)+sqr(ady));
//
// SetLength(Arrow,3);
adx:=adx/al*AHLength;
ady:=ady/al*AHLength;
sina:=sin(AHAngle);
cosa:=cos(AHAngle);
x:=adx*cosa-ady*sina;
y:=adx*sina+ady*cosa;
Arrow[0].X:=X2;
Arrow[0].Y:=Y2;
Arrow[1].X:=X2+Round(x);
Arrow[1].Y:=Y2+Round(y);
x:=adx*cosa+ady*sina;
y:=-adx*sina+ady*cosa;
Arrow[2].X:=X2+Round(x);
Arrow[2].Y:=Y2+Round(y);
EPSLine(f,Back,Head,Color);
EPSFillPoly(f,Arrow,Color,Fill)
end;


procedure EPSAxis(var f: TextFile;
  sx,sy:Integer;
  Scale:Extended;
  ScreenPlane:
  TPlane;ViewPoint,ViewUp,ViewRight,ViewDir:TVector);
var
    ArrowStart,
    ArrowFinish : TVector;
    x,y:Extended;
    p1,p2 : TVector;
    d1,d2:Extended;
    sa,ea : TPoint;
begin
 ArrowStart.x:=0;
 ArrowStart.y:=0;
 ArrowStart.z:=0;

 ArrowFinish.x:=StrToFloat(MainForm.edAxisLength.Text);
 ArrowFinish.y:=0;
 ArrowFinish.z:=0;

 Intersect(ScreenPlane,ViewPoint,Sub(ArrowStart,ViewPoint),p1,d1);
 Intersect(ScreenPlane,ViewPoint,Sub(ArrowFinish,ViewPoint),p2,d2);

 x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
 sa.x:=round(sx div 2 + x*scale);
 sa.y:=round(sy div 2 + y*scale);

 x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
 ea.x:=round(sx div 2 + x*scale);
 ea.y:=round(sy div 2 + y*scale);

 EPSArrow(F,sa,ea,CMYKBlack,CMYKBlack);

 ArrowStart.x:=0;
 ArrowStart.y:=0;
 ArrowStart.z:=0;

 ArrowFinish.x:=0;
 ArrowFinish.y:=StrToFloat(MainForm.edAxisLength.Text);
 ArrowFinish.z:=0;

 Intersect(ScreenPlane,ViewPoint,Sub(ArrowStart,ViewPoint),p1,d1);
 Intersect(ScreenPlane,ViewPoint,Sub(ArrowFinish,ViewPoint),p2,d2);

 x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
 sa.x:=round(sx div 2 + x*scale);
 sa.y:=round(sy div 2 + y*scale);

 x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
 ea.x:=round(sx div 2 + x*scale);
 ea.y:=round(sy div 2 + y*scale);

 EPSArrow(F,sa,ea,CMYKBlack,CMYKBlack);
// EPSDrawText(F,ea.x+10,ea.Y-10,'x_2');

end;




procedure TMainForm.EPS1Click(Sender: TObject);
var scrx,scry:extended;
    ScreenPlane:TPlane;
    Scr: array of TScreenTriangle;
//    ScrPoints:array of TScreenPoint;
    j,t,i,NTriangles: integer;
    p1,p2,p3:TVector;
    x,y:extended;
    d1,d2,d3:extended;
    tr:array of TPoint;
    fname:string;
    f:TextFile;
begin
 SaveDialog1.FilterIndex:=1;
 if not SaveDialog1.Execute then exit;
 Fname:=SaveDialog1.FileName;
 assignfile(f,fname); rewrite(f);
 writeln(f,'%!PS');
 writeln(f,'%%Creator: - Created by Surf');
 writeln(f,'%%Title: ',fname);
 writeln(f,'%%Pages: 1');
 writeln(f,'%%BoundingBox: 0 0 ',image1.width,' ',image1.height);
 writeln(f,'%%EndComments');
 writeln(f,'/m {moveto} def');
 writeln(f,'/l {lineto} def');
 writeln(f,'/s {stroke} def');
 writeln(f,'/c {closepath} def');
 writeln(f,'/n {newpath} def');
 writeln(f,'/Times-Italic findfont 16 scalefont setfont');
 writeln(f,'/F {fillC fillM fillY fillK setcmykcolor eofill} def');
 writeln(f,'/S {strokeC strokeM strokeY strokeK setcmykcolor stroke} def');
 writeln(f,'/B {gsave F grestore S} bind def');
 writeln(f,'/K { /strokeK exch def /strokeY exch def /strokeM exch def /strokeC exch def } bind def');
 writeln(f,'/k { /fillK   exch def /fillY   exch def /fillM   exch def /fillC   exch def } bind def');
 writeln(f,'1 setlinejoin');
 writeln(f,'0.2 setlinewidth');
 (*  Здесь надо рисовать картинку *)
 ScreenPlane:=Plane(Sum(ViewPoint,ViewDir),ViewDir);
 SetLength(scr,Length(Scene));
 {
 SetLength(ScrPoints,Mesh.NumPoints);
 for i:= 0 to Mesh.NumPoints-1 do
 begin
  ScrPoints[i].valid:=Intersect(ScreenPlane,Line(ViewPoint,ViewDir),p,ScrPoints[i].Dist);
  if not ScrPoints[i].valid then continue;
  x:=PScalar(ViewRight,Sum(p,neg(Sum(ViewPoint,ViewDir))));
  y:=PScalar(ViewUp,Sum(p,neg(Sum(ViewPoint,ViewDir))));
  ScrPoints[i].x:=round(image1.Width div 2 + x*scale);
  ScrPoints[i].y:=round(image1.Height div 2 + y*scale);
 end;
 }
 t:=0; i:=0; NTriangles:=Length(Scr);
 while t<NTriangles do
 begin
  Scr[t].valid:= Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v1.p,ViewPoint),p1,d1) and
                 Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v2.p,ViewPoint),p2,d2) and
                 Intersect(ScreenPlane,ViewPoint,Sub(Scene[i].v3.p,ViewPoint),p3,d3);
  if not scr[t].valid then begin inc(i); dec(NTriangles); continue; end;
  if (d1<0) or (d2<0) or (d3<0) then begin Scr[t].valid:=false; inc(i); dec(NTriangles); continue; end;

  x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
  Scr[t].x1:=round(image1.Width div 2 + x*scale);
  Scr[t].y1:=round(image1.Height div 2 + y*scale);

  x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
  Scr[t].x2:=round(image1.Width div 2 + x*scale);
  Scr[t].y2:=round(image1.Height div 2 + y*scale);

  x:=PScalar(ViewRight,Sub(p3,Sum(ViewPoint,ViewDir)));
  y:=PScalar(ViewUp   ,Sub(p3,Sum(ViewPoint,ViewDir)));
  Scr[t].x3:=round(image1.Width div 2 + x*scale);
  Scr[t].y3:=round(image1.Height div 2 + y*scale);
//  Scr[t].Dist:=-max(d1,max(d2,d3));
//  Scr[t].Dist:=(d1+d2+d3)/3;
  Scr[t].Dist:=-min(d1,min(d2,d3));
  Scr[t].Color:=Scene[i].Color;
  inc(t);
  inc(i);
 end;
 SetLength(Scr,NTriangles);
 QuickSort(Scr);
 setLength(tr,4);
// Image1.Canvas.Brush.style:=bsSolid;
 for i:=0 to NTriangles-1 do
 begin
  tr[0].x:=Scr[i].x1; tr[0].y:=Scr[i].y1;
  tr[1].x:=Scr[i].x2; tr[1].y:=Scr[i].y2;
  tr[2].x:=Scr[i].x3; tr[2].y:=Scr[i].y3;
  tr[3]:=tr[0];
//  Image1.Canvas.Pen.color:=Scr[i].color;
//  Image1.Canvas.Pen.width:=12-i;
//  Image1.Canvas.Brush.color:=Scr[i].color;
//  Image1.Canvas.Polygon(tr);
//  Image1.Canvas.MoveTo(tr[0].x,tr[0].y);
//  for j:=1 to 3 do image1.canvas.lineto(tr[j].x,tr[j].y);
  EPSFillPoly(f,tr,cmykBlack,CMYKPalette[Scr[i].Color]);
 end;
 EPSAxis(f,Image1.Width ,Image1.Height,Scale,ScreenPlane,ViewPoint,ViewUp,ViewRight,ViewDir);
 (*  Здесь надо рисовать картинку *)
 closefile(f);
end;

function TMainForm.PPsi(x, y: extended): extended;
begin
   result:=CPsi_0(x,y)+cdpsi_0dx(x,y)*N_1(x,y)+cdpsi_0dy(x,y)*N_2(x,y);
// result:=PPsi_0(x,y)+pdpsi_0dx(x,y)*N_1(x,y)+pdpsi_0dy(x,y)*N_2(x,y);
end;

function TMainForm.CPsi(x, y: extended): extended;
begin
 //result:=CPsi_0(x,y)+cdpsi_0dx(x,y)*N_1(x,y)+cdpsi_0dy(x,y)*N_2(x,y);
end;

function TMainForm.N_1(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.N1R[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.N1R[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.N1R[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

function TMainForm.N_2(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.N2R[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.N2R[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.N2R[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

procedure TMainForm.MenuShowPsiClick(Sender: TObject);
begin
 NowDraw:=Psi;
// NowDrawMin:=GMinn1;
// NowDrawMax:=Gmaxn1;
// MenuShowN2.Checked:=false;
// MenuShowN1.checked:=False;
 FillUpData;
 ShowData;
end;

procedure TMainForm.Psi2Click(Sender: TObject);
begin
// Psi2.checked:=not psi2.checked;
// showdata;
end;


function TMainForm.sigma_13(x, y: extended): extended;
begin
 result:=tau*dpsidy(x,y);
end;

function TMainForm.sigma_23(x, y: extended): extended;
begin
 result:=-tau*dpsidx(x,y);
end;

function TMainForm.dPsidx(x, y: extended): extended;
begin
   result:=0;
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

function TMainForm.dPsidy(x, y: extended): extended;
begin
 result:=0;
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

function TMainForm.dN_1dx(x, y: extended): extended;
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

function TMainForm.dN_1dy(x, y: extended): extended;
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

function TMainForm.dN_2dx(x, y: extended): extended;
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

function TMainForm.dN_2dy(x, y: extended): extended;
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


function TMainForm.eps_13(x, y: extended): extended;
begin
result:=sigma_13(x,y)/2/G1;
end;

function TMainForm.eps_23(x, y: extended): extended;
begin
result:=sigma_23(x,y)/2/G2;
end;

procedure TMainForm.ShowA1Click(Sender: TObject);
begin
// ShowA1.Checked:=not ShowA1.Checked;
// NowDraw:=sigma_13;
// NowDraw:=sigma_23;
// NowDraw:=dn_2dy;
// NowDraw:=eps_13;
// showdata;
end;


procedure TMainForm.ShowA2Click(Sender: TObject);
begin
// ShowA2.Checked:=not ShowA2.Checked;
// NowDraw:=sigma_13;
// NowDraw:=sigma_23;
// NowDraw:=dn_2dy;
// NowDraw:=eps_23;
// showdata;
end;

function TriangleNorm(V1,V2,V3: TVector):TVector;
begin
 Result:=PVector(Sub(V2,V1),Sub(V3,V1));
 Norm(Result);
end;

procedure TMainForm.FillUpData;
var i,j:integer;
//    z:extended;
//    min,max:extended;
begin
 lpbar.caption:='Построение поверхности'; lpbar.refresh;
 pbar.max:=Mesh.NumElements;pbar.Position :=0;
 SetLength(Scene,Mesh.NumElements);
// fscale:=100;
 for i:=0 to Mesh.NumElements -1 do
 begin
//  Scene[i].Color:=mcolors[Mesh.Elements[i].mark];
  Scene[i].Color:=Mesh.Elements[i].mark;

  Scene[i].v1.p.x:=mesh.Points[mesh.Elements[i].i].X;
  Scene[i].v1.p.y:=mesh.Points[mesh.Elements[i].i].y;
//  Scene[i].v1.p.z:=0;
//  Scene[i].v1.p.z:=Mesh.N1R[Mesh.Elements[i].i]*fscale;
  Scene[i].v1.p.z:=NowDraw(Scene[i].v1.p.x,Scene[i].v1.p.y);

  Scene[i].v2.p.x:=mesh.Points[mesh.Elements[i].j].X;
  Scene[i].v2.p.y:=mesh.Points[mesh.Elements[i].j].y;
//  Scene[i].v2.p.z:=0;
//  Scene[i].v2.p.z:=Mesh.N1R[Mesh.Elements[i].j]*fscale;
  Scene[i].v2.p.z:=NowDraw(Scene[i].v2.p.x,Scene[i].v2.p.y);

  Scene[i].v3.p.x:=mesh.Points[mesh.Elements[i].k].X;
  Scene[i].v3.p.y:=mesh.Points[mesh.Elements[i].k].y;
//  Scene[i].v3.p.z:=0;
//  Scene[i].v3.p.z:=Mesh.N1R[Mesh.Elements[i].k]*fscale;
  Scene[i].v3.p.z:=NowDraw(Scene[i].v3.p.x,Scene[i].v3.p.y);
//
  Scene[i].Norm:=TriangleNorm(Scene[i].v1.p,Scene[i].v2.p,Scene[i].v3.p);
  {
  Z:=NowDraw(Scene[i].v1.p.x,Scene[i].v1.p.y)+NowDraw(Scene[i].v2.p.x,Scene[i].v2.p.y)+NowDraw(Scene[i].v3.p.x,Scene[i].v3.p.y);
  if (i=0) then begin min:=z; max:=z; end;
  if z<min then min:=z;
  if z>max then max:=z;
  Scene[i].v1.p.z:=z;
  }
  pbar.Stepit;
 end;
{
 for i:=0 to Mesh.NumElements-1 do
 begin
  z:=Scene[i].v1.p.z; Scene[i].v1.p.z:=0;
  Scene[i].Color:=Round(11*(z-min)/(max-min)+1);
 end;
}
end;
function SP(x,y,z:extended):TScenePoint;
begin
result.p.x:=x; result.p.y:=y; result.p.z:=z;
end;
procedure TMainForm.MakeCube;
var p:array of TScenePoint;
    i:integer;
begin
 SetLength(p,8);
 p[0]:=SP( 1, 1, 1);
 p[1]:=SP(-1, 1, 1);
 p[2]:=SP( 1,-1, 1);
 p[3]:=SP( 1, 1,-1);
 p[4]:=SP(-1, 1,-1);
 p[5]:=SP(-1,-1, 1);
 p[6]:=SP( 1,-1,-1);
 p[7]:=SP(-1,-1,-1);

 SetLength(Scene,12);
 Scene[ 0].v1:=p[0]; Scene[ 0].v2:=p[1]; Scene[ 0].v3:=p[3];
 Scene[ 1].v1:=p[0]; Scene[ 1].v2:=p[1]; Scene[ 1].v3:=p[2];
 Scene[ 2].v1:=p[0]; Scene[ 2].v2:=p[2]; Scene[ 2].v3:=p[3];
 Scene[ 3].v1:=p[1]; Scene[ 3].v2:=p[4]; Scene[ 3].v3:=p[3];
 Scene[ 4].v1:=p[1]; Scene[ 4].v2:=p[2]; Scene[ 4].v3:=p[5];
 Scene[ 5].v1:=p[2]; Scene[ 5].v2:=p[3]; Scene[ 5].v3:=p[6];
 Scene[ 6].v1:=p[2]; Scene[ 6].v2:=p[5]; Scene[ 6].v3:=p[6];
 Scene[ 7].v1:=p[1]; Scene[ 7].v2:=p[4]; Scene[ 7].v3:=p[5];
 Scene[ 8].v1:=p[3]; Scene[ 8].v2:=p[4]; Scene[ 8].v3:=p[6];
 Scene[ 9].v1:=p[5]; Scene[ 9].v2:=p[6]; Scene[ 9].v3:=p[7];
 Scene[10].v1:=p[4]; Scene[10].v2:=p[5]; Scene[10].v3:=p[7];
 Scene[11].v1:=p[4]; Scene[11].v2:=p[6]; Scene[11].v3:=p[7];
 for i:=0 to 11 do begin Scene[i].color:=mColors[i]; end;

end;

procedure TMainForm.MenuShowcubeClick(Sender: TObject);
var b,h :TPoint;
    i:Integer;
begin
 for i:=0 to 10 do
 begin
  b.Y:=20;
  b.x:=i*10;
  h.Y:=200;
  h.X:=i*20;
  DrawArrow(Image1.Canvas,b,h);
 end;
// MakeCube;
// ShowData;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if ssAlt in Shift then phi:=phi*10;
 case Key of
  VK_NUMPAD4 : ToRight.Click;
  VK_NUMPAD6 : ToLeft.Click;
  VK_NUMPAD2 : ToDown.Click;
  VK_NUMPAD8 : ToUp.Click;
  VK_NUMPAD3 : CamUp.Click;
  VK_NUMPAD9 : CamDown.Click;
  VK_NUMPAD1 : CamRight.Click;
  VK_NUMPAD7 : CamLeft.Click;
  VK_NUMPAD0 : RoundLeft.Click;
  VK_SEPARATOR,VK_DECIMAL: RoundRight.Click;
  VK_ADD     : ZoomIn.Click;
  VK_SUBTRACT: ZoomOut.Click;
  VK_DIVIDE  : Sink.Click;
  VK_MULTIPLY: Lift.Click;
  219   : /// [
  begin
   if ssShift in Shift then fScale:=fScale*16 else fScale:=fScale*2;
   FillUpData;
   ShowData;
  end;
  221   : /// ]
  begin
   if ssShift in Shift then fScale:=fScale/16 else fScale:=fScale/2;
   FillUpData;
   ShowData;
  end;

  VK_NUMPAD5 :
  begin
//   ViewPoint:=Vector(10,0,0);
   ViewDir:=Neg(ViewPoint); Norm(ViewDir);
   ViewUp:=Vector(0,0,1);Norm(ViewUp);
   ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
   ViewUp:=PVector(ViewRight,ViewDir); Norm(ViewUp);
//   phi:=2*PI/360;
//   Scale:=1000;
   ShowData;
  end;
 end;
 if ssAlt in Shift then phi:=phi/10;
 SB.Panels[3].Text:= Format('f: %e',[fScale]);
end;

procedure TMainForm.CamDownClick(Sender: TObject);
begin
// ViewDir:=Mul(RotMatrix(ViewRight,-phi),ViewDir);
// ViewUp:=PVector(ViewRight,ViewDir); Norm(ViewUp);
 Basis.vdata[2]:=ViewDir; Basis.vdata[3]:=ViewRight; Basis.vdata[1]:=ViewUp;
 RotateBasis(Basis,phi);
 ViewDir:=Basis.Vdata[2]; ViewRight:=Basis.vdata[3]; ViewUp:=Basis.vdata[1];
 ShowData;
end;

procedure TMainForm.CamUpClick(Sender: TObject);
begin
// ViewDir:=Mul(RotMatrix(ViewRight,phi),ViewDir);
// ViewUp:=PVector(ViewRight,ViewDir); Norm(ViewUp);
 Basis.vdata[2]:=ViewDir; Basis.vdata[3]:=ViewRight; Basis.vdata[1]:=ViewUp;
 RotateBasis(Basis,-phi);
 ViewDir:=Basis.Vdata[2]; ViewRight:=Basis.vdata[3]; ViewUp:=Basis.vdata[1];
 ShowData;
end;

procedure TMainForm.CamLeftClick(Sender: TObject);
begin
// ViewUp:=Mul(RotMatrix(ViewDir,phi),ViewUp);
// ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
 Basis.vdata[3]:=ViewDir; Basis.vdata[1]:=ViewRight; Basis.vdata[2]:=ViewUp;
 RotateBasis(Basis,phi);
 ViewDir:=Basis.Vdata[3]; ViewRight:=Basis.vdata[1]; ViewUp:=Basis.vdata[2];
 ShowData;
end;

procedure TMainForm.CamRightClick(Sender: TObject);
begin
// ViewUp:=Mul(RotMatrix(ViewDir,-phi),ViewUp);
// ViewRight:=PVector(ViewDir,ViewUp); Norm(ViewRight);
 Basis.vdata[3]:=ViewDir; Basis.vdata[1]:=ViewRight; Basis.vdata[2]:=ViewUp;
 RotateBasis(Basis,-phi);
 ViewDir:=Basis.Vdata[3]; ViewRight:=Basis.vdata[1]; ViewUp:=Basis.vdata[2];
 ShowData;
end;

procedure TMainForm.RoundLeftClick(Sender: TObject);
var r:TMatrix;
    cphi,sphi:extended;
begin
 cphi:=cos(phi); sphi:=sin(phi);
 r.vdata[1]:=Vector( cphi, sphi,   0);
 r.vdata[2]:=Vector(-sphi, cphi,   0);
 r.vdata[3]:=Vector(    0,    0,   1);
 ViewPoint:=Neg(Mul(r,Neg(ViewPoint)));
 ViewDir:=Mul(r,ViewDir);
 ViewUp:=Mul(r,ViewUp);
 ViewRight:=Mul(r,ViewRight);
 ShowData;
end;

procedure TMainForm.RoundRightClick(Sender: TObject);
var r:TMatrix;
    cphi,sphi:extended;
begin
 cphi:=cos(-phi); sphi:=sin(-phi);
 r.vdata[1]:=Vector( cphi, sphi,   0);
 r.vdata[2]:=Vector(-sphi, cphi,   0);
 r.vdata[3]:=Vector(    0,    0,   1);
 ViewPoint:=Neg(Mul(r,Neg(ViewPoint)));
 ViewDir:=Mul(r,ViewDir);
 ViewUp:=Mul(r,ViewUp);
 ViewRight:=Mul(r,ViewRight);
 ShowData;
end;

procedure TMainForm.LiftClick(Sender: TObject);
begin
 ViewPoint.Z:=ViewPoint.Z+0.1;
 ShowData;
end;

procedure TMainForm.SinkClick(Sender: TObject);
begin
 ViewPoint.Z:=ViewPoint.Z-0.1;
 ShowData;
end;
procedure TMainForm.BMP1Click(Sender: TObject);
var a:TMyBitmap;
    i,j,k:integer;
    x,y,z:extended;
    c:xRGB;
    fname:string;
const PSIZEX=256;
      PSIZEY=256;
begin
 SaveDialog1.FilterIndex:=2;
 if not SaveDialog1.Execute then exit;
 Fname:=SaveDialog1.FileName;
 a:=TMyBitmap.Create(PSIZEX,PSIZEY,24);
 pbar.max:=PSIZEX; pbar.position:=0;
 for i:=0 to PSIZEX-1 do
 begin
  for j:=0 to PSIZEY-1 do
  begin
   x:=minx+i/PSIZEX*(maxx-minx);
   y:=miny+j/PSIZEY*(maxy-miny);
   z:=NowDraw(x,y)/fscale;
//   k:=Round((z-NowDrawMin)/(NowDrawMax-NowDrawMin)*15+1);
//   c:=MyPalette[k];
   c:=ContinualColor(z,NowDrawMin,NowDrawMax);
   a.PutPixel(i,j,c);
  end;
  pbar.stepit;
 end;
 a.savetofile(fname);
end;

procedure TMainForm.DAT1Click(Sender: TObject);
var f:TextFile;
    i,j,k:integer;
    x,y,z:extended;
    c:xRGB;
    fname:string;
const PSIZEX=100;
      PSIZEY=100;
begin
 AssignFile(F,'a.dat'); rewrite(f);
 for i:=0 to PSIZEX do
 begin
  for j:=0 to PSIZEY do
  begin
   x:=minx+i/PSIZEX*(maxx-minx);
   y:=miny+j/PSIZEY*(maxy-miny);
   z:=NowDraw(x,y)/fscale;
   writeln(f,format('%10.8f',[z]));
//   k:=Round((z-NowDrawMin)/(NowDrawMax-NowDrawMin)*15+1);
//   c:=MyPalette[k];
//   c:=ContinualColor(z,NowDrawMin,NowDrawMax);
//   a.PutPixel(i,j,c);
  end;
  pbar.stepit;
 end;
 closefile(f);
// a.savetofile(fname);
end;

function TMainForm.IsInside(x, y: extended; e: integer): boolean;
var n:TMyPoint;
begin
 n.X:=x;
 n.Y:=y;
   if  (area(n,
             Mesh.points[Mesh.Elements[e].i],
             Mesh.points[Mesh.Elements[e].j]) >= 0.0) and
       (area(n,
             Mesh.points[Mesh.Elements[e].j],
             Mesh.points[Mesh.Elements[e].k]) >= 0.0) and
      (area(n,
             Mesh.points[Mesh.Elements[e].k],
             Mesh.points[Mesh.Elements[e].i]) >= 0.0) then
   Result:=True else Result:=False;
end;

//
// Рисование стрелки к элементу
// ============================
procedure TMainForm.DrawArrow
 (Canvas : TCanvas;
  Back,
  Head
          :  TPoint);
const
AHAngle  // ArrowHead angle, rad
         :  Double = 0.3;
AHLength // ArrowHead Length
         :  Double = 15;
var
x1, y1, x2, y2: Integer;
al,
adx,
ady,
x,
y,
sina,
cosa  //
      :  Double;
Arrow // К
      :  array [0..2] of TPoint;
begin
x1:=Back.X;
y1:=Back.Y;
x2:=Head.X;
y2:=Head.Y;
adx:=x1-x2;
ady:=y1-y2;
al:=sqrt(sqr(adx)+sqr(ady));
//
// SetLength(Arrow,3);
adx:=adx/al*AHLength;
ady:=ady/al*AHLength;
sina:=sin(AHAngle);
cosa:=cos(AHAngle);
x:=adx*cosa-ady*sina;
y:=adx*sina+ady*cosa;
Arrow[0].X:=X2;
Arrow[0].Y:=Y2;
Arrow[1].X:=X2+Round(x);
Arrow[1].Y:=Y2+Round(y);
x:=adx*cosa+ady*sina;
y:=-adx*sina+ady*cosa;
Arrow[2].X:=X2+Round(x);
Arrow[2].Y:=Y2+Round(y);
Canvas.MoveTo(x1,y1);
Canvas.LineTo(x2,y2);
Canvas.Brush.Color:=clRed;
Canvas.Polygon(Arrow);
end;


procedure TMainForm.DrawAxis;
var
    ArrowStart,
    ArrowFinish : TVector;
    x,y:Extended;
    p1,p2 : TVector;
    d1,d2:Extended;
    ScreenPlane:TPlane;
    sa,ea : TPoint;
begin
 ScreenPlane:=Plane(Sum(ViewPoint,ViewDir),ViewDir);
 ArrowStart.x:=0;
 ArrowStart.y:=0;
 ArrowStart.z:=0;

 ArrowFinish.x:=StrToFloat(edAxisLength.Text);
 ArrowFinish.y:=0;
 ArrowFinish.z:=0;

 Intersect(ScreenPlane,ViewPoint,Sub(ArrowStart,ViewPoint),p1,d1);
 Intersect(ScreenPlane,ViewPoint,Sub(ArrowFinish,ViewPoint),p2,d2);

 x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
 sa.x:=round(image1.Width div 2 + x*scale);
 sa.y:=round(image1.Height div 2 - y*scale);

 x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
 ea.x:=round(image1.Width div 2 + x*scale);
 ea.y:=round(image1.Height div 2 - y*scale);

 Image1.Canvas.Brush.Color:=clWhite;
 Image1.Canvas.TextOut(ea.x,ea.y+4,'x_1');
 DrawArrow(Image1.Canvas,sa,ea);

 ArrowStart.x:=0;
 ArrowStart.y:=0;
 ArrowStart.z:=0;

 ArrowFinish.x:=0;
 ArrowFinish.y:=StrToFloat(edAxisLength.Text);
 ArrowFinish.z:=0;

 Intersect(ScreenPlane,ViewPoint,Sub(ArrowStart,ViewPoint),p1,d1);
 Intersect(ScreenPlane,ViewPoint,Sub(ArrowFinish,ViewPoint),p2,d2);

 x:=PScalar(ViewRight,Sub(p1,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p1,Sum(ViewPoint,ViewDir)));
 sa.x:=round(image1.Width div 2 + x*scale);
 sa.y:=round(image1.Height div 2 - y*scale);

 x:=PScalar(ViewRight,Sub(p2,Sum(ViewPoint,ViewDir)));
 y:=PScalar(ViewUp   ,Sub(p2,Sum(ViewPoint,ViewDir)));
 ea.x:=round(image1.Width div 2 + x*scale);
 ea.y:=round(image1.Height div 2 - y*scale);

 Image1.Canvas.Brush.Color:=clWhite;
 Image1.Canvas.TextOut(ea.x,ea.y+4,'x_2');
 DrawArrow(Image1.Canvas,sa,ea);

end;

procedure TMainForm.MenuShowPsi0Click(Sender: TObject);
begin
 NowDraw:=Psi0;
// NowDrawMin:=GMinn1;
// NowDrawMax:=Gmaxn1;
// MenuShowN2.Checked:=false;
// MenuShowN1.checked:=False;
 FillUpData;
 ShowData;
end;

function TMainForm.Psi(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.Psi[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Psi[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Psi[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

function TMainForm.Psi0(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.Psi0[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Psi0[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Psi0[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

procedure TMainForm.MenuShowDiffPsiClick(Sender: TObject);
begin
 NowDraw:=DiffPsi;
// NowDrawMin:=GMinn1;
// NowDrawMax:=Gmaxn1;
// MenuShowN2.Checked:=false;
// MenuShowN1.checked:=False;
 FillUpData;
 ShowData;
end;

function TMainForm.DiffPsi(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.DiffPsi[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.DiffPsi[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.DiffPsi[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

procedure TMainForm.MenuShowSigma13Click(Sender: TObject);
begin
 NowDraw:=Sigma13;
 FillUpData;
 ShowData;

end;

procedure TMainForm.MenuShowSigma23Click(Sender: TObject);
begin
 NowDraw:=Sigma23;
 FillUpData;
 ShowData;

end;

function TMainForm.Sigma13(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.Sigma13[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Sigma13[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Sigma13[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

function TMainForm.Sigma23(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh.Sigma23[Mesh.Elements[e].i]*(Mesh.Elements[e].ai+Mesh.Elements[e].bi*P.x+Mesh.Elements[e].ci*P.y)+
     Mesh.Sigma23[Mesh.Elements[e].j]*(Mesh.Elements[e].aj+Mesh.Elements[e].bj*P.x+Mesh.Elements[e].cj*P.y)+
     Mesh.Sigma23[Mesh.Elements[e].k]*(Mesh.Elements[e].ak+Mesh.Elements[e].bk*P.x+Mesh.Elements[e].ck*P.y)
     )/Mesh.Elements[e].A/2;
end;

procedure TMainForm.mult1Click(Sender: TObject);
var i: integer;
begin
 for i:=0 to 359 do
 begin
  RoundRight.Click;
  Image1.Picture.SaveToFile('mult'+IntToStr(1000+i)+'.bmp'); 
 end;
end;

procedure TMainForm.edAxisLengthKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_RETURN then ShowData;
end;

procedure TMainForm.N21Click(Sender: TObject);
var Fname:string;
    f:TextFile;
    e,i:integer;
    si,sj,sk:integer;
    V,Ve:extended;
    h,x,y:extended;
    p:TMyPoint;
    ClusterSizeX,
    ClusterSizeY : Integer;
    cx,cy:integer;
begin
 if not OpenDialog1.Execute then exit;
 Fname:=OpenDialog1.FileName;
 Fname:=copy(fname,1,length(fname)-2);

 AssignFile(f,fname+'.n'); Reset(f);
 Readln(f,mesh2.NumPoints);
 SetLength(mesh2.Points,mesh2.NumPoints);
 lpbar.caption:='Считываем точки';lpbar.Refresh;
 pbar.max:=mesh2.NumPoints;pbar.Position :=0;
 for i:=0 to mesh2.NumPoints-1 do
 begin
  readln(f,mesh2.Points[i].x,mesh2.Points[i].y,mesh2.points[i].mark);
  if i=0 then begin maxx:=mesh2.Points[i].x; maxy:=mesh2.Points[i].y; minx:=maxx; miny:=maxy; end;
  maxx:=max(mesh2.Points[i].x,maxx);
  maxy:=max(mesh2.Points[i].y,maxy);
  minx:=min(mesh2.Points[i].x,minx);
  miny:=min(mesh2.Points[i].y,miny);
  pbar.StepIt ;
 end;
 closefile(f);

 SetLength(LastFound2,round(sqrt(mesh2.NumPoints)*1.2));
 for i:=0 to Length(LastFound2)-1 do LastFound2[i]:=-1;
 LastLost2:=0;

 AssignFile(f,fname+'.s'); Reset(f);
 Readln(f,mesh2.NumSides);
 SetLength(mesh2.Sides,mesh2.NumSides);
 lpbar.caption:='Считываем стороны';lpbar.Refresh;
 pbar.max:=mesh2.NumSides;pbar.Position :=0;
 for i:=0 to mesh2.NumSides-1 do
 begin
  pbar.StepIt;
  readln(f,mesh2.Sides[i].n1,mesh2.Sides[i].n2,mesh2.Sides[i].ea,mesh2.Sides[i].eb,mesh2.Sides[i].nx,mesh2.Sides[i].ny,
   mesh2.sides[i].mark);
 end;
 closefile(f);

 // Инициализация кластеров
 ClusterSizeX:=10;
 ClusterSizeY:=10;
 SetLength(Clusters,ClusterSizeX*ClusterSizeY);
 for cx:=0 to ClusterSizeX-1 do
 for cy:=0 to ClusterSizeY-1 do
 with Clusters[cx+cy*ClusterSizeX] do
 begin
  sx:=minx+cx*(maxx-minx)/ClusterSizeX;
  sy:=miny+cy*(maxy-miny)/ClusterSizey;
  ex:=minx+(cx+1)*(maxx-minx)/ClusterSizeX;
  ey:=miny+(cy+1)*(maxy-miny)/ClusterSizey;
  SetLength(Elements,0);
 end;

 AssignFile(f,fname+'.e'); Reset(f);
 Readln(f,mesh2.NumElements);
 SetLength(mesh2.Elements,mesh2.NumElements);
 setlength(mesh2.cell,mesh2.numpoints);
 lpbar.caption:='Считываем элементы'; lpbar.refresh;
 pbar.max:=mesh2.NumElements;pbar.Position :=0;
 for i:=0 to mesh2.numpoints-1 do mesh2.cell[i]:=0;
 for i:=0 to mesh2.NumElements -1 do
 begin
   read(f,mesh2.Elements[i].i,mesh2.Elements[i].j,mesh2.Elements[i].k);
   read(f,mesh2.Elements[i].ei,mesh2.Elements[i].ej,mesh2.Elements[i].ek);
   read(f,mesh2.Elements[i].si,mesh2.Elements[i].sj,mesh2.Elements[i].sk);
   read(f,mesh2.Elements[i].mark);
   read(f,mesh2.Elements[i].A);
   read(f,mesh2.Elements[i].ai,mesh2.Elements[i].bi,mesh2.Elements[i].ci);
   read(f,mesh2.Elements[i].aj,mesh2.Elements[i].bj,mesh2.Elements[i].cj);
   read(f,mesh2.Elements[i].ak,mesh2.Elements[i].bk,mesh2.Elements[i].ck);
   mesh2.Elements[i].mx:=1/3*(
    mesh2.Points[mesh2.Elements[i].i].x+
    mesh2.Points[mesh2.Elements[i].j].x+
    mesh2.Points[mesh2.Elements[i].k].x);
   mesh2.Elements[i].my:=1/3*(
    mesh2.Points[mesh2.Elements[i].i].y+
    mesh2.Points[mesh2.Elements[i].j].y+
    mesh2.Points[mesh2.Elements[i].k].y);
   si:=mesh2.Elements[i].si;
   sj:=mesh2.Elements[i].sj;
   sk:=mesh2.Elements[i].sk;
   if mesh2.Sides[sk].N1=mesh2.Elements[i].i then mesh2.Sides[sk].ea:=i else mesh2.Sides[sk].eb:=i;
   if mesh2.Sides[sj].N1=mesh2.Elements[i].k then mesh2.Sides[sj].ea:=i else mesh2.Sides[sj].eb:=i;
   if mesh2.Sides[si].N1=mesh2.Elements[i].j then mesh2.Sides[si].ea:=i else mesh2.Sides[si].eb:=i;
   mesh2.cell[mesh2.elements[i].i]:=mesh2.cell[mesh2.elements[i].i]+mesh2.elements[i].A;
   mesh2.cell[mesh2.elements[i].j]:=mesh2.cell[mesh2.elements[i].j]+mesh2.elements[i].A;
   mesh2.cell[mesh2.elements[i].k]:=mesh2.cell[mesh2.elements[i].k]+mesh2.elements[i].A;
   {
   mesh2.cell[mesh2.elements[i].i]:=mesh2.cell[mesh2.elements[i].i]+1;
   mesh2.cell[mesh2.elements[i].j]:=mesh2.cell[mesh2.elements[i].j]+1;
   mesh2.cell[mesh2.elements[i].k]:=mesh2.cell[mesh2.elements[i].k]+1;
   }
   // заполнение кластеров
   x:=mesh2.Points[mesh2.Elements[i].i].x;
   y:=mesh2.Points[mesh2.Elements[i].i].y;
   AddToCluster(Clusters,x,y,i);
   x:=mesh2.Points[mesh2.Elements[i].j].x;
   y:=mesh2.Points[mesh2.Elements[i].j].y;
   AddToCluster(Clusters,x,y,i);
   x:=mesh2.Points[mesh2.Elements[i].k].x;
   y:=mesh2.Points[mesh2.Elements[i].k].y;
   AddToCluster(Clusters,x,y,i);
   pbar.StepIt;
 end;
 closefile(f);


 try
  MenuShowPsi0.Enabled := True;
  AssignFile(f,fname+'.psi0'); Reset(f);
  Readln(f,mesh2.NumPoints);
  SetLength(mesh2.Psi0,mesh2.NumPoints);
  lpbar.caption:='Считываем Psi0'; lpbar.refresh;
  pbar.max:=mesh2.NumPoints;pbar.Position :=0;
  for i:=0 to mesh2.NumPoints-1 do
  begin
   readln(f,mesh2.Psi0[i]);
   {
   if i=0 then begin Gmaxn1:=mesh2.N1R[i]; Gminn1:=Gmaxn1; end;
   Gmaxn1:=max(mesh2.N1R[i],Gmaxn1);
   Gminn1:=min(mesh2.N1R[i],GminN1);
   }
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowPsi0.Enabled := False;
 end;

 try
  MenuShowPsi.Enabled := True;
  AssignFile(f,fname+'.psi'); Reset(f);
  Readln(f,mesh2.NumPoints);
  SetLength(mesh2.Psi,mesh2.NumPoints);
  SetLength(mesh2.DiffPsi,mesh2.NumPoints);
  lpbar.caption:='Считываем Psi'; lpbar.refresh;
  pbar.max:=mesh2.NumPoints;pbar.Position :=0;
  for i:=0 to mesh2.NumPoints-1 do
  begin
   readln(f,mesh2.Psi[i]);
   mesh2.DiffPsi[i]:=mesh2.Psi[i]-mesh2.Psi0[i];
   {
   if i=0 then begin Gmaxn1:=mesh2.N1R[i]; Gminn1:=Gmaxn1; end;
   Gmaxn1:=max(mesh2.N1R[i],Gmaxn1);
   Gminn1:=min(mesh2.N1R[i],GminN1);
   }
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowPsi.Enabled := False;
 end;

 try
  MenuShowSigma13.Enabled := True;
  MenuShowSigma23.Enabled := True;
  AssignFile(f,fname+'.sigma'); Reset(f);
  Readln(f,mesh2.NumPoints);
  SetLength(mesh2.Sigma13,mesh2.NumPoints);
  SetLength(mesh2.Sigma23,mesh2.NumPoints);
  lpbar.caption:='Считываем Sigma'; lpbar.refresh;
  pbar.max:=mesh2.NumPoints;pbar.Position :=0;
  for i:=0 to mesh2.NumPoints-1 do
  begin
   readln(f,mesh2.Sigma13[i],mesh2.Sigma23[i]);
   pbar.stepit;
  end;
  closefile(f);
 except
  MenuShowSigma13.Enabled := False;
  MenuShowSigma23.Enabled := False;
 end;

 AssignFile(f,fname+'.n1'); Reset(f);
 Readln(f,mesh2.NumPoints);
 SetLength(mesh2.N1R,mesh2.NumPoints);
 lpbar.caption:='Считываем N1'; lpbar.refresh;
 pbar.max:=mesh2.NumPoints;pbar.Position :=0;
 for i:=0 to mesh2.NumPoints-1 do
 begin
  readln(f,mesh2.N1R[i]);
  if i=0 then begin Gmaxn1:=mesh2.N1R[i]; Gminn1:=Gmaxn1; end;
  Gmaxn1:=max(mesh2.N1R[i],Gmaxn1);
  Gminn1:=min(mesh2.N1R[i],GminN1);
  pbar.stepit;
 end;
 closefile(f);

 AssignFile(f,fname+'.n2'); Reset(f);
 Readln(f,mesh2.NumPoints);
 SetLength(mesh2.N2R,mesh2.NumPoints);
 lpbar.caption:='Считываем N2'; lpbar.refresh;
 pbar.max:=mesh2.NumPoints;pbar.Position :=0;
 for i:=0 to mesh2.NumPoints-1 do
 begin
  readln(f,mesh2.N2R[i]);
  if i=0 then begin Gmaxn2:=mesh2.N2R[i]; Gminn2:=Gmaxn2; end;
  Gmaxn2:=max(mesh2.N2R[i],Gmaxn2);
  Gminn2:=min(mesh2.N2R[i],GminN2);
  pbar.Stepit;
 end;
 closefile(f);

 AssignFile(f,fname+'.m'); reset(f);
 Readln(f,mesh2.NumMaterials);
 SetLength(mesh2.Materials,mesh2.NumMaterials);
 for i:=0 to mesh2.NumMaterials-1 do
 begin
  readln(f,mesh2.Materials[i].d11,mesh2.Materials[i].d12,mesh2.Materials[i].d21,mesh2.Materials[i].d22)
 end;
 closefile(f);

 // выставление производных
 setlength(mesh2.dN1dx,mesh2.numpoints);
 setlength(mesh2.dN1dy,mesh2.numpoints);
 setlength(mesh2.dN2dx,mesh2.numpoints);
 setlength(mesh2.dN2dy,mesh2.numpoints);
 for i:=0 to mesh2.numpoints-1 do
 begin
  mesh2.dn1dx[i]:=0;
  mesh2.dn1dy[i]:=0;
  mesh2.dn2dx[i]:=0;
  mesh2.dn2dy[i]:=0;
 end;
end;

function TMainForm.N_1_p(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement2(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh2.N1R[Mesh2.Elements[e].i]*(Mesh2.Elements[e].ai+Mesh2.Elements[e].bi*P.x+Mesh2.Elements[e].ci*P.y)+
     Mesh2.N1R[Mesh2.Elements[e].j]*(Mesh2.Elements[e].aj+Mesh2.Elements[e].bj*P.x+Mesh2.Elements[e].cj*P.y)+
     Mesh2.N1R[Mesh2.Elements[e].k]*(Mesh2.Elements[e].ak+Mesh2.Elements[e].bk*P.x+Mesh2.Elements[e].ck*P.y)
     )/Mesh2.Elements[e].A/2;
end;

function TMainForm.N_2_p(x, y: extended): extended;
var p:TMyPoint;
    e:integer;
begin
 result:=0;
 p.x:=x; p.y:=y;
 e:=InElement2(P);
 if e<0 then exit;

 Result:=fscale*(
     Mesh2.N2R[Mesh2.Elements[e].i]*(Mesh2.Elements[e].ai+Mesh2.Elements[e].bi*P.x+Mesh2.Elements[e].ci*P.y)+
     Mesh2.N2R[Mesh2.Elements[e].j]*(Mesh2.Elements[e].aj+Mesh2.Elements[e].bj*P.x+Mesh2.Elements[e].cj*P.y)+
     Mesh2.N2R[Mesh2.Elements[e].k]*(Mesh2.Elements[e].ak+Mesh2.Elements[e].bk*P.x+Mesh2.Elements[e].ck*P.y)
     )/Mesh2.Elements[e].A/2;
end;

function TMainForm.InElement2(n: TMyPoint): integer;
var i,e:integer;

begin
 result:=-1;
// Result:=ClusterSearch(Clusters,n.X,n.y,IsInside); {
 for i:=0 to Length(LastFound2)-1 do
 begin
  E:=LastFound2[i];
  if e>0 then
  begin
   if  (area(n,
             Mesh2.points[Mesh2.Elements[e].i],
             Mesh2.points[Mesh2.Elements[e].j]) >= 0.0) and
       (area(n,
             Mesh2.points[Mesh2.Elements[e].j],
             Mesh2.points[Mesh2.Elements[e].k]) >= 0.0) and
       (area(n,
             Mesh2.points[Mesh2.Elements[e].k],
             Mesh2.points[Mesh2.Elements[e].i]) >= 0.0)
   then begin result:=e;exit; end;
  end;
 end;
 for e:=0 to  Mesh2.NumElements-1 do
 begin
   if  (area(n,
             Mesh2.points[Mesh2.Elements[e].i],
             Mesh2.points[Mesh2.Elements[e].j]) >= 0.0) and
       (area(n,
             Mesh2.points[Mesh2.Elements[e].j],
             Mesh2.points[Mesh2.Elements[e].k]) >= 0.0) and
       (area(n,
             Mesh2.points[Mesh2.Elements[e].k],
             Mesh2.points[Mesh2.Elements[e].i]) >= 0.0) then
   begin
    LastFound2[LastLost2]:=e;
    inc(LastLost2);
    if LastLost2>=Length(LastFound2) then LastLost2:=0;
    result:=e;
    exit;
   end;
 end;
{ }
end;

procedure TMainForm.A1Click(Sender: TObject);
begin
 NowDraw:=DiffA;
 NowDrawMin:=GMinn1;
 NowDrawMax:=Gmaxn1;
 MenuShowN2.Checked:=false;
 MenuShowN1.checked:=true;
 FillUpData;
 ShowData;
end;

function TMainForm.diffA(x, y: extended): extended;
begin
 Result:=N_1(x,y)-N_1_P(x+1,y+1);
end;

function TMainForm.diffB(x, y: extended): extended;
begin
 Result:=N_1(x,y)-N_1_P(x-1,y+1);
end;

function TMainForm.diffC(x, y: extended): extended;
begin
 Result:=N_1(x,y)-N_1_P(x+1,y-1);
end;

function TMainForm.diffD(x, y: extended): extended;
begin
 Result:=N_1(x,y)-N_1_P(x-1,y-1);
end;

procedure TMainForm.SceneInfo1Click(Sender: TObject);
var i:Integer;
    smax,smin,vol,vola: Extended;

begin
 smax:=Scene[0].v1.p.z;
 smin:=Scene[0].v1.p.z;
 vol:=0;
 vola:=0;
 for i:=0 to Length(Scene)-1 do
 begin
  smax:=max(smax,Scene[i].v1.p.z);
  smax:=max(smax,Scene[i].v2.p.z);
  smax:=max(smax,Scene[i].v3.p.z);
  smin:=min(smin,Scene[i].v1.p.z);
  smin:=min(smin,Scene[i].v2.p.z);
  smin:=min(smin,Scene[i].v3.p.z);
  Vol:=Vol+Area(Scene[i].v1,Scene[i].v2,Scene[i].v3)/3*(Scene[i].v1.p.z+Scene[i].v2.p.z+Scene[i].v3.p.z);
  Vola:=Vola+Abs(Area(Scene[i].v1,Scene[i].v2,Scene[i].v3)/3*(Scene[i].v1.p.z+Scene[i].v2.p.z+Scene[i].v3.p.z));
 end;
 mLog.Lines.Add(Format('Min: %e, Max: %e, vol: %e, vola: %e',[smin/fscale,smax/fscale,vol/fscale,vola/fscale]));

end;

function TMainForm.area(na, nb, nc: TScenePoint): extended;
begin
 Result:=0.5* ((nb.p.x-na.p.x)*(nc.p.y-na.p.y)-(nb.p.y-na.p.y)*(nc.p.x-na.p.x));
end;

procedure TMainForm.B1Click(Sender: TObject);
begin
 NowDraw:=DiffB;
 NowDrawMin:=GMinn1;
 NowDrawMax:=Gmaxn1;
 MenuShowN2.Checked:=false;
 MenuShowN1.checked:=true;
 FillUpData;
 ShowData;

end;

procedure TMainForm.C1Click(Sender: TObject);
begin
 NowDraw:=DiffC;
 NowDrawMin:=GMinn1;
 NowDrawMax:=Gmaxn1;
 MenuShowN2.Checked:=false;
 MenuShowN1.checked:=true;
 FillUpData;
 ShowData;

end;

procedure TMainForm.D1Click(Sender: TObject);
begin
 NowDraw:=DiffD;
 NowDrawMin:=GMinn1;
 NowDrawMax:=Gmaxn1;
 MenuShowN2.Checked:=false;
 MenuShowN1.checked:=true;
 FillUpData;
 ShowData;
end;

procedure TMainForm.cbLightningClick(Sender: TObject);
begin
// FillUpData;
 ShowData;
end;

end.
