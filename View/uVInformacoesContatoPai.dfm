object fVInformacoesContatoPai: TfVInformacoesContatoPai
  Left = 0
  Top = 0
  ClientHeight = 232
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnGridDadosContato: TPanel
    Left = 0
    Top = 138
    Width = 568
    Height = 94
    Align = alBottom
    TabOrder = 0
    Visible = False
    object dbGridDadosContato: TDBGrid
      Left = 1
      Top = 1
      Width = 566
      Height = 92
      Align = alClient
      Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyPress = dbGridDadosContatoKeyPress
    end
  end
  object pnCentral: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 137
    Caption = 'pnCentral'
    TabOrder = 1
    object pnBotoes: TPanel
      Left = 1
      Top = 77
      Width = 567
      Height = 59
      Align = alBottom
      TabOrder = 0
      object btAdicionar: TButton
        Left = 23
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Adicionar'
        TabOrder = 0
        OnClick = btAdicionarClick
      end
      object btCancelar: TButton
        Left = 130
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        Enabled = False
        TabOrder = 1
        OnClick = btCancelarClick
      end
      object btLimpar: TButton
        Left = 240
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Limpar'
        TabOrder = 2
        OnClick = btLimparClick
      end
      object btExibir: TButton
        Left = 353
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Exibir'
        TabOrder = 3
        OnClick = btExibirClick
      end
      object btFechar: TButton
        Left = 466
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Fechar'
        TabOrder = 4
        OnClick = btFecharClick
      end
    end
    object pnCampos: TPanel
      Left = 1
      Top = 1
      Width = 567
      Height = 76
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object FcdsDadosContato: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 502
    Top = 174
  end
  object FdsDadosContato: TDataSource
    Left = 400
    Top = 174
  end
end
