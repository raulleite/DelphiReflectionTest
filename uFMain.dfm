object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Simple Moviment Test'
  ClientHeight = 416
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 681
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 776
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 40
      Height = 23
      Caption = 'Mov.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 57
      Height = 23
      Caption = 'Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 87
      Top = 0
      Width = 37
      Height = 23
      Caption = 'Data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 102
      Width = 64
      Height = 23
      Caption = 'Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 439
      Top = 104
      Width = 40
      Height = 23
      Caption = 'Qtde'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 597
      Top = 102
      Width = 38
      Height = 23
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 518
      Top = 102
      Width = 41
      Height = 23
      Caption = 'Valor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object beMovement: TButtonedEdit
      Left = 8
      Top = 24
      Width = 73
      Height = 21
      MaxLength = 7
      RightButton.Visible = True
      TabOrder = 0
      OnExit = beMovementExit
    end
    object beCodEntity: TButtonedEdit
      Left = 8
      Top = 72
      Width = 73
      Height = 21
      MaxLength = 7
      ReadOnly = True
      RightButton.Visible = True
      TabOrder = 1
    end
    object edEntityNome: TEdit
      Left = 87
      Top = 72
      Width = 583
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object dtDataMoviment: TDateTimePicker
      Left = 87
      Top = 24
      Width = 106
      Height = 21
      Date = 43191.769193645840000000
      Time = 43191.769193645840000000
      Enabled = False
      TabOrder = 3
    end
    object edItemDescricao: TEdit
      Left = 87
      Top = 126
      Width = 346
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
    object edItem: TEdit
      Left = 8
      Top = 126
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 5
      OnExit = edItemExit
    end
    object edItemQuantidade: TEdit
      Left = 439
      Top = 126
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
    object edItemTotal: TEdit
      Left = 597
      Top = 126
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 7
    end
    object edItemValor: TEdit
      Left = 518
      Top = 126
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 8
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 376
    Width = 681
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 776
    object Label8: TLabel
      Left = 521
      Top = 6
      Width = 38
      Height = 23
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5195575
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edTotal: TButtonedEdit
      Left = 579
      Top = 6
      Width = 91
      Height = 24
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 7
      ParentFont = False
      ReadOnly = True
      RightButton.Visible = True
      TabOrder = 0
    end
  end
  object StringGridAdapterBindSource1: TStringGrid
    Left = 0
    Top = 153
    Width = 681
    Height = 223
    Align = alClient
    ColCount = 1
    FixedCols = 0
    RowCount = 10
    TabOrder = 2
    ColWidths = (
      64)
  end
  object DataGeneratorAdapter1: TDataGeneratorAdapter
    FieldDefs = <>
    Active = True
    AutoPost = False
    RecordCount = 9
    Options = [loptAllowInsert, loptAllowDelete, loptAllowModify]
    Left = 152
    Top = 264
  end
  object AdapterBindSource1: TAdapterBindSource
    AutoActivate = True
    OnCreateAdapter = AdapterBindSource1CreateAdapter
    Adapter = DataGeneratorAdapter1
    ScopeMappings = <>
    Left = 304
    Top = 264
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 428
    Top = 261
    object LinkGridToDataSourceAdapterBindSource1: TLinkGridToDataSource
      Category = 'Quick Bindings'
      DataSource = AdapterBindSource1
      GridControl = StringGridAdapterBindSource1
      Columns = <>
    end
  end
end
