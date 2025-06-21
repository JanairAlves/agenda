object fVAgenda: TfVAgenda
  Left = 0
  Top = 0
  Caption = 'Agenda de contatos'
  ClientHeight = 242
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnAgendaContatos: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 69
    Align = alTop
    Caption = 'Agenda de contatos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object pnCentral: TPanel
    Left = 0
    Top = 69
    Width = 527
    Height = 173
    Align = alClient
    TabOrder = 1
    object btAdicionarContato: TButton
      Left = 38
      Top = 26
      Width = 107
      Height = 25
      Caption = 'Adicionar contato'
      TabOrder = 0
      OnClick = btAdicionarContatoClick
    end
    object btFechar: TButton
      Left = 390
      Top = 130
      Width = 107
      Height = 25
      Caption = 'Fechar'
      TabOrder = 1
      OnClick = btFecharClick
    end
  end
end
