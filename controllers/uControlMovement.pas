unit uControlMovement;

interface

uses
  uMovement;

type
  TControlMovement = class
  public
    class function saveMovement(movement: TMovement): Boolean;
    class function getMovement(codMovement: Integer): TMovement;
  end;

implementation

uses
  uMainConn,
  uEntity,
  uItemMovement,
  uConnSingleton,
  uControlEntity,
  uControlItemMovement,
  System.SysUtils;

class function TControlMovement.getMovement(codMovement: Integer): TMovement;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;

const
  WHERE = ' where CodMovement = %d';
begin
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getObject<TMovement>(String.Format(WHERE,
                                                         [codMovement]));

    if (Result <> nil) then
    begin
      Result.Entity   := TControlEntity.getEntity(Result.CodEntity);
      Result.ListItems:= TControlItemMovement.getListItemMovement(Result.CodMovement);
    end;
  finally
    FreeAndNil(mainConn)
  end;
end;

class function TControlMovement.saveMovement(movement: TMovement): Boolean;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;
  itemMovement : TItemMovement;
begin
  Result:= False;

  // if regras de negócios OK then
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    mainConn.startTransaction;
    mainConn.saveObject<TMovement>(movement);

    for itemMovement in movement.ListItems do
      TControlItemMovement.saveItemMovement(itemMovement, mainConn);

    mainConn.commitTransaction;

    Result:= True;
  finally
    FreeAndNil(mainConn)
  end;
end;

end.
