{$LIBRARYPATH lib}
program chessboard;

uses crt, chessgui;

begin
  drawBoard(0);
  ReadKey;

  drawBoard($ff);
  ReadKey;
end.
