unit mci_cmd;
{Windows標準のMCIを簡単に操作するためのユニット}
interface

uses
  Windows,
  SysUtils,
  Classes,
  MMSystem;

function mciCommand(cmd: string): Boolean;
function mciPlayFile(fname: string): Boolean;
function mciPlayFilePos(fname: string; p: Integer): Boolean;
function mciClose: Boolean;
function mciPlayPos: Integer;
function mciPlayLength: Integer;

var
  mciMessage,devName: string;

implementation
uses
  strunit;

function mciPlayFilePos(fname: string; p: Integer): Boolean;
begin
    Result := mciCommand(format('open "%s" alias %s',[fname, devName]));
    if Result then
    begin
        Result := mciCommand('play '+devName+' from '+IntToStr(p));
    end;
end;

function mciPlayFile(fname: string): Boolean;
begin
    Result := mciCommand(format('open "%s" alias %s',[fname, devName]));
    if Result then
    begin
        Result := mciCommand('play '+devName);
    end;
end;

function mciClose: Boolean;
begin
    Result := True;
    try
        Result := mciCommand('close '+devName);
    except
    end;
end;

function mciPlayPos: Integer;
begin
    if mciCommand('status '+devName+' position') then
    begin
        Result := StrToIntDef(mciMessage,0);
    end else
    begin
        Result := 0;
    end;
end;

function mciPlayLength: Integer;
begin
    if mciCommand('status '+devName+' length') then
    begin
        Result := StrToIntDef(mciMessage,0);
    end else
    begin
        Result := 0;
    end;
end;

function mciCommand(cmd: string): Boolean;
var
    rc: DWORD;
    s: string;
begin
    Result := True;

    SetLength(mciMessage, 512);
    rc := mciSendString(PChar(cmd),PChar(mciMessage),Length(mciMessage),0);
    if rc<>0 then
    begin
        SetLength(s,512);
        mciGetErrorString(rc, PChar(s), Length(s));
        raise EInvalidOperation.Create('MCIのエラー:'#13#10'"'+cmd+'"'+string(PChar(mciMessage))+string(PChar(s)));
    end;
end;

initialization
    devName := 'mci'+FormatDateTime('hh:nn:ss',Now);
    devName := JReplace(devName, '.','_',True);
    devName := JReplace(devName, '/','_',True);
    devName := JReplace(devName, ':','_',True);
    devName := JReplace(devName, ' ','_',True);

end.
