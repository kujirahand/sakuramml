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
    //�}�E�X�ړ���F�����鋗��
    property Margin: Integer read FMargin write FMargin;
    //�L��/����
    property Enabled: Boolean read FEnabled write FEnabled;
    //ListView,TreeView�ł̉E�N���b�N�I����L��
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
    mgUp: Result := '��';
    mgDown: Result := '��';
    mgLeft: Result := '��';
    mgRight: Result := '��';
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
//�j��
begin
  //�I���
  if Assigned(FOldMessageEvent) then
    Application.OnMessage := FOldMessageEvent;

  FOldMessageEvent := nil;
  inherited;
end;

procedure TAppMessageHook.DoMessage(var Msg: TMsg; var Handled: Boolean);
//�{���̃��\�b�h�����s
begin
  if Assigned(FOldMessageEvent) then
    FOldMessageEvent(Msg,Handled);
end;

procedure TAppMessageHook.Loaded;
//�J�n�O����
begin
  inherited;
  //�C�x���g�����ւ�
  FOldMessageEvent := Application.OnMessage;
  Application.OnMessage := DoMessage;
end;


{ TgMouseGesture }

function TgMouseGesture.AddGesture(
  Gesture: TMouseGestureType; Ary: TMouseGestureArray): TMouseGestureArray;
//�W�F�X�`���[��������
begin
  Result := Ary;
  if Length(Result) = 0 then
  begin
    //�쐬����
    SetLength(Result,1);
    Result[0] := Gesture;
  end
  else begin
    //�ǉ�����
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
//�}�E�X�W�F�X�`���[
begin
  case Msg.message of
  WM_RBUTTONDOWN: //�J�n
    begin
      FTempMoveGestures := nil;
      FPrevPoint := Msg.pt;
      //�E�N���b�N�I����L���ɂ���
      if FRightClickSelect then
      begin
        Handled := False;
        //�T�u�N���X
        SetSubClass(Msg.hwnd);
      end
      else
        Handled := True;
    end;

    WM_RBUTTONUP: //���s
    begin
      if (Length(FTempMoveGestures) > 0) and (Msg.wParam = 0) then
      begin
        GestureExecute(FTempMoveGestures);
        Handled := True;
      end
      else
        Handled := False;

      FClickGestureStandby := False;
      //���Z�b�g
      ResetSubClass;
    end;

    WM_MOUSEMOVE: //�W�F�X�`���[���`�F�b�N
      if Msg.wParam = MK_RBUTTON then
      begin
        MoveGesture(Msg.pt);
        Handled := True;
      end;

    WM_LBUTTONUP: //���{�^��
      if FClickGestureStandby then
      begin
        FClickGestureStandby := False;
        Handled := True;
        GestureExecute(AddGesture(mgLeftClick));
      end;

    WM_MBUTTONUP: //�z�C�[���{�^��
      if FClickGestureStandby then
      begin
        FClickGestureStandby := False;
        Handled := True;
        GestureExecute(AddGesture(mgWheelClick));
      end;

    WM_XBUTTONUP: //���{�^��
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
//���s����
begin
  if Assigned(FOnMouseGestureExecute) then
    FOnMouseGestureExecute(Self,Gestures);
end;

procedure TgMouseGesture.MoveGesture(pt: TPoint);
//�W�F�X�`���[���`�F�b�N
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
      //�C�x���g
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
//�T�u�N���X�̏I���ʒm
begin
  if Operation = opRemove then
    ResetSubClass;

  inherited;
end;

procedure TgMouseGesture.ResetSubClass;
//����������
begin
  if Assigned(FTempControl) then
  begin
    //���ɖ߂�
    FTempControl.WindowProc := FTempWndMethod;
    FTempControl.RemoveFreeNotification(Self);
    FTempControl := nil;
    FTempWndMethod := nil;
  end;
end;

procedure TgMouseGesture.SetSubClass(Handle: HWND);
//�V����WndProc���Z�b�g
begin
  //�O�̂����Z�b�g
  ResetSubClass;
  //�R���g���[���𓾂�
  FTempControl := FindControl(Handle);
  if Assigned(FTempControl) then
  begin
    //�I���ʒm��v��
    FTempControl.FreeNotification(Self);
    //WndPrco����ւ�
    FTempWndMethod := FTempControl.WindowProc;
    FTempControl.WindowProc := SubClassMessageHook;
  end;
end;

procedure TgMouseGesture.SubClassMessageHook(var Message: TMessage);
//�T�u�N���X
begin
  case Message.Msg of
    WM_CONTEXTMENU: //����������
      if (GetKeyState(VK_RBUTTON) < 0) then
        Message.Result := 1;
  end;

  if Assigned(FTempWndMethod) then
    FTempWndMethod(Message);
end;

end.
 