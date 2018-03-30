unit uLibObj;

interface

uses
  uAttributes,
  System.Rtti,
  System.SysUtils,
  //System.TypInfo,
  System.Generics.Collections;

const
  SQL_SELECT = 'select %s'#13#10 +
               '  from %s';

  SQL_INSERT = 'insert     '#13#10 +
               '  into (%s)'#13#10 +
               'values (%s)';

  SQL_UPDATE = 'update %s'#13#10 +
               '   set %s'#13#10 +
               ' where %s';

  SQL_DELETE = 'delete    '#13#10 +
               '  from %s '#13#10 +
               ' where %s ';

type
  TLibObj<T> = class
  private
    class function getFields(): TList<TRttiField>;
    class function getTableName(): String;
    class function getGetFieldsName(): TList<String>;
  public
    class function getSqlSelect(): String;

  end;

implementation

class function TLibObj<T>.getFields(): TList<TRttiField>;
var
  rttiType : TRttiType;
  rttiField: TRttiField;
begin
  Result:= TList<TRttiField>.Create;

  rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

  for rttiField in rttiType.GetFields do
    Result.Add(rttiField);
end;

class function TLibObj<T>.getGetFieldsName(): TList<String>;
var
  rttiType : TRttiType;
  rttiField: TRttiField;
  custonAttribute: TCustomAttribute;
  rttiFields: TList<TRttiField>;
  columnName: String;
begin
  rttiFields:= Self.getFields;
  Result:= TList<String>.Create;

  for rttiField in rttiFields do
  begin
    columnName:= rttiField.Name;
    columnName:= columnName.Remove(0, 1);
    for custonAttribute in rttiField.GetAttributes do
      if (custonAttribute is Column) then
      begin
        if (Column(custonAttribute).columnName.Equals(String.Empty)) then
          columnName:= Column(custonAttribute).columnName;

        Break;
      end;

    Result.Add(columnName);
  end;
end;

class function TLibObj<T>.getTableName(): String;
var
  custonAttribute: TCustomAttribute;
  rttiType       : TRttiType;
begin
  Result:= String.Empty;

  rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

  for custonAttribute in rttiType.GetAttributes do
    if (custonAttribute is Table) then
    begin
      Result:= Table(custonAttribute).tableName;
      Break;
    end;

  if (Result = String.Empty) then
    Result:= rttiType.Name.Remove(0, 1);
end;


class function TLibObj<T>.getSqlSelect(): String;
var
  rttiFields  : TList<TRttiField>;
  rttiField   : TRttiField;
  tableName   : String;
  concatColumn: String;
  column      : String;
  listColumns : TList<string>;
begin
  Result:= String.Empty;

  try
    tableName  := Self.getTableName;
    listColumns:= Self.getGetFieldsName;

    for column in listColumns do
      concatColumn:= Result + column;

    Result:= Format(SQL_SELECT,
                    [concatColumn,
                     tableName]);
  finally
    FreeAndNil(listColumns);
  end;
end;

end.
