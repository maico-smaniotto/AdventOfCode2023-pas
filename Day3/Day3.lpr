program Day3;
{
  https://adventofcode.com/2023/day/3
}
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  SysUtils,
  Generics.Collections;

var
  Input: TStringList;
  Numbers: specialize TDictionary<String, Integer>;
  Sum1, Sum2: Integer;

function IsDigit(C: Char): Boolean;
begin
  Result := (C >= '0') and (C <= '9');
end;

function IsSymbol(I: Integer; J: Integer): Boolean;
begin
  Result := (Input[I][J] <> '.') and not IsDigit(Input[I][J]);
end;

procedure StoreValue(I: Integer; J: Integer; Value: Integer);
begin
  if not Numbers.ContainsKey(I.ToString + ':' + J.ToString) then
  begin
    Numbers.Add(I.ToString + ':' + J.ToString, Value);
    Inc(Sum1, Value);
  end;
end;

function ExtractNumber(I: Integer; J: Integer; out Start: Integer): Integer;
var
  N, &End: Integer;
begin
  Result := 0;
  N := J;
  Start := N;
  &End := N;
  while N >= 1 do
  begin
    if IsDigit(Input[I][N]) then
      Start := N
    else
      Break;
    Inc(N, -1);
  end;
  N := J;
  while N <= Length(Input[I]) do
  begin
    if IsDigit(Input[I][N]) then
      &End := N
    else
      Break;
    Inc(N, 1);
  end;
  Result := StrToInt(Copy(Input[I], Start, &End + 1 - Start));
end;

procedure Look(I: Integer; J: Integer; var PartNumbers: Integer; var Ratio: Integer);
var
  Value, Start: Integer;

  procedure MultiplyRatio;
  begin
    if PartNumbers = 0 then
      Ratio := Value
    else
      Ratio := Ratio * Value;
    Inc(PartNumbers);
  end;

begin
  if IsDigit(Input[I][J]) then
  begin
    // Middle
    Value := ExtractNumber(I, J, Start);
    StoreValue(I, Start, Value);
    MultiplyRatio;
  end
  else
  begin
    // Left
    if J > 1 then
      if IsDigit(Input[I][J - 1]) then
      begin
        Value := ExtractNumber(I, J - 1, Start);
        StoreValue(I, Start, Value);
        MultiplyRatio;
      end;
    // Right
    if J < Length(Input[I]) then
      if IsDigit(Input[I][J + 1]) then
      begin
        Value := ExtractNumber(I, J + 1, Start);
        StoreValue(I, Start, Value);
        MultiplyRatio;
      end;
  end;
end;

procedure LookAround(I: Integer; J: Integer);
var
  PartNumbers, Ratio: Integer;
begin
  PartNumbers := 0;
  Ratio := 0;

  if I > 0 then
    Look(I - 1, J, PartNumbers, Ratio);

  Look(I, J, PartNumbers, Ratio);

  if I < (Input.Count - 1) then
    Look(I + 1, J, PartNumbers, Ratio);

  if PartNumbers > 1 then
    Inc(Sum2, Ratio);
end;

var
  I, J: Integer;
begin
  Numbers := specialize TDictionary<String, Integer>.Create;
  Sum1 := 0;
  Sum2 := 0;

  Input := TStringList.Create;
  Input.LoadFromFile('input.txt');

  for I := 0 to Input.Count - 1 do
    for J := 1 to Length(Input[I]) do
      if IsSymbol(I, J) then
        LookAround(I, J);

  Input.Free;
  Numbers.Free;

  WriteLn('Part 1 = ' + Sum1.ToString);
  WriteLn('Part 2 = ' + Sum2.ToString);
end.

