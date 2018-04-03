unit uControlItemMoviment;

interface

uses
  uItemMoviment,
  System.Generics.Collection;

type
  TControlItemMoviment = class
  public
    class function getItemMoviment(codItemMoviment: Integer): TItemMoviment;
    class function getListItemMoviment(codMoviment: Integer): TList<TItemMoviment>;
  end;

implementation

uses
  uMainConn,
  uEntity,
  uItemMoviment,
  uConnSingleton,
  uControlEntity,
  System.SysUtils;

class function TControlMoviment.getMoviment(codMoviment: Integer): TMoviment;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;

const
  WHERE = ' where CodMoviment = %d';
begin
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getObject<TMoviment>(String.Format(WHERE,
                                                         [codMoviment]));

    Result.Entity:= TControlEntity.getEntity(Result.CodEntity);

    Result.ListItems:= mainConn.getListObject<TItemMoviment>(String.Format(WHERE,
                                                                           [codMoviment]));
  finally
    FreeAndNil(mainConn)
  end;
end;

end.

