unit uAttributes;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TColumnAttributes = (caRequired, caNoUpdate, caNoInsert, caNoUse);

  TSetColumnAttributes = set of TColumnAttributes;

type
  Table = class(TCustomAttribute)
  private
    fTableName: String;
  public
    constructor Create(const tabelName: String);
    property tableName: String read fTableName;
  end;

  Id = class(TCustomAttribute)
  private
    fListId: TList<String>;
  public
    constructor Create(const listId: String);
    destructor Destroy; override;

    property listId: TList<String> read fListId;
  end;

  Column = class(TCustomAttribute)
  private
    fColumnName       : String;
    fColumnAttributes: TSetColumnAttributes;
  public
    constructor Create(const columnName: String; columnAttributes: TSetColumnAttributes);

    property columnName      : String               read fColumnName;
    property columnAttributes: TSetColumnAttributes read fColumnAttributes;
  end;

implementation

constructor Table.Create(const tabelName: String);
begin
  fTableName:= tabelName;
end;

constructor Id.Create(const listId: String);
var
  id     : String;
  splitId: TArray<String>;
begin
  fListId:= TList<String>.Create;

  splitId:= listId.Split([';']);

  for id in splitId do
    fListId.Add(id);
end;

destructor Id.Destroy;
begin
  FreeAndNil(fListId);
end;

constructor Column.Create(const columnName: String; columnAttributes: TSetColumnAttributes);
begin
  fColumnName      := columnName;
  fColumnAttributes:= columnAttributes;
end;


end.
