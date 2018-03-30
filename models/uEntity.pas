unit uEntity;

interface

uses
  uAttributes;

type
  [Table('Entity')]
  [Id('CodEntity')]
  TEntity = class(TObject)
  private
    fCodEntity: Integer;
  end;

implementation

end.
