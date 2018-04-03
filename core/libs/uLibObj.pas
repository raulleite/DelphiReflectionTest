unit uLibObj;

interface

uses
  uAttributes,
  Data.SqlExpr,
  System.TypInfo,
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections;

type
  TLibObj<T> = class
  private
    class function getInstanceObj(): TObject;
  public
    class procedure Copy(ASource, ATarget: T; AIgnore: String = '');
    class function fillObject(qryObj: TSQLQuery): T;
    class procedure fillQuery(obj: TObject; var qryObj: TSQLQuery); overload;
    class procedure fillQuery(obj: TObject; var qryObj: TSQLQuery; fillId: Boolean); overload;
  end;

implementation

class function TLibObj<T>.getInstanceObj(): TObject;
var
  rttiType        : TRttiType;
  rttiContext     : TRttiContext;
  value, return   : TValue;
begin
  rttiContext:= TRttiContext.Create;
  rttiType   := rttiContext.GetType(TypeInfo(T));

  value:= GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
  value.TryCast(TypeInfo(T), return);

  Result:= return.AsType<TObject>;
end;

class function TLibObj<T>.fillObject(qryObj: TSQLQuery): T;
var
  columnName     : String;
  rttiType       : TRttiType;
  rttiField      : TRttiField;
  custonAttribute: TCustomAttribute;
  obj            : TObject;
  dontUse        : Boolean;
begin
  obj:= TObject(Self.getInstanceObj);

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
            columnName:= Column(custonAttribute).columnName;

          Break;
        end;

      if (dontUse) then
        Continue;

      if (columnName.Equals(String.Empty)) then
        columnName:= rttiField.Name.Remove(0, 1).ToUpper;

      rttiField.SetValue(obj,
                         TValue.From<Variant>(qryObj.FieldByName(columnName).Value));
    end;

    Result:= TValue(obj).AsType<T>;
  finally
    FreeAndNil(rttiType);
  end;
end;

class procedure TLibObj<T>.fillQuery(obj: TObject; var qryObj: TSQLQuery);
begin
  Self.fillQuery(obj, qryObj, False);
end;

class procedure TLibObj<T>.fillQuery(obj: TObject; var qryObj: TSQLQuery; fillId: Boolean);
var
  columnName    : String;
  columnField   : String;
  rttiType      : TRttiType;
  rttiField     : TRttiField;
  customAttTable: TCustomAttribute;
  customAttField: TCustomAttribute;
  dontUse        : Boolean;
begin
  try
    rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

    if (fillId) then
    begin
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

            dontUse   := False;
            columnName:= String.Empty;

            for customAttField in rttiField.GetAttributes do
              if (customAttField is Column) then
              begin
                dontUse:= TColumnAttributes.caNoUse in Column(customAttField).columnAttributes;

                if (dontUse) then
                  Break;

                if (Column(customAttField).columnName.Equals(String.Empty)) then
                  columnName:= Column(customAttField).columnName.ToUpper;

                Break;
              end;

            if (dontUse) then
              Continue;

            if (columnName.Equals(String.Empty)) then
              columnName:= rttiField.Name.Remove(0, 1).ToUpper;

            qryObj.ParamByName(columnName).Value:= rttiField.GetValue(obj).AsVariant;

          end;

          Break;
        end;
    end
    else
      for rttiField in rttiType.GetFields do
      begin
        columnName:= String.Empty;

        for customAttField in rttiField.GetAttributes do
          if (customAttField is Column) then
          begin
            if (Column(customAttField).columnName.Equals(String.Empty)) then
              columnName:= Column(customAttField).columnName;

            Break;
          end;

        if (columnName.Equals(String.Empty)) then
          columnName:= rttiField.Name.Remove(0, 1).ToUpper;

        qryObj.ParamByName(columnName).Value:= rttiField.GetValue(obj).AsVariant;
      end;
  finally
    FreeAndNil(rttiType);
  end;
end;

class procedure TLibObj<T>.Copy(ASource, ATarget: T; AIgnore: String = '');
var
  rttiContext: TRttiContext;
  rttiType   : TRttiType;
  MinVisibility: TMemberVisibility;
  rttiProperty: TRttiProperty;
  rttiField: TRttiField;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  AIgnore := ',' + AIgnore.ToLower + ',';
  rttiType := rttiContext.GetType(TypeInfo(T));

  try
    Move(ASource, SourceAsPointer, SizeOf(Pointer));
    Move(ATarget, ResultAsPointer, SizeOf(Pointer));
    MinVisibility := mvPublic;

    for rttiField in rttiType.GetFields do
      if (rttiField.Visibility >= MinVisibility) then
        rttiField.SetValue(ResultAsPointer, rttiField.GetValue(SourceAsPointer));

    for rttiProperty in RttiType.GetProperties do
      if ((rttiProperty.Visibility >= MinVisibility) and
          (rttiProperty.IsReadable) and
           (rttiProperty.IsWritable)) then
        try
          if pos(',' + rttiProperty.Name.ToLower + ',', AIgnore) = 0 then
          begin
            rttiProperty.SetValue(ResultAsPointer, rttiProperty.GetValue(SourceAsPointer));
          end;
        except
        end;
  except
    raise;
  end;
end;

end.
