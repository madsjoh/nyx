{ lib }:

let
  hexDigit = digit:
    builtins.getAttr digit {
      "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
      "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
      "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
      "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
    };
in
{
  strip = hex: lib.removePrefix "#" hex;

  rgb = hex:
    let
      h = lib.removePrefix "#" hex;
      ch = i: builtins.substring i 1 h;
      val = i: hexDigit (ch i) * 16 + hexDigit (ch (i + 1));
    in "${toString (val 0)}, ${toString (val 2)}, ${toString (val 4)}";
}
