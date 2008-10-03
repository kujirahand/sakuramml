unit frmBBS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, ImgList, ToolWin, Menus, csvDB,
  OleCtrls, SHDocVw, ExtCtrls, StdCtrls, Gauges, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;


const
  LOG_LIST = 'data\loglist.txt';
  FORM = 'tools\bbs\show.htm';
  TEMP_HTM = 'tools\bbs\temp_bbs.htm';
  COMMA = '~{COM}';

type
  TfrmGetBBS = class(TForm)
    grdList: TStringGrid;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mnuDownloadList: TMenuItem;
    Find1: TMenuItem;
    mnuFind: TMenuItem;
    mnuFindNext: TMenuItem;
    mnuLogList: TMenuItem;
    mnuClose: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mnuChangeLog: TMenuItem;
    N5: TMenuItem;
    mnuHelp: TMenuItem;
    Splitter1: TSplitter;
    web: TWebBrowser;
    N6: TMenuItem;
    mnuGotoBBS: TMenuItem;
    mnuGotoBBSzatudan: TMenuItem;
    mnuChangeNew: TMenuItem;
    N7: TMenuItem;
    mnuFindKanso: TMenuItem;
    mnuViewKiyaku: TMenuItem;
    PopupMenu1: TPopupMenu;
    popPlay: TMenuItem;
    N8: TMenuItem;
    popReload: TMenuItem;
    popKanso: TMenuItem;
    mnuOpenDataDir: TMenuItem;
    N10: TMenuItem;
    mnuReDownload: TMenuItem;
    N2: TMenuItem;
    N11: TMenuItem;
    ImageList1: TImageList;
    cBar: TControlBar;
    ToolBar1: TToolBar;
    btnDownload: TToolButton;
    btnGetLog: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    btnPlay: TToolButton;
    btnStop: TToolButton;
    cbarB: TControlBar;
    lblBar: TLabel;
    prog: TGauge;
    ToolButton1: TToolButton;
    btnKanso: TToolButton;
    http: TIdHTTP;
    ToolButton2: TToolButton;
    toolIgnore: TToolButton;
    N12: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuDownloadListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuFindNextClick(Sender: TObject);
    procedure grdListDblClick(Sender: TObject);
    procedure grdListClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnShowWebClick(Sender: TObject);
    procedure mnuLogListClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuChangeLogClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuGotoBBSClick(Sender: TObject);
    procedure mnuGotoBBSzatudanClick(Sender: TObject);
    procedure mnuChangeNewClick(Sender: TObject);
    procedure mnuFindKansoClick(Sender: TObject);
    procedure mnuViewKiyakuClick(Sender: TObject);
    procedure popReloadClick(Sender: TObject);
    procedure mnuOpenDataDirClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure httpWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure httpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure toolIgnoreClick(Sender: TObject);
  private
    { Private 宣言 }
    SortMuki: array [0..8{適当}] of Boolean;
    procedure ViewList;
  public
    { Public 宣言 }
    csv: TCsvDb;
    viewDb: TCsvDb;
    FindKey: string;
  end;

var
  frmGetBBS: TfrmGetBBS;

implementation

uses StrUnit, gui_benri, sakurapadU, frmSelListU, HEditor;

{$R *.dfm}

const
field_id      = 0;
field_count   = 1;
field_date    = 2;
field_name    = 3;
field_email   = 4;
field_web     = 5;
field_password= 6;
field_genre   = 7;
field_title   = 8;
field_header  = 9;
field_comment = 10;
field_kanso   = 11;


procedure TfrmGetBBS.FormCreate(Sender: TObject);
begin
    csv := TCsvDb.Create;
    viewDb := nil;
    Randomize;
    frmSakuraPad.ini.LoadForm(Self);
end;

procedure TfrmGetBBS.ViewList;
var
    i: Integer;
    c: TCsvDb;
begin
    if viewDB<>nil then viewDB.Free;
    c := TCsvDb.Create ;
    try
        c.SetRowCommaText(0,'(ID),(得票),曲名,作者,日付,ジャンル');
        for i:=0 to csv.Count -1 do
        begin
            c.Cells[0,i+1] := csv.Cells[field_id, i];
            c.Cells[1,i+1] := csv.Cells[field_count, i];
            c.Cells[2,i+1] := csv.Cells[field_title, i];
            c.Cells[3,i+1] := csv.Cells[field_name, i];
            c.Cells[4,i+1] := csv.Cells[field_date, i];
            c.Cells[5,i+1] := csv.Cells[field_genre, i];
            //c.Cells[6,i+1] := csv.Cells[field_comment, i];
        end;
        c.SetStringGrid(grdList, True);
        viewDb := c;
    finally
    end;
end;

procedure TfrmGetBBS.FormShow(Sender: TObject);
var
    s,m: string;
begin
    if FileExists(AppPath+'data\list.txt') then
    begin
        csv.LoadFromFile(AppPath+'data\list.txt');
        ViewList;
        ReadTextFile(AppPath+'data\listdate.txt', s);
        if s='' then s := '(不明)';
        lblBar.Caption := 'このリストは、'+Trim(s)+' に取得されたものです。';
    end;
    case Random(5) of
    0: m := '過去ログにも名曲がたくさんあります。';
    1: m := '灰色のタブをクリックすると項目ごとにソートします。';
    2: m := 'サクラユーザーの最大の宝、曲掲示板を堪能あれ！';
    3: m := '著作権に注意！転載,利用は、各曲の作者様に連絡してください。';
    4: m := '掲示板利用規約を守って楽しく音楽しましょう！';
    end;
    s := '<HTML><BODY><IMG src="'+AppPath+'tools\bbs\bbs_logo.gif">'+'<P>今日の一言</P>'+m+'</BODY></HTML>';
    WriteTextFile(AppPath + TEMP_HTM, s);
    web.Navigate(AppPath + TEMP_HTM);
    cBar.Picture.Assign(frmSakuraPad.cbarTop.Picture);
    cBarB.Picture.Assign(frmSakuraPad.cbarTop.Picture);
end;

procedure TfrmGetBBS.grdListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    row,col,i: Integer;
    caret_id: string;
begin
    grdList.MouseToCell(X, Y, col, row);

    if row = 0 then
    begin
        caret_id := grdList.Cells[ 0, grdList.Row ];
        viewDb.UseHeader := True;
        if Copy(viewDb.Cells[col,0],1,1)='(' then
        begin
            viewDb.MergeSortNo(col);
        end else
        if viewDb.Cells[col,0] = '日付' then
        begin
            viewDb.MergeSortDate(col);
        end else begin
            viewDb.MergeSort(col);
        end;
        if SortMuki[col] = False then
        begin
            viewDb.RowReverse ;
        end;
        viewDb.SetStringGrid(grdList, False);
        SortMuki[col] := not SortMuki[col];
        i := viewDb.Find(caret_id, 0,0);
        if i>0 then grdList.Row := i; 
    end;
end;

procedure TfrmGetBBS.mnuDownloadListClick(Sender: TObject);
var
    i: Integer;
    s: string;
begin
    popKanso.Enabled := True;
    btnKanso.Enabled := True;
    btnDownload.Enabled := False;

    try

    //indexを、取得
    try
        s := http.Get('http://www.text2music.com/tools/sakura/mml_bbs3/bbs-data.txt');
    except
        ShowWarn('ダウンロードに失敗！','サクラ曲掲示板の取得');
        Exit;
    end;
    lblBar.Caption := 'WEBより、一覧表の取得を完了しました。';


    csv.Clear ;
    s := JReplace(s,',',  COMMA,True);
    s := JReplace(s,'"', '”',True);
    s := JReplace(s,#9, ',',True);
    csv.Text := s;

    //倫理的問題で、パスワードは隠す
    for i:=0 to csv.Count -1 do
    begin
        csv.Cells[field_password, i] := '';
    end;
    //データを保存する
    if csv.RowCount > 0 then
    begin
        csv.SaveToFile(AppPath+'data\list.txt');
        WriteTextFile(AppPath+'data\listdate.txt', FormatDateTime('yyyy/mm/dd hh:nn:ss',Now));
    end;
    //
    ViewList;
    grdList.Row := 1;
    finally
        btnDownload.Enabled := True;
    end;
end;

procedure TfrmGetBBS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    csv.Clear ;
end;

procedure TfrmGetBBS.FormDestroy(Sender: TObject);
begin
    csv.Free ;
    frmSakuraPad.ini.SaveForm(Self);
end;

procedure TfrmGetBBS.mnuFindClick(Sender: TObject);
begin
    FindKey := InputBox('検索','検索のキーワードを指定してください。','');
    if FindKey <> '' then mnuFindNextClick(nil);
end;

procedure TfrmGetBBS.mnuFindNextClick(Sender: TObject);
var
    i: Integer;
    s: string;
begin
    i := grdList.Row + 1;
    while i < viewDb.Count do
    begin
        if mnuFindKanso.Checked then
        begin
            s := csv.GetRowCommaText(i-1); 
        end else
        begin
            s := viewDb.GetRowCommaText(i);
        end;
        if Pos(FindKey, s)>0 then
        begin
            grdList.Row := i;
            lblBar.Caption := '"'+FindKey+'"が見つかりました。';
            Exit;
        end;
        Inc(i);
    end;
    ShowWarn('カーソルより下側に、"'+FindKey+'"はありません。','検索');
end;

procedure TfrmGetBBS.grdListDblClick(Sender: TObject);
var
    id, fname, url: string;
    row: Integer;
begin
    //まず、ローカルをチェック
    frmSakuraPad.toolPlayResetClick(nil);
    frmSakuraPad.mnuResetGMClick(nil);//GMでリセット
    row := grdList.Row ;
    id := viewDb.Cells[0, row];
    fname := AppPath + 'data\' + id + '.mml';
    if FileExists(fname) then
    begin
        with frmSakuraPad do
        begin
            LoadToEdit( fname);
        end;
    end else
    begin
        //ダウンロード
        lblBar.Caption := 'WEB より取得します。';
        url := 'http://www.text2music.com/tools/sakura/mml_bbs3/mml/'+id+'.mml';
        try
        try
            grdList.Enabled := False;
            with frmSakuraPad.ActiveEditor.Lines do
            begin
                Text := http.Get(url); //取得
                SaveToFile(fname); //保存
            end;

            with frmSakuraPad.ActiveEditor do
            begin
              //SetFocus;
              //Application.ProcessMessages ;
              SelStart := 0;
              SelLength := 1;
              SetRowCol(0, 0);
              SelLength := 0;
            end;
        except
            Exit;
        end;
        finally
            grdList.Enabled := True;
        end;
    end;
    lblbar.Caption := '取得完了しました。曲をコンパイルしています。そのままお待ちください。';
    frmSakuraPad.PlayModify := True;
    frmSakuraPad.mnuRunClick(nil);
    lblBar.Caption := '';
end;

procedure TfrmGetBBS.grdListClick(Sender: TObject);
var
    row: Integer;
    id, temp,s,ss,name: string;
    i: Integer;
    sl: TStringList;
begin
    row := grdList.Row ;
    //bar.SimpleText := viewDb.Cells[6,row];

    //get id
    id := viewDb.Cells[0, row];
    row := csv.Find(id,0,0);
    if row<0 then Exit;

    //テンプレート読み込み
    ReadTextFile(AppPath+FORM, temp);
    temp := JReplace(temp, '@@TITLE@@', csv.Cells[field_title,row] ,True);
    temp := JReplace(temp, '@@COMMENT@@', csv.Cells[field_comment,row] ,True);
    temp := JReplace(temp, '@@ID@@', id ,True);
    temp := JReplace(temp, '@@LINK@@', '<A href="http://www.text2music.com/tools/sakura/mml_bbs3/bbs.cgi?mode=show&id='+id+'">書き込みと投票はこちら</A>' ,True);
    //kanso
    ss := csv.Cells[field_kanso,row];
    ss := JReplace(ss, COMMA, #13#10, True);

    sl := TStringList.Create ;
    sl.Text := ss;

    s := '<TABLE border=1><TR><TD bgcolor=#FFFF9C>';
    for i:=0 to sl.Count -1 do
    begin
        ss := sl.Strings[i];
        name := GetToken('=',ss);
        s := s + '<FONT color=blue>【'+ name + '】</FONT>'+ ss + #13#10;
        if i<>(sl.Count-1) then s:=s+'<HR>';
    end;
    s := s + '</FONT></TD></TR></TABLE>'#13#10;
    temp := JReplace(temp, '@@KANSO@@', s,True);
    //header
    ss := csv.Cells[field_name,row];
    s  := '作者：'+ss;
    temp := JReplace(temp, '@@HEADER@@', s ,True);

    WriteTextFile(AppPath+TEMP_HTM, temp);
    web.Navigate(AppPath+TEMP_HTM);
end;

procedure TfrmGetBBS.btnPlayClick(Sender: TObject);
begin
    grdListDblClick(nil);
    //self.BringToFront ;
end;

procedure TfrmGetBBS.btnShowWebClick(Sender: TObject);
var
    row: Integer;
    id: string;
begin
    row := grdList.Row ;
    id := viewDb.Cells[0,row];
    OpenApp('http://www.text2music.com/tools/sakura/mml_bbs3/bbs.cgi?mode=show&id='+id);
end;

procedure TfrmGetBBS.mnuLogListClick(Sender: TObject);
var s: string;
begin

    btnGetLog.Enabled := False;
    try
    s := http.Get('http://www.text2music.com/tools/sakura/mml_bbs3/bbs.cgi?mode=old_log');
    WriteTextFile(AppPath+LOG_LIST, s);
    mnuChangeLogClick(nil) ;
    finally
        btnGetLog.Enabled := True;
    end;
end;

procedure TfrmGetBBS.mnuCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmGetBBS.mnuChangeLogClick(Sender: TObject);
var
    s, fname, f: string;
    i,cnt: Integer;
begin
    //過去ログは、感想が書けない。
    popKanso.Enabled := False;
    btnKanso.Enabled := False;

    if False = FileExists(AppPath+LOG_LIST) then
    begin
        mnuLogListClick(nil);
        Exit;
    end;
    ReadTextFile(AppPath+LOG_LIST, s);
    cnt := -1;
    for i:=1 to 500 do
    begin
        if Pos('log_'+IntToStr(i)+'.txt',s)>0 then
        begin
            cnt := i;
        end else
            Break;
    end;
    if cnt<0 then
    begin
        ShowMessage('過去ログデータがありません。');
        Exit;
    end;
    s := '';
    for i:=1 to cnt do //cnt＝データ数ではないので注意
    begin
        s := s + 'log_'+ IntToStr(i)+'.txt'#13#10;
    end;
    frmSelList.lstMain.Items.Text := s;
    frmSelList.ShowModal ;
    f := frmSelList.ResultStr;
    if f='' then Exit;

    //一度ローカルを見る
    csv.Clear ;
    fname := AppPath + 'data\' + f;
    if FileExists(fname) then
    begin
        csv.LoadFromFile(fname);
        lblbar.Caption  := '過去ログ:'+f;
        csv.MergeSortNo(1);//得票順に
        csv.RowReverse ;
        ViewList ;
        Exit;
    end;
    //ネットからダウンロード
    try
        s := http.Get('http://www.text2music.com/tools/sakura/mml_bbs3/'+f);
    except
        ShowMessage('ログ取得に失敗');
        Exit;
    end;
    s := JReplace(s,',', '，',True);
    s := JReplace(s,#9, ',',True);
    csv.Text := s;

    //倫理的問題で、パスワードは隠す
    for i:=0 to csv.Count -1 do
    begin
        csv.Cells[field_password, i] := '';
    end;
    csv.SaveToFile(fname);
    csv.MergeSortNo(1);//得票順に
    csv.RowReverse ;
    ViewList;
    lblbar.Caption := '過去ログ:'+f;
end;

procedure TfrmGetBBS.mnuHelpClick(Sender: TObject);
begin
    OpenApp(AppPath+'doc\edit\skr-bbs.htm');
end;

procedure TfrmGetBBS.mnuGotoBBSClick(Sender: TObject);
begin
    OpenApp('http://www.text2music.com/tools/sakura/mml_bbs3/bbs.cgi');
end;

procedure TfrmGetBBS.mnuGotoBBSzatudanClick(Sender: TObject);
begin
    OpenApp('http://oto.chu.jp/cgi/bbs/bbs.cgi?id=sakura-bbs');
end;

procedure TfrmGetBBS.mnuChangeNewClick(Sender: TObject);
begin
    FormShow(nil);
    btnKanso.Enabled := True;
    popKanso.Enabled := True;
end;

procedure TfrmGetBBS.mnuFindKansoClick(Sender: TObject);
begin
    mnuFindKanso.Checked := not mnuFindKanso.Checked ;
end;

procedure TfrmGetBBS.mnuViewKiyakuClick(Sender: TObject);
begin
    OpenApp(AppPath+'doc\edit\skr-bbs-kiyaku.htm');
end;

procedure TfrmGetBBS.popReloadClick(Sender: TObject);
var
    row: Integer;
    id,s: string;
begin
    row := grdList.Row ;
    //get id
    id := viewDb.Cells[0, row];
    s := AppPath + 'data\' + id + '.mml';
    if FileExists(s) then DeleteFile(s);
    btnPlayClick(nil);
end;

procedure TfrmGetBBS.mnuOpenDataDirClick(Sender: TObject);
begin
    OpenApp(AppPath+'data\');
end;

procedure TfrmGetBBS.btnStopClick(Sender: TObject);
begin
    frmSakuraPad.mnuStopClick(nil); 
end;

procedure TfrmGetBBS.httpWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
    prog.Progress := AWorkCount ;
    Application.ProcessMessages ;
end;

procedure TfrmGetBBS.httpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
    prog.MaxValue := AWorkCountMax ;
end;

procedure TfrmGetBBS.toolIgnoreClick(Sender: TObject);
begin
  http.Disconnect ;
  lblBar.Caption := '中断しました。';
end;

end.
