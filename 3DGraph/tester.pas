uses ugeometry;
var RotMat1,r:TMatrix;
	phi:extended;
	i,j:integer;
begin
 phi:=pi/12;
 RotMat1.vdata[1]:=Vector(sin(phi),cos(phi),0);
 RotMat1.vdata[2]:=Vector(-cos(phi),sin(phi),0);
 RotMat1.vdata[3]:=Vector(0,0,1);
 for i:=1 to 3 do
 begin
  for j:=1 to 3 do
   write(RotMat1.data[i,j]:10:7,' ');
  writeln;
 end;
 writeln('-----------');
 r:=RotMat1;
 for i:=1 to 5 do
 r:=Mul(r,RotMat1);
 for i:=1 to 3 do
 begin
  for j:=1 to 3 do
   write(r.data[i,j]:10:7,' ');
  writeln;
 end;

end.