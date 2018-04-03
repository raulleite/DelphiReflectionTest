unit uItemMovement;

interface

uses
  uItem,
  uAttributes;

type
  TItemMovement = class(TObject)
  private
    fCodMovement    : Integer;
    fCodItemMovement: Integer;
    fCodItem        : Integer;
    fQuantidade     : Double;
    fValorVenda     : Double;
    fTotalVenda     : Double;
    fValorCusto     : Double;
    fTotalCusto     : Double;
    fCodStock       : Integer;
    [Column('Item', [caNoUse])]
    fItem: TItem;

    function getDescricao: String;
  public
    property CodMovement    : Integer read fCodMovement     write fCodMovement;
    property CodItemMovement: Integer read fCodItemMovement write fCodItemMovement;
    property CodItem        : Integer read fCodItem         write fCodItem;
    property Descricao      : String  read getDescricao;
    property Quantidade     : Double  read fQuantidade      write fQuantidade;
    property ValorVenda     : Double  read fValorVenda      write fValorVenda;
    property TotalVenda     : Double  read fTotalVenda      write fTotalVenda;
    property ValorCusto     : Double  read fValorCusto      write fValorCusto;
    property TotalCusto     : Double  read fTotalCusto      write fTotalCusto;
    property CodStock       : Integer read fCodStock        write fCodStock;
  public
    destructor Destroy; override;
    property Item     : TItem  read fItem      write fItem;
  end;

implementation

uses
  System.SysUtils;

destructor TItemMovement.Destroy;
begin
  if (fItem <> nil) then
    FreeAndNil(fItem);
end;

function TItemMovement.getDescricao: String;
begin
  if (fItem <> nil) then
    Result:= fItem.Descricao;
end;


end.
