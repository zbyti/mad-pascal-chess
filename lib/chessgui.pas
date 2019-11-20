unit chessgui;

//---------------------- INTERFACE ---------------------------------------------

interface

  procedure renderChessman(chessman: word; x, y, invert: byte);
  procedure drawRectangle;
  procedure drawBoard(side: byte);

//---------------------- TYPES -------------------------------------------------

type TChessman = array[0..56] of byte;

//---------------------- CONSTANS ----------------------------------------------

const
  {$i pieces.inc}

  CHESSBOARD            : array[0..32] of word = (
    WHITE_SQUARE,
    ROOK_SE,KNIGHT_EE,BISHOP_SE,QUEEN_EE,KING_SE,BISHOP_EE,KNIGHT_SE,ROOK_EE,
    PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,
    PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,PAWN_EE,PAWN_SE,
    ROOK_SE,KNIGHT_EE,BISHOP_SE,QUEEN_EE,KING_SE,BISHOP_EE,KNIGHT_SE,ROOK_EE
  );

//---------------------- VARIABLES ---------------------------------------------

var
  bmpAdr                : word;
  p1, p2                : Pchar;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses crt, graph;

procedure renderChessman(chessman: word; x, y, invert: byte);
var i0b                 : byte;
begin
  p1 := pointer(bmpAdr + (x * 3) + (y * 760) + 40 + 1);
  for i0b := 0 to 18 do begin
    p1[0]:= Char(peek(chessman) xor invert); Inc(chessman);
    p1[1]:= Char(peek(chessman) xor invert); Inc(chessman);
    p1[2]:= Char(peek(chessman) xor invert); Inc(chessman);
    Inc(p1, 40);
  end;
end;

procedure drawRectangle;
var i0b                 : byte;
begin
  p1 := pointer(bmpAdr);
  p2 := pointer(bmpAdr + 25);
  for i0b := 0 to 153 do begin
    p1[0]:= chr(%00000001); Inc(p1, 40);
    p2[0]:= chr(%10000000); Inc(p2, 40);
  end;
  p1 := pointer(bmpAdr);
  p2 := pointer(bmpAdr + 6120); // 19*8*40 + 40
  for i0b := 1 to 24 do begin
    p1[i0b] := #$ff;
    p2[i0b] := #$ff;
  end;
end;

{* Then side = $0 draw white side; $ff draw black side *}
procedure drawBoard(side: byte);
var i0b, i1b            : byte;
    invert, chessman    : byte;
begin
  drawRectangle;
  chessman := 1;
  for i1b := 0 to 7 do begin
    for i0b := 0 to 7 do begin
      if (Odd(i0b + i1b)) then invert := side else invert := not side;
      if ((i1b > 1) and (i1b < 6)) then begin
        renderChessman(CHESSBOARD[0], i0b, i1b, not invert);
      end else begin
        renderChessman(CHESSBOARD[chessman], i0b, i1b, invert);
        Inc(chessman);
      end;
    end;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

  // There are 192 rows of 320 dots in the full screen mode.
  InitGraph(8);
  bmpAdr := dpeek(88);

  SetColor(1);
  // colors: 2, 4, 80, 82, 96, 98, 112, 130, 132, 144, 146, 148, 150
  SetBKColor(2);
  TextBackground(2);

end.
