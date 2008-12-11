unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons,UFormTensorD,math;

type

  TMyPoint = record
    X,Y: Double;
    mark:integer;
    F:double;
  end;

  TSide = record
    N1,N2:integer;
    mark:integer;
  end;

  TMark = record
    X,Y: Double;
    M:integer;
  end;


  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    SaveDialog1: TSaveDialog;
    Image1: TImage;
    ZoomIn: TBitBtn;
    ZoomOut: TBitBtn;
    ToLeft: TBitBtn;
    ToRight: TBitBtn;
    ToUp: TBitBtn;
    ToDown: TBitBtn;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    SB: TStatusBar;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    edtNowPoint: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    OpenDialog1: TOpenDialog;
    Label5: TLabel;
    Edit7: TEdit;
    edtNowPointMark: TEdit;
    Edit9: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    D1: TMenuItem;
    Label8: TLabel;
    edtNowSideMark: TEdit;
    N16: TMenuItem;
    procedure N6Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddPoint(X,Y:Integer);
    procedure DeletePoint(n:integer);
    procedure AddSide(n1,n2:Integer);
    procedure DeleteSide(n:integer);
    procedure AddMark(X,Y:Integer);
    procedure DeleteMark(n:integer);
    function FindPoint(X,Y:Integer) :integer;
    function FindSide(X,Y:Integer) :integer;
    function FindMark(X,Y:Integer) :integer;
    procedure ShowData;
    procedure N13Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure edtNowPointKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ToLeftClick(Sender: TObject);
    procedure ToRightClick(Sender: TObject);
    procedure ToUpClick(Sender: TObject);
    procedure ToDownClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure edtNowPointMarkKeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure D1Click(Sender: TObject);
    procedure edtNowSideMarkKeyPress(Sender: TObject; var Key: Char);
    procedure N16Click(Sender: TObject);
  private
    { Private declarations }
    Points   : array of TMyPoint;
    Sides    : array of TSide;
    Marks    : array of TMark;
    Materials: TMatArray;
    NumPoints,
    NumSides,
    NumMarks,
    NumMaterials : integer;

    NowDraw  : integer; // 0 - точки, 1 - отрезки, 2 - метки
    NowPoint,
    NowSide,
    NowMark  : integer;
    curmark : integer;
    curF: double;
    ViewX, ViewY : double;
    Zoom : double;

    ShowPoints,
    ShowPNum,
    ShowSides,
    ShowSNum,
    ShowMarks,
    ShowMNum,
    ShowMat     :boolean;
  procedure Load(const fname:string);
  procedure Save(const fname:string);
  procedure BatchInsert;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses ClipBrd;
{$R *.DFM}

procedure TMainForm.N6Click(Sender: TObject);
begin
  Application.MessageBox('Программа для задания начальных условий,'+^M^J+
                         'построения областей и задания свойств материалов.',
                         'О программе.',0);
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
 Self.Close;
end;

procedure TMainForm.N2Click(Sender: TObject);
var Fname:string;
begin
 if not OpenDialog1.Execute then exit;
 Fname:=OpenDialog1.FileName;
 Load(Fname);
end;

procedure TMainForm.N3Click(Sender: TObject);
var Fname:string;
begin
 if not SaveDialog1.Execute then exit;
 Fname:=SaveDialog1.FileName;
 Save(Fname);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 Image1.Canvas.FloodFill(0,0,clWhite,fsSurface);
 SetLength(Points,4000); NumPoints :=0;
 SetLength(Sides,20000);  NumSides :=0;
 SetLength(Marks,100);   NumMarks :=0;
 SetLength(Materials,100); NumMaterials:=0;
 Zoom:= 100;
 ViewX:=0; ViewY:=0;
 ShowPoints:=true;
 ShowPNum:=true;
 ShowSides:=true;
 ShowSNum:=false;
 ShowMarks:=true;
 ShowMNum:=true;
 curmark:=1;
 curf:=0.1;
 NowDraw:=0;
 NowPoint:=0; NowSide:=0;
 Image1.Canvas.Font.name:='sans serif';
 Image1.Canvas.Font.size:=8;
 if paramcount>0 then Load(paramstr(1));
end;

procedure TMainForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NewPoint:integer;
begin
 Activecontrol:=nil;
 if ssShift in Shift then
 begin
  if NowDraw=0 then AddPoint(X,Y) else
  if NowDraw=1 then
  begin
   NewPoint:=FindPoint(X,Y);
   AddSide(NowPoint,NewPoint);
   NowPoint:=NewPoint;
  end else
  if NowDraw=2 then AddMark(X,Y);
 end else
 if ssAlt in Shift then
 begin        
  if NowDraw=1 then NowPoint:=FindPoint(x,y);
//  if curmark>1 then inc(curmark);
 end else
 if NowDraw=0 then
 begin
  NowPoint:=FindPoint(x,y);
  if nowpoint>=0 then
  begin
   curf:=points[nowpoint].f;
   curmark:=points[nowpoint].mark;
  end
 end else
 if NowDraw=1 then
 begin
  NowSide:=FindSide(x,y);
  if nowside>=0 then
  begin
   curmark:=sides[nowside].mark;
  end
 end else
 if NowDraw=2 then NowMark:=FindMark(x,y);
 ShowData;
end;

procedure TMainForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var NewX,NewY:double;
    T:string;
begin
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 str(NewX:7:5,T); SB.Panels[3].text:='X:'+T;
 str(NewY:7:5,T); SB.Panels[4].text:='Y:'+T;
end;

procedure TMainForm.AddMark(X, Y: Integer);
var NewX,NewY:double;
begin
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 NowMark:=NumMarks;
 Inc(NumMarks);
 Marks[NumMarks-1].x:=newx;
 Marks[NumMarks-1].y:=newy;
end;

procedure TMainForm.AddPoint(X, Y: Integer);
var NewX,NewY:double;
begin
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 NowPoint:=NumPoints;
 Inc(NumPoints);
 Points[NumPoints-1].x:=newx;
 Points[NumPoints-1].y:=newy;
 points[numpoints-1].f:=curf;
 points[numpoints-1].mark:=curmark;
end;

procedure TMainForm.AddSide(n1, n2: Integer);
begin
 if n1=n2 then
 begin
  ShowMessage('Неправильный отрезок');
  exit;
 end;
 NowSide:=Numsides;
 Inc(NumSides);
 Sides[NumSides-1].n1:=n1;
 Sides[NumSides-1].n2:=n2;
 sides[numsides-1].mark:=curmark;
end;

procedure TMainForm.ShowData;
var i:integer;
    x,y,x2,y2:integer;
    s:string;
    Newx,newy:double;
    P1,P2:TMyPoint;
    bnd:array of TPoint;
begin
 Edit7.Enabled:=false;
 Image1.Canvas.Brush.Color:=clWhite;
 Image1.Canvas.FillRect(Image1.ClientRect);

 SB.Panels[0].text:='Точек: '+IntToStr(NumPoints);
 SB.Panels[1].text:='Отрезков: '+IntToStr(NumSides);
 SB.Panels[2].text:='Меток: '+IntToStr(NumMarks);

 if NowPoint>=0 then
 begin
  edtNowPoint.Text:=IntToStr(NowPoint);
  edtNowPointMark.text:=inttostr(points[nowpoint].mark);
 end;

 if NowSide>=0 then
 begin
  edtNowSideMark.text:=inttostr(sides[nowside].mark);
 end;

 if NowDraw=0 then
 if (NumPoints>0) and (NowPoint>=0) then
 begin
  Newx:=Points[NowPoint].x;
  Newy:=Points[NowPoint].y;
  str(Newx:7:5,s); Edit1.Text:=s;
  str(Newy:7:5,s); Edit2.Text:=s;
  str(points[nowpoint].f:7:5,s);
  edit9.text:=s;
 end;

 if NowDraw=2 then
 if (NumMarks>0) and (NowMark>=0) then
 begin
  Newx:=Marks[NowMark].x;
  Newy:=Marks[NowMark].y;
  str(Newx:7:5,s); Edit1.Text:=s;
  str(Newy:7:5,s); Edit2.Text:=s;
  edtNowPoint.Text:=IntToStr(NowMark);
  Edit7.Enabled:=true;
  Edit7.Text:=IntToStr(Marks[NowMark].M);
 end;

 if (NumSides>0) and (NowSide>=0) then
 begin
  Edit4.Text:=IntToStr(NowSide);
  Edit5.Text:=IntToStr(Sides[NowSide].N1);
  Edit6.Text:=IntToStr(Sides[NowSide].N2);
 end;

 if ShowPoints then
 begin
  for i:=0 to NumPoints-1 do
  begin
    X:=Round((Points[i].x-ViewX)*Zoom+Image1.Width/2);
    Y:=Round(-(Points[i].y-ViewY)*Zoom+Image1.Height/2);
    if i=NowPoint then Image1.Canvas.Brush.Color:=clRed;
    Image1.Canvas.Ellipse(X-2,y-2,x+2,y+2);
    Image1.Canvas.Brush.Color:=clWhite;
    if ShowPNum then
    begin
      s:=inttostr(i);
      Image1.Canvas.TextOut(x+4,y-14,s);
    end;
  end;
 end;

 Image1.Canvas.Pen.Color:=clBlack;
 if ShowSides then
 begin
  for i:=0 to NumSides-1 do
  begin
    P1:=Points[Sides[i].N1];
    P2:=Points[Sides[i].N2];
    X:=Round((P1.x-ViewX)*Zoom+Image1.Width/2);
    Y:=Round(-(P1.y-ViewY)*Zoom+Image1.Height/2);
    X2:=Round((P2.x-ViewX)*Zoom+Image1.Width/2);
    Y2:=Round(-(P2.y-ViewY)*Zoom+Image1.Height/2);

    if i=NowSide then Image1.Canvas.Pen.Color:=clRed;
    Image1.Canvas.MoveTo(x,y);
    Image1.Canvas.LineTo(x2,y2);
    Image1.Canvas.Pen.Color:=clBlack;
    if ShowSNum then
    begin
      s:=inttostr(i);
      Image1.Canvas.TextOut((x+x2) div 2,(y+y2) div 2,s);
    end;
  end;
 end;

 if ShowMarks then
 begin
  for i:=0 to NumMarks-1 do
  begin
    X:=Round((Marks[i].x-ViewX)*Zoom+Image1.Width/2);
    Y:=Round(-(Marks[i].y-ViewY)*Zoom+Image1.Height/2);
    if i=NowMark then Image1.Canvas.Brush.Color:=clRed;
    Image1.Canvas.Rectangle(X-2,y-2,x+2,y+2);
    Image1.Canvas.Brush.Color:=clWhite;
    if ShowMNum then
    begin
      s:=inttostr(i);
      Image1.Canvas.TextOut(x+2,y-6,s);
    end;
  end;
 end;

end;

procedure TMainForm.N13Click(Sender: TObject);
begin
 N13.Checked:=not N13.Checked;
 ShowPoints:=N13.Checked;
 N17.Checked:=N13.Checked;
 ShowData;
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
 N17.Checked:=not N17.Checked;
 ShowPNum:=N17.Checked;
 ShowData;
end;

procedure TMainForm.N14Click(Sender: TObject);
begin
 N14.Checked:=not N14.Checked;
 ShowSides:=N14.Checked;
 N18.Checked:=N14.Checked;
 ShowData;
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
 N18.Checked:=not N18.Checked;
 ShowSNum:=N18.Checked;
 ShowData;
end;

function TMainForm.FindMark(X, Y: Integer): integer;
var NewX,NewY:double;
    R,Rmin:double;
    i,imin:integer;
begin
 Result:=-1;
 if NumMarks=0 then exit;
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 Rmin:=(Marks[0].x-newx)*(Marks[0].x-newx)+(Marks[0].y-newy)*(Marks[0].y-newy);
 imin:=0;
 for i:=1 to NumMarks-1 do
 begin
  R:=(Marks[i].x-newx)*(Marks[i].x-newx)+(Marks[i].y-newy)*(Marks[i].y-newy);
  if R<Rmin then begin Rmin:=R; imin:=i; end;
 end;
 result:=imin;
end;

function TMainForm.FindPoint(X, Y: Integer): integer;
var NewX,NewY:double;
    R,Rmin:double;
    i,imin:integer;
begin
 Result:=-1;
 if NumPoints=0 then exit;
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 Rmin:=(Points[0].x-newx)*(Points[0].x-newx)+(Points[0].y-newy)*(Points[0].y-newy);
 imin:=0;
 for i:=1 to NumPoints-1 do
 begin
  R:=(Points[i].x-newx)*(Points[i].x-newx)+(Points[i].y-newy)*(Points[i].y-newy);
  if R<Rmin then begin Rmin:=R; imin:=i; end;
 end;
 result:=imin;
end;

function Rho(x1,y1,x2,y2,x0,y0:double):double;
var t:double;
begin
  t:=((x0-x1)*(x2-x1)+(y0-y1)*(y2-y1))/(sqr(x2-x1)+sqr(y2-y1));
  if t<=0 then
  begin
   result:=sqr(x0-x1)+sqr(y0-y1);
   exit;
  end;
  if t>=1.0 then
  begin
   result:=sqr(x0-x2)+sqr(y0-y2);
   exit;
  end;
  result:= -1/(sqr(x2-x1)+sqr(y2-y1))*sqr((x1-x0)*(x2-x1)+(y1-y0)*(y2-y1))+sqr(x0-x1)+sqr(y0-y1);
end;

function TMainForm.FindSide(X, Y: Integer): integer;
var NewX,NewY:double;
    R,Rmin:double;
    i,imin:integer;
begin
 Result:=-1;
 if NumSides=0 then exit;
 NewX:=(x-Image1.Width/2)/Zoom+ViewX;
 NewY:=(-Y+Image1.Height/2)/Zoom+ViewY;
 Rmin:=Rho(Points[Sides[0].N1].x,Points[Sides[0].N1].y,Points[Sides[0].N2].x,Points[Sides[0].N2].y,newx,newy);
 imin:=0;
 for i:=1 to NumSides-1 do
 begin
  R:=Rho(Points[Sides[i].N1].x,Points[Sides[i].N1].y,Points[Sides[i].N2].x,Points[Sides[i].N2].y,newx,newy);
  if R<Rmin then begin Rmin:=R; imin:=i; end;
 end;
 result:=imin;
end;

procedure TMainForm.edtNowPointKeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  s:=edtNowPoint.Text;
  for i:=1 to length(s) do if not (s[i] in ['0'..'9']) then exit;
  if Nowdraw=0 then val(s,NowPoint,i) else
  if nowdraw=2 then val(s,NowMark,i);
  if NowDraw=0 then if NowPoint>=NumPoints then NowPoint:=NumPoints-1;
  if NowDraw=2 then if NowMark>=NumMarks then NowMark:=NumMarks-1;
  ShowData;
 end;
end;

procedure TMainForm.Edit1KeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  s:=Edit1.Text;
  for i:=1 to length(s) do if not (s[i] in ['-','+','.','0'..'9']) then exit;
  if NowDraw=0 then val(s,Points[NowPoint].X,i) else
  if Nowdraw=2 then val(s,Marks[NowMark].X,i);
  ShowData;
 end;
end;

procedure TMainForm.Edit2KeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  s:=Edit2.Text;
  for i:=1 to length(s) do if not (s[i] in ['-','+','.','0'..'9']) then exit;
  if NowDraw=0 then val(s,Points[NowPoint].Y,i) else
  if Nowdraw=2 then val(s,Marks[NowMark].Y,i);
  ShowData;
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

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if ActiveControl=Edit1 then exit;
 if ActiveControl=Edit2 then exit;
 if ActiveControl=edtNowPoint then exit;
 if ActiveControl=Edit4 then exit;
 if ActiveControl=Edit5 then exit;
 if ActiveControl=Edit6 then exit;
 if ActiveControl=Edit7 then exit;
 if ActiveControl=edtNowPointMark then exit;
 if ActiveControl=edtNowSideMark then exit;
 if ActiveControl=Edit9 then exit;
 if NowDraw=0 then
  if key=VK_DELETE then DeletePoint(NowPoint);
 if NowDraw=0 then
  if key=VK_INSERT then BatchInsert;
 if NowDraw=1 then
  if key=VK_DELETE then DeleteSide(NowSide);
 if NowDraw=2 then
  if key=VK_DELETE then DeleteMark(NowMark);
 ShowData;
end;

procedure TMainForm.DeletePoint(n: integer);
begin
 if n<0 then exit;
 if n>=NumPoints then exit;
 Points[n]:=Points[NumPoints-1];
 dec(NumPoints);
end;

procedure TMainForm.DeleteSide(n: integer);
begin
 if n<0 then exit;
 if n>=NumSides then exit;
 Sides[n]:=Sides[NumSides-1];
 dec(NumSides);
end;

procedure TMainForm.DeleteMark(n: integer);
begin
 if n<0 then exit;
 if n>=NumMarks then exit;
 Marks[n]:=Marks[NumMarks-1];
 dec(NumMarks);
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
 NowDraw:=1;
 N10.Checked:=true;
 ShowData;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
 NowDraw:=0;
 N9.Checked:=true;
 ShowData;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
 NowDraw:=2;
 N11.Checked:=true;
 ShowData;
end;


procedure TMainForm.N15Click(Sender: TObject);
begin
 N15.Checked:=not N15.Checked;
 ShowMarks:=N15.Checked;
 N19.Checked:=N15.Checked;
 ShowData;
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
 N19.Checked:=not N19.Checked;
 ShowMNum:=N19.Checked;
 ShowData;
end;

procedure TMainForm.Edit7KeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  s:=Edit7.Text;
  for i:=1 to length(s) do if not (s[i] in ['0'..'9']) then exit;
  val(s,Marks[NowMark].M,i);
  ShowData;
 end;
end;

procedure TMainForm.edtNowPointMarkKeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  if NowPoint<0 then Exit;
  s:=edtNowPointMark.Text;
  for i:=1 to length(s) do if not (s[i] in ['0'..'9']) then exit;
  val(s,curmark,i);
  Points[NowPoint].Mark:=CurMark;
 end;
end;

procedure TMainForm.Edit9KeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  s:=Edit9.Text;
  for i:=1 to length(s) do if not (s[i] in ['-','+','.','0'..'9']) then exit;
  val(s,curf,i);
  if NowDraw=0 then Points[NowPoint].F:=CurF;
 end;
end;

procedure TMainForm.D1Click(Sender: TObject);
var i:integer;
begin
 NumMaterials:=-1;
 for i:=0 to NumMarks-1  do
   NumMaterials:=max(NumMaterials,Marks[i].M);
 if NumMaterials=-1 then
 begin
  ShowMessage('Не задано ни одной метки');
  exit;
 end;
 inc(NumMaterials);
 FormTensorD.Data:=Materials;
 SetLength(FormTensorD.Data,NumMaterials);
 if FormTensorD.ShowModal<>mrOk then begin { showmessage('ибо нефиг');}exit;end;
 for i:=0 to NumMaterials-1 do
  Materials[i]:=FormTensorD.Data[i];
end;


procedure TMainForm.Load(const fname: string);
var f:TextFile;
    i:integer;
begin
 AssignFile(f,fname); Reset(f);
 Readln(f,NumPoints);
 Readln(f,NumSides);
 Readln(f,NumMarks);
 for i:=0 to NumPoints-1 do readln(f,Points[i].x,Points[i].y,points[i].f,points[i].mark);
 for i:=0 to NumSides-1 do readln(f,Sides[i].n1,Sides[i].n2,sides[i].mark);
 for i:=0 to NumMarks-1 do readln(f,Marks[i].x,Marks[i].y,Marks[i].M);

 closefile(f);
 {$I-}
 AssignFile(f,copy(fname,1,length(fname)-2)+'.m'); reset(f);
 {$I+}
 if IOResult=0 then
 begin
 readln(f,NumMaterials);
 for i:=0 to NumMaterials-1 do readln(f,Materials[i].d11,Materials[i].d12,
                                        Materials[i].d12,Materials[i].d22);

 closefile(f);
 end else NumMaterials:=0;
 Nowpoint:=Numpoints-1;
 Nowside:=Numsides-1;
 Nowmark:=nummarks-1;
 Showdata;
end;

procedure TMainForm.Save(const fname: string);
var f:TextFile;
    i:integer;
begin
 AssignFile(f,fname); ReWrite(f);
 writeln(f,NumPoints);
 Writeln(f,NumSides);
 Writeln(f,NumMarks);
 for i:=0 to NumPoints-1 do writeln(f,Points[i].x,' ',Points[i].y,' ',points[i].f,' ',points[i].mark);
 for i:=0 to NumSides-1 do writeln(f,Sides[i].n1:3,' ',Sides[i].n2:3,' ',sides[i].mark);
 for i:=0 to NumMarks-1 do writeln(f,Marks[i].x,' ',Marks[i].y,' ',Marks[i].M);

 closefile(f);
 AssignFile(f,copy(fname,1,length(fname)-2)+'.m'); rewrite(f);

 writeln(f,NumMaterials);
 for i:=0 to NumMaterials-1 do writeln(f,Materials[i].d11,' ',Materials[i].d12,' ',
                                         Materials[i].d12,' ',Materials[i].d22);

 closefile(f);
end;

procedure TMainForm.BatchInsert;
var S     :TStringList;
    v:string;
    Count, sp : Integer;
    x,y: extended;
begin
 if not Clipboard.HasFormat (CF_TEXT) then
 begin
  Application.MessageBox('Буфер не содержит координат','Ошибка',MB_ICONHAND + MB_OK);
  Exit;
 end;
 S:=TStringList.Create;
 S.CommaText := Clipboard.AsText;
 x:=0; y:=0;
 for Count:=0 to S.Count div 2-1 do
 begin
  v:=S[Count*2];
  x:=StrToFloatDef(v,-7777);
  if x=-7777 then break;
  v:=S[Count*2+1];
  y:=StrToFloatDef(v,-7777);
  if y=-7777 then break;
  NowPoint:=NumPoints;
  Inc(NumPoints);
  Points[NumPoints-1].x:=x;
  Points[NumPoints-1].y:=y;
  points[numpoints-1].f:=curf;
  points[numpoints-1].mark:=curmark;
 end;
 S.Free;
 Clipboard.Clear;
end;

procedure TMainForm.edtNowSideMarkKeyPress(Sender: TObject; var Key: Char);
var s:string;
    i:integer;
begin
 if Key =#13 then
 begin
  if NowSide<0 then Exit;
  s:=edtNowSideMark.Text;
  for i:=1 to length(s) do if not (s[i] in ['0'..'9']) then exit;
  val(s,curmark,i);
  Sides[NowSide].Mark:=CurMark;
 end;
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
 Image1.Picture.LoadFromFile('a.bmp'); 
end;

end.
