program Test;

uses
  Vcl.Forms,
  uFMain in 'uFMain.pas' {Form1},
  uIConnection in 'core\interfaces\uIConnection.pas',
  uEntity in 'models\uEntity.pas',
  uMainConn in 'core\connections\uMainConn.pas',
  uLibObj in 'core\libs\uLibObj.pas',
  uAttributes in 'core\attributes\uAttributes.pas',
  uLibSql in 'core\libs\uLibSql.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
