object frmAbout: TfrmAbout
  Left = 287
  Top = 185
  BorderStyle = bsDialog
  Caption = #12496#12540#12472#12519#12531#24773#22577
  ClientHeight = 298
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object imgBack: TImage
    Left = 0
    Top = 0
    Width = 338
    Height = 298
    Align = alClient
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 217
    BevelOuter = bvLowered
    Caption = #12486#12461#12473#12488#38899#27005#12300#12469#12463#12521#12301
    Color = clWhite
    TabOrder = 0
    object lblHide: TLabel
      Left = 16
      Top = 16
      Width = 167
      Height = 12
      Caption = #32654#21619#12375#12373#12356#12429#12356#12429#12289#34425#12398#12424#12358#12394#29004#12365
    end
    object Image1: TImage
      Left = 10
      Top = 8
      Width = 302
      Height = 201
      OnClick = Image1Click
    end
  end
  object Button1: TButton
    Left = 264
    Top = 264
    Width = 67
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 8
    Top = 232
    Width = 249
    Height = 57
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 2
    object lblVersion: TLabel
      Left = 48
      Top = 5
      Width = 102
      Height = 12
      Caption = '2002/10/10 ver.2.00'
    end
    object Label5: TLabel
      Left = 8
      Top = 21
      Width = 20
      Height = 12
      Caption = 'DLL'
    end
    object lblDLLVer: TLabel
      Left = 48
      Top = 21
      Width = 102
      Height = 12
      Caption = '2222/22/22 ver.2.00'
    end
    object Label1: TLabel
      Left = 8
      Top = 5
      Width = 30
      Height = 12
      Caption = 'Editor'
    end
    object lblInfoAuthor: TLabel
      Left = 8
      Top = 40
      Width = 97
      Height = 12
      Cursor = crHandPoint
      Caption = #35069#20316': '#12463#12472#12521#39131#34892#26426
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblInfoAuthorClick
    end
  end
  object btnDevelopper: TButton
    Left = 264
    Top = 232
    Width = 65
    Height = 25
    Caption = #35443#32048
    TabOrder = 3
    OnClick = btnDevelopperClick
  end
end
