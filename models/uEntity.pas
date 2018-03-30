unit uEntity;

interface

uses
  uAttributes;

type
  [Table('Entity')]
  [Id('CodEntity')]
  TEntity = class(TObject)
  private
    fCodEntity : Integer;
    fTipoEntity: Integer;
    fNome      : String;

  public
    property Nome: String read fNome write fNome;
  end;

implementation

end.
