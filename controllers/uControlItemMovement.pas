unit uControlItemMovement;

interface

uses
  uMainConn,
  uItemMovement,
  System.Generics.Collections;

type
  TControlItemMovement = class
  private
  public
    class function getItemMovement(codItemMovement: Integer): TItemMovement;
    class function getListItemMovement(codMovement: Integer): TList<TItemMovement>;
    class function saveItemMovement(itemMovement: TItemMovement; mainConn: TMainConn): Boolean;
  end;

implementation

uses
  uEntity,
  uConnSingleton,
  uControlItem,
  uControlEntity,
  System.SysUtils;

class function TControlItemMovement.getItemMovement(codItemMovement: Integer): TItemMovement;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;

const
  WHERE = ' where CodMovement = %d';
begin
{
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getObject<TMovement>(String.Format(WHERE,
                                                         [codMovement]));

    Result.Entity:= TControlEntity.getEntity(Result.CodEntity);

    Result.ListItems:= mainConn.getListObject<TItemMovement>(String.Format(WHERE,
                                                                           [codMovement]));
  finally
    FreeAndNil(mainConn)
  end;
  }
end;

class function TControlItemMovement.getListItemMovement(codMovement: Integer): TList<TItemMovement>;
var
  mainConn     : TMainConn;
  connSingleton: TConnSingleton;
  itemMovement : TItemMovement;

const
  WHERE = ' where CodMovement = %d';
begin
  try
    connSingleton:= TConnSingleton.getInstance;
    mainConn:= TMainConn.Create(connSingleton.getConnection);

    Result:= mainConn.getListObject<TItemMovement>(String.Format(WHERE,
                                                                [codMovement]));

    for itemMovement in Result do
      itemMovement.Item:= TControlItem.getItem(itemMovement.CodItem);
  finally
    FreeAndNil(mainConn)
  end;
end;

class function TControlItemMovement.saveItemMovement(itemMovement: TItemMovement;
                                                     mainConn: TMainConn): Boolean;
begin
  Result:= False;

  // if regras de negócios OK then
  mainConn.saveObject<TItemMovement>(itemMovement);
  Result:= True;
end;


end.

