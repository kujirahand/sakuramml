unit gMouseGesture;

{
  Mouse Gesture Component for Delphi

  written by Wolfy(http://hp.vector.co.jp/authors/VA024591/)
  license BSD
  modified 2002/10/12

  thanks to OpenJane, i had written.
}



{$IFDEF VER130}
{$ELSE}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes,forms,controls;


type
  TMouseGestureType = (mgUp,mgDown,mgLeft,mgRight,
                       mgLeftClick,mgWheelClick,mgWheelUp,mgWheelDown,
                       mgSide1,mgSide2,mgSide1R,mgSide2R);
  TMouseGestureArray = array of TMouseGestureType;


  TMouseGestureExecuteEvent = procedure(Sender: TObject; Gestures: TMouseGestureArray) of object;
  TMouseGestureNotifyEvent = procedure(Sender: TObject; Gesture: TMouseGestureType) of object;


  TAppMessageHook = class(TComponent)
  private        
    FOldMessageEvent: TMessageEvent;
  protected
    procedure DoMessage(var Msg: TMsg; var Handled: Boolean); virtual;
    procedure Loaded; override;
  public
    destructor Destroy; override;
  end;

  TgMouseGesture = class(TAppMessageHook)
  private
    FPrevPoint: TPoint;
    FClickGestureStandby: Boolean;
    FMargin: Integer;
    FTempMoveGestures: TMouseGestureArray;
    FEnabled: Boolean;
    FTempControl: TWinControl;
    FTempWndMethod: TWndMethod;
    FRightClickSelect: Boolean;
    
    FOnMouseGestureExecute: TMouseGestureExecuteEvent;
    FOnMouseGestureNotify: TMouseGestureNotifyEvent;
    FOnMouseGestureNotifyMove: TMouseGestureExecuteEvent;

  protected
    procedure DoMessage(var Msg: TMsg; var Handled: Boolean); override;
    procedure DoMouseGesture(var Msg: TMsg; var Handled: Boolean); virtual;
    procedure MoveGesture(pt: TPoint);
    procedure GestureExecute(Gestures: TMouseGestureArray);
    function AddGesture(Gesture: TMouseGestureType; Ary: TMouseGestureArray = nil): TMouseGestureArray;
    procedure SubClassMessageHook(var Message: TMessage); virtual;
    procedure ResetSubClass;
    procedure SetSubClass(Handle: HWND);
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //マウス移動を認識する距離
    property Margin: Integer read FMargin write FMargin;
    //有効/無効
    property Enabled: Boolean read FEnabled write FEnabled;
    //ListView,TreeViewでの右クリック選択を有効
    property RightClickSelect: Boolean read FRightClickSelect write FRightClickSelect;
    property OnMouseGestureExecute: TMouseGestureExecuteEvent read FOnMouseGestureExecute write FOnMouseGestureExecute;
    property OnMouseGestureNotify: TMouseGestureNotifyEvent read FOnMouseGestureNotify write FOnMouseGestureNotify;
    property OnMouseGestureNotifyMove: TMouseGestureExecuteEvent read FOnMouseGestureNotifyMove write FOnMouseGestureNotifyMove;
  end;


function MouseGestureToString(Gesture: TMouseGestureType): String;
function MouseGestureArrayToString(Gestures: TMouseGestureArray): String;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Main1', [TgMouseGesture]);
end;

const
  CRLF = sLineBreak;
  WM_CONTROLRECREATED = WM_USER + 020103;
  WM_XBUTTONDOWN   = $020B;
  WM_XBUTTONUP     = $020C;
  WM_XBUTTONDBLCLK = $020D;
  MK_XBUTTON1 = $0001;
  MK_XBUTTON2 = $0002;

function MouseGestureToString(Gesture: TMouseGestureType): String;
begin
  case Gesture of
    mgUp: Result := '↑';
    mgDown: Result := '↓';
    mgLeft: Result := '←';
    mgRight: Result := '→';
    mgLeftClick: Result := 'LeftClick';
    mgWheelClick: Result := 'WheelClick';
    mgWheelUp: Result := 'WheelUp';
    mgWheelDown: Result := 'WheelDown';
    mgSide1: Result := 'Side1';
    mgSide2: Result := 'Side2';
    mgSide1R: Result := 'Side1R';
    mgSide2R: Result := 'Sede2R';
  end;
end;

function MouseGestureArrayToString(Gestures: TMouseGestureArray): String;
var
  i: Integer;
  g: TMouseGestureType;
begin
  for i := 0 to Length(Gestures) - 1 do
  begin
    g := Gestures[i];
    case g of
      mgUp,mgDown,mgLeft,mgRight:
        Result := Result + MouseGestureToString(g);
    else
      if Result = '' then
        Result := MouseGestureToString(g)
      else
        Result := Result + CRLF + MouseGestureToString(g);
    end;
  end;
end;
  

{ TAppMessageHook }


destructor TAppMessageHook.Destroy;
//破棄
begin
  //終わり
  if Assigned(FOldMessageEvent) then
    Application.OnMessage := FOldMessageEvent;

  FOldMessageEvent := nil;
  inherited;
end;

procedure TAppMessageHook.DoMessage(var Msg: TMsg; var Handled: Boolean);
//本来のメソッドを実行
begin
  if Assigned(FOldMessageEvent) then
    FOldMessageEvent(Msg,Handled);
end;

procedure TAppMessageHook.Loaded;
//開始前準備
begin
  inherited;
  //イベントを入れ替え
  FOldMessageEvent := Application.OnMessage;
  Application.OnMessage := DoMessage;
end;


{ TgMouseGesture }

function TgMouseGesture.AddGesture(
  Gesture: TMouseGestureType; Ary: TMouseGestureArray): TMouseGestureArray;
//ジェスチャーを加える
begin
  Result := Ary;
  if Length(Result) = 0 then
  begin
    //作成する
    SetLength(Result,1);
    Result[0] := Gesture;
  end
  else begin
    //追加する
    if Result[High(Result)] <> Gesture then
    begin
      SetLength(Result,Length(Result) + 1);
      Result[High(Result)] := Gesture;
    end;
  end;
end;

constructor TgMouseGesture.Create(AOwner: TComponent);
begin
  inherited;
  FMargin := 5;
  FEnabled := True;
  FRightClickSelect := False;
end;

destructor TgMouseGesture.Destroy;
begin
  ResetSubClass;
  inherited;
end;

procedure TgMouseGesture.DoMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if FEnabled then
    DoMouseGesture(Msg,Handled);

  inherited;
end;

procedure TgMouseGesture.DoMouseGesture(var Msg: TMsg;
  var Handled: Boolean);
//マウスジェスチャー
begin
  case Msg.message of
  WM_RBUTTONDOWN: //開始
    begin
      FTempMoveGestures := nil;
      FPrevPoint := Msg.pt;
      //右クリック選択を有効にする
      if FRightClickSelect then
      begin
        Handled := False;
        //サブクラス
        SetSubClass(Msg.hwnd);
      end
      else
        Handled := True;
    end;

    WM_RBUTTONUP: //実行
    begin
      if (Length(FTempMoveGestures) > 0) and (Msg.wParam = 0) then
      begin
        GestureExecute(FTempMoveGestures);
        Handled := True;
      end
      else
        Handled := False;

      FClickGestureStandby := False;
      //リセット
      ResetSubClass;
    end;

    WM_MOUSEMOVE: //ジェスチャーをチェック
      if Msg.wParam = MK_RBUTTON then
      begin
        MoveGesture(Msg.pt);
        Handled := True;
      end;

    WM_LBUTTONUP: //左ボタン
      if FClickGestureStandby then
      begin
        FClickGestureStandby := False;
        Handled := True;
        GestureExecute(AddGesture(mgLeftClick));
      end;

    WM_MBUTTONUP: //ホイールボタン
      if FClickGestureStandby then
      begin
        FClickGestureStandby := False;
        Handled := True;
        GestureExecute(AddGesture(mgWheelClick));
      end;

    WM_XBUTTONUP: //横ボタン
      if FClickGestureStandby then
      begin
        FClickGestureStandby := False;
        Handled := True;
        if (GetKeyState(VK_RBUTTON) < 0) then
        case HiWord(Msg.wParam) of
          MK_XBUTTON1: GestureExecute(AddGesture(mgSide1R));
          MK_XBUTTON2: GestureExecute(AddGesture(mgSide2R));
        end
        else begin
          case HiWord(Msg.wParam) of
            MK_XBUTTON1: GestureExecute(AddGesture(mgSide1));
            MK_XBUTTON2: GestureExecute(AddGesture(mgSide2));
          end;
        end;
      end;

    WM_LBUTTONDOWN:
      if Msg.wParam = (MK_RBUTTON + MK_LBUTTON) then
      begin
        FClickGestureStandby := True;
        Handled := True;
      end;

    WM_MBUTTONDOWN:
      if Msg.wParam = (MK_RBUTTON + MK_MBUTTON) then
      begin
        FClickGestureStandby := True;
        Handled := True;
      end;

    WM_XBUTTONDOWN:
      if (HiWord(Msg.wParam) = MK_XBUTTON1) or
         (HiWord(Msg.wParam) = MK_XBUTTON2) then
      begin
        FClickGestureStandby := True;
        Handled := (GetKeyState(VK_RBUTTON) < 0);
      end;

    WM_MOUSEWHEEL:
      if LoWord(Msg.wParam) = MK_RBUTTON then
      begin
        if (Msg.wParam > 0) then
          GestureExecute(AddGesture(mgWheelUp))
        else
          GestureExecute(AddGesture(mgWheelDown));

        Handled := True;
      end;
  end;

end;

procedure TgMouseGesture.GestureExecute(Gestures: TMouseGestureArray);
//実行する
begin
  if Assigned(FOnMouseGestureExecute) then
    FOnMouseGestureExecute(Self,Gestures);
end;

procedure TgMouseGesture.MoveGesture(pt: TPoint);
//ジェスチャーをチェック
var
  temp: Extended;
  distance: TPoint;
  arrow: TMouseGestureType;
  len: Integer;
begin
  distance.X := Abs(pt.X - FPrevPoint.X);
  distance.Y := Abs(pt.Y - FPrevPoint.Y);
  if (distance.X > FMargin) or
     (distance.Y > FMargin) then
  begin
    temp := distance.Y / (distance.X + 0.001);
    if temp >= 1 then
    begin
      if pt.Y > FPrevPoint.Y then
        arrow := mgDown
      else
        arrow := mgUp;
    end else
    begin
      if pt.X > FPrevPoint.X then
        arrow := mgRight
      else
        arrow := mgLeft;
    end;

    len := Length(FTempMoveGestures);
    FTempMoveGestures := AddGesture(arrow,FTempMoveGestures);
    if len <> Length(FTempMoveGestures) then
    begin
      //イベント
      if Assigned(FOnMouseGestureNotify) then
        FOnMouseGestureNotify(Self,arrow);

      if Assigned(FOnMouseGestureNotifyMove) then
        FOnMouseGestureNotifyMove(Self,FTempMoveGestures);
    end;

    FPrevPoint := pt;
  end;
end;

procedure TgMouseGesture.Notification(AComponent: TComponent;
  Operation: TOperation);
//サブクラスの終了通知
begin
  if Operation = opRemove then
    ResetSubClass;

  inherited;
end;

procedure TgMouseGesture.ResetSubClass;
//初期化する
begin
  if Assigned(FTempControl) then
  begin
    //元に戻す
    FTempControl.WindowProc := FTempWndMethod;
    FTempControl.RemoveFreeNotification(Self);
    FTempControl := nil;
    FTempWndMethod := nil;
  end;
end;

procedure TgMouseGesture.SetSubClass(Handle: HWND);
//新しいWndProcをセット
begin
  //前のをリセット
  ResetSubClass;
  //コントロールを得る
  FTempControl := FindControl(Handle);
  if Assigned(FTempControl) then
  begin
    //終了通知を要求
    FTempControl.FreeNotification(Self);
    //WndPrco入れ替え
    FTempWndMethod := FTempControl.WindowProc;
    FTempControl.WindowProc := SubClassMessageHook;
  end;
end;

procedure TgMouseGesture.SubClassMessageHook(var Message: TMessage);
//サブクラス
begin
  case Message.Msg of
    WM_CONTEXTMENU: //無効化する
      if (GetKeyState(VK_RBUTTON) < 0) then
        Message.Result := 1;
  end;

  if Assigned(FTempWndMethod) then
    FTempWndMethod(Message);
end;

end.
 