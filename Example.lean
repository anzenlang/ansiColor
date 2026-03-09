import AnsiColor
import Tests.Readme

open Ansi

def main : IO Unit := do
  let text := "some text 😺"
  println! "normal → [{Style.normal text}]"
  println! "bold → [{Style.bold text}]"
  println! "dim → [{Style.dim text}]"
  println! "conceal → [{Style.conceal text}]"
  println! "reverse → [{Style.reverse text}]"
  println! "strike → [{Style.strike text}]"
  println! "underline → [{paint text (style := underline)}]"
  println! ""

  println! "red, italic → [{paint text (color := red) (style := italic)}]"
  println! "cyan, dim → [{paint text (color := cyan) (style := dim)}]"
  println! "yellow, blink slow → [{paint text (color := yellow) (style := blinkSlow)}]"
  println! "gray, blink fast → [{paint text (color := gray) (style := blinkFast)}]"
  println! ""

  println! "red bg, italic → [{paint text (background := red) (style := italic)}]"
  println! "cyan bg, dim → [{paint text (background := cyan) (style := dim)}]"
  println! "yellow bg, blink fast → [{paint text (background := yellow) (style := blinkFast)}]"
  println! ""

  println! "black, red bg, italic → \
    [{paint text (color := black) (background := red) (style := italic)}]"
  println! "green, cyan bg, dim → \
    [{paint text (color := green) (background := cyan) (style := dim)}]"
  println! "magenta, yellow bg, blink fast → \
    [{paint text (color := magenta) (background := yellow) (style := blinkFast)}]"
  println! ""

  println! "ansi 9, underline → \
    [{paint text (color := Color.ansi 9) (style := Style.underline)}]"
  println! "rgb 70 70 150, underline → \
    [{paint text (color := Color.rgb 70 70 150) (style := Style.underline)}]"
  println! "ansi 9 bg, underline → \
    [{paint text (background := Color.ansi 9) (style := Style.underline)}]"
  println! "rgb 70 70 150 bg, underline → \
    [{paint text (background := Color.rgb 70 70 150) (style := Style.underline)}]"
  println! ""

  println! "nested examples"
  let inner := paint (color := red) "red text"
  let outer := paint (style := underline) s!"{inner} then not red, all underline"
  println! "  → {outer}"
  let inner1 := paint (color := red) "red text"
  let inner2 := paint (background := magenta) s!"{inner1} then not red, all magenta bg"
  let outer := paint (style := underline) s!"{inner2} then normal, all underline"
  println! "  → {outer}"
  let redText := red "red text"
  let cyanBg := cyan.paintBack s!"{redText}, not red"
  let dim := dim s!"{cyanBg}, not colored"
  let underline := underline s!"before {dim} after"
  println! "  → {underline}"
  println! ""

  println! "bad nesting"
  let inner := red "red text"
  let badOuter := green s!"green text, {inner}, not red anymore but not green either 😿"
  println! "  → {badOuter}"
  let inner := red.paintBack "red bg"
  let badOuter := green.paintBack s!"green bg, {inner}, not red anymore but not green either 😿"
  println! "  → {badOuter}"
  println! ""

  println! "readme test:"
  println! ""
  Readme.main
  println! ""

  println! "done"
