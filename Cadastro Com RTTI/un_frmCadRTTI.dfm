object frm_principal_cadRTTI: Tfrm_principal_cadRTTI
  Left = 0
  Top = 0
  Caption = 'Manipulando Cadastro com RTTI'
  ClientHeight = 414
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 805
    Height = 414
    Align = alClient
    Color = clScrollBar
    ParentBackground = False
    TabOrder = 0
    object Label4: TLabel
      Left = 99
      Top = 52
      Width = 28
      Height = 13
      Caption = 'Idade'
    end
    object Label3: TLabel
      Left = 12
      Top = 53
      Width = 23
      Height = 13
      Caption = 'Peso'
    end
    object Label2: TLabel
      Left = 12
      Top = 9
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object Label5: TLabel
      Left = 495
      Top = 10
      Width = 60
      Height = 13
      Caption = 'Log de Erros'
    end
    object Codigo: TEdit
      Left = 99
      Top = 70
      Width = 97
      Height = 21
      NumbersOnly = True
      TabOrder = 8
      Visible = False
    end
    object btnSalvar: TButton
      Left = 195
      Top = 107
      Width = 85
      Height = 33
      Caption = 'Salvar'
      TabOrder = 5
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 105
      Top = 107
      Width = 85
      Height = 33
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = btnExcluirClick
    end
    object btnEditar: TButton
      Left = 15
      Top = 107
      Width = 85
      Height = 33
      Caption = 'Editar'
      TabOrder = 3
      OnClick = btnEditarClick
    end
    object btnCancelar: TButton
      Left = 285
      Top = 107
      Width = 85
      Height = 33
      Caption = 'Cancelar'
      TabOrder = 6
      OnClick = btnCancelarClick
    end
    object Nome: TEdit
      Left = 12
      Top = 25
      Width = 421
      Height = 21
      Color = clInfoBk
      TabOrder = 0
    end
    object Peso: TEdit
      Left = 12
      Top = 70
      Width = 65
      Height = 21
      Color = clInfoBk
      TabOrder = 1
    end
    object Idade: TEdit
      Left = 99
      Top = 70
      Width = 97
      Height = 21
      Color = clInfoBk
      NumbersOnly = True
      TabOrder = 2
    end
    object StringGrid: TStringGrid
      Left = 20
      Top = 168
      Width = 469
      Height = 187
      Color = clInfoBk
      ColCount = 4
      FixedCols = 0
      RowCount = 4
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 7
      OnSelectCell = StringGridSelectCell
    end
    object btnNovo: TButton
      Left = 377
      Top = 107
      Width = 85
      Height = 33
      Caption = 'Novo'
      TabOrder = 9
      OnClick = btnNovoClick
    end
  end
  object ListBox1: TListBox
    Left = 495
    Top = 29
    Width = 233
    Height = 326
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
  end
  object SQLConn: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver260.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver260.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'MaxBlobSize=-1'
      'DriverName=MySQL'
      'HostName=localhost'
      'Database=banco_rtti'
      'User_Name=root'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60'
      'Password=')
    Left = 448
    Top = 160
  end
end
