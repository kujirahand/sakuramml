{%BuildCommand $(CompPath) -Mdelphi $(EdFile)}
program csakura;

{$APPTYPE CONSOLE}

uses
  {$ifdef Win32}
  Windows,
  mmsystem,
  {$endif}
  SysUtils,
  Classes,
  csakurautils in 'csakurautils.pas',
  mml_unit in 'mml_unit.pas',
  StrUnit in 'strunit.pas',
  wildcard in 'wildcard.pas',
  mml_base in 'mml_base.pas',
  mml_error in 'mml_error.pas',
  hashUnit in 'hashUnit.pas',
  mml_types in 'mml_types.pas',
  mml_const in 'mml_const.pas',
  mml_token in 'mml_token.pas',
  mml_system in 'mml_system.pas',
  mml_var in 'mml_var.pas',
  mml_calc in 'mml_calc.pas',
  smf_types in 'smf_types.pas',
  smf_const in 'smf_const.pas',
  mml_token2 in 'mml_token2.pas';


procedure showHelp;
begin
  Writeln('=== sakuramml.com ===');
  Writeln('[USAGE]');
  Writeln('csakura mmlfile [midifile]');
  Writeln('csakura -e mmlcode [midifile]');
end;

var
  i: Integer;
  mml, midi, src: string;
  s: TStringList;
begin
  i := 1;
  mml := '';
  midi := '';
  src := '';
  while i <= ParamCount do
  begin
    // Check Parmeter options
    if ParamStr(i) = '-e' then
    begin
      Inc(i);
      src := ParamStr(i);
      Inc(i);
      continue;
    end;
    // get source code
    if (src = '') and (mml = '') then begin
      mml := ParamStr(i);
      Inc(i);
      continue;
    end;
    if (mml <> '') and (midi = '') then begin
      midi := ParamStr(i);
      Inc(i);
      continue;
    end;
    // WriteLn(ParamStr(i));
    Inc(i);
  end;

  if (src <> '') and (midi = '') then begin
    midi := 'a.mid';
  end else begin
    if (mml <> '') and (midi = '') then begin
      midi := ChangeFileExt(mml, '.mid');
    end;
    if mml = '' then
    begin
      showHelp;
      Exit;
    end;
    // ソースコードの読み込み
    s := TStringList.Create;
    try
      try
        s.LoadFromFile(mml);
        src := s.Text;
      except
        Writeln('Failed .. Could not load mml file: ', mml);
        Exit;
      end;
    finally
      s.Free;
    end;
  end;

  if mmlCompile(src, midi) then
  begin
    Writeln('Success!');
  end else begin
    Writeln('Failed...' + SakuraError);
  end;
  
end.
