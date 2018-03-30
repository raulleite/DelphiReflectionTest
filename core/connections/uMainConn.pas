unit uMainConn;

interface

uses
  Dialogs,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset,
  ZConnection,
  uIConnection,
  System.UITypes,
  System.SysUtils,
  System.Generics.Collections;

type
  TMainConn = class(TInterfacedObject, IConnection)
  public
    fConnection: TZConnection;

    constructor Create(connection: TZConnection);
    destructor Destroy; override;

    function startTransaction: Boolean;
    function commitTransaction: Boolean;

    function getObject<T: Class>(where: String): T;
    function getListObject<T: Class>(where: String): TList<T>;

    function saveObject<T: Class>(obj: T): Boolean;
    function saveListObject<T: Class>(listObj: TList<T>): Boolean;

    function updateObject<T: Class>(obj: T): Boolean;
    function updateListObject<T: Class>(listObj: TList<T>): Boolean;

    function deleteObject<T: Class>(obj: T): Boolean;
    function deleteListObject<T: Class>(listObj: TList<T>): Boolean;
  end;

implementation

uses
  uLibObj,
  uLibSql,
  System.Rtti;

constructor TMainConn.Create(connection: TZConnection);
begin
  fConnection:= connection;
end;

destructor TMainConn.Destroy;
begin
  if (fConnection.InTransaction) then
    fConnection.Rollback;

  if (fConnection.Connected) then
    fConnection.Disconnect;

  FreeAndNil(fConnection);
end;

function TMainConn.startTransaction;
begin
  Result:= False;
  try
    if (fConnection = nil) then
      raise Exception.Create('A conexão com o banco de dados não foi definida');

    if (fConnection.InTransaction) then
      raise Exception.Create('A conexão com o banco de dados não foi definida');

    fConnection.StartTransaction;

    Result:= True;
  except
    On E : Exception do
      MessageDlg('Falha ao abrir transação:'#13#10 + e.Message,
                 mtWarning,
                 [mbOK],
                 0);
  end;
end;

function TMainConn.commitTransaction;
begin
  Result:= False;
  try
    if (fConnection.InTransaction) then
      fConnection.Commit;

    Result:= True;
except
    On E : Exception do
    begin
      if (fConnection.InTransaction) then
        fConnection.Rollback;

      MessageDlg('Falha ao efetuar commit na transação:'#13#10 + e.Message,
                 mtWarning,
                 [mbOK],
                 0);
    end;
  end;
end;

function TMainConn.getObject<T>(where: String): T;
var
  qryGet     : TZQuery;
  rttiContext: TRttiContext;
begin
  Result:= nil;

  try
    qryGet:= TZQuery.Create(nil);
    qryGet.Connection:= fConnection;
    qryGet.SQL.Text:= TLibSql<T>.getSqlSelect + where;
    qryGet.Open;

    if (qryGet.RecordCount > 0) then
    begin
      if (qryGet.RecordCount > 1) then
        raise Exception.Create(String.Format('Pesquisa trouxe mais de um registro para: %s'#13#10'%s',
                                             [rttiContext.GetType(TypeInfo(T)).Name,
                                              where]));
      Result:= TLibObj<T>.fillObject(qryGet);
    end;
  finally
    FreeAndNil(qryGet);
  end;
end;

function TMainConn.getListObject<T>(where: String): TList<T>;
var
  qryGet     : TZQuery;
  rttiContext: TRttiContext;
begin
  Result:= nil;

  try
    qryGet:= TZQuery.Create(nil);
    qryGet.Connection:= fConnection;
    qryGet.SQL.Text:= TLibSql<T>.getSqlSelect + where;
    qryGet.Open;

    if (qryGet.RecordCount > 0) then
    begin
      Result:= TList<T>.Create;

      while (not qryGet.Eof) do
      begin
        Result.Add(TLibObj<T>.fillObject(qryGet));
        qryGet.Next;
      end;
    end;
  finally
    FreeAndNil(qryGet);
  end;
end;

function TMainConn.saveObject<T>(obj: T): Boolean;
begin
  Result:= False;

end;

function TMainConn.saveListObject<T>(listObj: TList<T>): Boolean;
var
  obj: T;
begin
  Result:= False;

  for obj in listObj do
    Self.saveObject(obj);
end;

function TMainConn.updateObject<T>(obj: T): Boolean;
begin
  Result:= False;

end;

function TMainConn.updateListObject<T>(listObj: TList<T>): Boolean;
var
  obj: T;
begin
  Result:= False;

  for obj in listObj do
    Self.updateObject(obj);
end;

function TMainConn.deleteObject<T>(obj: T): Boolean;
begin
  Result:= False;

end;

function TMainConn.deleteListObject<T>(listObj: TList<T>): Boolean;
var
  obj: T;
begin
  Result:= False;

  for obj in listObj do
    Self.deleteObject(obj);
end;

end.
