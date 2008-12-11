program Surf;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {MainForm},
  UGeometry in 'UGeometry.pas',
  MyBitmap in 'MyBitmap.pas',
  IntegerList in 'IntegerList.pas',
  UClusterSearch in 'UClusterSearch.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
