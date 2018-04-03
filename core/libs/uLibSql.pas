unit uLibSql;

interface

uses
  uAttributes,
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections;

const
  SQL_SELECT = 'select %s'#13#10 +
               '  from %s';

  SQL_INSERT = 'insert     '#13#10 +
               '  into %s  '#13#10 +
               '       (%s)'#13#10 +
               'values (%s)';

  SQL_UPDATE = 'update %s'#13#10 +
               '   set %s'#13#10 +
               ' where %s';

  SQL_DELETE = 'delete    '#13#10 +
               '  from %s '#13#10 +
               ' where %s ';

  COLUMN_VALUE = '%s = :%s';

type
  TLibSql<T> = class
  private
    class function getTableName(): String;
    class function getFieldsName(): TList<String>; overload;
    class function getFieldsName(withValues: Boolean): TList<String>; overload;
    class function getFieldsId(): TList<String>;
  public
    class function getSqlSelect(): String;
    class function getSqlInsert(): String;
    class function getSqlUpdate(): String;
    class function getSqlDelete(): String;
  end;

implementation

class function TLibSql<T>.getFieldsName(): TList<String>;
begin
  Result:= Self.getFieldsName(False);
end;

class function TLibSql<T>.getFieldsName(withValues: Boolean): TList<String>;
var
  columnName     : String;
  rttiType       : TRttiType;
  rttiField      : TRttiField;
  custonAttribute: TCustomAttribute;
  fillColumn     : TFunc<Boolean, String, String>;
  dontUse        : Boolean;
begin
  Result:= TList<String>.Create;

  fillColumn:=  function(withValues: Boolean; column: String): String
                begin
                  if (withValues) then
                    Result:= String.Format(COLUMN_VALUE,
                                           [column,
                                            column])
                  else
                    Result:= column
                end;

  try
    rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

    for rttiField in rttiType.GetFields do
    begin
      dontUse   := False;
      columnName:= String.Empty;

      for custonAttribute in rttiField.GetAttributes do
        if (custonAttribute is Column) then
        begin
          dontUse:= TColumnAttributes.caNoUse in Column(custonAttribute).columnAttributes;

          if (dontUse) then
            Break;

          if (Column(custonAttribute).columnName.Equals(String.Empty)) then
            columnName:= fillColumn(withValues, Column(custonAttribute).columnName.ToUpper);

          Break;
        end;

      if (dontUse) then
        Continue;

      if (columnName.Equals(String.Empty)) then
        columnName:= fillColumn(withValues, rttiField.Name.Remove(0, 1).ToUpper);

      Result.Add(columnName);
    end;
  finally
    FreeAndNil(rttiType);
  end;
end;

class function TLibSql<T>.getFieldsId(): TList<String>;
var
  customAttTable: TCustomAttribute;
  customAttField: TCustomAttribute;
  rttiType      : TRttiType;
  rttiField     : TRttiField;
  columnName    : String;
  columnField   : String;
begin
  Result:= TList<String>.Create;

  try
    rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

    for customAttTable in rttiType.GetAttributes do
      if (customAttTable is Id) then
      begin
        for columnField in Id(customAttTable).listId do
        begin
          rttiField:= rttiType.GetField(columnField);

          if (rttiField = nil) then
            raise Exception.Create(String.Format('Field "%s", não encontrada no objeto "%s".',
                                                 [columnField,
                                                  rttiType.Name]));

          columnName:= String.Empty;

          for customAttField in rttiField.GetAttributes do
            if (customAttField is Column) then
            begin
              if (Column(customAttField).columnName.Equals(String.Empty)) then
                columnName:= Column(customAttField).columnName.ToUpper;

              Break;
            end;

          if (columnName.Equals(String.Empty)) then
            columnName:= rttiField.Name.Remove(0, 1).ToUpper;


          Result.Add(String.Format(COLUMN_VALUE,
                                   [columnName.ToUpper,
                                    columnName.ToUpper]));
        end;

        Break;
      end;

    if (Result.Count = 0) then
      raise Exception.Create(String.Format('Necessário definir chave primária para "%s"',
                                           [rttiType.Name]));
  finally
    FreeAndNil(rttiType);
  end;
end;

class function TLibSql<T>.getTableName(): String;
var
  custonAttribute: TCustomAttribute;
  rttiType       : TRttiType;
begin
  Result:= String.Empty;

  try
    rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

    for custonAttribute in rttiType.GetAttributes do
      if (custonAttribute is Table) then
      begin
        Result:= Table(custonAttribute).tableName.ToUpper;
        Break;
      end;

    if (Result = String.Empty) then
      Result:= rttiType.Name.Remove(0, 1).ToUpper;
  finally
    FreeAndNil(rttiType);
  end;
end;

class function TLibSql<T>.getSqlSelect(): String;
var
  tableName   : String;
  concatColumn: String;
  listColumns : TList<string>;
begin
  Result:= String.Empty;

  try
    tableName  := Self.getTableName;
    listColumns:= Self.getFieldsName;

    concatColumn:= String.Join(', ', listColumns.ToArray);

    Result:= String.Format(SQL_SELECT,
                           [concatColumn,
                            tableName]);
  finally
    FreeAndNil(listColumns);
  end;
end;

class function TLibSql<T>.getSqlInsert(): String;
var
  tableName   : String;
  concatColumn: String;
  concatValues: String;
  listColumns : TList<String>;
//  listId      : TList<String>;
begin
  Result:= String.Empty;

  try
    tableName  := Self.getTableName;
    listColumns:= Self.getFieldsName;
//    listId     := Self.getFieldsId;

    concatColumn:= String.Join(', ' , listColumns.ToArray);
    concatValues:= ':' + String.Join(', :' , listColumns.ToArray);

    Result:= String.Format(SQL_INSERT,
                           [tableName,
                            concatColumn,
                            concatValues]);
  finally
    FreeAndNil(listColumns);
  end;
end;

class function TLibSql<T>.getSqlUpdate(): String;
var
  tableName   : String;
  concatColumn: String;
  concatId    : String;
  listColumns : TList<String>;
  listId      : TList<String>;
begin
  Result:= String.Empty;

  try
    tableName  := Self.getTableName;
    listColumns:= Self.getFieldsName(True);
    listId     := Self.getFieldsId;

    concatColumn:= String.Join(', ' , listColumns.ToArray);
    concatId    := String.Join(' and ', listId.ToArray);

    Result:= String.Format(SQL_UPDATE,
                           [tableName,
                            concatColumn,
                            concatId]);
  finally
    FreeAndNil(listColumns);
    FreeAndNil(listId);
  end;
end;

class function TLibSql<T>.getSqlDelete(): String;
var
  tableName   : String;
  concatId    : String;
  listId      : TList<String>;
begin
  Result:= String.Empty;

  try
    tableName:= Self.getTableName;
    listId   := Self.getFieldsId;
    concatId := String.Join(' and ', listId.ToArray);

    Result:= String.Format(SQL_DELETE,
                           [tableName,
                            concatId]);
  finally
    FreeAndNil(listId);
  end;
end;

end.
