unit UGeometry;

interface
type
  TVector= packed record
   case integer of
    0: (x,y,z:extended);
    1: (data:array [1..3] of extended);
  end;
  TMatrix=packed record
   case integer of
    0: (data: array [1..3,1..3] of extended);
    1: (vdata: array [1..3] of TVector);
  end;
  TLine=record
   Ord,Dir :TVector;
  end;
  TPlane=record
   A,B,C,D : extended;
   Ord,Norm: TVector;
  end;
function Vector(x,y,z:extended):TVector; overload;
function Vector(x:extended):TVector; overload;
function PScalar(v1,v2:TVector):extended; overload;
function PScalar(v1:TVector;a:extended):TVector; overload;
function PVector(v1,v2:TVector):TVector;
function Sum(v1,v2:TVector):TVector;
function Sub(v1,v2:TVector):TVector;
function Neg(v:TVector):TVector;
procedure Add(var v1:TVector; v2:TVector);
procedure Norm(var v:TVector);

function Matrix(x:extended):TMatrix;
function Mul(m:TMatrix;v:TVector):TVector; overload;
function RotMatrix(v:TVector; phi:extended):TMatrix;
function Mul(m1,m2:TMatrix):TMatrix; overload;

function Plane(Ord,N:TVector):TPlane; overload;
function Plane(A,B,C,D:extended):TPlane; overload;

function Line(O,D:TVector):TLine;

//function Intersect(p:TPlane;l:TLine;var pt:TVector; var dist:extended):boolean;
function Intersect(p:TPlane;ord,dir:TVector;var pt:TVector; var dist:extended):boolean;

procedure RotateBasis(var Basis:TMatrix;phi:extended);
implementation
function Vector(x,y,z:extended):TVector;
begin
 result.x:=x;
 result.y:=y;
 result.z:=z;
end;
function Vector(x:extended):TVector;
begin
 result:=Vector(x,x,x);
end;
function PScalar(v1,v2:TVector):extended;
begin
 result:=v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
end;
function PScalar(v1:TVector;a:extended):TVector;
begin
 result:=Vector(v1.x*a,v1.y*a,v1.z*a);
end;
function PVector(v1,v2:TVector):TVector;
begin
 result.x:=v1.y*v2.z-v2.y*v1.z;
 result.y:=v1.z*v2.x-v2.z*v1.x;
 result.z:=v1.x*v2.y-v2.x*v1.y;
end;
function Sum(v1,v2:TVector):TVector;
begin
 result:=Vector(v1.x+v2.x,v1.y+v2.y,v1.z+v2.z);
end;
function Sub(v1,v2:TVector):TVector;
begin
 result:=Vector(v1.x-v2.x,v1.y-v2.y,v1.z-v2.z);
end;
function Neg(v:TVector):TVector;
begin
 result:=Vector(-v.x,-v.y,-v.z);
end;
procedure Add(var v1:TVector; v2:TVector);
begin
 v1:=Sum(v1,v2);
end;
procedure Norm(var v:TVector);
var l:extended;
begin
 l:=sqrt(PScalar(v,v));
 v:=PScalar(v,1/l);
end;
function Matrix(x:extended):TMatrix;
var i,j:integer;
begin
 for i:=1 to 3 do for j:=1 to 3 do result.data[i,j]:=x;
end;
function RotMatrix(v:TVector; phi:extended):TMatrix;
var m1,m2,m1i,m2i,r: TMatrix;
    cphi,sphi:extended;
    sr1,sr2,cr1,cr2,l:extended;
    vp:TVector;
begin
 cphi:=cos(phi); sphi:=sin(phi);
 r.vdata[1]:=Vector( cphi, sphi,   0);
 r.vdata[2]:=Vector(-sphi, cphi,   0);
 r.vdata[3]:=Vector(    0,    0,   1);
 l:=sqrt(v.y*v.y+v.z*v.z);
 if abs(l)>1e-16 then
 begin
  sr1:=v.y/l; cr1:=v.z/l;
 end else begin sr1:=0; cr1:=1; end;
  m1.vdata[1]:=Vector( 1,   0,   0);  m1i.vdata[1]:=Vector( 1,   0,   0);
  m1.vdata[2]:=Vector( 0, cr1, sr1);  m1i.vdata[2]:=Vector( 0, cr1,-sr1);
  m1.vdata[3]:=Vector( 0, -sr1, cr1);  m1i.vdata[3]:=Vector( 0, sr1, cr1);
 vp:=Mul(m1,v);
 l:=sqrt(vp.x*vp.x+vp.z*vp.z);
 if abs(l)>1e-16 then
 begin
  sr2:=-vp.x/l; cr2:=vp.z/l;
 end else begin sr2:=0; cr2:=1; end;
 m2.vdata[1]:=Vector( cr2,   0, sr2);  m2i.vdata[1]:=Vector( cr2,   0, sr2);
 m2.vdata[2]:=Vector(   0,   1,   0);  m2i.vdata[2]:=Vector(   0,   1,   0);
 m2.vdata[3]:=Vector(-sr2,   0, cr2);  m2i.vdata[3]:=Vector(-sr2,   0, cr2);
 Result:=Mul(m1,Mul(m2,Mul(r,Mul(m2i,m1i))));
end;
function Mul(m:TMatrix;v:TVector):TVector;
var i,j:integer;
begin
 for i:=1 to 3 do
 begin
  result.data[i]:=0;
  for j:=1 to 3 do
   result.data[i]:=result.data[i]+m.data[i,j]*v.data[j];
 end;
end;
function Mul(m1,m2:TMatrix):TMatrix;
var i,j,k:integer;
begin
 for i:=1 to 3 do
  for j:=1 to 3 do
  begin
   result.data[i,j]:=0;
   for k:=1 to 3 do
    result.data[i,j]:=result.data[i,j]+m1.data[i,k]*m2.data[k,j];
  end;
end;
function Line(O,D:TVector):TLine;
begin
 result.Ord:=o;
 result.Dir:=D; Norm(result.Dir);
end;

function Plane(Ord,N:TVector):TPlane;
begin
 result.Ord:=ord; Norm(N);
 result.Norm:=N; 
 result.A:=N.x; result.B:=N.y; result.C:=N.z;
 Result.D:=-PScalar(N,Ord);
// result:=Plane(result.A,result.B,result.C,result.D);
end;
function Plane(A,B,C,D:extended):TPlane;
var alpha:extended;
begin
 result.A:=A; Result.B:=B; result.C:=C; result.D:=D;
 result.Norm:=Vector(A,B,C); Norm(result.Norm);
 alpha:=PScalar(result.Norm,Vector(A,B,C));
 alpha:=-D/alpha;
 result.Ord:=PScalar(result.Norm,alpha);
// result:=Plane(result.Ord,Result.Norm);
end;
function Intersect(p:TPlane;ord,dir:TVector;var pt:TVector; var dist:extended):boolean;
var alpha,s:extended;
begin
 s:=PScalar(Dir,p.Norm);
 if abs(s)<1e-16 then begin result:=false; exit; end;
 result:=true;
 alpha:=-(p.D+PScalar(Ord,p.Norm))/s;
 pt:=Sum(Ord,PScalar(Dir,alpha));
// dist:=p.D+PScalar(pt,p.Norm);
 dist:=alpha;
end;
procedure RotateBasis(var Basis:TMatrix;phi:extended);
var r:TMatrix;
    cphi,sphi:extended;
begin
 cphi:=cos(phi); sphi:=sin(phi);
 r.vdata[1]:=Vector( cphi, sphi,   0);
 r.vdata[2]:=Vector(-sphi, cphi,   0);
 r.vdata[3]:=Vector(    0,    0,   1);
 Basis:=Mul(r,Basis);
end;

end.
