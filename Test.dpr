program Test;

uses
  Vcl.Forms,
  uFMain in 'uFMain.pas' {frmMain},
  uIConnection in 'core\interfaces\uIConnection.pas',
  uEntity in 'models\uEntity.pas',
  uMainConn in 'core\connections\uMainConn.pas',
  uLibObj in 'core\libs\uLibObj.pas',
  uAttributes in 'core\attributes\uAttributes.pas',
  uLibSql in 'core\libs\uLibSql.pas',
  uControlEntity in 'controllers\uControlEntity.pas',
  uMovement in 'models\uMovement.pas',
  uItemMovement in 'models\uItemMovement.pas',
  uItem in 'models\uItem.pas',
  uControlMovement in 'controllers\uControlMovement.pas',
  uConnSingleton in 'core\connections\uConnSingleton.pas',
  uControlItemMovement in 'controllers\uControlItemMovement.pas',
  uControlItem in 'controllers\uControlItem.pas',
  uStock in 'models\uStock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
