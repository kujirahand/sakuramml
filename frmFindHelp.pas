unit frmFindHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls;

type
  TfrmFindHelpF = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtKey: TEdit;
    btnFind: TButton;
    cmbRange: TComboBox;
    Label2: TLabel;
    Panel2: TPanel;
    browser: TWebBrowser;
    chkUpper: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtKeyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  frmFindHelpF: TfrmFindHelpF;

implementation

uses gui_benri, DirUtil, StrUnit, sakurapadU;

{$R *.dfm}

procedure TfrmFindHelpF.FormShow(Sender: TObject);
begin
  //browser.Navigate(AppPath + 'doc\edit\find.htm'); 
end;

procedure TfrmFindHelpF.btnFindClick(Sender: TObject);
var
  key: string;

  procedure findLocale;
  var
    files: TStringList;
    i, cnt: Integer;
    f, ff, txt, txtu, key1, key2, key3, htm,title: string;
  begin
    key := JReplace(key, '　', ' ', True);
    if chkUpper.Checked then key := UpperCase(key);
    key1 := GetToken(' ', key);
    key2 := GetToken(' ', key);
    key3 := GetToken(' ', key);//適当に、３つまでキーにして検索
    cnt := 0;
    files := getAllFiles(AppPath+'doc\*.htm');
    try
      htm := '<H1>検索結果:'+edtKey.Text+'</H1><TABLE border=1 cellpadding=4 bgcolor="#FFFF99">';
      for i:=0 to files.Count -1 do
      begin
        f := files.Strings[ i ];
        ReadTextFile(f, txt);
        if chkUpper.Checked then txtu := UpperCase(txt);
        if Pos(key1, txtu) > 0 then
        begin
          if (key2<>'')and(Pos(key2, txtu)=0) then Continue;
          if (key3<>'')and(Pos(key2, txtu)=0) then Continue;
          //発見
          title := DeleteTag( GetTag(txt, 'TITLE') );
          ff := Copy(f, Length(AppPath), Length(f));
          htm := htm + '<TR><TD>'+title+'</TD><TD><A href="'+f+'" target="_new">'+
                 ff+'</A></TD>'+'</TR>'#13#10;
          Inc(cnt);
        end;
      end;
      htm := htm + '</TABLE>';
      htm := '<HTML><HEAD><TITLE>検索結果:'+edtKey.Text+'</TITLE></HEAD><BODY>'#13#10 + htm + '</BODY></HTML>';
      if cnt=0 then
      begin
        htm := '<HTML><BODY>『'+edtKey.Text+'』は、見つかりませんでした。</BODY></BODY>';
      end;
      WriteTextFile(AppPath+TEMP_DIR+'res.htm', htm);
      Browser.Navigate(AppPath+TEMP_DIR+'res.htm');
    finally
      files.Free ;
    end;
  end;

  procedure findWeb;
  var s: string;
  begin
    s := 'http://www.google.co.jp/search?q='+key+'&hl=ja&lr=lang_ja&as_sitesearch=text2music.com';
    //browser.Navigate(s);
    OpenApp(s);
  end;

  procedure findBBS;
  var s: string;
  begin
    s := 'https://sakuramml.com/tools/sakura/sakura-q/srch.cgi?no=0&word='+key+'&andor=and&logs=all&KYO=1&PAGE=20';
    OpenApp(s);
  end;

begin
  key := edtKey.Text ;
  if key='' then Exit;

  case cmbRange.ItemIndex of
  0: findLocale;
  1: findWeb;
  2: findBBS;
  end;
end;

procedure TfrmFindHelpF.edtKeyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then btnFindClick(nil); 
end;

procedure TfrmFindHelpF.FormCreate(Sender: TObject);
begin
  frmSakuraPad.ini.LoadForm(Self);
end;

procedure TfrmFindHelpF.FormDestroy(Sender: TObject);
begin
  frmSakuraPad.ini.SaveForm(Self);

end;

end.
