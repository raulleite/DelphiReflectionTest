unit uLibObj;

interface

uses
  uAttributes,
  ZDataset,
  System.TypInfo,
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections;

type
  TLibObj<T> = class
  private
    //class function getInstanceObj(): T;
    class function getInstanceObj(): TObject;

  public
    class function fillObject(qryObj: TZQuery): T;
  end;

implementation

{
class function TLibObj<T>.getInstanceObj(): T;
var
  AValue          : TValue;
  rttiType        : TRttiType;
  rttiMethod      : TRttiMethod;
  rttiContext     : TRttiContext;
  rttiInstanceType: TRttiInstanceType;
  value, return   : TValue;
begin
  rttiContext:= TRttiContext.Create;
  rttiType   := rttiContext.GetType(TypeInfo(T));

  value:= GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
  value.TryCast(TypeInfo(T), return);

  Result:= return.AsType<T>;

//  for rttiMethod in rttiType.GetMethods do
//    if ((rttiMethod.IsConstructor) and
//        (Length(rttiMethod.GetParameters) = 0)) then
//    begin
//      rttiInstanceType := rttiType.AsInstance;
//
//      Result:= TValue(rttiMethod.Invoke(rttiInstanceType.MetaclassType, [])).AsType<T>;
//      Break;
//    end;
end;
}

class function TLibObj<T>.getInstanceObj(): TObject;
var
  AValue          : TValue;
  rttiType        : TRttiType;
  rttiMethod      : TRttiMethod;
  rttiContext     : TRttiContext;
  rttiInstanceType: TRttiInstanceType;
  value, return   : TValue;
begin
  rttiContext:= TRttiContext.Create;
  rttiType   := rttiContext.GetType(TypeInfo(T));

  value:= GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
  value.TryCast(TypeInfo(T), return);

  Result:= return.AsType<TObject>;
end;

class function TLibObj<T>.fillObject(qryObj: TZQuery): T;
var
  columnName     : String;
  rttiType       : TRttiType;
  rttiField      : TRttiField;
  custonAttribute: TCustomAttribute;
  value          : TValue;
  valueCur       : TValue;
  obj            : TObject;
begin
  obj:= TObject(Self.getInstanceObj);

  try
    rttiType:= TRttiContext.Create.GetType(TypeInfo(T));

    for rttiField in rttiType.GetFields do
    begin
      columnName:= String.Empty;

      for custonAttribute in rttiField.GetAttributes do
        if (custonAttribute is Column) then
        begin
          if (Column(custonAttribute).columnName.Equals(String.Empty)) then
            columnName:= Column(custonAttribute).columnName;

          Break;
        end;

      if (columnName.Equals(String.Empty)) then
        columnName:= rttiField.Name.Remove(0, 1).ToUpper;

      rttiField.SetValue(obj, TValue.From<Variant>(qryObj.FieldByName(columnName).Value));
    end;

    Result:= TValue(obj).AsType<T>;
  finally
    FreeAndNil(rttiType);
  end;
end;

end.
