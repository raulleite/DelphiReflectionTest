unit uMovement;

interface

uses
  uEntity,
  uItemMovement,
  uAttributes,
  System.Generics.Collections;

type
  TMovement = class(TObject)
  private
    fCodMovement : Integer;
	  fCodEntity   : Integer;
	  fDataMovement: TDateTime;
    fTotal       : Double;

    [Column('Entity', [caNoUse])]
    fEntity: TEntity;
    [Column('ListItems', [caNoUse])]
    fListItems: TList<TItemMovement>;

    procedure setListItems(aValue: TList<TItemMovement>);
    function getListItems: TList<TItemMovement>;
  public
    property CodMovement : Integer   read fCodMovement  write fCodMovement;
    property CodEntity   : Integer   read fCodEntity    write fCodEntity;
    property DataMovement: TDateTime read fDataMovement write fDataMovement;
    property Total       : Double    read fTotal        write fTotal;
  public
    destructor Destroy; override;
    constructor Create;

    property Entity   : TEntity              read fEntity    write fEntity;
    property ListItems: TList<TItemMovement> read getListItems write setListItems;
  end;

implementation

uses
  System.SysUtils;

function TMovement.getListItems: TList<TItemMovement>;
begin
  Result:= fListItems;
end;

procedure TMovement.setListItems(aValue: TList<TItemMovement>);
var
  itemMovement: TItemMovement;
begin
  if (fListItems <> nil) then
  begin
    for itemMovement in fListItems do
      itemMovement.Free;

    FreeAndNil(fListItems);
  end;

  fTotal:= 0;
  fListItems:= aValue;

  for itemMovement in fListItems do
    fTotal:= fTotal + itemMovement.TotalVenda;
end;

constructor TMovement.Create;
begin
  fListItems:= TList<TItemMovement>.Create;
end;

destructor TMovement.Destroy;
var
  itemMovement: TItemMovement;
begin
  if (fEntity <> nil) then
    FreeAndNil(fEntity);

  if (fListItems <> nil) then
  begin
    for itemMovement in fListItems do
      itemMovement.Free;

    FreeAndNil(fListItems);
  end;
end;

end.
