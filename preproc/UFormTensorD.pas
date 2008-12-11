unit UFormTensorD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type

  TMaterial=record
    d11,d12,d21,d22:double;
  end;
  TMatArray=array of TMaterial;

  TFormTensorD = class(TForm)
    D11: TEdit;
    D12: TEdit;
    D21: TEdit;
    D22: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PrevBtn: TBitBtn;
    BitBtn2: TBitBtn;
    NextBtn: TBitBtn;
    Label5: TLabel;
    MaterialID: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure D11Change(Sender: TObject);
    procedure D21Change(Sender: TObject);
    procedure D12Change(Sender: TObject);
    procedure D22Change(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FlagBadData:boolean;
    { Private declarations }
    procedure EnableButtons;
    procedure ShowData;
  public
    { Public declarations }
    Data:TMatArray;
    CurMat:integer;
  end;

var
  FormTensorD: TFormTensorD;

implementation

{$R *.DFM}

procedure TFormTensorD.FormCreate(Sender: TObject);
begin
 Data:=nil;
 CurMat:=-1;
 FlagBadData:=false;
end;

procedure TFormTensorD.FormShow(Sender: TObject);
begin
 FlagBadData:=false;
// EnableButtons;
{
 if length(Data)=0 then
 begin
  ShowMessage('Не задана ни одна метка материала');
//  application.ProcessMessages;
  self.Close;
  modalresult:=mrCancel;

  exit;
 end;
}
 CurMat:=0;
 EnableButtons;
 ShowData;
end;
function CheckFloat(const s:string):boolean;
var i:integer;
begin
 result:=false;
 for i:=1 to length(s) do if not (s[i] in ['.','-','0'..'9']) then exit;
 result:=true;
end;
procedure TFormTensorD.D11Change(Sender: TObject);
begin
 if not CheckFloat(D11.Text) then exit;
 Data[CurMat].D11:=strtofloat(D11.Text);
end;

procedure TFormTensorD.D21Change(Sender: TObject);
begin
 if not CheckFloat(D21.Text) then exit;
 Data[CurMat].D21:=strtofloat(D21.Text);

end;

procedure TFormTensorD.D12Change(Sender: TObject);
begin
 if not CheckFloat(D12.Text) then exit;
 Data[CurMat].D12:=strtofloat(D12.Text);
end;

procedure TFormTensorD.D22Change(Sender: TObject);
begin
 if not CheckFloat(D22.Text) then exit;
 Data[CurMat].D22:=strtofloat(D22.Text);
end;

procedure TFormTensorD.PrevBtnClick(Sender: TObject);
begin
 if CurMat>0 then dec(CurMat);
 EnableButtons;
 ShowData;
 MaterialID.caption:=inttostr(CurMat);
end;

procedure TFormTensorD.NextBtnClick(Sender: TObject);
begin
 if CurMat<length(data)-1 then inc(CurMat);
 EnableButtons;
 ShowData;
 MaterialID.caption:=inttostr(CurMat);
end;

procedure TFormTensorD.EnableButtons;
begin
 if CurMat>0 then PrevBtn.Enabled:=true else PrevBtn.Enabled:=false;
 if curmat<length(data)-1 then NextBtn.enabled:=true else NExtBtn.enabled:=false;
end;

procedure TFormTensorD.BitBtn2Click(Sender: TObject);
begin
 modalresult:=mrOk;
end;

procedure TFormTensorD.ShowData;
begin
 if FlagBadData then exit;
 D11.Text:=FloatToStr(Data[CurMat].D11);
 D12.Text:=FloatToStr(Data[CurMat].D12);
 D21.Text:=FloatToStr(Data[CurMat].D21);
 D22.Text:=FloatToStr(Data[CurMat].D22);
end;

procedure TFormTensorD.FormPaint(Sender: TObject);
begin
 if not FlagBadData and (length(Data)=0) then
 begin
  FlagBadData:=true;
  ShowMessage('Не задана ни одна метка материала');
//  application.ProcessMessages;
  modalresult:=mrCancel;
//  exit;
 end;

end;

end.
