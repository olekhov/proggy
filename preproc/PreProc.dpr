program PreProc;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {MainForm},
  UFormTensorD in 'UFormTensorD.pas' {FormTensorD};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTensorD, FormTensorD);
  Application.Run;
end.
