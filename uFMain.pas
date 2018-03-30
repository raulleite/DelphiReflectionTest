unit uFMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  ZAbstractConnection,
  ZConnection;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uLibSql,
  uLibObj,
  uMainConn,
  uEntity,
  System.Generics.Collections;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  sql: String;
  entity: TEntity;
  entities: TList<TEntity>;
  mainConn: TMainConn;
begin
  try
    sql:= TLibSql<TEntity>.getSqlSelect;
    sql:= TLibSql<TEntity>.getSqlUpdate;
    sql:= TLibSql<TEntity>.getSqlInsert;
    sql:= TLibSql<TEntity>.getSqlDelete;

    mainConn:= TMainConn.Create(ZConnection1);

    entity  := mainConn.getObject<TEntity>(' where CODENTITY = 1');
    entities:= mainConn.getListObject<TEntity>(String.Empty);

    ShowMessage(entity.Nome);
  finally
    FreeAndNil(entity);
  end;

  ShowMessage(sql);
end;

end.
