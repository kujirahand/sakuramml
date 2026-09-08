unit HEditorMi;

interface
uses
  SysUtils, Classes, HEditor, Windows;

type
  TEditorMi = class(TEditor)
  public
    procedure GetCaretXY(var x,y: Integer);
    procedure ShowCaret;
  end;

implementation

{ TEditerMi }

procedure TEditorMi.GetCaretXY(var x,y: Integer);
begin
    SetCaretPosition(x,y);
end;

procedure TEditorMi.ShowCaret;
begin
    ScrollCaret;
end;

end.
