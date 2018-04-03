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
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Grids,
  uItem,
  uMovement, Data.Bind.GenData, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Vcl.Bind.Grid, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.ObjectScope;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    beMovement: TButtonedEdit;
    beCodEntity: TButtonedEdit;
    Label2: TLabel;
    edEntityNome: TEdit;
    dtDataMoviment: TDateTimePicker;
    Label3: TLabel;
    edTotal: TButtonedEdit;
    StringGridAdapterBindSource1: TStringGrid;
    edItemDescricao: TEdit;
    Label4: TLabel;
    edItem: TEdit;
    Label5: TLabel;
    edItemQuantidade: TEdit;
    edItemTotal: TEdit;
    Label6: TLabel;
    edItemValor: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    DataGeneratorAdapter1: TDataGeneratorAdapter;
    AdapterBindSource1: TAdapterBindSource;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceAdapterBindSource1: TLinkGridToDataSource;
    procedure beMovementExit(Sender: TObject);
    procedure edItemExit(Sender: TObject);
    procedure AdapterBindSource1CreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
  private
    { Private declarations }
    fMovement: TMovement;
    fItem    : TItem;
  public
    { Public declarations }
  end;

var
  frmMain  : TfrmMain;

implementation

uses
  uLibObj,
  uEntity,
  uItemMovement,
  uControlItem,
  uControlMovement,
  System.Generics.Collections;

{$R *.dfm}

procedure TfrmMain.AdapterBindSource1CreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
var
  listItem: TList<TItemMovement>;
  itemMovement: TItemMovement;
begin
  listItem:= TList<TItemMovement>.Create;
  ABindSourceAdapter := TListBindSourceAdapter<TItemMovement>.Create(self, listItem, True);
end;

procedure TfrmMain.beMovementExit(Sender: TObject);
var
  codMovement : Integer;
  itemMovement: TItemMovement;
begin
  Integer.TryParse(TButtonedEdit(Sender).Text, codMovement);

  if (codMovement > 0) then
  begin
    if (fMovement <> nil) then
      FreeAndNil(fMovement);

    fMovement:= TControlMovement.getMovement(codMovement);

    if (fMovement<> nil) then
    begin
      beCodEntity.Text := fMovement.CodEntity.ToString;
      edEntityNome.Text:= fMovement.Entity.Nome;
      dtDataMoviment.DateTime:= fMovement.DataMovement;
      edTotal.Text:= fMovement.Total.ToString;

      with (TListBindSourceAdapter<TItemMovement>(AdapterBindSource1.InternalAdapter)) do
      begin
        SetList(fMovement.ListItems, False);
        Active:= True;
      end;
    end
    else
    begin
      ShowMessage('Movimento não encontrado');
      beMovement.SetFocus;
      beCodEntity.Text := string.Empty;
      edEntityNome.Text:= string.Empty;
      dtDataMoviment.DateTime:= Now;
      edTotal.Text:= string.Empty;

      with (TListBindSourceAdapter<TItemMovement>(AdapterBindSource1.InternalAdapter)) do
        Active:= False;
    end;
  end
  else
    ShowMessage('Valor digitado não é válido');
end;

procedure TfrmMain.edItemExit(Sender: TObject);
var
  codItem  : Integer;
  quatidade: Double;
begin
  Integer.TryParse(TButtonedEdit(Sender).Text, codItem);

  if (codItem > 0) then
  begin
    if (fItem <> nil) then
      FreeAndNil(fItem);

    fItem:= TControlItem.getItem(codItem);

    if (fItem <> nil) then
    begin
      edItemDescricao.Text := fItem.Descricao;
      edItemValor.Text     := fItem.ValorVenda.ToString;
      edItemQuantidade.Text:= '1';
     end;
  end;
end;

end.
