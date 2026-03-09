import AnsiColor

namespace Ansi.Tests

def text := "<text>"
def debug (s : String) := println! "{repr s}"

/--
info:
"\x1b[39m<text>\x1b[39m"
"\x1b[38;5;0m<text>\x1b[39m"
"\x1b[38;5;1m<text>\x1b[39m"
"\x1b[38;5;2m<text>\x1b[39m"
"\x1b[38;5;3m<text>\x1b[39m"
"\x1b[38;5;4m<text>\x1b[39m"
"\x1b[38;5;5m<text>\x1b[39m"
"\x1b[38;5;6m<text>\x1b[39m"
"\x1b[38;5;8m<text>\x1b[39m"
"\x1b[38;5;9m<text>\x1b[39m"
"\x1b[38;5;10m<text>\x1b[39m"
"\x1b[38;5;11m<text>\x1b[39m"
"\x1b[38;5;12m<text>\x1b[39m"
"\x1b[38;5;13m<text>\x1b[39m"
"\x1b[38;5;14m<text>\x1b[39m"
"\x1b[38;5;7m<text>\x1b[39m"
"\x1b[38;5;3m<text>\x1b[39m"
"\x1b[38;2;10;10;10m<text>\x1b[39m"
-/
#guard_msgs in #eval do
  Color.default text |> debug
  Color.black text |> debug
  Color.darkRed text |> debug
  Color.darkGreen text |> debug
  Color.darkYellow text |> debug
  Color.darkBlue text |> debug
  Color.darkMagenta text |> debug
  Color.darkCyan text |> debug
  Color.darkGray text |> debug
  Color.red text |> debug
  Color.green text |> debug
  Color.yellow text |> debug
  Color.blue text |> debug
  Color.magenta text |> debug
  Color.cyan text |> debug
  Color.gray text |> debug
  text |> Color.ansi 3 |> debug
  text |> Color.rgb 10 10 10 |> debug

/--
info:
"\x1b[49m<text>\x1b[49m"
"\x1b[48;5;0m<text>\x1b[49m"
"\x1b[48;5;1m<text>\x1b[49m"
"\x1b[48;5;2m<text>\x1b[49m"
"\x1b[48;5;3m<text>\x1b[49m"
"\x1b[48;5;4m<text>\x1b[49m"
"\x1b[48;5;5m<text>\x1b[49m"
"\x1b[48;5;6m<text>\x1b[49m"
"\x1b[48;5;8m<text>\x1b[49m"
"\x1b[48;5;9m<text>\x1b[49m"
"\x1b[48;5;10m<text>\x1b[49m"
"\x1b[48;5;11m<text>\x1b[49m"
"\x1b[48;5;12m<text>\x1b[49m"
"\x1b[48;5;13m<text>\x1b[49m"
"\x1b[48;5;14m<text>\x1b[49m"
"\x1b[48;5;7m<text>\x1b[49m"
"\x1b[48;5;3m<text>\x1b[49m"
"\x1b[48;2;10;10;10m<text>\x1b[49m"
-/
#guard_msgs in #eval do
  Color.default.paintBack text |> debug
  Color.black.paintBack text |> debug
  Color.darkRed.paintBack text |> debug
  Color.darkGreen.paintBack text |> debug
  Color.darkYellow.paintBack text |> debug
  Color.darkBlue.paintBack text |> debug
  Color.darkMagenta.paintBack text |> debug
  Color.darkCyan.paintBack text |> debug
  Color.darkGray.paintBack text |> debug
  Color.red.paintBack text |> debug
  Color.green.paintBack text |> debug
  Color.yellow.paintBack text |> debug
  Color.blue.paintBack text |> debug
  Color.magenta.paintBack text |> debug
  Color.cyan.paintBack text |> debug
  Color.gray.paintBack text |> debug
  Color.ansi 3 |>.paintBack text |> debug
  Color.rgb 10 10 10 |>.paintBack text |> debug

/--
info:
"\x1b[22m<text>\x1b[22m"
"\x1b[1m<text>\x1b[22m"
"\x1b[2m<text>\x1b[22m"
"\x1b[3m<text>\x1b[23m"
"\x1b[4m<text>\x1b[24m"
"\x1b[5m<text>\x1b[25m"
"\x1b[6m<text>\x1b[25m"
"\x1b[7m<text>\x1b[27m"
"\x1b[8m<text>\x1b[28m"
"\x1b[9m<text>\x1b[29m"
-/
#guard_msgs in #eval do
  Style.normal text |> debug
  Style.bold text |> debug
  Style.dim text |> debug
  Style.italic text |> debug
  Style.underline text |> debug
  Style.blinkSlow text |> debug
  Style.blinkFast text |> debug
  Style.reverse text |> debug
  Style.conceal text |> debug
  Style.strike text |> debug

/--
info: "\x1b[4mbefore \x1b[2m\x1b[48;5;14m\x1b[38;5;9minner\x1b[39m, not red\x1b[49m, not colored\x1b[22m after\x1b[24m"
-/
#guard_msgs in #eval do
  let redText := paint "inner" (color := red)
  let cyanBg := paint s!"{redText}, not red" (background := cyan)
  let dim := paint s!"{cyanBg}, not colored" (style := dim)
  let underline := paint s!"before {dim} after" (style := underline)
  debug underline

/-- info: "\x1b[2m\x1b[48;5;14m\x1b[38;5;9minner\x1b[39m, not red\x1b[49m, not colored\x1b[22m" -/
#guard_msgs in #eval do
  let redText := paint "inner" (color := red)
  let cyanBg := paint s!"{redText}, not red" (background := cyan)
  let dim := paint s!"{cyanBg}, not colored" (style := dim)
  debug dim
