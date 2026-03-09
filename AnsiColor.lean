module

/-! # ANSI colors and styles

The two main types exposed by this library are `Color` and `Style`. Both feature a `paint` function
(`Color.paint` and `Style.paint`) to paint text with.

Colors apply either to the foreground or the background, see `Color.paint`'s `background` optional
argument; alternatively, one can use `Color.paintFront` and `Color.paintBack`.

For convenience, `Color` and `Style` values coerce to `String.Slice → String`, which goes to
`Color.paintFront` and `Style.paint` respectively. This allows writing, for example, `Color.red
myString` or `Style.underline myString` for quick and easy coloring/styling.

## Nesting

Some nestings are not supported because, when painting some inner content, the escape sequence
closing the inner color/style may cancel the outer color/style. Say `paint1` and `paint2` paint
their input string, and say we have
- `inner := paint1 "inner text"`, and
- `outer := paint2 s!"before {inner} after"`

Then if the ANSI color/style closing sequence introduced by `paint1` at the end of `inner` may
cause the effect of `paint2` to be turned off on the substring `" after"` in `outer`. Note that
this applies whether or not the nesting is direct or under several nesting levels.

This will happen when
- nesting *foreground* coloring in *foreground* coloring;
- nesting *background* coloring in *background* coloring;
- nesting any of `Style.normal`/`Style.bold`/`Style.dim` in any of them;
- nesting any style in itself.

All other forms of nesting are supported. Here is a convoluted example that behaves as expected:

```lean
open Ansi in
def ugly : String :=
  let redText := red "red text"
  let cyanBg := cyan.paintBack s!"{redText}, not red"
  let dim := dim s!"{cyanBg}, not colored"
  underline s!"before {dim} after"
```
-/
namespace Ansi

public section pub

/-- An ANSI color. -/
inductive Color
  /-- Default color, mostly used to reset other colors. -/
  | protected default
  /-- Black. -/
  | black
  /-- Dark red. -/
  | darkRed
  /-- Dark green. -/
  | darkGreen
  /-- Dark yellow. -/
  | darkYellow
  /-- Dark blue. -/
  | darkBlue
  /-- Dark magenta. -/
  | darkMagenta
  /-- Dark cyan. -/
  | darkCyan
  /-- Dark gray. -/
  | darkGray
  /-- Red. -/
  | red
  /-- Green. -/
  | green
  /-- Yellow. -/
  | yellow
  /-- Blue. -/
  | blue
  /-- Magenta. -/
  | magenta
  /-- Cyan. -/
  | cyan
  /-- Gray. -/
  | gray
  /-- White. -/
  | white
  /-- Explicit ANSI color code. -/
  | ansi (code : UInt8)
  /-- Custom red/green/blue value. -/
  | rgb (r g b : UInt8)
deriving Inhabited, DecidableEq, Hashable, Ord, Repr

export Color (
  black darkRed darkGreen darkYellow darkBlue darkMagenta darkCyan darkGray
  red green yellow blue magenta cyan gray white
)

/-- ANSI style/attribute. -/
inductive Style
  /-- Normal style. -/
  | normal
  /-- Bold. -/
  | bold
  /-- Dim/faint. -/
  | dim
  /-- Italic. -/
  | italic
  /-- Underline. -/
  | underline
  /-- Slow blink. -/
  | blinkSlow
  /-- Fast blink, not widely supported, prefer `blinkSlow`. -/
  | blinkFast
  /-- Reverses the foreground and background color. -/
  | reverse
  /-- Concealed/hidden. -/
  | conceal
  /-- Strikethrough/crossed. -/
  | strike
deriving Inhabited, DecidableEq, Hashable, Ord, Repr

export Style (bold dim normal italic underline blinkSlow blinkFast reverse conceal strike)

end pub

/-- Start of an ANSI escape sequence. -/
def escSeq := "\x1b["
/-- Adds `escSeq` at the start of something. -/
def escape [ToString α] : α → String := (s!"{escSeq}{·}m")

namespace Color

/-- Ansi code (sequence) for a foreground/background color. -/
@[inline]
def toCode (c : Color) (background : Bool) : String :=
  if _h_default : c = .default then if background then "49" else "39" else
    let ground : UInt8 := if background then 48 else 38
    match c with
    | black => s!"{ground};5;0"
    | darkRed => s!"{ground};5;1"
    | darkGreen => s!"{ground};5;2"
    | darkYellow => s!"{ground};5;3"
    | darkBlue => s!"{ground};5;4"
    | darkMagenta => s!"{ground};5;5"
    | darkCyan => s!"{ground};5;6"
    | gray => s!"{ground};5;7"
    | darkGray => s!"{ground};5;8"
    | red => s!"{ground};5;9"
    | green => s!"{ground};5;10"
    | yellow => s!"{ground};5;11"
    | blue => s!"{ground};5;12"
    | magenta => s!"{ground};5;13"
    | cyan => s!"{ground};5;14"
    | white => s!"{ground};5;15"
    | ansi c => s!"{ground};5;{c}"
    | rgb r g b => s!"{ground};2;{r};{g};{b}"

/-- ANSI escape sequence for a foreground/background color. -/
@[inline]
public def toSeq (c : Color) (background : Bool) := c.toCode background |> escape

/-- Paints a string. -/
@[inline]
public def paint (c : Color) (s : String.Slice) (background : Bool := false) : String :=
  s!"{c.toSeq background}{s}{Color.default.toSeq background}"

/-- Paints the foreground of a string. -/
@[inline]
public def paintFront (c : Color) (s : String.Slice) : String :=
  c.paint s (background := false)

/-- Paints the background of a string. -/
@[inline]
public def paintBack (c : Color) (s : String.Slice) : String :=
  c.paint s (background := true)

public instance : CoeFun Color (fun _ => String.Slice → String) where
  coe color str := color.paintFront str

end Color

namespace Style variable (s : Style)

/-- ANSI code of a style. -/
@[inline]
def toCode : UInt8 :=
  match s with
  | bold => 1
  | dim => 2
  | normal => 22
  | italic => 3
  | underline => 4
  | blinkSlow => 5
  | blinkFast => 6
  | reverse => 7
  | conceal => 8
  | strike => 9

/-- ANSI code that turns **off** a specific style. -/
def offCode : UInt8 :=
  match s with
  | bold | dim | normal => normal.toCode
  | italic => 23
  | underline => 24
  | blinkSlow | blinkFast => 25
  | reverse => 27
  | conceal => 28
  | strike => 29

/-- ANSI escape sequence for some style. -/
def toSeq := s.toCode |> escape

/-- ANSI escape sequence that turns **off** a specific style. -/
def offSeq := s.offCode |> escape

/-- Applies a style to a string. -/
public def paint (s : Style) (str : String.Slice) : String :=
  let turnOff := s.offSeq
  s!"{s.toSeq}{str}{turnOff}"

public instance : CoeFun Style (fun _ => String.Slice → String) where
  coe style str := style.paint str

end Style

/-- Applies a foreground/background color to a string. -/
public def colorize (s : String.Slice) (color : Color) (background : Bool := false) : String :=
  color.paint s (background := ¬ background)

/-- Applies a style to a string. -/
public def stylize (s : String.Slice) (style : Style) : String :=
  style.paint s

/-- Paints a string with foreground/background colors and a style, all optional. -/
public def paint (s: String.Slice)
: (color : Option Color := none)
→ (background : Option Color := none)
→ (style : Option Style := none)
→ String
  | none, none, none => s.toString
  | color?, background?, style? => Id.run do
    let mut s := s.toString
    if let some color := color? then s := color.paintFront s
    if let some color := background? then s := color.paintBack s
    if let some style := style? then s := style s
    s

end Ansi
