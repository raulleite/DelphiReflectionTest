unit uMainConn;

interface

uses
  Dialogs,
  Data.SqlExpr,
  DBXCommon,
  uIConnection,
  System.UITypes,
  System.SysUtils,
  System.Generics.Collections;

type
  TMainConn = class(TInterfacedObject, IConnection)
  private
    fConnection : TSQLConnection;
    fTransaction: TTransactionDesc;
    function getQuery: TSQLQuery;
  public
    constructor Create(connection: TSQLConnection);
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

constructor TMainConn.Create(connection: TSQLConnection);
begin
  fConnection:= connection;
end;

destructor TMainConn.Destroy;
begin
  if (fConnection.InTransaction) then
    fConnection.Rollback(fTransaction);

  if (fConnection.Connected) then
    fConnection.CloneConnection;

  FreeAndNil(fConnection);
end;

function TMainConn.getQuery: TSQLQuery;
begin
  Result:= TSQLQuery.Create(nil);
  Result.SQLConnection:= fConnection;
end;

function TMainConn.startTransaction;
begin
  Result:= False;
  try
    if (fConnection = nil) then
      raise Exception.Create('A conexão com o banco de dados não foi definida');

    if (fConnection.InTransaction) then
      raise Exception.Create('A conexão com o banco de dados não foi definida');

    fConnection.StartTransaction(fTransaction);

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
      fConnection.Commit(fTransaction);

    Result:= True;
  except
    On E : Exception do
    begin
      if (fConnection.InTransaction) then
        fConnection.Rollback(fTransaction);

      MessageDlg('Falha ao efetuar commit na transação:'#13#10 + e.Message,
                 mtWarning,
                 [mbOK],
                 0);
    end;
  end;
end;

function TMainConn.getObject<T>(where: String): T;
var
  qryGet     : TSQLQuery;
  rttiContext: TRttiContext;
begin
  Result:= nil;

  try
    qryGet:= Self.getQuery;
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
  qryGet     : TSQLQuery;
  rttiContext: TRttiContext;
begin
  Result:= nil;

  try
    qryGet:= Self.getQuery;
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
var
  qryGet     : TSQLQuery;
  rttiContext: TRttiContext;
begin
  Result:= False;

  try
    qryGet:= Self.getQuery;
    qryGet.SQLConnection:= fConnection;
    qryGet.SQL.Text:= TLibSql<T>.getSqlInsert;

    TLibObj<T>.fillQuery(obj, qryGet);
    qryGet.ExecSQL;

    Result:= True
  finally
    FreeAndNil(qryGet);
  end;
end;

function TMainConn.saveListObject<T>(listObj: TList<T>): Boolean;
var
  obj: T;
begin
  Result:= False;

  for obj in listObj do
    Self.saveObject(obj);

  Result:= True;
end;

function TMainConn.updateObject<T>(obj: T): Boolean;
var
  qryGet     : TSQLQuery;
  rttiContext: TRttiContext;
begin
  Result:= False;

  try
    qryGet:= Self.getQuery;
    qryGet.SQL.Text:= TLibSql<T>.getSqlUpdate;

    TLibObj<T>.fillQuery(obj, qryGet);
    qryGet.ExecSQL;

    Result:= True
  finally
    FreeAndNil(qryGet);
  end;
end;

function TMainConn.updateListObject<T>(listObj: TList<T>): Boolean;
var
  obj: T;
begin
  Result:= False;

  for obj in listObj do
    Self.updateObject(obj);

  Result:= True;
end;

function TMainConn.deleteObject<T>(obj: T): Boolean;
var
  qryGet     : TSQLQuery;
  rttiContext: TRttiContext;
begin
  Result:= False;

  try
    qryGet:= Self.getQuery;
    qryGet.SQL.Text:= TLibSql<T>.getSqlDelete;

    TLibObj<T>.fillQuery(obj, qryGet, True);
    qryGet.ExecSQL;

    Result:= True
  finally
    FreeAndNil(qryGet);
  end;
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
