program Day2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  Types,
  SysUtils;

type
  TGame = record
    Red: Integer;
    Green: Integer;
    Blue: Integer;
  end;

var
  Games: Array of TGame;
  I, J: Integer;
  P: Integer;
  Str: String;
  Cubes: TStringDynArray;
  Value: Integer;
  Sum1, Sum2: Integer;
  Input: TStringList;
begin
  Games := nil;

  Input := TStringList.Create;
  Input.LoadFromFile('input.txt');
  for I := 0 to Input.Count - 1 do
  begin
    SetLength(Games, Length(Games) + 1);
    P := Pos(':', Input[I]);
    Str := Copy(Input[I], P + 1, Length(Input[I]));

    Cubes :=  Str.Split([';', ',']);

    for J := 0 to Length(Cubes) - 1 do
    begin
      P := Pos('red', Cubes[J]);
      if P > 0 then
      begin
        Value := StrToInt(Trim(Copy(Cubes[J], 1, P - 1)));
        if Value > Games[I].Red then
          Games[I].Red := Value;
        Continue;
      end;

      P := Pos('green', Cubes[J]);
      if P > 0 then
      begin
        Value := StrToInt(Trim(Copy(Cubes[J], 1, P - 1)));
        if Value > Games[I].Green then
          Games[I].Green := Value;
        Continue;
      end;

      P := Pos('blue', Cubes[J]);
      if P > 0 then
      begin
        Value := StrToInt(Trim(Copy(Cubes[J], 1, P - 1)));
        if Value > Games[I].Blue then
          Games[I].Blue := Value;
      end;
    end
  end;
  Input.Free;

  Sum1 := 0;
  Sum2 := 0;
  for I := 0 to Length(Games) - 1 do
  begin
    if (Games[I].Red <= 12) and (Games[I].Green <= 13) and (Games[I].Blue <= 14) then
      Inc(Sum1, I + 1);

    Inc(Sum2, Games[I].Red * Games[I].Green * Games[I].Blue);
  end;
  WriteLn('Part 1 = ' + Sum1.ToString);
  WriteLn('Part 2 = ' + Sum2.ToString);
end.

