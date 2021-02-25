object frm_principal: Tfrm_principal
  Left = 0
  Top = 0
  Caption = 'Estudo RTTI'
  ClientHeight = 703
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 350
    Align = alCustom
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    object memo: TMemo
      Left = 24
      Top = 71
      Width = 361
      Height = 258
      TabOrder = 0
    end
    object btnDescricaoClasse: TButton
      Left = 24
      Top = 24
      Width = 97
      Height = 41
      Caption = 'Descri'#231#227'o Classe'
      TabOrder = 1
      OnClick = btnDescricaoClasseClick
    end
    object btnDescricaoBotao: TButton
      Left = 127
      Top = 24
      Width = 97
      Height = 42
      Caption = 'Descri'#231#227'o Bot'#227'o'
      TabOrder = 2
      OnClick = btnDescricaoBotaoClick
    end
  end
  object Panel2: TPanel
    Left = 408
    Top = 0
    Width = 449
    Height = 350
    Color = clOlive
    ParentBackground = False
    TabOrder = 1
    object ListBox1: TListBox
      Left = 24
      Top = 71
      Width = 409
      Height = 266
      ItemHeight = 13
      TabOrder = 0
    end
    object btnValidarCustom: TButton
      Left = 24
      Top = 21
      Width = 225
      Height = 42
      Caption = 'Gerar e Validar Classe (CustomAtribbutes)'
      TabOrder = 1
      OnClick = btnValidarCustomClick
    end
  end
end
