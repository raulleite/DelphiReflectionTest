unit uControlEntity;

interface

uses
  uEntity;

type
  TControlEntity = class
  public
    class function getEntity(codEntity: Integer): TEntity;
  end;

implementation

uses
  uMainConn,
  uConnSingleton,
  System.SysUtils;

class function TControlEntity.getEntity(codEntity: Integer): TEntity;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;

const
  WHERE = ' where CODENTITY = %d';
begin
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getObject<TEntity>(String.Format(WHERE,
                                                       [codEntity]));
  finally
    FreeAndNil(mainConn);
  end;
end;


end.
