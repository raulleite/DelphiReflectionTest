unit uControlItem;

interface

uses
  uItem;

type
  TControlItem = class
  public
    class function getItem(codItem: Integer): TItem;
  end;

implementation

uses
  uMainConn,
  uEntity,
  uConnSingleton,
  uControlEntity,
  System.SysUtils;

class function TControlItem.getItem(codItem: Integer): TItem;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;

const
  WHERE = ' where CodItem = %d';
begin
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getObject<TItem>(String.Format(WHERE,
                                                     [codItem]));
  finally
    FreeAndNil(mainConn)
  end;
end;

end.

