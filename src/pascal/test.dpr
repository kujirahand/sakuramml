program test;

uses
  Forms,
  testUnit in 'testUnit.pas' {Form1},
  mci_cmd in 'mci_cmd.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
