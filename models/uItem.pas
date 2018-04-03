unit uItem;

interface

type
  TItem = class(TObject)
  private
    fCodItem   : Integer;
    fDescricao : String;
    fTipoItem  : Integer;
    fValorVenda: Double;
    fValorCusto: Double;
  public
    property CodItem   : Integer read fCodItem    write fCodItem;
    property Descricao : String  read fDescricao  write fDescricao;
    property TipoItem  : Integer read fTipoItem   write fTipoItem;
    property ValorVenda: Double  read fValorVenda write fValorVenda;
    property ValorCusto: Double  read fValorCusto write fValorCusto;
  end;

implementation

end.
