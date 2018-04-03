unit uStock;

interface

type
  TStock = class(TObject)
  private
    fCodStock  : Integer;
    fCodItem   : Integer;
    fQuantidade: Double ;
  public
    property CodStock  : Integer read fCodStock   write fCodStock  ;
    property CodItem   : Integer read fCodItem    write fCodItem   ;
    property Quantidade: Double  read fQuantidade write fQuantidade;
  end;

implementation

end.
