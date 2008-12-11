unit UClusterSearch;

interface
type

  TCluster= record
   sx,sy,ex,ey : Extended;
   Elements : array of Integer;
  end;

  InElementFunc = function (x,y:Extended; E:integer): boolean of object;

  TClusters = array of TCluster;

function ClusterSearch(const Clusters: TClusters; x,y:Extended; InElement: InElementFunc): Integer;
procedure AddToCluster(var Clusters:TClusters; x,y:Extended; E:Integer);
function FindCluster(const Clusters:TClusters; x,y:Extended):Integer;

implementation
uses Forms, Dialogs;
function FindCluster(const Clusters:TClusters; x,y:Extended):Integer;
var i:  Integer;
begin
 Result:=-1;
 for i:=0 to Length(Clusters)-1 do
 begin
  if x< Clusters[i].sx then continue;
  if x> Clusters[i].ex then continue;
  if y< Clusters[i].sy then continue;
  if y> Clusters[i].ey then continue;
  Result:=i; break;
 end;
// if Result<0 then ShowMessage('Achtung!');
end;

function ClusterSearch(const Clusters: TClusters; x,y:Extended; InElement: InElementFunc): Integer;
var i,
    C // Индекс кластера
      :  Integer;
begin
 Result:=-1;
 C:=FindCluster(Clusters,x,y);
 if C<0 then Exit;
 for i:=0 to Length(Clusters[C].Elements)-1 do
 begin
  if InElement(x,y,Clusters[C].Elements[i]) then
  begin
   Result:=Clusters[C].Elements[i];
   Exit;
  end;
 end;
end;

procedure AddToCluster(var Clusters:TClusters; x,y:Extended; E:Integer);
var i:Integer;
    C:TCluster;
begin
 i:=FindCluster(Clusters,x,y);
 if i<0 then Exit;
 C:=Clusters[i];
 for i:=0 to LEngth(C.Elements )-1 do
 begin
  if C.Elements [i]=E then exit;
 end;
 i:=LEngth(C.Elements);
 SetLength(C.Elements,i+1);
 C.Elements[i]:=E;
end;

end.
