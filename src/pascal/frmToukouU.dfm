object frmToukou: TfrmToukou
  Left = 192
  Top = 107
  Width = 402
  Height = 467
  Caption = #32032#26448#25522#31034#26495#25237#31295#12501#12457#12540#12512
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object grpToukou: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 425
    TabOrder = 0
    object Label2: TLabel
      Left = 16
      Top = 32
      Width = 11
      Height = 12
      Caption = 'ID'
    end
    object Label3: TLabel
      Left = 16
      Top = 56
      Width = 54
      Height = 12
      Caption = #12497#12473#12527#12540#12489
    end
    object Label4: TLabel
      Left = 16
      Top = 80
      Width = 24
      Height = 12
      Caption = #21517#21069
    end
    object Label5: TLabel
      Left = 16
      Top = 104
      Width = 34
      Height = 12
      Caption = 'E-Mail'
    end
    object Label6: TLabel
      Left = 16
      Top = 128
      Width = 52
      Height = 12
      Caption = #65422#65392#65425#65421#65439#65392#65404#65438
    end
    object Label8: TLabel
      Left = 16
      Top = 200
      Width = 36
      Height = 12
      Caption = #33879#20316#27177
    end
    object Label9: TLabel
      Left = 16
      Top = 224
      Width = 24
      Height = 12
      Caption = #31278#39006
    end
    object Label10: TLabel
      Left = 16
      Top = 248
      Width = 43
      Height = 12
      Caption = #12472#12515#12531#12523
    end
    object Label11: TLabel
      Left = 16
      Top = 272
      Width = 24
      Height = 12
      Caption = #38899#28304
    end
    object Label12: TLabel
      Left = 16
      Top = 296
      Width = 37
      Height = 12
      Caption = #12467#12513#12531#12488
    end
    object Label7: TLabel
      Left = 73
      Top = 363
      Width = 265
      Height = 12
      Caption = #12393#12435#12394#22580#38754#12434#24819#23450#12375#12390#20316#12387#12383#12363#12289#12414#12383#33510#21172#12375#12383#28857#12394#12393
    end
    object Label14: TLabel
      Left = 16
      Top = 176
      Width = 24
      Height = 12
      Caption = #26354#21517
    end
    object lblInfo: TLabel
      Left = 144
      Top = 405
      Width = 18
      Height = 12
      Caption = '***'
    end
    object edtID: TEdit
      Left = 72
      Top = 32
      Width = 81
      Height = 20
      ReadOnly = True
      TabOrder = 10
    end
    object edtPw: TEdit
      Left = 72
      Top = 56
      Width = 289
      Height = 20
      TabOrder = 0
    end
    object edtName: TEdit
      Left = 72
      Top = 80
      Width = 289
      Height = 20
      TabOrder = 1
    end
    object edtEMail: TEdit
      Left = 72
      Top = 104
      Width = 289
      Height = 20
      TabOrder = 2
    end
    object edtWeb: TEdit
      Left = 72
      Top = 128
      Width = 289
      Height = 20
      TabOrder = 3
    end
    object memComment: TMemo
      Left = 72
      Top = 296
      Width = 289
      Height = 65
      ScrollBars = ssVertical
      TabOrder = 9
    end
    object cmbCopy: TComboBox
      Left = 72
      Top = 200
      Width = 289
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 5
      Text = #12458#12522#12472#12490#12523
      Items.Strings = (
        #12458#12522#12472#12490#12523
        #12467#12500#12540)
    end
    object btnToukou: TButton
      Left = 240
      Top = 392
      Width = 75
      Height = 25
      Caption = #25237#31295#12377#12427
      TabOrder = 11
      OnClick = btnToukouClick
    end
    object cmbType: TComboBox
      Left = 72
      Top = 224
      Width = 289
      Height = 20
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 6
      Text = #12507#12540#12512#12506#12540#12472#29992'BGM'
      Items.Strings = (
        #12507#12540#12512#12506#12540#12472#29992'BGM'
        #12466#12540#12512#29992'BGM'
        #12381#12398#20182)
    end
    object cmbGenre: TComboBox
      Left = 72
      Top = 248
      Width = 289
      Height = 20
      ItemHeight = 12
      TabOrder = 7
      Text = #12381#12398#20182
      Items.Strings = (
        #12525#12483#12463
        #12509#12483#12503#12473
        #12472#12515#12474
        #12480#12531#12473
        #12486#12463#12494
        #12463#12521#12471#12483#12463
        #31461#35617
        #27665#35617
        #12381#12398#20182)
    end
    object cmbSynth: TComboBox
      Left = 72
      Top = 272
      Width = 289
      Height = 20
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 8
      Text = #12497#12477#12467#12531#20869#34101#38899#28304
      Items.Strings = (
        #12497#12477#12467#12531#20869#34101#38899#28304
        'GM'#38899#28304#27726#29992
        'GS'#38899#28304
        'XG'#38899#28304)
    end
    object edtTitle: TEdit
      Left = 72
      Top = 176
      Width = 289
      Height = 20
      TabOrder = 4
    end
    object chkChange: TCheckBox
      Left = 160
      Top = 32
      Width = 185
      Height = 17
      Caption = #20197#21069#25237#31295#12375#12383#26354#12434#20462#27491#12377#12427#22580#21512
      TabOrder = 12
      OnClick = chkChangeClick
    end
    object Button1: TButton
      Left = 344
      Top = 24
      Width = 25
      Height = 25
      Caption = '?'
      TabOrder = 13
      OnClick = Button1Click
    end
    object bar: TProgressBar
      Left = 8
      Top = 401
      Width = 129
      Height = 16
      TabOrder = 14
    end
    object btnHelp: TButton
      Left = 320
      Top = 392
      Width = 49
      Height = 25
      Caption = #12504#12523#12503
      TabOrder = 15
      OnClick = btnHelpClick
    end
  end
  object http: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = httpWork
    OnWorkBegin = httpWorkBegin
    OnWorkEnd = httpWorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 40
    Top = 320
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = ftpWork
    OnWorkBegin = ftpWorkBegin
    OnWorkEnd = ftpWorkEnd
    Host = 'ftp.text2music.com'
    Password = 'futagawasyou'
    Username = 'midi'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 40
    Top = 352
  end
end
