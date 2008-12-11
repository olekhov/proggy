// 24 bpp supported
unit MyBitmap;

interface

type
 DWord=Longword;
 TMyBitmapHeader=packed record
  Signature: Word;
  FileLength: DWord;
  Zero:DWord;
  Ptr:DWord;
  Version:DWord;
  Width:DWord;
  Height:DWord;
  Planes:Word;
  BitsPerPixel:Word;
  Compression:DWord;
  SizeImage:DWord;
  XPelsPerMeter:DWord;
  YPelsPerMeter:DWord;
  ClrUsed:DWord;
  ClrImportant:DWord;
 end;

 xRGB=packed record
  b,g,r: byte;
 end;
 

 TMyBitmap=class
 private
  Hdr: TMyBitmapHeader;
  Data: array of byte;
  RealWidth: DWord;
 public
  constructor Create(x,y:DWord; BPP:Word);
  constructor LoadFromFile(const fname:string);
  procedure SaveTofile(const fname:string);
  destructor Destroy; override;   
  procedure PutPixel(x,y:DWord; c: xRGB);
  function GetPixel(x,y:DWord):xRGB;
  property Width : DWord read Hdr.Width; 
  property Height : DWord read Hdr.Height; 
 end;
const
 xRGB_Black:xRGB=(b:0;g:0;r:0);
 xRGB_White:xRGB=(b:255;g:255;r:255);
 MyPalette:array[1..16] of xRGB=(
  (B:36; G:50; R:239),
  (B:33; G:111; R:244),
  (B:21; G:172; R:250),
  (B:10; G:219; R:247),
  (B:38; G:218; R:199),
  (B:65; G:194; R:117),
  (B:79; G:175; R:26),
  (B:110; G:167; R:0),
  (B:158; G:169; R:0),
  (B:206; G:170; R:0),
  (B:219; G:154; R:0),
  (B:193; G:120; R:0),
  (B:166; G:83; R:13),
  (B:149; G:54; R:59),
  (B:134; G:30; R:30),
  (B:121; G:20; R:20)
//  (B:139; G:10; R:213)
 );
function BlendColor(c1,c2:xRGB;alpha:extended):xRGB;
function ContinualColor(z,min,max:extended):xRGB;
implementation
Uses SysUtils;
type PxRGB= ^xRGB;
{ TMyBitmap }
constructor TMyBitmap.Create(x, y: DWord; BPP: Word);
begin
 if BPP<>24 then raise Exception.Create('Only 24bpp supported');
 inherited Create;
 Hdr.Signature := $4d42;
 Hdr.Width := x; Hdr.Height := y;
 Hdr.Zero := 0; Hdr.BitsPerPixel :=BPP;
 x:=x*3;
 if x mod 4 <>0 then x:=x+(4-(x mod 4));
 RealWidth:=x;
 Hdr.ClrImportant:=0; Hdr.ClrUsed:=0;
 Hdr.Compression:=0; Hdr.FileLength := RealWidth*y+256;
 Hdr.Planes:=1; Hdr.Ptr:=256; Hdr.SizeImage:=RealWidth*y;
 Hdr.Version:=$28; Hdr.XPelsPerMeter:=0;
 Hdr.YPelsPerMeter :=0;
 SetLength(data,Hdr.SizeImage);
end;

destructor TMyBitmap.Destroy;
begin
 Data:=nil;
 inherited;
end;

function TMyBitmap.GetPixel(x, y: DWord): xRGB;
var p:PxRGB;
begin
 p:=@(data[x*3+y*RealWidth]);
 result:=p^;
end;

procedure TMyBitmap.PutPixel(x, y: DWord; c: xRGB);
var p:PxRGB;
begin
 p:=@(data[x*3+y*RealWidth]);
 p^:=c;
end;

constructor TMyBitmap.LoadFromFile(const fname: string);
var f:file;
begin
 AssignFile(f,fname); reset(f,1);
 blockread(f,Hdr,sizeof(Hdr));
 if Hdr.Signature <>$4d42 then raise Exception.Create('Not a BMP file');
 if Hdr.BitsPerPixel <> 24 then raise Exception.Create('Only 24bpp supported');
 inherited Create;
 Seek(f,Hdr.Ptr);
 RealWidth:=Hdr.Width*3;
 if RealWidth mod 4 <>0 then RealWidth:=RealWidth+(4-(RealWidth mod 4));
 Hdr.SizeImage:=RealWidth*Hdr.Height;
 SetLength(data,Hdr.SizeImage);
 blockread(f,data[0],Hdr.SizeImage );
 closefile(f);
end;

procedure TMyBitmap.SaveTofile(const fname: string);
var f:file;
begin
 AssignFile(f,fname); rewrite(f,1);
 blockwrite(f,Hdr,sizeof(Hdr));
 Seek(f,Hdr.Ptr);
 blockwrite(f,data[0],Hdr.SizeImage );
 closefile(f);
end;
function BlendColor(c1,c2:xRGB;alpha:extended):xRGB;
begin
 result.r:=round(c1.r*alpha+c2.r*(1-alpha));
 result.g:=round(c1.g*alpha+c2.g*(1-alpha));
 result.b:=round(c1.b*alpha+c2.b*(1-alpha));
end;

function ContinualColor(z,min,max:extended):xRGB;
var k: integer;
    d: extended;
begin
 d:=(max-min)/15;
 k:=Trunc(15*(z-min)/(max-min));
 z:=(z-(k)*d-min)/d;
 Result:=BlendColor(MyPalette[k+1],MyPalette[k+2],1-z);
end;
end.
