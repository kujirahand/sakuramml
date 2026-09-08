object frmMidiPort: TfrmMidiPort
  Left = 383
  Top = 186
  Width = 304
  Height = 243
  Caption = #65325#65321#65316#65321#12509#12540#12488#35373#23450
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object panelSetMidi: TPanel
    Left = 8
    Top = 8
    Width = 281
    Height = 161
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 35
      Height = 12
      Caption = 'Port(0)'
    end
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 35
      Height = 12
      Caption = 'Port(1)'
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 35
      Height = 12
      Caption = 'Port(2)'
    end
    object Label4: TLabel
      Left = 8
      Top = 80
      Width = 35
      Height = 12
      Caption = 'Port(3)'
    end
    object Label5: TLabel
      Left = 8
      Top = 104
      Width = 35
      Height = 12
      Caption = 'Port(4)'
    end
    object Label6: TLabel
      Left = 8
      Top = 128
      Width = 35
      Height = 12
      Caption = 'Port(5)'
    end
    object ComboBox1: TComboBox
      Left = 56
      Top = 8
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
    end
    object ComboBox2: TComboBox
      Tag = 1
      Left = 56
      Top = 32
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object ComboBox3: TComboBox
      Tag = 2
      Left = 56
      Top = 56
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 2
    end
    object ComboBox4: TComboBox
      Tag = 3
      Left = 56
      Top = 80
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 3
    end
    object ComboBox5: TComboBox
      Tag = 4
      Left = 56
      Top = 104
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 4
    end
    object ComboBox6: TComboBox
      Tag = 5
      Left = 56
      Top = 128
      Width = 209
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 5
    end
  end
  object btnOk: TButton
    Left = 216
    Top = 176
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOkClick
  end
end
