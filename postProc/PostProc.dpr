program PostProc;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
