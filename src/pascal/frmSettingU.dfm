object frmSetting: TfrmSetting
  Left = 305
  Top = 150
  Width = 545
  Height = 561
  Caption = #35373#23450
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object page: TPageControl
    Left = 0
    Top = 0
    Width = 529
    Height = 481
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #35211#12383#30446#12539#12473#12461#12531#27231#33021
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 497
        Height = 201
        Caption = #12473#12461#12531#12398#35373#23450
        TabOrder = 0
        object Bevel1: TBevel
          Left = 192
          Top = 48
          Width = 169
          Height = 137
        end
        object imgSkin: TImage
          Left = 200
          Top = 56
          Width = 153
          Height = 121
          Proportional = True
          Stretch = True
        end
        object listSkin: TListBox
          Left = 16
          Top = 48
          Width = 169
          Height = 137
          ItemHeight = 12
          TabOrder = 0
          OnClick = listSkinClick
        end
        object btnSkinAdd: TButton
          Left = 368
          Top = 160
          Width = 121
          Height = 25
          Caption = #20219#24847#30011#20687#12434#36861#21152
          TabOrder = 1
          OnClick = btnSkinAddClick
        end
        object edtSkinPath: TEdit
          Left = 136
          Top = 16
          Width = 353
          Height = 20
          BorderStyle = bsNone
          TabOrder = 2
        end
        object chkSkinUse: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = #12473#12461#12531#27231#33021#12434#20351#12358
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = chkSkinUseClick
        end
        object Memo1: TMemo
          Left = 368
          Top = 48
          Width = 121
          Height = 105
          Color = clBtnFace
          Lines.Strings = (
            #12473#12461#12531#27231#33021#12434#20351#12358#12392#12469
            #12463#12521#12398#12456#12487#12451#12479#12398#32257#12364
            #33775#12420#12363#12395#30011#20687#12391#24425#12425
            #12428#12414#12377#12290
            #24038#12398#12522#12473#12488#12508#12483#12463#12473#12363#12425
            #30011#20687#12434#36984#25246#12377#12427#12363#12289#19979
            #12398#12508#12479#12531#12434#25276#12375#12390#12289#20219
            #24847#12398#30011#20687#12434#36984#25246#12375#12414#12377
            #12290)
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #12503#12524#12452#12516
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 454
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object grpPlayer: TRadioGroup
          Left = 8
          Top = 8
          Width = 233
          Height = 97
          Caption = #12503#12524#12452#12516#12540#12398#31278#39006
          ItemIndex = 2
          Items.Strings = (
            'MCI - Windows '#12513#12487#12451#12450#12503#12524#12452#12516#12540
            'TMIDI'
            #12469#12463#12521#20869#34101#12503#12524#12452#12516#12540
            'TW-MUSIC2')
          TabOrder = 0
          OnClick = grpPlayerClick
        end
        object Memo2: TMemo
          Left = 256
          Top = 16
          Width = 257
          Height = 89
          BorderStyle = bsNone
          Lines.Strings = (
            #12469#12463#12521#12398#20869#34101#12503#12524#12452#12516#12540#12434#36984#25246#12375#12383#22580#21512#12398#12415#12289#28436
            #22863#12514#12491#12479#12540#12394#12393#12398#35576#27231#33021#12364#20351#12360#12414#12377#12290
            ''
            'TMIDI/TW-MUSIC2'#12434#20351#12358#22580#21512#12399#12289#12452#12531#12473#12488#12540#12523#12375
            #12383#22580#25152#12434#25351#23450#12377#12427#24517#35201#12364#12354#12426#12414#12377#12290)
          TabOrder = 1
        end
        object grpTMidi: TGroupBox
          Left = 152
          Top = 256
          Width = 353
          Height = 57
          Caption = 'TMidi'#12398#12497#12473
          TabOrder = 2
          object edtTmidiPath: TEdit
            Left = 16
            Top = 21
            Width = 217
            Height = 20
            TabOrder = 0
          end
          object btnTMidiGet: TButton
            Left = 236
            Top = 21
            Width = 38
            Height = 19
            Caption = #21442#29031
            TabOrder = 1
            OnClick = btnTMidiGetClick
          end
          object btnTMidiDownload: TButton
            Left = 280
            Top = 21
            Width = 60
            Height = 19
            Caption = #65408#65438#65395#65437#65435#65392#65412#65438
            TabOrder = 2
            OnClick = btnTMidiDownloadClick
          end
        end
        object grpSmfPlayer: TGroupBox
          Left = 8
          Top = 120
          Width = 497
          Height = 121
          Caption = #12469#12463#12521#20869#34101#12503#12524#12452#12516#12540#12398#35373#23450
          TabOrder = 3
          object Label1: TLabel
            Left = 8
            Top = 24
            Width = 60
            Height = 12
            Caption = #9679#28436#22863#31934#24230
          end
          object lblPlayerWaitTime: TLabel
            Left = 16
            Top = 40
            Width = 6
            Height = 12
            Caption = '5'
          end
          object Label2: TLabel
            Left = 48
            Top = 40
            Width = 27
            Height = 12
            Caption = 'msec'
          end
          object Label3: TLabel
            Left = 272
            Top = 24
            Width = 200
            Height = 12
            Caption = #25968#20516#12364#20302#12356#12411#12393#31934#24230#12364#39640#12367#12394#12426#12414#12377#12364#12289
          end
          object Label4: TLabel
            Left = 272
            Top = 40
            Width = 160
            Height = 12
            Caption = #12497#12477#12467#12531#12398#21205#20316#12364#37325#12367#12394#12426#12414#12377#12290
          end
          object Label5: TLabel
            Left = 8
            Top = 64
            Width = 115
            Height = 12
            Caption = #9679#12514#12491#12479#12540#12398#25551#30011#31934#24230
          end
          object lblPlayerDrawWaitTime: TLabel
            Left = 16
            Top = 88
            Width = 24
            Height = 12
            Caption = '1000'
          end
          object Label7: TLabel
            Left = 48
            Top = 88
            Width = 27
            Height = 12
            Caption = 'msec'
          end
          object scrPlayerWaitTime: TScrollBar
            Left = 88
            Top = 24
            Width = 153
            Height = 25
            Max = 50
            PageSize = 0
            Position = 5
            TabOrder = 0
            OnChange = scrPlayerWaitTimeChange
          end
          object scrPlayerDrawWaitTime: TScrollBar
            Left = 88
            Top = 80
            Width = 153
            Height = 24
            Max = 1000
            Min = 1
            PageSize = 0
            Position = 100
            TabOrder = 1
            OnChange = scrPlayerDrawWaitTimeChange
          end
          object btnPlayerPort: TButton
            Left = 366
            Top = 88
            Width = 123
            Height = 25
            Caption = 'MIDI'#12509#12540#12488#12398#21106#12426#24403#12390
            TabOrder = 2
            OnClick = btnPlayerPortClick
          end
        end
        object grpPlayerSynthType: TRadioGroup
          Left = 8
          Top = 256
          Width = 137
          Height = 121
          Caption = #38899#28304#12398#31278#39006
          ItemIndex = 0
          Items.Strings = (
            'GM'
            'GS'
            'XG'
            #25658#24111#31471#26411)
          TabOrder = 4
        end
        object grpTW: TGroupBox
          Left = 152
          Top = 320
          Width = 353
          Height = 57
          Caption = 'TW-Music'#12398#12497#12473
          TabOrder = 5
          object edtTWPath: TEdit
            Left = 16
            Top = 21
            Width = 217
            Height = 20
            TabOrder = 0
          end
          object btnTWGet: TButton
            Left = 236
            Top = 21
            Width = 38
            Height = 19
            Caption = #21442#29031
            TabOrder = 1
            OnClick = btnTWGetClick
          end
          object btnTWDownload: TButton
            Left = 280
            Top = 21
            Width = 60
            Height = 19
            Caption = #65408#65438#65395#65437#65435#65392#65412#65438
            TabOrder = 2
            OnClick = btnTWDownloadClick
          end
        end
        object GroupBox6: TGroupBox
          Left = 8
          Top = 384
          Width = 497
          Height = 65
          Caption = 'OS'#12510#12523#12481#12513#12487#12451#12450
          TabOrder = 6
          object btnMultimedia: TButton
            Left = 16
            Top = 24
            Width = 161
            Height = 25
            Caption = #12510#12523#12481#12513#12487#12451#12450#12398#35373#23450#12434#38283#12367
            TabOrder = 0
            OnClick = btnMultimediaClick
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #28436#22863#12514#12491#12479#12540
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 454
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object imgMon: TImage
          Left = 16
          Top = 40
          Width = 153
          Height = 337
          OnMouseDown = imgMonMouseDown
        end
        object Label6: TLabel
          Left = 40
          Top = 16
          Width = 99
          Height = 12
          Caption = #37197#33394#12398#12459#12473#12479#12510#12452#12474
        end
        object GroupBox2: TGroupBox
          Left = 184
          Top = 296
          Width = 329
          Height = 81
          Caption = #29694#22312#12398#37197#33394#12487#12540#12479
          TabOrder = 0
          object memColor: TEdit
            Left = 8
            Top = 21
            Width = 313
            Height = 20
            TabOrder = 0
          end
          object btnColorCopy: TButton
            Left = 8
            Top = 48
            Width = 97
            Height = 25
            Caption = #37197#33394#12434#12467#12500#12540
            TabOrder = 1
            OnClick = btnColorCopyClick
          end
          object btnColorPaste: TButton
            Left = 112
            Top = 48
            Width = 97
            Height = 25
            Caption = #37197#33394#12434#36028#12426#20184#12369
            TabOrder = 2
            OnClick = btnColorPasteClick
          end
          object btnMemoToColor: TButton
            Left = 216
            Top = 48
            Width = 105
            Height = 25
            Caption = #37197#33394#12434#21453#26144
            TabOrder = 3
            OnClick = btnMemoToColorClick
          end
        end
        object GroupBox3: TGroupBox
          Left = 184
          Top = 32
          Width = 329
          Height = 185
          Caption = #37197#33394#12521#12452#12502#12521#12522#12540
          TabOrder = 1
          object lstColor: TListBox
            Left = 16
            Top = 24
            Width = 297
            Height = 121
            ItemHeight = 12
            TabOrder = 0
            OnClick = lstColorClick
          end
          object btnColorRegLib: TButton
            Left = 120
            Top = 152
            Width = 193
            Height = 25
            Caption = #29694#22312#12398#35373#23450#12434#37197#33394#12521#12452#12502#12521#12522#12395#30331#37682
            TabOrder = 1
            OnClick = btnColorRegLibClick
          end
          object btnColorLoadLib: TButton
            Left = 16
            Top = 152
            Width = 33
            Height = 25
            Caption = #35501#36796
            TabOrder = 2
            OnClick = btnColorLoadLibClick
          end
          object btnColorDelLib: TButton
            Left = 56
            Top = 152
            Width = 49
            Height = 25
            Caption = #21066#38500
            TabOrder = 3
            OnClick = btnColorDelLibClick
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'MIDI'#20837#21147
      ImageIndex = 3
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 454
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object GroupBox4: TGroupBox
          Left = 8
          Top = 16
          Width = 505
          Height = 153
          Caption = #30435#35222#12377#12427'MIDI'#12509#12540#12488
          TabOrder = 0
          object chkKansiMidiIn: TCheckBox
            Left = 16
            Top = 32
            Width = 145
            Height = 17
            Caption = 'MIDI-IN'#12434#30435#35222#12377#12427
            TabOrder = 0
            OnClick = chkKansiMidiInClick
          end
          object lstMidiIn: TListBox
            Left = 248
            Top = 16
            Width = 241
            Height = 121
            ItemHeight = 12
            TabOrder = 1
          end
        end
        object GroupBox5: TGroupBox
          Left = 8
          Top = 192
          Width = 505
          Height = 169
          Caption = #30435#35222#12375#12390#12393#12358#12377#12427#12398#12363#65311
          TabOrder = 1
          object Label8: TLabel
            Left = 256
            Top = 24
            Width = 135
            Height = 12
            Caption = #12473#12523#12540#12377#12427#20808#12398'MIDI'#12509#12540#12488
          end
          object chkMidiInToOut: TCheckBox
            Left = 16
            Top = 32
            Width = 153
            Height = 17
            Caption = 'MIDI-OUT'#12408#12473#12523#12540#12377#12427
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object cmbMidiOut: TComboBox
            Left = 256
            Top = 40
            Width = 233
            Height = 22
            Style = csOwnerDrawFixed
            ItemHeight = 16
            TabOrder = 1
          end
          object chkMidiInToEdit: TCheckBox
            Left = 16
            Top = 80
            Width = 209
            Height = 17
            Caption = #12456#12487#12451#12479#12395#38899#38542#12434#36028#12426#20184#12369#12427
            TabOrder = 2
          end
        end
      end
    end
  end
  object btnOk: TButton
    Left = 344
    Top = 488
    Width = 99
    Height = 25
    Caption = #27770#23450'(&O)'
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 448
    Top = 488
    Width = 73
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object dlgPic: TOpenDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG|*.jpg'
    Left = 488
    Top = 384
  end
  object dlgExe: TOpenDialog
    DefaultExt = 'exe'
    Filter = #23455#34892#12501#12449#12452#12523'|*.exe'
    Left = 456
    Top = 384
  end
  object dlgColor: TColorDialog
    Left = 424
    Top = 384
  end
end
