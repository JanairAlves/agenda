inherited fVTelefone: TfVTelefone
  Caption = 'Cadastro de Telefone'
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  OnShow = FormShow
  TextHeight = 15
  inherited pnGridDadosContato: TPanel
    TabOrder = 1
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnCentral: TPanel
    Caption = ''
    TabOrder = 0
    StyleElements = [seFont, seClient, seBorder]
    inherited pnBotoes: TPanel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited pnCampos: TPanel
      StyleElements = [seFont, seClient, seBorder]
      object lbTelefone: TLabel
        Left = 23
        Top = 14
        Width = 45
        Height = 15
        Caption = 'Telefone'
      end
      object lbTPLinha: TLabel
        Left = 208
        Top = 14
        Width = 53
        Height = 15
        Caption = 'Tipo linha'
      end
      object lbOperadora: TLabel
        Left = 420
        Top = 14
        Width = 56
        Height = 15
        Caption = 'Operadora'
      end
      object edtTelefone: TMaskEdit
        Left = 23
        Top = 35
        Width = 119
        Height = 23
        EditMask = '(##) # ####-####;1;_'
        MaxLength = 16
        TabOrder = 0
        Text = '(  )       -    '
      end
      object edtOperadora: TEdit
        Left = 420
        Top = 35
        Width = 121
        Height = 23
        TabOrder = 2
      end
      object cbTPLinha: TComboBox
        Left = 208
        Top = 35
        Width = 145
        Height = 23
        Style = csDropDownList
        TabOrder = 1
      end
    end
  end
end
