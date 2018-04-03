unit uEntity;

interface

uses
  uAttributes;

type
  [Table('Entity')]
  [Id('fCodEntity')]
  TEntity = class(TObject)
  private
    fCodEntity : Integer;
    fTipoEntity: Integer;
    fNome      : String;

  public
    property CodEntity : Integer read fCodEntity  write fCodEntity;
    property TipoEntity: Integer read fTipoEntity write fTipoEntity;
    property Nome      : String  read fNome       write fNome;
  end;

implementation

end.
