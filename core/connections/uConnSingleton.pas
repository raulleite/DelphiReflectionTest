unit uConnSingleton;

interface

uses
  Data.SqlExpr,
  Data.DBXFirebird,
  System.IniFiles,
  System.SysUtils;

type
  TConnSingleton = class
  private
    fIniFile: TIniFile;
    constructor Create;
  public
    class function newInstance: TObject; override;
    class function getInstance: TConnSingleton;
    function getConnection: TSQLConnection;
  end;

var
  Instance: TConnSingleton;

implementation

uses
  Vcl.Forms;

{ TConnSingleton }

constructor TConnSingleton.Create;
var
  configPath: String;
begin
  configPath:= ChangeFileExt(Application.ExeName, '.ini');

  if (not FileExists(configPath)) then
    raise Exception.Create('Arquivo "INI" de configurações, não presente na pasta do projeto');

  fIniFile:= TIniFile.Create(configPath);
end;

class function TConnSingleton.newInstance: TObject;
begin
  if (not Assigned(Instance)) then
    Instance:= TConnSingleton(inherited newInstance);

  Result:= Instance;
end;

class function TConnSingleton.getInstance: TConnSingleton;
begin
  Result:= TConnSingleton.Create;
end;

function TConnSingleton.getConnection: TSQLConnection;
const
  SECTION = 'Conn';
begin
  Result:= TSQLConnection.Create(nil);
  Result.DriverName     := fIniFile.ReadString(SECTION, 'Protocol', '');
  Result.LoginPrompt    := False;
  Result.Params.Clear;
  Result.Params.Add(String.Format('DriverName=%s',
                                  [fIniFile.ReadString(SECTION, 'Protocol', '')]));
  Result.Params.Add(String.Format('Database=%s',
                                  [fIniFile.ReadString(SECTION, 'Database', '')]));
  Result.Params.Add(String.Format('User_Name=%s',
                                  [fIniFile.ReadString(SECTION, 'User', '')]));
  Result.Params.Add(String.Format('Password=%s',
                                  [fIniFile.ReadString(SECTION, 'Password', '')]));
  Result.Params.Add('RoleName=RoleName');
  Result.Params.Add('ServerCharSet=');
  Result.Params.Add('SQLDialect=3');
  Result.Params.Add('LocaleCode=0000');
  Result.Params.Add('BlobSize=-1');
  Result.Params.Add('CommitRetain=False');
  Result.Params.Add('WaitOnLocks=True');
  Result.Params.Add('IsolationLevel=ReadCommitted');
  Result.Params.Add('Trim Char=False');
end;


initialization

finalization
  FreeAndNil(Instance);

end.

