object frmSakuraPad: TfrmSakuraPad
  Left = 194
  Top = 108
  Width = 769
  Height = 577
  Caption = #12486#12461#12473#12488#38899#27005#12300#12469#12463#12521#12301
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object panelForm: TPanel
    Left = 0
    Top = 31
    Width = 761
    Height = 470
    Align = alClient
    BevelOuter = bvLowered
    UseDockManager = False
    DragKind = dkDock
    TabOrder = 0
    object splitBottom: TSplitter
      Left = 1
      Top = 362
      Width = 759
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
    end
    object splitLeft: TSplitter
      Left = 186
      Top = 1
      Height = 361
      OnMoved = splitLeftMoved
    end
    object pageBottom: TPageControl
      Left = 1
      Top = 370
      Width = 759
      Height = 99
      ActivePage = tabError
      Align = alBottom
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      HotTrack = True
      ParentFont = False
      TabHeight = 12
      TabOrder = 0
      TabPosition = tpBottom
      object tabError: TTabSheet
        Caption = 'Text'
        ImageIndex = 2
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 751
          Height = 79
          Align = alClient
          BevelOuter = bvLowered
          Caption = 'Panel5'
          TabOrder = 0
          object Panel8: TPanel
            Left = 1
            Top = 1
            Width = 17
            Height = 77
            Align = alLeft
            TabOrder = 0
            object tabErrTabClose2: TSpeedButton
              Left = 1
              Top = 0
              Width = 15
              Height = 16
              Flat = True
              Glyph.Data = {
                E6010000424DE60100000000000036000000280000000C0000000C0000000100
                180000000000B0010000130B0000130B00000000000000000000687ED41636B7
                1838B91A39B71939B81739BA1338BD0D35C00931BF032DC0062CBA6176C8173E
                D72448D92E50DB3053DC2E53DC2B53DD2450DF1B4CE01246E1093EE00234D905
                2BB81D44DE3356E25874E78097EE3E61E53960E5305DE72458E8698DF02E60EC
                063CE1022BBD274CE04060E4889CEEF1F3FD9DB0F24168E73964E891ABF4EEF2
                FD6489F10E42E20831BF3154E24967E6516EE7A4B3F2FFFFFF8FA6F18DA5F1FC
                FCFF87A3F3184EE71547E10F36C03D5DE3536FE75771E75370E796A8F0F9FAFE
                F8FAFE819BF12353E61D4DE61D4BE0173BBE4564E55A75E85A74E85570E697A8
                F0F9FAFEF8F9FE839BF02651E4204DE4244DDE1C3DBD516EE6647EE95F79E8A7
                B4F3FFFFFF8EA1EF8C9FEFFFFFFF8CA1F0264DE2294FDD2040BC5975E87088EB
                9CADF1F3F4FDA2B0F24764E43E5EE495A7F0EFF2FD748DEC2D51DC2341BB6580
                EA8398EE879CEE9BABF15C75E8516DE64A67E54362E48397ED5371E73153DD20
                40BA788FEC95A7F08095ED7089EB6881E9627CE85F79E85974E8506EE64564E4
                3255DD2140BAA2B1F2758CEC617CE95672E7506DE64B6AE64967E54363E53E5F
                E33457E2294DDA7085D6}
              OnClick = btnErrTabCloseClick
            end
          end
          object edtError: TEditor
            Left = 18
            Top = 1
            Width = 732
            Height = 77
            Cursor = crIBeam
            Align = alClient
            Caret.AutoCursor = True
            Caret.AutoIndent = True
            Caret.BackSpaceUnIndent = True
            Caret.Cursors.DefaultCursor = crIBeam
            Caret.Cursors.DragSelCursor = crDrag
            Caret.Cursors.DragSelCopyCursor = 1959
            Caret.Cursors.InSelCursor = crDefault
            Caret.Cursors.LeftMarginCursor = 1958
            Caret.Cursors.TopMarginCursor = crDefault
            Caret.FreeCaret = True
            Caret.FreeRow = False
            Caret.InTab = False
            Caret.KeepCaret = False
            Caret.LockScroll = False
            Caret.NextLine = True
            Caret.PrevSpaceIndent = False
            Caret.RowSelect = True
            Caret.SelDragMode = dmAutomatic
            Caret.SelMove = True
            Caret.SoftTab = False
            Caret.Style = csDefault
            Caret.TabIndent = False
            Caret.TabSpaceCount = 8
            Caret.TokenEndStop = False
            Font.Charset = SHIFTJIS_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            HitStyle = hsSelect
            Imagebar.DigitWidth = 8
            Imagebar.LeftMargin = 2
            Imagebar.MarkWidth = 0
            Imagebar.RightMargin = 2
            Imagebar.Visible = False
            Marks.EofMark.Color = clGray
            Marks.EofMark.Visible = False
            Marks.RetMark.Color = clGray
            Marks.RetMark.Visible = False
            Marks.WrapMark.Color = clGray
            Marks.WrapMark.Visible = False
            Marks.HideMark.Color = clGray
            Marks.HideMark.Visible = False
            Marks.Underline.Color = clGray
            Marks.Underline.Visible = False
            Margin.Character = 0
            Margin.Left = 4
            Margin.Line = 2
            Margin.Top = 2
            Leftbar.BkColor = clSilver
            Leftbar.Color = clBlack
            Leftbar.Column = 4
            Leftbar.Edge = True
            Leftbar.LeftMargin = 8
            Leftbar.RightMargin = 4
            Leftbar.ShowNumber = True
            Leftbar.ShowNumberMode = nmRow
            Leftbar.Visible = False
            Leftbar.ZeroBase = False
            Leftbar.ZeroLead = False
            PopupMenu = popMessageBox
            ReadOnly = False
            Ruler.BkColor = clSilver
            Ruler.Color = clBlack
            Ruler.Edge = False
            Ruler.GaugeRange = 10
            Ruler.MarkColor = clBlack
            Ruler.Visible = False
            ScrollBars = ssVertical
            Speed.CaretVerticalAc = 2
            Speed.InitBracketsFull = False
            Speed.PageVerticalRange = 2
            Speed.PageVerticalRangeAc = 2
            TabOrder = 1
            UndoListMax = 64
            View.Brackets = <
              item
                ItemColor.BkColor = clAqua
                ItemColor.Color = clBlue
                ItemColor.Style = []
                LeftBracket = '['
                RightBracket = ']'
              end
              item
                ItemColor.BkColor = clNone
                ItemColor.Color = clBlue
                ItemColor.Style = []
                LeftBracket = '('
                RightBracket = ')'
              end>
            View.Colors.Ank.BkColor = clNone
            View.Colors.Ank.Color = clNone
            View.Colors.Ank.Style = []
            View.Colors.Comment.BkColor = clNone
            View.Colors.Comment.Color = clNone
            View.Colors.Comment.Style = []
            View.Colors.DBCS.BkColor = clNone
            View.Colors.DBCS.Color = clNone
            View.Colors.DBCS.Style = []
            View.Colors.Hit.BkColor = clNone
            View.Colors.Hit.Color = clNone
            View.Colors.Hit.Style = []
            View.Colors.Int.BkColor = clNone
            View.Colors.Int.Color = clMaroon
            View.Colors.Int.Style = []
            View.Colors.Mail.BkColor = clNone
            View.Colors.Mail.Color = clNone
            View.Colors.Mail.Style = []
            View.Colors.Reserve.BkColor = clAqua
            View.Colors.Reserve.Color = clBlue
            View.Colors.Reserve.Style = []
            View.Colors.Select.BkColor = clNavy
            View.Colors.Select.Color = clWhite
            View.Colors.Select.Style = []
            View.Colors.Str.BkColor = clNone
            View.Colors.Str.Color = clNone
            View.Colors.Str.Style = []
            View.Colors.Symbol.BkColor = clNone
            View.Colors.Symbol.Color = clBlue
            View.Colors.Symbol.Style = []
            View.Colors.Url.BkColor = clNone
            View.Colors.Url.Color = clNone
            View.Colors.Url.Style = []
            View.ControlCode = False
            View.Mail = False
            View.Url = False
            WantReturns = True
            WantTabs = True
            WordWrap = True
            WrapOption.FollowRetMark = False
            WrapOption.FollowPunctuation = False
            WrapOption.FollowStr = #12289#12290#65292#65294#12539#65311#65281#12443#12444#12541#12542#12445#12446#12293#12540#65289#65341#65373#12301#12303'!),.:;?]}'#65377#65379#65380#65381#65392#65438#65439
            WrapOption.Leading = True
            WrapOption.LeadStr = #65288#65339#65371#12300#12302'([{'#65378
            WrapOption.PunctuationStr = #12289#12290#65292#65294',.'#65377#65380
            WrapOption.WordBreak = False
            WrapOption.WrapByte = 100
            OnClick = edtErrorClick
            OnDblClick = edtErrorDblClick
          end
        end
      end
      object tabHTML: TTabSheet
        Caption = 'Html'
        ImageIndex = 1
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 751
          Height = 79
          Align = alClient
          BevelOuter = bvLowered
          Caption = 'Panel2'
          TabOrder = 0
          object panelManual: TPanel
            Left = 1
            Top = 1
            Width = 27
            Height = 77
            Align = alLeft
            TabOrder = 0
            object btnBack: TSpeedButton
              Left = 0
              Top = 16
              Width = 25
              Height = 25
              Hint = '1'#12388#21069#12398#12506#12540#12472#12395#25147#12427
              Flat = True
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333333333333333333333333333333333333333333333333333333333333333
                3333333333333FF3333333333333003333333333333F77F33333333333009033
                333333333F7737F333333333009990333333333F773337FFFFFF330099999000
                00003F773333377777770099999999999990773FF33333FFFFF7330099999000
                000033773FF33777777733330099903333333333773FF7F33333333333009033
                33333333337737F3333333333333003333333333333377333333333333333333
                3333333333333333333333333333333333333333333333333333333333333333
                3333333333333333333333333333333333333333333333333333}
              NumGlyphs = 2
              ParentShowHint = False
              ShowHint = True
              OnClick = btnBackClick
            end
            object btnShowNewBrowser: TSpeedButton
              Left = 0
              Top = 41
              Width = 25
              Height = 25
              Hint = #12502#12521#12454#12470#12391#34920#31034#12377#12427
              Flat = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000C40E0000C40E00000000000000000000C6C3C6C6C3C6
                C6C1BFC7BDB6C8BFB8C6C3C5C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3
                C6C6C3C6C6C3C6C6C3C6C6C3C6C8C1BECBA979CB974BD1A367CAB9A8BEB1A6B2
                AAA5B2AAA5B2AAA5B3ABA7C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6CFBBA0
                CF9745C1AB93C6C3C6B4864CB07535946B3599723A93734097733DA89D94B3AB
                A6C6C3C6C6C3C6C6C3C6C6C3C6D3BE9ED09744BDA895A69B92A87736DF8C35EA
                9D37F4AC42EDB756F0BC58A18152927452B3ABA7C6C3C6C6C3C6C6C3C6D2BEA3
                DAA147A7885CB1813FE99C31ED992FD0872FAC7533C98C39F7C157F2CB77C093
                58AE9881C6C3C6C6C3C6C6C3C6C9C1BCDFB56FD79A32E9A12DE9992CD18629A7
                7E57AA9D95BAA593CC8E3CFAC254ECC372C59A67C3B4A8C6C3C6C6C3C6C6C3C6
                D8BD93F3B540F1A92BE29223A16421775C3E7F6A527F6A527C5B338A6835896C
                3F7F603AAEA298C6C3C6C6C3C6C6C3C6C8C3C1E6BF68F1B02CE59A22CF7628CA
                752ACA752ACA752ACA752ACA752ACA752ABB7531BEAA99C6C3C6C6C3C6C6C3C6
                C8C3C3C8C3C4EDC65EEFB02CDE9722D9932CE39B3BE2942EE4952AF09832F3A1
                3BD08E3CC1AC9AC6C3C6C6C3C6C6C3C6D5C7B4D7C8B1E6C673F1C141AE7D2A87
                7159B1A8A4B4804AD28F2EEE982BEB9C33CC9047C2B1A4C6C3C6C6C3C6C6C3C6
                C6C3C6DBC7A5D6C7ACE6C56FD5AA4B89682B876029B87B2AE49B26EC9D2CDD95
                39BEA083C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6CCC1B2DCC691D2C4A5EED56EDF
                BA40DBA42BE8A729EBA626EAA230CC9550C5AF93C8C2BEC6C3C6C6C3C6C6C3C6
                C6C3C6C6C3C6CCC1B1CFC2A7DEC97AE1C974E7BE54F4BD3DD39533CB9147C1AE
                9FCEC0A7CBC1B4C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C7C3C4CBC1B3CB
                C1B3CDC0A8DEC381D6B474C1B0A1C6C3C6CEC0A7CBC1B4C6C3C6C6C3C6C6C3C6
                C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C9C2BCCEC6B7E0CC99DBC7
                99CEC1AAC7C3C2C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6
                C3C6C6C3C6C6C3C6C6C3C6CAC4C0C9C3C0C7C3C3C6C3C6C6C3C6}
              ParentShowHint = False
              ShowHint = True
              OnClick = btnShowNewBrowserClick
            end
            object btnErrTabClose: TSpeedButton
              Left = 2
              Top = 0
              Width = 15
              Height = 16
              Flat = True
              Glyph.Data = {
                E6010000424DE60100000000000036000000280000000C0000000C0000000100
                180000000000B0010000130B0000130B00000000000000000000687ED41636B7
                1838B91A39B71939B81739BA1338BD0D35C00931BF032DC0062CBA6176C8173E
                D72448D92E50DB3053DC2E53DC2B53DD2450DF1B4CE01246E1093EE00234D905
                2BB81D44DE3356E25874E78097EE3E61E53960E5305DE72458E8698DF02E60EC
                063CE1022BBD274CE04060E4889CEEF1F3FD9DB0F24168E73964E891ABF4EEF2
                FD6489F10E42E20831BF3154E24967E6516EE7A4B3F2FFFFFF8FA6F18DA5F1FC
                FCFF87A3F3184EE71547E10F36C03D5DE3536FE75771E75370E796A8F0F9FAFE
                F8FAFE819BF12353E61D4DE61D4BE0173BBE4564E55A75E85A74E85570E697A8
                F0F9FAFEF8F9FE839BF02651E4204DE4244DDE1C3DBD516EE6647EE95F79E8A7
                B4F3FFFFFF8EA1EF8C9FEFFFFFFF8CA1F0264DE2294FDD2040BC5975E87088EB
                9CADF1F3F4FDA2B0F24764E43E5EE495A7F0EFF2FD748DEC2D51DC2341BB6580
                EA8398EE879CEE9BABF15C75E8516DE64A67E54362E48397ED5371E73153DD20
                40BA788FEC95A7F08095ED7089EB6881E9627CE85F79E85974E8506EE64564E4
                3255DD2140BAA2B1F2758CEC617CE95672E7506DE64B6AE64967E54363E53E5F
                E33457E2294DDA7085D6}
              OnClick = btnErrTabCloseClick
            end
          end
          object browser: TWebBrowser
            Left = 28
            Top = 1
            Width = 722
            Height = 77
            Align = alClient
            TabOrder = 1
            OnBeforeNavigate2 = browserBeforeNavigate2
            ControlData = {
              4C0000009F4A0000F50700000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E126208000000000000004C0000000114020000000000C000000000000046
              8000000000000000000000000000000000000000000000000000000000000000
              00000000000000000100000000000000000000000000000000000000}
          end
        end
      end
    end
    object panelLeft: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 361
      Align = alLeft
      TabOrder = 1
      OnClick = panelLeftClick
      object panelLeftTop: TPanel
        Left = 1
        Top = 1
        Width = 183
        Height = 15
        Align = alTop
        Color = clSkyBlue
        TabOrder = 0
        OnClick = panelLeftClick
        object imgLeftTop: TImage
          Left = 1
          Top = 1
          Width = 181
          Height = 13
          Align = alClient
          OnClick = panelLeftClick
        end
        object btnLeftPanelClose: TSpeedButton
          Left = 167
          Top = 0
          Width = 14
          Height = 13
          Flat = True
          Glyph.Data = {
            E6010000424DE60100000000000036000000280000000C0000000C0000000100
            180000000000B0010000130B0000130B00000000000000000000687ED41636B7
            1838B91A39B71939B81739BA1338BD0D35C00931BF032DC0062CBA6176C8173E
            D72448D92E50DB3053DC2E53DC2B53DD2450DF1B4CE01246E1093EE00234D905
            2BB81D44DE3356E25874E78097EE3E61E53960E5305DE72458E8698DF02E60EC
            063CE1022BBD274CE04060E4889CEEF1F3FD9DB0F24168E73964E891ABF4EEF2
            FD6489F10E42E20831BF3154E24967E6516EE7A4B3F2FFFFFF8FA6F18DA5F1FC
            FCFF87A3F3184EE71547E10F36C03D5DE3536FE75771E75370E796A8F0F9FAFE
            F8FAFE819BF12353E61D4DE61D4BE0173BBE4564E55A75E85A74E85570E697A8
            F0F9FAFEF8F9FE839BF02651E4204DE4244DDE1C3DBD516EE6647EE95F79E8A7
            B4F3FFFFFF8EA1EF8C9FEFFFFFFF8CA1F0264DE2294FDD2040BC5975E87088EB
            9CADF1F3F4FDA2B0F24764E43E5EE495A7F0EFF2FD748DEC2D51DC2341BB6580
            EA8398EE879CEE9BABF15C75E8516DE64A67E54362E48397ED5371E73153DD20
            40BA788FEC95A7F08095ED7089EB6881E9627CE85F79E85974E8506EE64564E4
            3255DD2140BAA2B1F2758CEC617CE95672E7506DE64B6AE64967E54363E53E5F
            E33457E2294DDA7085D6}
          OnClick = btnLeftPanelCloseClick
        end
      end
      object pageLeft: TPageControl
        Left = 1
        Top = 16
        Width = 183
        Height = 344
        ActivePage = tabList
        Align = alClient
        DockSite = True
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        HotTrack = True
        MultiLine = True
        ParentFont = False
        TabOrder = 1
        OnChange = pageLeftChange
        object tabComment: TTabSheet
          Caption = #12375#12362#12426
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 175
            Height = 33
            Align = alTop
            BevelOuter = bvLowered
            TabOrder = 0
            object Label1: TLabel
              Left = 114
              Top = 12
              Width = 22
              Height = 11
              Caption = #12398#34892
              Font.Charset = SHIFTJIS_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
              Font.Style = []
              ParentFont = False
            end
            object cmbComment: TComboBox
              Left = 48
              Top = 8
              Width = 65
              Height = 20
              ItemHeight = 12
              TabOrder = 0
              Text = '//_'
              OnKeyDown = cmbCommentKeyDown
              Items.Strings = (
                '//TODO'
                '//'
                '//_'
                '/**'
                '#'
                'Int'
                'Str'
                'Function'
                'PlayFrom'
                'Track'
                'TR'
                'Channel'
                'CH')
            end
            object btnEnumComment: TButton
              Left = 8
              Top = 8
              Width = 36
              Height = 20
              Caption = #21015#25369
              TabOrder = 1
              OnClick = btnEnumCommentClick
            end
          end
          object lstComment: TListBox
            Left = 0
            Top = 33
            Width = 175
            Height = 267
            Style = lbOwnerDrawFixed
            Align = alClient
            Font.Charset = SHIFTJIS_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ItemHeight = 20
            ParentFont = False
            TabOrder = 1
            OnClick = lstCommentClick
            OnDrawItem = lstCommentDrawItem
          end
        end
        object tabCommand: TTabSheet
          Caption = #65404#65405#65411#65425
          ImageIndex = 1
          object Splitter3: TSplitter
            Left = 0
            Top = 97
            Width = 175
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object lstCmdGroup: TListBox
            Left = 0
            Top = 0
            Width = 175
            Height = 97
            Style = lbOwnerDrawFixed
            Align = alTop
            ItemHeight = 16
            TabOrder = 0
            OnClick = lstCmdGroupClick
            OnDrawItem = lstCmdGroupDrawItem
          end
          object lstCommand: TListBox
            Left = 0
            Top = 100
            Width = 175
            Height = 200
            Style = lbOwnerDrawFixed
            Align = alClient
            DragMode = dmAutomatic
            ItemHeight = 16
            PopupMenu = popupMenuSystemTab
            TabOrder = 1
            OnClick = lstCommandClick
            OnDblClick = lstCommandDblClick
            OnDrawItem = lstCommandDrawItem
          end
        end
        object tabInclude: TTabSheet
          Caption = #23450#32681
          ImageIndex = 2
          object Splitter4: TSplitter
            Left = 0
            Top = 97
            Width = 175
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object lstFiles: TListBox
            Tag = 4
            Left = 0
            Top = 0
            Width = 175
            Height = 97
            Style = lbOwnerDrawFixed
            Align = alTop
            DragMode = dmAutomatic
            ItemHeight = 16
            PopupMenu = popupMenuInclude
            Sorted = True
            TabOrder = 0
            OnClick = lstFilesClick
            OnDrawItem = lstFilesDrawItem
          end
          object Panel1: TPanel
            Left = 0
            Top = 274
            Width = 175
            Height = 26
            Align = alBottom
            BevelOuter = bvLowered
            TabOrder = 1
            object chkSortUserFunc: TCheckBox
              Left = 6
              Top = 6
              Width = 115
              Height = 17
              Caption = #12450#12523#12501#12449#12505#12483#12488#38918
              TabOrder = 0
              OnClick = chkSortUserFuncClick
            end
          end
          object lstUser: TListBox
            Tag = 1
            Left = 0
            Top = 100
            Width = 175
            Height = 174
            Style = lbOwnerDrawFixed
            Align = alClient
            DragMode = dmAutomatic
            Font.Charset = SHIFTJIS_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ItemHeight = 16
            ParentFont = False
            ParentShowHint = False
            PopupMenu = popupDefine
            ShowHint = False
            TabOrder = 2
            OnClick = lstUserClick
            OnDblClick = lstUserDblClick
            OnDrawItem = lstUserDrawItem
          end
        end
        object tabList: TTabSheet
          Caption = #38899#33394
          ImageIndex = 3
          object Splitter5: TSplitter
            Left = 0
            Top = 137
            Width = 175
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object imgGakki: TImage
            Left = 48
            Top = 120
            Width = 25
            Height = 25
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000C40E0000C40E0000100000000000
              0000000000000082840000FFFF00C6C3C60084828400FFFFFF00000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000555555500555555555555501045555555555501033455545555501445545
              5455555012035545455550012503554555550142520055455555123525040545
              4444123252030545555515352500554555555112520355454555555125035545
              5455555512445545554555555120554555555555551404555555555555500555
              5555}
          end
          object imgDown: TImage
            Left = 40
            Top = 120
            Width = 25
            Height = 25
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000C40E0000C40E0000100000000000
              0000FFFFFF00008AE50033DBFF000077B2000000000033BBFF00FFFFFF000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000013333331000000002555555300000000255555530000000025555553
              0000000025555553000000002555555300000000255555530000000002222221
              0000000000000000000000000000000000000000000000000000000000000000
              0000}
          end
          object lstVoice: TListBox
            Tag = 2
            Left = 0
            Top = 140
            Width = 175
            Height = 160
            Style = lbOwnerDrawFixed
            Align = alClient
            DragMode = dmAutomatic
            ItemHeight = 20
            TabOrder = 0
            OnDblClick = lstVoiceDblClick
            OnDrawItem = lstVoiceDrawItem
            OnExit = lstVoiceExit
            OnMouseDown = lstVoiceMouseDown
            OnMouseUp = lstVoiceMouseUp
          end
          object lstVoiceGroup: TListBox
            Left = 0
            Top = 0
            Width = 175
            Height = 137
            Style = lbOwnerDrawFixed
            Align = alTop
            ItemHeight = 18
            TabOrder = 1
            OnClick = lstVoiceGroupClick
            OnDrawItem = lstVoiceGroupDrawItem
          end
        end
        object tabHelp: TTabSheet
          Caption = #12504#12523#12503
          ImageIndex = 5
          object panelPicture: TPanel
            Left = 0
            Top = 0
            Width = 175
            Height = 285
            Align = alClient
            BevelOuter = bvLowered
            Caption = #12463#12452#12483#12463#12504#12523#12503
            TabOrder = 0
            object Splitter1: TSplitter
              Left = 1
              Top = 49
              Width = 173
              Height = 3
              Cursor = crVSplit
              Align = alTop
            end
            object lstHelp: TListBox
              Left = 1
              Top = 52
              Width = 173
              Height = 232
              Style = lbOwnerDrawFixed
              Align = alClient
              ItemHeight = 20
              TabOrder = 0
              OnClick = lstHelpClick
              OnDrawItem = lstHelpDrawItem
            end
            object panelHelpTop: TPanel
              Left = 1
              Top = 1
              Width = 173
              Height = 48
              Align = alTop
              TabOrder = 1
              OnResize = panelHelpTopResize
              object imgMan: TImage
                Left = 1
                Top = 1
                Width = 171
                Height = 46
                Align = alClient
              end
              object lblMsg: TLabel
                Left = 8
                Top = 32
                Width = 6
                Height = 12
                Caption = '...'
                Transparent = True
                Visible = False
              end
              object progBar: TProgressBar
                Left = 8
                Top = 8
                Width = 153
                Height = 17
                TabOrder = 0
                Visible = False
              end
            end
          end
        end
        object tabTemplate: TTabSheet
          Caption = #38619#22411
          ImageIndex = 5
          object lstTemplate: TListBox
            Tag = 3
            Left = 0
            Top = 0
            Width = 175
            Height = 285
            Style = lbOwnerDrawFixed
            Align = alClient
            DragMode = dmAutomatic
            ItemHeight = 20
            PopupMenu = popupTemplate
            TabOrder = 0
            OnClick = lstTemplateClick
            OnDblClick = lstTemplateDblClick
            OnDrawItem = lstTemplateDrawItem
          end
        end
      end
    end
    object panelEditor: TPanel
      Left = 189
      Top = 1
      Width = 571
      Height = 361
      Align = alClient
      Caption = 'panelEditor'
      TabOrder = 2
      object edtMain: TEditor
        Left = 1
        Top = 1
        Width = 569
        Height = 359
        Cursor = crIBeam
        Align = alClient
        Caret.AutoCursor = True
        Caret.AutoIndent = True
        Caret.BackSpaceUnIndent = True
        Caret.Cursors.DefaultCursor = crIBeam
        Caret.Cursors.DragSelCursor = crDrag
        Caret.Cursors.DragSelCopyCursor = 1959
        Caret.Cursors.InSelCursor = crDefault
        Caret.Cursors.LeftMarginCursor = 1958
        Caret.Cursors.TopMarginCursor = crDefault
        Caret.FreeCaret = False
        Caret.FreeRow = False
        Caret.InTab = False
        Caret.KeepCaret = False
        Caret.LockScroll = False
        Caret.NextLine = True
        Caret.PrevSpaceIndent = True
        Caret.RowSelect = True
        Caret.SelDragMode = dmAutomatic
        Caret.SelMove = True
        Caret.SoftTab = False
        Caret.Style = csDefault
        Caret.TabIndent = True
        Caret.TabSpaceCount = 6
        Caret.TokenEndStop = False
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #65325#65331' '#12468#12471#12483#12463
        Font.Style = []
        HitStyle = hsSelect
        Imagebar.DigitWidth = 3
        Imagebar.LeftMargin = 0
        Imagebar.MarkWidth = 4
        Imagebar.RightMargin = 0
        Imagebar.Visible = True
        Marks.EofMark.Color = clGray
        Marks.EofMark.Visible = True
        Marks.RetMark.Color = clGray
        Marks.RetMark.Visible = True
        Marks.WrapMark.Color = clGray
        Marks.WrapMark.Visible = True
        Marks.HideMark.Color = clGray
        Marks.HideMark.Visible = False
        Marks.Underline.Color = clGray
        Marks.Underline.Visible = False
        Margin.Character = 0
        Margin.Left = 8
        Margin.Line = 2
        Margin.Top = 2
        Leftbar.BkColor = clSilver
        Leftbar.Color = clBlack
        Leftbar.Column = 2
        Leftbar.Edge = True
        Leftbar.LeftMargin = 1
        Leftbar.RightMargin = 2
        Leftbar.ShowNumber = True
        Leftbar.ShowNumberMode = nmRow
        Leftbar.Visible = True
        Leftbar.ZeroBase = True
        Leftbar.ZeroLead = False
        PopupMenu = PopupMenu1
        ReadOnly = False
        ReserveWordList.Strings = (
          'Function'
          'Int'
          'Str'
          'TR'
          'TRACK'
          #12488#12521#12483#12463
          #38899#38542
          #38899#33394
          #38899#31526)
        Ruler.BkColor = clSilver
        Ruler.Color = clBlack
        Ruler.Edge = True
        Ruler.GaugeRange = 8
        Ruler.MarkColor = clBlack
        Ruler.Visible = True
        ScrollBars = ssBoth
        Speed.CaretVerticalAc = 2
        Speed.InitBracketsFull = False
        Speed.PageVerticalRange = 2
        Speed.PageVerticalRangeAc = 2
        TabOrder = 0
        UndoListMax = 64
        View.Brackets = <
          item
            ItemColor.BkColor = clNone
            ItemColor.Color = clGreen
            ItemColor.Style = []
            LeftBracket = '/*'
            RightBracket = '*/'
          end>
        View.Colors.Ank.BkColor = clNone
        View.Colors.Ank.Color = clBlack
        View.Colors.Ank.Style = []
        View.Colors.Comment.BkColor = clNone
        View.Colors.Comment.Color = clGreen
        View.Colors.Comment.Style = []
        View.Colors.DBCS.BkColor = clNone
        View.Colors.DBCS.Color = clNone
        View.Colors.DBCS.Style = []
        View.Colors.Hit.BkColor = clNone
        View.Colors.Hit.Color = clNone
        View.Colors.Hit.Style = []
        View.Colors.Int.BkColor = clNone
        View.Colors.Int.Color = clBlue
        View.Colors.Int.Style = []
        View.Colors.Mail.BkColor = clNone
        View.Colors.Mail.Color = clBlue
        View.Colors.Mail.Style = [fsUnderline]
        View.Colors.Reserve.BkColor = clNone
        View.Colors.Reserve.Color = clRed
        View.Colors.Reserve.Style = []
        View.Colors.Select.BkColor = clNavy
        View.Colors.Select.Color = clWhite
        View.Colors.Select.Style = []
        View.Colors.Str.BkColor = clNone
        View.Colors.Str.Color = clNavy
        View.Colors.Str.Style = []
        View.Colors.Symbol.BkColor = clNone
        View.Colors.Symbol.Color = clTeal
        View.Colors.Symbol.Style = []
        View.Colors.Url.BkColor = clNone
        View.Colors.Url.Color = clBlue
        View.Colors.Url.Style = [fsUnderline]
        View.Commenter = '//'
        View.ControlCode = False
        View.HexPrefix = '$'
        View.Mail = True
        View.Quotation = #39
        View.Url = True
        WantReturns = True
        WantTabs = True
        WordWrap = False
        WrapOption.FollowRetMark = False
        WrapOption.FollowPunctuation = False
        WrapOption.FollowStr = #12289#12290#65292#65294#12539#65311#65281#12443#12444#12541#12542#12445#12446#12293#12540#65289#65341#65373#12301#12303'!),.:;?]}'#65377#65379#65380#65381#65392#65438#65439
        WrapOption.Leading = False
        WrapOption.LeadStr = #65288#65339#65371#12300#12302'([{'#65378
        WrapOption.PunctuationStr = #12289#12290#65292#65294',.'#65377#65380
        WrapOption.WordBreak = False
        WrapOption.WrapByte = 80
        OnChange = edtMainChange
        OnDblClick = edtMainDblClick
        OnDragDrop = edtMainDragDrop
        OnDragOver = edtMainDragOver
        OnEnter = edtMainEnter
        OnKeyDown = edtMainKeyDown
        OnKeyPress = edtMainKeyPress
        OnTopRowChange = edtMainTopRowChange
      end
      object MPlay: TMediaPlayer
        Left = 32
        Top = 16
        Width = 253
        Height = 30
        Visible = False
        TabOrder = 1
      end
    end
  end
  object cbarTop: TControlBar
    Left = 0
    Top = 0
    Width = 761
    Height = 31
    Align = alTop
    AutoSize = True
    RowSnap = False
    TabOrder = 1
    object ToolBar5: TToolBar
      Left = 310
      Top = 2
      Width = 104
      Height = 23
      ButtonWidth = 25
      Caption = 'Player'
      DockSite = True
      DragKind = dkDock
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = imgToolBar
      TabOrder = 0
      Transparent = True
      object toolPlayFirst: TToolButton
        Left = 0
        Top = 0
        Action = actRunFirst
        ParentShowHint = False
        ShowHint = True
      end
      object toolPlay: TToolButton
        Left = 25
        Top = 0
        Hint = #20877#29983
        Caption = 'toolPlay'
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuRunClick
      end
      object toolStop: TToolButton
        Left = 50
        Top = 0
        Hint = #20572#27490
        Caption = 'toolStop'
        ImageIndex = 9
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuStopClick
      end
      object toolPlayReset: TToolButton
        Left = 75
        Top = 0
        Hint = #21021#12417#12395#25147#12377
        Caption = 'toolPlayReset'
        ImageIndex = 20
        ParentShowHint = False
        ShowHint = True
        OnClick = toolPlayResetClick
      end
    end
    object panelPlayer: TPanel
      Left = 634
      Top = 2
      Width = 121
      Height = 23
      BevelOuter = bvNone
      DockSite = True
      DragKind = dkDock
      TabOrder = 1
      object Label2: TLabel
        Left = 139
        Top = 0
        Width = 20
        Height = 11
        Caption = #12363#12425
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 139
        Top = 11
        Width = 22
        Height = 11
        Caption = #28436#22863
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object chkPlayFrom: TCheckBox
        Left = 3
        Top = 5
        Width = 30
        Height = 11
        TabOrder = 0
        OnClick = chkPlayFromClick
      end
      object edtTime1: TSpinEdit
        Left = 18
        Top = 0
        Width = 43
        Height = 21
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 1
        OnChange = edtTime1Change
      end
      object edtTime3: TSpinEdit
        Left = 100
        Top = 0
        Width = 39
        Height = 21
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnChange = edtTime1Change
      end
      object edtTime2: TSpinEdit
        Left = 62
        Top = 0
        Width = 39
        Height = 21
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
        OnChange = edtTime1Change
      end
    end
    object ToolBar1: TToolBar
      Left = 11
      Top = 2
      Width = 91
      Height = 23
      ButtonWidth = 25
      Caption = 'ToolBar1'
      DockSite = True
      DragKind = dkDock
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = imgToolBar
      TabOrder = 2
      Transparent = True
      object toolNew: TToolButton
        Left = 0
        Top = 0
        Hint = #26032#35215#20316#25104
        Action = actNew
        ParentShowHint = False
        ShowHint = True
      end
      object toolOpen: TToolButton
        Left = 25
        Top = 0
        Hint = #38283#12367
        Action = actOpen
        DropdownMenu = popRecent
        ParentShowHint = False
        PopupMenu = popRecent
        ShowHint = True
        Style = tbsDropDown
      end
      object toolSave: TToolButton
        Left = 61
        Top = 0
        Hint = #20445#23384
        Action = actSaveAs
        ParentShowHint = False
        ShowHint = True
      end
    end
    object panelTrack: TPanel
      Left = 427
      Top = 2
      Width = 114
      Height = 23
      BevelOuter = bvNone
      DockSite = True
      DragKind = dkDock
      TabOrder = 3
      object track: TTrackBar
        Left = 0
        Top = 0
        Width = 114
        Height = 23
        Align = alClient
        TabOrder = 0
        OnEnter = trackEnter
      end
    end
    object ToolBar3: TToolBar
      Left = 621
      Top = 2
      Width = 0
      Height = 23
      Caption = 'ToolBar3'
      DockSite = True
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = imgToolBar
      TabOrder = 4
      Transparent = True
      object toolFontSmall: TToolButton
        Left = 0
        Top = 0
        Hint = #25991#23383#12469#12452#12474
        Caption = 'toolFontSmall'
        ImageIndex = 16
        ParentShowHint = False
        Wrap = True
        ShowHint = True
        OnClick = toolFontSmallClick
      end
      object toolFontMiddle: TToolButton
        Left = 0
        Top = 22
        Hint = #25991#23383#12469#12452#12474
        Caption = 'toolFontMiddle'
        ImageIndex = 17
        ParentShowHint = False
        Wrap = True
        ShowHint = True
        OnClick = toolFontMiddleClick
      end
      object toolFontBig: TToolButton
        Left = 0
        Top = 44
        Hint = #25991#23383#12469#12452#12474
        Caption = 'toolFontBig'
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        OnClick = toolFontBigClick
      end
    end
    object ToolBar4: TToolBar
      Left = 222
      Top = 2
      Width = 75
      Height = 23
      Caption = 'tools'
      DockSite = True
      DragKind = dkDock
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = imgToolBar
      TabOrder = 5
      Transparent = True
      object ToolButton3: TToolButton
        Left = 0
        Top = 0
        Hint = #37749#30436#20837#21147
        Caption = 'ToolButton3'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuShowKeyboardClick
      end
      object ToolButton8: TToolButton
        Left = 23
        Top = 0
        Hint = #20116#32218#35676#20837#21147
        Caption = 'ToolButton8'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuShowGosenfuClick
      end
      object toolMon: TToolButton
        Left = 46
        Top = 0
        Hint = #28436#22863#12514#12491#12479#12540
        Caption = 'toolMon'
        ImageIndex = 21
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuShowMonitorClick
      end
    end
    object ToolBar2: TToolBar
      Left = 115
      Top = 2
      Width = 94
      Height = 23
      Caption = 'ToolBar1'
      DockSite = True
      DragKind = dkDock
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = imgToolBar
      TabOrder = 7
      Transparent = True
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Hint = #20803#12395#25147#12377
        Action = actZ
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton2: TToolButton
        Left = 23
        Top = 0
        Hint = #20999#12426#21462#12426
        Action = actX
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton4: TToolButton
        Left = 46
        Top = 0
        Hint = #12467#12500#12540
        Action = actC
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton6: TToolButton
        Left = 69
        Top = 0
        Hint = #36028#12426#20184#12369
        Action = actV
        ParentShowHint = False
        ShowHint = True
      end
    end
    object toolbarPlaySub: TToolBar
      Left = 554
      Top = 2
      Width = 54
      Height = 23
      ButtonHeight = 7
      ButtonWidth = 8
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      ShowCaptions = True
      TabOrder = 6
      object cmbPlaySpeed: TComboBox
        Left = 0
        Top = 0
        Width = 52
        Height = 22
        Hint = #28436#22863#36895#24230
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ItemIndex = 3
        TabOrder = 0
        Text = '100%'
        OnChange = cmbPlaySpeedChange
        OnClick = cmbPlaySpeedClick
        Items.Strings = (
          '30%'
          '50%'
          '70%'
          '100%'
          '150%'
          '200%'
          '400%')
      end
    end
  end
  object cbarBottom: TControlBar
    Left = 0
    Top = 501
    Width = 761
    Height = 30
    Align = alBottom
    AutoSize = True
    TabOrder = 2
    OnClick = barClick
    object lblInfo: TLabel
      Left = 11
      Top = 2
      Width = 6
      Height = 22
      Caption = '...'
      DragKind = dkDock
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object lblBar: TLabel
      Left = 33
      Top = 2
      Width = 6
      Height = 22
      Caption = '...'
      DragKind = dkDock
      Transparent = True
      Layout = tlCenter
      OnClick = barClick
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Images = imgToolBar
    Left = 16
    Top = 296
    object File1: TMenuItem
      Caption = #12501#12449#12452#12523'(&F)'
      object mnuNew: TMenuItem
        Caption = #26032#35215#20316#25104'(&N)'
        ImageIndex = 0
        ShortCut = 16462
        OnClick = mnuNewClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuOpen: TMenuItem
        Caption = #38283#12367'(&O)'
        ImageIndex = 1
        ShortCut = 16463
        OnClick = mnuOpenClick
      end
      object mnuRecent: TMenuItem
        Caption = #26368#36817#20351#12387#12383#12501#12449#12452#12523
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuSave: TMenuItem
        Caption = #19978#26360#12365#20445#23384'(&S)'
        ImageIndex = 2
        ShortCut = 16467
        OnClick = mnuSaveClick
      end
      object mnuSaveAs: TMenuItem
        Caption = #21517#21069#12434#20184#12369#12390#20445#23384'(&A)...'
        OnClick = mnuSaveAsClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuShowBBS: TMenuItem
        Caption = #12469#12463#12521#26354#25522#31034#26495#12434#38283#12367
        ImageIndex = 14
        OnClick = mnuShowBBSClick
      end
      object MIDI1: TMenuItem
        Caption = 'MIDI'#32032#26448#25522#31034#26495
        Visible = False
        object mnuOpenMidiBBS: TMenuItem
          Caption = 'MIDI'#32032#26448#25522#31034#26495#12434#38283#12367
          OnClick = mnuOpenMidiBBSClick
        end
        object mnuWriteMidiBBS: TMenuItem
          Caption = 'MIDI'#32032#26448#25522#31034#26495#12408#26360#12365#36796#12415
          OnClick = mnuWriteMidiBBSClick
        end
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object mnuSaveAsMidiEasy: TMenuItem
        Caption = 'MIDI'#24418#24335#12391#20445#23384'(&M)'
        OnClick = mnuSaveAsMIDIClick
      end
      object N38: TMenuItem
        Caption = #12381#12398#20182#12398#20445#23384'...'
        object SMFformat01: TMenuItem
          Caption = 'MIDI'#12501#12449#12452#12523#24418#24335'(format 0)'#12391#20445#23384'(&N)'
          OnClick = SMFformat01Click
        end
        object mnuSaveAsMIDI: TMenuItem
          Caption = 'MIDI'#12501#12449#12452#12523#24418#24335'(format 1)'#12391#20445#23384'(&M)'
          OnClick = mnuSaveAsMIDIClick
        end
        object N41: TMenuItem
          Caption = '-'
        end
        object mnuMML2MIDIAll: TMenuItem
          Caption = 'MML'#12434'MIDI'#12501#12449#12452#12523#12408#19968#25324#22793#25563
          OnClick = mnuMML2MIDIAllClick
        end
        object mnuSaveToMld: TMenuItem
          Caption = 'i'#12514#12540#12489#30528#12513#12525#24418#24335#12391#20445#23384'(&T)'
          Visible = False
          OnClick = mnuSaveToMldClick
        end
      end
      object N51: TMenuItem
        Caption = '-'
      end
      object mnuAutoSaveMenu: TMenuItem
        Caption = #33258#21205#20445#23384#27231#33021
        object mnuOpenAutoSave: TMenuItem
          Caption = #32232#38598#12375#12383#23653#27508#12434#38283#12367
          OnClick = mnuOpenAutoSaveClick
        end
        object N67: TMenuItem
          Caption = '-'
        end
        object mnuClearAutoSave: TMenuItem
          Caption = #33258#21205#20445#23384#12375#12383#12501#12449#12452#12523#12434#20840#37096#21066#38500#12377#12427
          OnClick = mnuClearAutoSaveClick
        end
        object N60: TMenuItem
          Caption = '-'
        end
        object mnuAutoSave: TMenuItem
          Caption = #33258#21205#20445#23384#27231#33021#12434#20351#12358
          Checked = True
          OnClick = mnuAutoSaveClick
        end
      end
      object N40: TMenuItem
        Caption = '-'
      end
      object mnuCloseEx: TMenuItem
        Caption = #26360#12365#12363#12369#32066#20102'(&Q)'
        OnClick = mnuCloseExClick
      end
      object mnuExit: TMenuItem
        Caption = #12469#12463#12521#12398#32066#20102'(&X)'
        OnClick = mnuExitClick
      end
    end
    object Edit1: TMenuItem
      Caption = #32232#38598'(&E)'
      object mnuSelectKakou: TMenuItem
        Caption = #36984#25246#31684#22258
        object mnuSelectComment: TMenuItem
          Caption = #12467#12513#12531#12488#21270' /* ... */'
          OnClick = mnuSelectCommentClick
        end
        object mnuSelectLoop: TMenuItem
          Caption = #32368#12426#36820#12375#21270' [ ... ]'
          OnClick = mnuSelectLoopClick
        end
        object mnuSelectStr: TMenuItem
          Caption = #25991#23383#21015#21270' { ... }'
          OnClick = mnuSelectStrClick
        end
        object N24: TMenuItem
          Caption = '-'
        end
        object mnuTabToSpace: TMenuItem
          Caption = #12479#12502#12434#20840#35282#12473#12506#12540#12473#12395#32622#25563
          OnClick = mnuTabToSpaceClick
        end
        object N54: TMenuItem
          Caption = '-'
        end
        object N26: TMenuItem
          Action = actInsLineTab
        end
        object N53: TMenuItem
          Action = actDelLineTab
        end
        object N73: TMenuItem
          Caption = '-'
        end
        object mnuAddDecNum: TMenuItem
          Caption = #25968#20516#12434#22679#28187#12373#12379#12427
          OnClick = mnuAddDecNumClick
        end
        object N79: TMenuItem
          Action = actTemplateReg
        end
      end
      object N50: TMenuItem
        Caption = #12459#12540#12477#12523#34892
        object mnuLineCentering: TMenuItem
          Caption = #12475#12531#12479#12522#12531#12464
          OnClick = mnuLineCenteringClick
        end
        object mnuLineRighting: TMenuItem
          Caption = #21491#23492#12379
          OnClick = mnuLineRightingClick
        end
      end
      object N72: TMenuItem
        Caption = '-'
      end
      object mnuUndo: TMenuItem
        Action = actZ
      end
      object mnuRedo: TMenuItem
        Action = actY
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuCut: TMenuItem
        Action = actX
      end
      object mnuCopy: TMenuItem
        Action = actC
      end
      object mnuPaste: TMenuItem
        Action = actV
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuSelectAll: TMenuItem
        Action = actAll
      end
      object N25: TMenuItem
        Caption = '-'
      end
    end
    object Find1: TMenuItem
      Caption = #26908#32034'(&S)'
      object mnuFind: TMenuItem
        Caption = #26908#32034'(&F)'
        ShortCut = 16454
        OnClick = mnuFindClick
      end
      object mnuFindNext: TMenuItem
        Caption = #27425#12434#26908#32034'(&M)'
        ShortCut = 114
        OnClick = mnuFindNextClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mnuReplace: TMenuItem
        Action = actReplace
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuGoto: TMenuItem
        Caption = #25351#23450#34892#12395#31227#21205'(&G)'
        ShortCut = 8307
        OnClick = mnuGotoClick
      end
    end
    object Show1: TMenuItem
      Caption = #20837#21147#25903#25588'(&V)'
      object mnuShowKeyboard: TMenuItem
        Action = actKeybd
      end
      object mnuShowGosenfu: TMenuItem
        Action = actGosenfu
      end
      object mnuRythmBox: TMenuItem
        Caption = #12522#12474#12512#12508#12483#12463#12473'(&R)'
        OnClick = mnuRythmBoxClick
      end
      object mnuTenkey: TMenuItem
        Caption = #12486#12531#12461#12540#12363#12425#12398#20837#21147#12434#22793#25563
        OnClick = mnuTenkeyClick
      end
      object N42: TMenuItem
        Caption = '-'
      end
      object mnuMidi2Mml: TMenuItem
        Caption = 'MIDI'#12501#12449#12452#12523#12434'MML'#12408#22793#25563
        OnClick = mnuMidi2MmlClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object mnuShowTemplateTab: TMenuItem
        Caption = #38619#22411#25407#20837
        OnClick = mnuShowTemplateTabClick
      end
      object N57: TMenuItem
        Action = actTemplateReg
      end
      object N43: TMenuItem
        Caption = '-'
      end
      object mnuHokan: TMenuItem
        Action = actHokan
      end
      object N49: TMenuItem
        Caption = '-'
      end
      object mnuLineBreak: TMenuItem
        Action = actLineBreak
      end
      object mnuInsDllVer: TMenuItem
        Caption = #12469#12463#12521#12398#12496#12540#12472#12519#12531#24773#22577#12434#25407#20837
        OnClick = mnuInsDllVerClick
      end
    end
    object Show2: TMenuItem
      Caption = #34920#31034'(&V)'
      object mnuShowBenriPanel: TMenuItem
        Caption = #24038#20596#12479#12502#12398#34920#31034
        Checked = True
        OnClick = mnuShowBenriPanelClick
      end
      object mnuErrorTab: TMenuItem
        Caption = #19979#20596#12479#12502#12398#34920#31034
        Checked = True
        OnClick = mnuErrorTabClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object mnuShowBookmark: TMenuItem
        Caption = #12375#12362#12426#19968#35239#12434#34920#31034
        OnClick = mnuShowBookmarkClick
      end
      object mnuShowTrackInfo: TMenuItem
        Caption = #12459#12540#12477#12523#20301#32622#12398#12488#12521#12483#12463#24773#22577#12434#34920#31034
        ShortCut = 16468
        OnClick = mnuShowTrackInfoClick
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object mnuSplitEdit: TMenuItem
        Caption = #12456#12487#12451#12479#12398#19978#19979#20998#21106
        OnClick = mnuSplitEditClick
      end
      object N68: TMenuItem
        Caption = '-'
      end
      object mnuShowMonitor: TMenuItem
        Caption = #28436#22863#12514#12491#12479#12540#12434#34920#31034
        ShortCut = 16461
        OnClick = mnuShowMonitorClick
      end
    end
    object mnuPlugins: TMenuItem
      Caption = #36947#20855'(&T)'
      object mnuPluginEnum: TMenuItem
        Caption = #12503#12521#12464#12452#12531#12434#20877#21015#25369#12377#12427
        Visible = False
        OnClick = mnuPluginEnumClick
      end
      object N46: TMenuItem
        Caption = '-'
      end
    end
    object N2: TMenuItem
      Caption = #28436#22863'(&R)'
      object mnuRun: TMenuItem
        Action = actRun
      end
      object mnuStop: TMenuItem
        Action = actStop
      end
      object N55: TMenuItem
        Action = actPlayPrev
      end
      object mnuRunFirst: TMenuItem
        Action = actRunFirst
      end
      object N64: TMenuItem
        Caption = '-'
      end
      object mnuResetGM: TMenuItem
        Caption = 'GM '#12522#12475#12483#12488#36865#20986'(&G)'
        OnClick = mnuResetGMClick
      end
      object mnuResetGS: TMenuItem
        Caption = 'GS '#12522#12475#12483#12488#36865#20986'(&S)'
        OnClick = mnuResetGSClick
      end
      object mnuResetXG: TMenuItem
        Caption = 'XG '#12522#12475#12483#12488#36865#20986'(&X)'
        OnClick = mnuResetXGClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object N16: TMenuItem
        Caption = #12487#12496#12483#12464'(&D)'
        object mnuCompilerLog: TMenuItem
          Caption = #12467#12531#12497#12452#12521#12398#23455#34892#12525#12464#12434#35352#37682#12377#12427
          OnClick = mnuCompilerLogClick
        end
        object mnuCompilerTime: TMenuItem
          Caption = #12467#12531#12497#12452#12521#12398#23455#34892#26178#38291#12434#34920#31034#12377#12427
          OnClick = mnuCompilerTimeClick
        end
        object N39: TMenuItem
          Caption = '-'
        end
        object mnuArukas: TMenuItem
          Caption = 'Arukas'#12391#12452#12505#12531#12488#24773#22577#12434#30906#35469
          OnClick = mnuArukasClick
        end
        object N44: TMenuItem
          Caption = '-'
        end
        object mnuPlayMidi: TMenuItem
          Caption = #12467#12531#12497#12452#12523#12375#12394#12356#12391#28436#22863
          OnClick = mnuPlayMidiClick
        end
        object mnuOnlyCompile: TMenuItem
          Caption = #12467#12531#12497#12452#12523#12398#12415
          OnClick = mnuOnlyCompileClick
        end
      end
      object S2: TMenuItem
        Caption = #28436#22863#36895#24230'(&S)'
        object mnuSpeedLow: TMenuItem
          Action = actSpeedLow
        end
        object mnuSpeedNormal: TMenuItem
          Action = actSpeedNormal
        end
        object mnuSpeedHigh: TMenuItem
          Action = actSpeedHigh
        end
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object mnuPlayerRepeat: TMenuItem
        Caption = #32368#12426#36820#12375#20877#29983
        OnClick = mnuPlayerRepeatClick
      end
    end
    object S1: TMenuItem
      Caption = #35373#23450'(&Z)'
      object N69: TMenuItem
        Caption = #36215#21205#35373#23450
        object mnuAutoPlay: TMenuItem
          Caption = #36215#21205#12375#12383#12425#12377#12368#28436#22863#12377#12427
          Checked = True
          OnClick = mnuAutoPlayClick
        end
        object mnuSplashWindow: TMenuItem
          Caption = #36215#21205#26178#12395#12525#12468#12434#34920#31034#12377#12427
          Checked = True
          OnClick = mnuSplashWindowClick
        end
      end
      object N21: TMenuItem
        Caption = #32066#20102#35373#23450
        object mnuUseCloseEx: TMenuItem
          Caption = #26360#12365#12363#12369#32066#20102#12434#27161#28310#12395#12377#12427
          OnClick = mnuUseCloseExClick
        end
      end
      object N15: TMenuItem
        Caption = #12456#12487#12451#12479#12398#35373#23450
        object mnuKeyMapping: TMenuItem
          Caption = #12471#12519#12540#12488#12459#12483#12488#12398#21106#12426#24403#12390
          OnClick = mnuKeyMappingClick
        end
        object mnuEditSetting: TMenuItem
          Caption = #12456#12487#12451#12479#12398#35443#32048#12394#35373#23450
          OnClick = mnuEditSettingClick
        end
      end
      object N48: TMenuItem
        Caption = #21177#26524#38899
        object mnuEffect: TMenuItem
          Caption = #12456#12487#12451#12479#12398#21177#26524#38899'(&W)'
          Checked = True
          OnClick = mnuEffectClick
        end
        object mnuEffectPlay: TMenuItem
          Caption = #20877#29983#21069#12398#21177#26524#38899
          Checked = True
          OnClick = mnuEffectPlayClick
        end
        object mnuEffectClipboard: TMenuItem
          Caption = #12463#12522#12483#12503#12508#12540#12489#25805#20316#12398#21177#26524#38899
          Checked = True
          OnClick = mnuEffectClipboardClick
        end
      end
      object N65: TMenuItem
        Caption = #12510#12454#12473#12472#12455#12473#12481#12515#12540
        object mnuHelpMouseGesture: TMenuItem
          Caption = #12510#12454#12473#12472#12455#12473#12481#12515#12540#12398#35500#26126
          OnClick = mnuHelpMouseGestureClick
        end
        object mnuUseMouseGesture: TMenuItem
          Caption = #12510#12454#12473#12472#12455#12473#12481#12515#12540#12434#20351#12358
          OnClick = mnuUseMouseGestureClick
        end
      end
      object N56: TMenuItem
        Caption = #12504#12523#12503#12398#35373#23450
        object mnuAutoHelp: TMenuItem
          Caption = #12504#12523#12503#12398#33258#21205#34920#31034
          Checked = True
          OnClick = mnuAutoHelpClick
        end
        object mnuExternalBrowser: TMenuItem
          Caption = #12504#12523#12503#34920#31034#26178#12395#22806#37096#12502#12521#12454#12470#12434#36215#21205#12377#12427
          Checked = True
          OnClick = mnuExternalBrowserClick
        end
      end
      object N22: TMenuItem
        Caption = #38306#36899#20184#12369
        object mnuRegistMML: TMenuItem
          Caption = 'MML'#12501#12449#12452#12523#12434#38306#36899#20184#12369#12427
          OnClick = mnuRegistMMLClick
        end
        object mnuUninstall: TMenuItem
          Caption = #38306#36899#20184#12369#12434#35299#38500#12377#12427
          OnClick = mnuUninstallClick
        end
      end
      object N71: TMenuItem
        Caption = #12467#12531#12497#12452#12523#35373#23450
        object mnuSpeedCompile: TMenuItem
          Caption = #36884#20013#20572#27490#27231#33021#12434#12458#12501#12395#12375#12390#39640#36895#12467#12531#12497#12452#12523
          OnClick = mnuSpeedCompileClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuShowPlayMonitor: TMenuItem
        Caption = #28436#22863#12514#12491#12479#12540#12434#20351#12358
        Checked = True
        OnClick = mnuShowPlayMonitorClick
      end
      object mnuPlayMonitorTop: TMenuItem
        Caption = #28436#22863#12514#12491#12479#12540#12434#24120#12395#25163#21069#12395#34920#31034
        OnClick = mnuPlayMonitorTopClick
      end
      object N70: TMenuItem
        Caption = #28436#22863#12514#12491#12479#12540#12434#34920#31034
        ShortCut = 16461
        OnClick = mnuShowMonitorClick
      end
      object mnuOutMidClock: TMenuItem
        Caption = 'MIDI'#12463#12525#12483#12463#12398#36865#20986
        Checked = True
        OnClick = mnuOutMidClockClick
      end
      object N47: TMenuItem
        Caption = '-'
      end
      object mnuSelDevice: TMenuItem
        Caption = #12510#12523#12481#12513#12487#12451#12450#12398#35373#23450'(&M)'
        OnClick = mnuSelDeviceClick
      end
      object mnuSetting: TMenuItem
        Caption = #12503#12524#12452#12516#12540#12392#22806#35211#12398#35373#23450'(&P)'
        OnClick = mnuSettingClick
      end
    end
    object Help1: TMenuItem
      AutoHotkeys = maManual
      Caption = #12504#12523#12503'(&H)'
      object mnuHelpContents: TMenuItem
        Action = actHelp
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #12459#12540#12477#12523#35486#12398#35500#26126#12434#34920#31034
      end
      object N66: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = '-'
      end
      object mnuHelpIndex: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #12510#12491#12517#12450#12523#30446#27425#12434#34920#31034
        OnClick = mnuHelpIndexClick
      end
      object mnuFindManual: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #12510#12491#12517#12450#12523#12434#26908#32034
        OnClick = mnuFindManualClick
      end
      object mnuShowFAQ: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #22256#12387#12383#12392#12365#12399#8230
        OnClick = mnuShowFAQClick
      end
      object N36: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = '-'
      end
      object mnuHomePage: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #12469#12463#12521#12398#12507#12540#12512#12506#12540#12472#12408#34892#12367
        OnClick = mnuHomePageClick
      end
      object N10: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = '-'
      end
      object mnuAbout: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)...'
        OnClick = mnuAboutClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'mml'
    Filter = 
      #12469#12463#12521#12501#12449#12452#12523'(*.mml)|*.mml|'#12486#12461#12473#12488#12501#12449#12452#12523'(*.txt)|*.txt|'#23450#32681#12501#12449#12452#12523'(*.h)|*.h|'#20840#12390#12398#12501#12449 +
      #12452#12523'(*.*)|*.*'
    Left = 80
    Top = 200
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'mml'
    Filter = 
      #12469#12463#12521#12501#12449#12452#12523'(*.mml)|*.mml|'#12486#12461#12473#12488#12501#12449#12452#12523'(*.txt)|*.txt|'#23450#32681#12501#12449#12452#12523'(*.h)|*.h|'#20840#12390#12398#12501#12449 +
      #12452#12523'(*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 80
    Top = 232
  end
  object dlgSaveMidi: TSaveDialog
    DefaultExt = 'mid'
    Filter = 'MIDI'#12501#12449#12452#12523'(*.mid)|*.mid|'#20840#12390'|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'MIDI'#12501#12449#12452#12523#24418#24335#12391#20445#23384
    Left = 112
    Top = 232
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 264
    object popUndo: TMenuItem
      Caption = #20803#12395#25147#12377'(&U)'
      OnClick = mnuUndoClick
    end
    object popRedo: TMenuItem
      Caption = #12420#12426#30452#12377'(&R)'
      OnClick = mnuRedoClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object popCut: TMenuItem
      Caption = #20999#12426#21462#12426'(&T)'
      OnClick = mnuCutClick
    end
    object popCopy: TMenuItem
      Caption = #12467#12500#12540'(&C)'
      OnClick = mnuCopyClick
    end
    object popPaste: TMenuItem
      Caption = #36028#12426#20184#12369'(&P)'
      OnClick = mnuPasteClick
    end
    object N35: TMenuItem
      Caption = '-'
    end
    object N27: TMenuItem
      Caption = #36984#25246#31684#22258
      object N28: TMenuItem
        Caption = #12467#12513#12531#12488#21270' /* ... */'
        OnClick = mnuSelectCommentClick
      end
      object N29: TMenuItem
        Caption = #32368#12426#36820#12375#21270' [ ... ]'
        OnClick = mnuSelectLoopClick
      end
      object N30: TMenuItem
        Caption = #25991#23383#21015#21270' { ... }'
        OnClick = mnuSelectStrClick
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object N34: TMenuItem
        Caption = #12479#12502#12434#20840#35282#12473#12506#12540#12473#12395#32622#25563
        OnClick = mnuTabToSpaceClick
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object N33: TMenuItem
        Action = actInsLineTab
      end
      object N52: TMenuItem
        Action = actDelLineTab
      end
      object N58: TMenuItem
        Caption = '-'
      end
      object N59: TMenuItem
        Action = actTemplateReg
      end
      object popAddDecNum: TMenuItem
        Caption = #25968#20516#12434#22679#28187#12373#12379#12427
        OnClick = mnuAddDecNumClick
      end
    end
    object popJumpDefVar: TMenuItem
      Caption = #36984#25246#35486#12398#24847#21619#12539#23450#32681#12434#35211#12427
      OnClick = popJumpDefVarClick
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object popSetSiori: TMenuItem
      Caption = #12375#12362#12426#12398#35373#23450
      OnClick = popSetSioriClick
    end
    object mnuRecBookmark: TMenuItem
      Caption = #12502#12483#12463#12510#12540#12463#30331#37682'(&B)'
    end
    object mnuGotoBookmark: TMenuItem
      Caption = #12502#12483#12463#12510#12540#12463#12408#39131#12406'(&J)'
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object popSelectAll: TMenuItem
      Caption = #20840#12390#36984#25246'(&A)'
      OnClick = mnuSelectAllClick
    end
  end
  object DdeClientConv1: TDdeClientConv
    ConnectMode = ddeManual
    Left = 48
    Top = 296
  end
  object EditorProp: TEditorProp
    Color = clWindow
    Caret.AutoCursor = True
    Caret.AutoIndent = True
    Caret.BackSpaceUnIndent = True
    Caret.Cursors.DefaultCursor = crIBeam
    Caret.Cursors.DragSelCursor = crDrag
    Caret.Cursors.DragSelCopyCursor = 1959
    Caret.Cursors.InSelCursor = crDefault
    Caret.Cursors.LeftMarginCursor = 1958
    Caret.Cursors.TopMarginCursor = crDefault
    Caret.FreeCaret = True
    Caret.FreeRow = False
    Caret.InTab = False
    Caret.KeepCaret = False
    Caret.LockScroll = False
    Caret.NextLine = False
    Caret.PrevSpaceIndent = False
    Caret.RowSelect = True
    Caret.SelDragMode = dmAutomatic
    Caret.SelMove = True
    Caret.SoftTab = False
    Caret.Style = csDefault
    Caret.TabIndent = False
    Caret.TabSpaceCount = 8
    Caret.TokenEndStop = False
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'FixedSys'
    Font.Style = []
    HitStyle = hsSelect
    Imagebar.DigitWidth = 8
    Imagebar.LeftMargin = 2
    Imagebar.MarkWidth = 0
    Imagebar.RightMargin = 2
    Imagebar.Visible = True
    Leftbar.BkColor = clSilver
    Leftbar.Color = clBlack
    Leftbar.Column = 4
    Leftbar.Edge = True
    Leftbar.LeftMargin = 8
    Leftbar.RightMargin = 4
    Leftbar.ShowNumber = True
    Leftbar.ShowNumberMode = nmRow
    Leftbar.Visible = False
    Leftbar.ZeroBase = False
    Leftbar.ZeroLead = False
    Margin.Character = 0
    Margin.Left = 19
    Margin.Line = 0
    Margin.Top = 2
    Marks.EofMark.Color = clGray
    Marks.EofMark.Visible = False
    Marks.RetMark.Color = clGray
    Marks.RetMark.Visible = False
    Marks.WrapMark.Color = clGray
    Marks.WrapMark.Visible = False
    Marks.HideMark.Color = clGray
    Marks.HideMark.Visible = False
    Marks.Underline.Color = clGray
    Marks.Underline.Visible = False
    Ruler.BkColor = clSilver
    Ruler.Color = clBlack
    Ruler.Edge = True
    Ruler.GaugeRange = 10
    Ruler.MarkColor = clBlack
    Ruler.Visible = False
    ScrollBars = ssNone
    Speed.CaretVerticalAc = 2
    Speed.InitBracketsFull = False
    Speed.PageVerticalRange = 2
    Speed.PageVerticalRangeAc = 2
    View.Brackets = <>
    View.Colors.Ank.BkColor = clNone
    View.Colors.Ank.Color = clNone
    View.Colors.Ank.Style = []
    View.Colors.Comment.BkColor = clNone
    View.Colors.Comment.Color = clNone
    View.Colors.Comment.Style = []
    View.Colors.DBCS.BkColor = clNone
    View.Colors.DBCS.Color = clNone
    View.Colors.DBCS.Style = []
    View.Colors.Hit.BkColor = clNone
    View.Colors.Hit.Color = clNone
    View.Colors.Hit.Style = []
    View.Colors.Int.BkColor = clNone
    View.Colors.Int.Color = clNone
    View.Colors.Int.Style = []
    View.Colors.Mail.BkColor = clNone
    View.Colors.Mail.Color = clNone
    View.Colors.Mail.Style = []
    View.Colors.Reserve.BkColor = clNone
    View.Colors.Reserve.Color = clNone
    View.Colors.Reserve.Style = []
    View.Colors.Select.BkColor = clNavy
    View.Colors.Select.Color = clWhite
    View.Colors.Select.Style = []
    View.Colors.Str.BkColor = clNone
    View.Colors.Str.Color = clNone
    View.Colors.Str.Style = []
    View.Colors.Symbol.BkColor = clNone
    View.Colors.Symbol.Color = clNone
    View.Colors.Symbol.Style = []
    View.Colors.Url.BkColor = clNone
    View.Colors.Url.Color = clNone
    View.Colors.Url.Style = []
    View.ControlCode = False
    View.Mail = False
    View.Url = False
    WordWrap = False
    WrapOption.FollowRetMark = False
    WrapOption.FollowPunctuation = False
    WrapOption.FollowStr = #12289#12290#65292#65294#12539#65311#65281#12443#12444#12541#12542#12445#12446#12293#12540#65289#65341#65373#12301#12303'!),.:;?]}'#65377#65379#65380#65381#65392#65438#65439
    WrapOption.Leading = False
    WrapOption.LeadStr = #65288#65339#65371#12300#12302'([{'#65378
    WrapOption.PunctuationStr = #12289#12290#65292#65294',.'#65377#65380
    WrapOption.WordBreak = False
    WrapOption.WrapByte = 80
    Left = 80
    Top = 296
  end
  object dlgExe: TOpenDialog
    DefaultExt = 'exe'
    Filter = #23455#34892#21487#33021#12501#12449#12452#12523'(*.exe)|*.exe|'#20840#12390'(*.*)|*.*'
    Title = 'TMIDI'#12398#12497#12473#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
    Left = 16
    Top = 200
  end
  object FileDrop1: TFileDrop
    Control = edtMain
    OnFileDrop = FileDrop1FileDrop
    Left = 16
    Top = 232
  end
  object popupMenuInclude: TPopupMenu
    Left = 112
    Top = 264
    object mnuOpenIncludeFile: TMenuItem
      Caption = #21029#31379#12391#38283#12367'(&O)'
      OnClick = mnuOpenIncludeFileClick
    end
    object mnuInsInclude: TMenuItem
      Caption = #12456#12487#12451#12479#12395#25407#20837#12377#12427'(&I)'
      OnClick = mnuInsIncludeClick
    end
    object mnuShowIncludeManual: TMenuItem
      Caption = #12510#12491#12517#12450#12523#12434#34920#31034'(&H)'
      OnClick = mnuShowIncludeManualClick
    end
  end
  object timerPlayer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = timerPlayerTimer
    Left = 16
    Top = 328
  end
  object imgToolBar: TImageList
    Left = 112
    Top = 296
    Bitmap = {
      494C010117001800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF00000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000000000000000FF000000FF000000
      FF0084008400840084008400840000FF000000FF000000FF0000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000084000000840000008400
      0000FFFF0000FFFF0000FFFF0000008400000084000000840000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      00000000FF00000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      FF000000FF00000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      00008400000084000000840000008400000084000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF00000000000000FF00000000000000
      0000840000008400000000000000000000000000000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000840000008400
      00008400000084000000840000008400000084000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      FF000000FF00000000000000000000000000000000000000FF00000000000000
      0000840000008400000000000000000000000000000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      00000000FF00000000000000000000000000000000000000FF00000000000000
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000840000008400000000000000000000000000000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000840000008400
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000840000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000840000008400000000000000000000000000000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000000000008400
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000840000008400000000000000000000000000000084000000840000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000008400000000000000000000000000000084000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000084000000000000000000000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000084000000000000008400000000000000000000008400
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF008400000084000000840000008400
      00008400000084000000FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000084000000000000008400000000000000000000008400
      0000000000000000000000000000000000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000008400000000000000000000008400
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00840000008400000084000000FFFF
      FF0084000000840000008400000084000000FFFFFF00FF000000FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000008400000084000000840000000000
      0000000000000000000000000000000000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000FFFFFF008400000000000000FFFFFF00FF000000FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000840000000000000000000000FFFFFF00FF000000FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      8400848484000084840084000000840000008400000084000000840000008400
      000084000000000000000000000000000000FFFFFF00FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840000848400848484000084840084848400008484008484
      840000848400000000000000000000000000FFFFFF00FF000000FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      840084848400000000000000000000000000FFFFFF00FF000000FFFFFF00FF00
      0000FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      840000848400000000000000000000000000FFFFFF00FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      84000000000000FFFF00000000000000000000FFFF0000000000848484000084
      840084848400000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      000084000000840000008400000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF008400000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FF00000000000000FF000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000000000FF0000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF008400000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00FF000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000FFFFFF008400
      000084000000840000008400000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF00840000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      000084000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000084000000840000008400000084000000840000008400
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF0000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFFFF000000FF00FFFF
      FF000000FF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF000000FF00FFFFFF000000FF00FFFFFF000000FF00FFFFFF000000FF000000
      FF000000FF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00007B7B7B007B7B7B007B7B7B0000FFFF0000FFFF007B7B7B007B7B7B007B7B
      7B007B7B7B0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD0000000000FF000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD0000000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD0000000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B00000000000000000000000000000000000000000000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000FFFFFF000000
      000000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF0000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000FFFF000000000000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FF000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000FF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FF
      FF0000FFFF0000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF0000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF00000000000000000000000000000000007B7B7B000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF00000001FFFF00010000
      000100000001000000010000000100001FF100001FF100001FF100001FF10000
      1D31000019710000193100001931000011310000191100001931000019310000
      1D310000197100001FF100001FF100001FF100001FF100000001000000010000
      0001FFFF000100000001FFFF00010000FFFFFFFFFFFFFFFFCE778003CE7BFFFF
      CE67BFFBCE79FFFFC040B39BC040FFFFCE67B39BCE79FFFFCE77B01BCE7BFFFF
      CE7FB39BCE7FFFFFEEFFB39BEEFFDFFFF1FFB39BF1FF8FFFF1FFBBBBF1FF07FF
      DFFFBC7BDFFFFFFF8FFFBC7BDFFFFFFF07FFBFFBDFFFFFFFDFFF800307FFFFFF
      DFFFFFFF8FFFFFFFDFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF3FFFC00FFFFFFFF
      ED9F80000000FFFFED6F00000000C02AED6F00000000FFFFF16F00000000FFEF
      FD1F00010000FFF7FC7F00030000FFFBFEFF00030000C3FDFC7F00030000C7FD
      FD7F00030000C7FDF93F0FC30000DBFBFBBF00030000FDF7FBBF80070000FE0F
      FBBFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFF00010001FFDFFC01
      00010001FFC7FC0100010001FFDFFC011FF11FF1FFD500011DF11FF180750001
      1CF11831FEFF00011C711831803F00011C311831FF1F00031C711831800F0007
      1CF11831FFC7000F1DF11FF1806300FF1FF11FF1FFF101FF00010001807B03FF
      00010001FFFFFFFF00010001FFFFFFFFFFFFFFFFFFFFFFFFFFFF80018001FFFF
      000080018001FFFF000080018001800100008001800180010000800180018001
      0000800180018001000080018001800100008001800180010000800180018001
      000080018001800100008001800180010000800180018001FFFF800180018001
      FFFF80018001FFFFFFFFFFFFFFFFFFFFFF7EFFFFFFFFFFFF9001FFFFE0018001
      C003FFFFC0018001E003FFFF80018001E003C00F80018001E003800780018001
      E00380038001800100018001800180018000800180018001E007800F80018001
      E00F800F80018001E00F801F80018001E027C0FF80018001C073C0FF80058001
      9E79FFFF800180017EFEFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object timerAutoPlay: TTimer
    Enabled = False
    Interval = 300
    OnTimer = timerAutoPlayTimer
    Left = 48
    Top = 328
  end
  object dlgSaveMld: TSaveDialog
    DefaultExt = 'mld'
    Filter = 'i'#12514#12540#12489#24418#24335'(*.mld)|*.mld|'#20840#12390'|*.*'
    Left = 48
    Top = 232
  end
  object popupMenuSystemTab: TPopupMenu
    Left = 48
    Top = 264
    object popupShowManWeb: TMenuItem
      Caption = #12510#12491#12517#12450#12523#12434#34920#31034'(on)'
      OnClick = popupShowManWebClick
    end
    object popShowManual: TMenuItem
      Caption = #12510#12491#12517#12450#12523#12434#34920#31034'(off)'
      OnClick = popShowManualClick
    end
    object N23: TMenuItem
      Caption = '-'
    end
    object popInsCmd: TMenuItem
      Caption = #12467#12510#12531#12489#12434#25407#20837
      OnClick = lstCommandDblClick
    end
    object mnuInsSampleMML: TMenuItem
      Caption = #12469#12531#12503#12523#12434#25407#20837
      OnClick = mnuInsSampleMMLClick
    end
  end
  object dlgOpenMidi: TOpenDialog
    DefaultExt = 'mid'
    Filter = 'MIDI'#12501#12449#12452#12523'|*.mid|'#20840#12390'|*.*'
    Left = 48
    Top = 200
  end
  object actList: TActionList
    Images = imgToolBar
    Left = 112
    Top = 328
    object actNew: TAction
      Category = 'File'
      Caption = #26032#35215#20316#25104'(&N)'
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = mnuNewClick
    end
    object actOpen: TAction
      Category = 'File'
      Caption = #38283#12367'(&O)'
      ImageIndex = 1
      ShortCut = 16463
      OnExecute = mnuOpenClick
    end
    object actSaveAs: TAction
      Category = 'File'
      Caption = #19978#26360#12365#20445#23384'(&S)'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = mnuSaveClick
    end
    object actHokan: TAction
      Caption = #12459#12540#12477#12523#35486#12398#21336#35486#35036#23436
      ShortCut = 16416
      OnExecute = mnuHokanClick
    end
    object actZ: TAction
      Category = 'Clipbrd'
      Caption = #20803#12395#25147#12377'(&U)'
      ImageIndex = 15
      ShortCut = 16474
      OnExecute = mnuUndoClick
    end
    object actY: TAction
      Category = 'Clipbrd'
      Caption = #12420#12426#30452#12377
      ShortCut = 16473
      OnExecute = actYExecute
    end
    object actX: TAction
      Category = 'Clipbrd'
      Caption = #20999#12426#21462#12426'(&T)'
      ImageIndex = 12
      ShortCut = 16472
      OnExecute = mnuCutClick
    end
    object actC: TAction
      Category = 'Clipbrd'
      Caption = #12467#12500#12540'(&C)'
      ImageIndex = 11
      ShortCut = 16451
      OnExecute = mnuCopyClick
    end
    object actV: TAction
      Category = 'Clipbrd'
      Caption = #36028#12426#20184#12369'(&P)'
      ImageIndex = 13
      ShortCut = 16470
      OnExecute = mnuPasteClick
    end
    object actAll: TAction
      Category = 'Clipbrd'
      Caption = #20840#12390#36984#25246'(&A)'
      ShortCut = 16449
      OnExecute = mnuSelectAllClick
    end
    object actFind: TAction
      Category = 'Edit'
      Caption = #26908#32034'(&F)'
      ShortCut = 16454
      OnExecute = mnuFindClick
    end
    object actFindNext: TAction
      Category = 'Edit'
      Caption = #27425#12434#26908#32034'(&M)'
      ShortCut = 114
      OnExecute = mnuFindNextClick
    end
    object actReplace: TAction
      Category = 'Edit'
      Caption = #32622#25563'(&E)'
      ShortCut = 16466
      OnExecute = mnuReplaceClick
    end
    object actGotoLine: TAction
      Category = 'Edit'
      Caption = #25351#23450#34892#12395#31227#21205'(&G)'
      ShortCut = 115
      OnExecute = mnuGotoClick
    end
    object actKeybd: TAction
      Category = 'Tools'
      Caption = #37749#30436#20837#21147
      ImageIndex = 4
      ShortCut = 16459
      OnExecute = mnuShowKeyboardClick
    end
    object actGosenfu: TAction
      Category = 'Tools'
      Caption = #20116#32218#35676#20837#21147
      ImageIndex = 10
      ShortCut = 16455
      OnExecute = mnuShowGosenfuClick
    end
    object actRun: TAction
      Caption = #28436#22863#38283#22987'(&R)'
      ImageIndex = 8
      ShortCut = 120
      OnExecute = mnuRunClick
    end
    object actStop: TAction
      Caption = #28436#22863#20572#27490'(&S)'
      ImageIndex = 9
      ShortCut = 121
      OnExecute = mnuStopClick
    end
    object actLineBreak: TAction
      Category = 'Edit'
      Caption = #21306#20999#12426#32218#12398#25407#20837
      ShortCut = 49238
      OnExecute = actLineBreakExecute
    end
    object actHelp: TAction
      Category = 'Help'
      Caption = #12510#12491#12517#12450#12523#12434#34920#31034
      ShortCut = 112
      OnExecute = actHelpExecute
    end
    object actInsLineTab: TAction
      Category = 'Tab'
      Caption = #36984#25246#31684#22258#23383#19979#12370
      ShortCut = 24649
      OnExecute = actInsLineTabExecute
    end
    object actDelLineTab: TAction
      Category = 'Tab'
      Caption = #36984#25246#31684#22258#23383#19979#12370#35299#38500
      ShortCut = 24661
      OnExecute = actDelLineTabExecute
    end
    object actTemplateReg: TAction
      Caption = #36984#25246#31684#22258#12434#38619#22411#12395#30331#37682
      OnExecute = actTemplateRegExecute
    end
    object actPlayPrev: TAction
      Caption = #24059#25147#12375
      ImageIndex = 20
      ShortCut = 122
      OnExecute = toolPlayResetClick
    end
    object actRunFirst: TAction
      Caption = #20808#38957#12363#12425#28436#22863
      ImageIndex = 22
      ShortCut = 123
      OnExecute = actRunFirstExecute
    end
    object actSpeedLow: TAction
      Caption = #12422#12387#12367#12426#28436#22863'(50%)'
      ShortCut = 16453
      OnExecute = actSpeedLowExecute
    end
    object actSpeedNormal: TAction
      Caption = #26222#36890#12395#20877#29983'(100%)'
      ShortCut = 16471
      OnExecute = actSpeedNormalExecute
    end
    object actSpeedHigh: TAction
      Caption = #36895#12367#28436#22863'(400%)'
      ShortCut = 16465
      OnExecute = actSpeedHighExecute
    end
  end
  object dlgOpenSkin: TOpenDialog
    Filter = #30011#20687#12501#12449#12452#12523'(*.jpg;*.bmp)|*.jpg;*.jpeg;*.bmp|'#20840#12390'|*.*'
    Left = 112
    Top = 200
  end
  object popupTemplate: TPopupMenu
    Left = 80
    Top = 264
    object N61: TMenuItem
      Caption = #12456#12487#12451#12479#12408#38619#24418#25407#20837
      OnClick = lstTemplateDblClick
    end
    object N62: TMenuItem
      Caption = '-'
    end
    object N45: TMenuItem
      Action = actTemplateReg
      Caption = #12456#12487#12451#12479#12398#36984#25246#31684#22258#12434#38619#22411#12395#30331#37682
    end
    object mnuTemplateDir: TMenuItem
      Caption = #38619#22411#12398#12501#12457#12523#12480#34920#31034
      OnClick = mnuTemplateDirClick
    end
    object N63: TMenuItem
      Caption = '-'
    end
    object mnuTemplateDelete: TMenuItem
      Caption = #36984#25246#20013#38619#22411#12398#21066#38500
      OnClick = mnuTemplateDeleteClick
    end
  end
  object popRecent: TPopupMenu
    Left = 80
    Top = 328
  end
  object command: TDdeServerConv
    OnExecuteMacro = commandExecuteMacro
    Left = 80
    Top = 360
  end
  object popMessageBox: TPopupMenu
    Left = 40
    Top = 424
    object popMsgCopy: TMenuItem
      Caption = #12467#12500#12540
      OnClick = popMsgCopyClick
    end
    object popMsgClear: TMenuItem
      Caption = #12513#12483#12475#12540#12472#12463#12522#12450
      OnClick = popMsgClearClick
    end
  end
  object img32file: TImageList
    Height = 32
    Width = 32
    Left = 224
    Top = 112
    Bitmap = {
      494C010104000900040020002000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      00000000000036000000280000008000000060000000010020000000000000C0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021002100210021002100210021002100210021002100
      2100210021002100210021002100210021002100210021002100210021002100
      2100210021002100210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5000000FF737300FF737300FF737300FF737300FF737300FF73
      7300FF737300FF737300FF393900FF393900FF393900A50000007BBD9C007BBD
      9C007BBD9C007BBD9C0000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000210021004A8CCE004A8CCE004A8CCE004A8CCE004A8CCE004A8C
      CE004A8CCE004A8CCE004A8CCE004A8CCE004A8CCE004A8CCE004A8CCE004A8C
      CE004A8CCE004A8CCE0021002100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5000000FF737300FF737300FF737300FF737300FF737300FF73
      7300FF737300FF737300FF737300FF737300FF393900A50000007BBD9C007BBD
      9C007BBD9C007BBD9C0000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEE7EF00DEE7EF00DEE7EF00DEE7
      EF00DEE7EF00DEE7EF00FFFFFF00DEE7EF00DEE7EF00BDCEDE00BDCEDE009CB5
      CE009CB5CE009CB5CE009CB5CE009CB5CE007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF008CCEFF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF004A8CCE004A8CCE00210021000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000084007BBDFF007BBDFF007BBD
      FF007BBDFF004A8CCE004A8CCE004A8CCE004A8CCE0018528C0018528C001852
      8C0018528C000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5000000FFADAD00FF737300FF737300FF737300FF737300FF73
      7300FF737300FF737300FF737300FF737300FF737300A50000007BBD9C007BBD
      9C007BBD9C007BBD9C0000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEE7EF00DEE7EF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00FFFFFF00F7FFFF00F7FFFF00BDCE
      DE009CB5CE009CB5CE009CB5CE009CB5CE007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE00210021002100210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000840042420000000084007BBDFF007BBD
      FF007BBDFF007BBDFF007BBDFF007BBDFF004A8CCE004A8CCE004A8CCE004A8C
      CE0018528C0018528C0000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5000000FFADAD00FFADAD00FF737300FF737300FF737300FF73
      7300FF737300FF737300FF737300FF737300FF737300A50000007BBD9C007BBD
      9C007BBD9C007BBD9C0000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00BDCEDE00BDCEDE00BDCEDE009CB5CE007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE0021002100396B9C0021002100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000840042420000000084007BBDFF007BBD
      FF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF004A8CCE004A8C
      CE004A8CCE0018528C0000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5000000FFE7E700FFADAD00FFADAD00FF737300FF737300FF73
      7300FF737300FF737300FF737300FF737300FF737300A50000007BBD9C007BBD
      9C007BBD9C007BBD9C0000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00BDCEDE007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000840018528C0042420000FFFFFF00000084008CCE
      FF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBD
      FF004A8CCE004A8CCE0018528C00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A5000000A5000000A5000000A5000000A5000000A500
      0000A5000000A5000000A5000000A5000000A50000007BBD9C007BBD9C007BBD
      9C007BBD9C000042840000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00DEE7EF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000840018528C0042420000FFFFFF0000008400ADDE
      FF008CCEFF008CCEFF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBD
      FF007BBDFF007BBDFF004A8CCE004A8CCE000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002100000021000000ADDEFF0021000000210000000042
      8400004284000042840000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700FFFFFF00F7FFFF00DEE7EF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF00396B9C00396B9C000039
      6B0000396B00396B9C006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840018528C0018528C0042420000FFFFFF00FFFFFF000000
      84009CD6FF009CD6FF008CCEFF008CCEFF007BBDFF007BBDFF007BBDFF007BBD
      FF007BBDFF007BBDFF007BBDFF004A8CCE004A8CCE0000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002100000021000000ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF002100
      0000210000000042840000428400004284000042840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700FFFFFF00F7FFFF00F7FFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF000042840000396B000042
      8400004284000042840000396B00396B9C006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840018528C0018528C0042420000FFFFFF00FFFFFF000000
      8400BDE7FF00ADDEFF00ADDEFF009CD6FF008CCEFF008CCEFF007BBDFF007BBD
      FF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF0000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002100
      0000ADDEFF00ADDEFF000000FF000000FF000000FF00ADDEFF00ADDEFF00ADDE
      FF00ADDEFF002100000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700F7FFFF00FFFFFF00F7FFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF0000396B006BADEF006BAD
      EF006BADEF006BADEF006BADEF0000396B00396B9C006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000008400000084000000840042420000FFFFFF00FFFFFF00FFFF
      FF0000008400BDE7FF00BDE7FF00ADDEFF009CD6FF009CD6FF008CCEFF008CCE
      FF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF007BBDFF00000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021000000ADDE
      FF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDE
      FF00ADDEFF00ADDEFF0000396B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00DEEFE7007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF006BADEF006BADEF006BADEF0000396B006BADEF006BAD
      EF006BADEF006BADEF006BADEF0000396B00396B9C006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000042420000FFFFFF00C6C6C600FFFF
      FF00000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021000000ADDE
      FF00ADDEFF0021000000ADDEFF00ADDEFF00ADDEFF0021000000ADDEFF00ADDE
      FF00ADDEFF00ADDEFF0000396B0000396B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700DEEFE700F7FFFF00FFFFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000210021008CCEFF008CCEFF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF004A8CCE002100210000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000042420000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00424200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021000000ADDE
      FF00ADDEFF0021000000ADDEFF00ADDEFF00ADDEFF0021000000ADDEFF00ADDE
      FF00ADDEFF00ADDEFF0000396B0000396B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700DEEFE700F7FFFF00FFFFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000210021008CCEFF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BADEF006BAD
      EF006BADEF004A8CCE002100210000396B0000396B005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000042420000FFFFFF00C6C6C600FFFF
      FF00C6C6C600C6C6C600FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00424200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021000000ADDE
      FF00ADDEFF0021000000ADDEFF00ADDEFF00ADDEFF0021000000ADDEFF00ADDE
      FF00ADDEFF00ADDEFF0000396B0000424A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEEFE700F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700DEEFE700F7FFFF00F7FFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021002100210021002100210021002100210021002100
      2100210021002100210021002100210021002100210021002100210021002100
      2100210021002100210000396B0000396B005A9CDE005A9CDE00210021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000042420000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00424200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021000000ADDE
      FF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDEFF00ADDE
      FF00ADDEFF00ADDEFF0000424A0000396B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEEFE700F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEF
      E700DEEFE700DEEFE700F7FFFF00F7FFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000210021005A9C
      DE005A9CDE005A9CDE005A9CDE005A9CDE005A9CDE005A9CDE005A9CDE005A9C
      DE005A9CDE005A9CDE005A9CDE005A9CDE005A9CDE0021002100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042420000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004242000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000424A0000396B002100
      0000ADDEFF0000424A00ADDEFF0000396B00ADDEFF0000396B00ADDEFF000039
      6B00ADDEFF0000396B0000396B0000396B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEEFE700F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700DEEFE700F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002100
      2100210021002100210021002100210021002100210021002100210021002100
      2100210021002100210021002100210021002100210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424200004242
      0000424200004242000042420000424200004242000042420000424200004242
      0000424200004242000042420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000396B0000424A000042
      4A0000396B0000424A0000396B0000424A0000396B0000396B0000424A000039
      6B0000396B0000396B0000424A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00000000000000
      000000000000000000000000000000396B000000000000000000000000000000
      000000396B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000424A0000396B0000424A0000396B0000424A0000396B0000424A000039
      6B0000424A0000424A0000396B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF007B7B7B00DEEF
      E700DEEFE700BDDECE007BBD9C007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF00F7FFFF00F7FFFF00F7FFFF00007BFF00F7FFFF000000
      000000000000F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF000039
      6B00F7FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7FFFF00F7FFFF000000000000000000F7FFFF00F7FF
      FF000000000000396B00F7FFFF00F7FFFF00F7FFFF0000424A0000424A000042
      4A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00DEEFE700DEEF
      E700DEEFE700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF007B7B7B00DEEF
      E700BDDECE007BBD9C007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00007BFF00007BFF00007BFF00F7FFFF00007BFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00007BFF00007BFF00007BFF00F7FFFF00007BFF00F7FF
      FF00007BFF00F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00008442000084420000844200FFFFFF0000844200FFFFFF00FFFF
      FF0000844200FFFFFF00FFFFFF000084420000844200FFFFFF00FFFFFF000084
      42000084420000844200FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF000052FF000052FF00F7FFFF00F7FFFF000052FF000052
      FF00F7FFFF00F7FFFF000052FF000052FF000052FF00F7FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00F7FFFF00F7FFFF00F7FFFF00DEEF
      E700DEEFE700DEEFE700F7FFFF00F7FFFF00F7FFFF00F7FFFF007B7B7B00BDDE
      CE007BBD9C007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00007BFF00F7FFFF00007BFF00F7FFFF00007BFF00007BFF00007B
      FF00F7FFFF00F7FFFF00007BFF00F7FFFF00F7FFFF00F7FFFF00007BFF00F7FF
      FF00007BFF00F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000844200FFFFFF0000844200008442000084
      420000844200FFFFFF00FFFFFF000084420000844200FFFFFF00FFFFFF000084
      4200FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF000052FF00F7FFFF000052FF00F7FFFF000052FF00F7FF
      FF000052FF00F7FFFF00F7FFFF00F7FFFF000052FF00F7FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEE7EF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF007B7B7B007BBD
      9C007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00007BFF00F7FFFF00007BFF00F7FFFF00007BFF00F7FFFF00F7FF
      FF00007BFF00F7FFFF00007BFF00007BFF00007BFF00F7FFFF00007BFF00F7FF
      FF00007BFF00F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00008442000084420000844200FFFFFF0000844200FFFFFF00FFFF
      FF0000844200FFFFFF0000844200FFFFFF00FFFFFF0000844200FFFFFF000084
      420000844200FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF000052FF000052FF00F7FFFF00F7FFFF000052FF000052
      FF00F7FFFF00F7FFFF000052FF000052FF000052FF00F7FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00DEE7EF00DEE7EF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00007BFF00F7FFFF00007BFF00F7FFFF00007BFF00F7FFFF00F7FF
      FF00007BFF00F7FFFF00007BFF00F7FFFF00F7FFFF00F7FFFF00007BFF00F7FF
      FF00007BFF00F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000844200FFFFFF00FFFFFF00FFFFFF0000844200FFFFFF00FFFF
      FF0000844200FFFFFF0000844200FFFFFF00FFFFFF0000844200FFFFFF000084
      4200FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF000052FF00F7FFFF000052FF00F7FFFF000052FF00F7FF
      FF000052FF00F7FFFF000052FF00F7FFFF00F7FFFF00F7FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00007BFF00007BFF00007BFF00F7FFFF00007BFF00007BFF00007B
      FF00F7FFFF00F7FFFF00007BFF00007BFF00007BFF00F7FFFF00007BFF00007B
      FF00F7FFFF00F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00008442000084420000844200FFFFFF00FFFFFF00008442000084
      4200FFFFFF00FFFFFF0000844200FFFFFF00FFFFFF0000844200FFFFFF000084
      42000084420000844200FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF000052FF000052FF00F7FFFF00F7FFFF000052FF000052
      FF00F7FFFF00F7FFFF000052FF000052FF000052FF00F7FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FF
      FF0000000000F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000600000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0003FFFFFFFFFFF800007F
      FF0000FFF80001FFFF0007FFF800007FFE00007FF00000FFFF0003FFF800007F
      FE00007FF000007FFE0001FFF800007FFE00007FF000003FFE0001FFF800007F
      FE00007FF000001FFC0000FFFC00007FFE00007FF000001FFC00007FFFFC007F
      FE00007FF000001FF800003FFFF0007FFE00007FF000001FF800003FFFE003FF
      FE00007FF000001FF800001FFFC001FFFE00007FF000001FFF00001FFFC000FF
      FE00007FF000001FFF0007FFFFC000FFFE00007FF800001FFF0007FFFFC000FF
      FE00007FFC00001FFF0007FFFFC000FFFE00007FFFC0003FFF8003FFFF8000FF
      FE00007FFFE0007FFFC001FFFF8001FFFE00007FFFBEF7FFFFFFFFFFFFF001FF
      FE0000FFF81907FFF88661FFFCC80FFFFE0001FFF00003FFF00001FFF8003FFF
      FE0003FFF00003FFF00001FFF8003FFFFE0007FFF00003FFF00003FFF8003FFF
      FE000FFFF00003FFF00001FFF8003FFFFF001FFFF00003FFF00001FFF8003FFF
      FFFFFFFFF88907FFF8C001FFFC007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object timerAutoSave: TTimer
    Interval = 60000
    OnTimer = timerAutoSaveTimer
    Left = 16
    Top = 360
  end
  object popupDefine: TPopupMenu
    Left = 144
    Top = 264
    object popDefPlay: TMenuItem
      Caption = #28436#22863'(&P)'
      OnClick = popDefPlayClick
    end
    object N74: TMenuItem
      Caption = #28436#22863#29992#12481#12515#12531#12493#12523#25351#23450
      object popDefCH1: TMenuItem
        Tag = 1
        Caption = '1'
        Checked = True
        OnClick = popDefCH16Click
      end
      object popDefCH2: TMenuItem
        Tag = 2
        Caption = '2'
        OnClick = popDefCH16Click
      end
      object popDefCH3: TMenuItem
        Tag = 3
        Caption = '3'
        OnClick = popDefCH16Click
      end
      object popDefCH4: TMenuItem
        Tag = 4
        Caption = '4'
        OnClick = popDefCH16Click
      end
      object N75: TMenuItem
        Break = mbBreak
        Caption = '-'
      end
      object popDefCH5: TMenuItem
        Tag = 5
        Caption = '5'
        OnClick = popDefCH16Click
      end
      object popDefCH6: TMenuItem
        Tag = 6
        Caption = '6'
        OnClick = popDefCH16Click
      end
      object popDefCH7: TMenuItem
        Tag = 7
        Caption = '7'
        OnClick = popDefCH16Click
      end
      object popDefCH8: TMenuItem
        Tag = 8
        Caption = '8'
        OnClick = popDefCH16Click
      end
      object N77: TMenuItem
        Break = mbBreak
        Caption = '-'
        OnClick = popDefCH16Click
      end
      object popDefCH9: TMenuItem
        Tag = 9
        Caption = '9'
        OnClick = popDefCH16Click
      end
      object popDefCH10: TMenuItem
        Tag = 10
        Caption = '10'
        OnClick = popDefCH16Click
      end
      object popDefCH11: TMenuItem
        Tag = 11
        Caption = '11'
        OnClick = popDefCH16Click
      end
      object popDefCH12: TMenuItem
        Tag = 12
        Caption = '12'
        OnClick = popDefCH16Click
      end
      object N76: TMenuItem
        Break = mbBreak
        Caption = '-'
      end
      object popDefCH13: TMenuItem
        Tag = 13
        Caption = '13'
        OnClick = popDefCH16Click
      end
      object popDefCH14: TMenuItem
        Tag = 14
        Caption = '14'
        OnClick = popDefCH16Click
      end
      object popDefCH15: TMenuItem
        Tag = 15
        Caption = '15'
        OnClick = popDefCH16Click
      end
      object popDefCH16: TMenuItem
        Tag = 16
        Caption = '16'
        OnClick = popDefCH16Click
      end
    end
    object N78: TMenuItem
      Caption = '-'
    end
    object popInsEdit: TMenuItem
      Caption = #12456#12487#12451#12479#12408#25407#20837
      OnClick = popInsEditClick
    end
  end
end
