object frmRythmBox: TfrmRythmBox
  Left = 211
  Top = 118
  Width = 463
  Height = 279
  BorderIcons = [biSystemMenu]
  Caption = 'Rythm - Box'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object imgKoma0: TImage
    Left = 216
    Top = 112
    Width = 105
    Height = 105
    Visible = False
  end
  object imgKoma1: TImage
    Left = 224
    Top = 120
    Width = 105
    Height = 105
    Visible = False
  end
  object imgKomaZ: TImage
    Left = 216
    Top = 96
    Width = 105
    Height = 105
    Visible = False
  end
  object panelBottom: TPanel
    Left = 0
    Top = 191
    Width = 455
    Height = 37
    Align = alBottom
    TabOrder = 0
    object imgBack: TImage
      Left = 1
      Top = 1
      Width = 453
      Height = 35
      Align = alClient
      Stretch = True
    end
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 24
      Height = 12
      Caption = #38899#31526
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 80
      Top = 17
      Width = 33
      Height = 12
      Caption = #12467#12510#25968
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 160
      Top = 17
      Width = 24
      Height = 12
      Caption = #38899#37327
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label4: TLabel
      Left = 232
      Top = 17
      Width = 24
      Height = 12
      Caption = #32368#36820
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 304
      Top = 17
      Width = 32
      Height = 12
      Caption = #12486#12531#12509
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object spnLength: TSpinEdit
      Left = 32
      Top = 8
      Width = 41
      Height = 21
      MaxValue = 256
      MinValue = 1
      TabOrder = 0
      Value = 16
    end
    object spnWidth: TSpinEdit
      Left = 112
      Top = 8
      Width = 41
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 16
      OnChange = spnWidthChange
    end
    object spnV: TSpinEdit
      Left = 184
      Top = 8
      Width = 41
      Height = 21
      MaxValue = 127
      MinValue = 1
      TabOrder = 2
      Value = 100
    end
    object spnRepeat: TSpinEdit
      Left = 256
      Top = 8
      Width = 41
      Height = 21
      MaxValue = 127
      MinValue = 1
      TabOrder = 3
      Value = 8
    end
    object spnTempo: TSpinEdit
      Left = 336
      Top = 8
      Width = 41
      Height = 21
      MaxValue = 999
      MinValue = 30
      TabOrder = 4
      Value = 120
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 455
    Height = 191
    Align = alClient
    BevelWidth = 3
    TabOrder = 1
    object grdCanvas: TStringGrid
      Left = 3
      Top = 3
      Width = 449
      Height = 185
      Align = alClient
      Color = clBlack
      DefaultColWidth = 20
      DefaultRowHeight = 20
      DefaultDrawing = False
      RowCount = 8
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ParentFont = False
      TabOrder = 0
      OnDrawCell = grdCanvasDrawCell
      OnMouseDown = grdCanvasMouseDown
      OnMouseMove = grdCanvasMouseMove
      OnMouseUp = grdCanvasMouseUp
      RowHeights = (
        20
        20
        20
        20
        20
        20
        20
        20)
    end
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 128
    object File1: TMenuItem
      Caption = #12501#12449#12452#12523'(&F)'
      object mnuNew: TMenuItem
        Caption = #26032#35215#12497#12479#12540#12531
        OnClick = mnuNewClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuOpen: TMenuItem
        Caption = #12497#12479#12540#12531#38283#12367'(&O)'
        OnClick = mnuOpenClick
      end
      object mnuSave: TMenuItem
        Caption = #12497#12479#12540#12531#20445#23384'(&S)'
        OnClick = mnuSaveClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuClose: TMenuItem
        Caption = #38281#12376#12427'(&C)'
        OnClick = mnuCloseClick
      end
    end
    object Edit1: TMenuItem
      Caption = #32232#38598'(&E)'
      object mnuRandom: TMenuItem
        Caption = #25351#23450#34892#12434#12521#12531#12480#12512#12395#37197#32622
        OnClick = mnuRandomClick
      end
      object mnuRep4Koma: TMenuItem
        Caption = #25351#23450#34892#12398#38957#65300#12467#12510#12434#32368#12426#36820#12377
        OnClick = mnuRep4KomaClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuCopyHalf: TMenuItem
        Caption = #20840#12390#12398#12497#12540#12488#12398#21069#21322#12434#24460#21322#12395#12467#12500#12540
        OnClick = mnuCopyHalfClick
      end
    end
    object P1: TMenuItem
      Caption = #20986#21147'(&O)'
      object mnuPasteToEdit: TMenuItem
        Caption = #12456#12487#12451#12479#12408#36028#20184#12369
        OnClick = mnuPasteToEditClick
      end
      object mnuMakeAndCopy: TMenuItem
        Caption = #28436#22863#12497#12479#12540#12531#12434#12467#12500#12540
        OnClick = mnuMakeAndCopyClick
      end
    end
    object N7: TMenuItem
      Caption = #35373#23450'(&Q)'
      object mnuShowVelocity: TMenuItem
        Caption = #38899#37327#12434#34920#31034
        OnClick = mnuShowVelocityClick
      end
    end
    object N3: TMenuItem
      Caption = '|'
    end
    object mnuPlay: TMenuItem
      Caption = #20877#29983'(&P)'
      ShortCut = 120
      OnClick = mnuPlayClick
    end
    object mnuStop: TMenuItem
      Caption = #20572#27490'(&S)'
      ShortCut = 121
      OnClick = mnuStopClick
    end
    object N4: TMenuItem
      Caption = '|'
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'CSV'#12501#12449#12452#12523'(*.csv)|*.csv|'#20840#12390'(*.*)|*.*'
    Left = 376
    Top = 16
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV'#12501#12449#12452#12523'(*.csv)|*.csv|'#20840#12390'(*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 408
    Top = 16
  end
end
