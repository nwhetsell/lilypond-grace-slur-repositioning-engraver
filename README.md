# lilypond-grace-slur-repositioning-engraver

You can use the file [grace-slur-repositioning-engraver.ily](grace-slur-repositioning-engraver.ily) in this repository with LilyPond v2.25.0 or later to reposition slurs attached to above-staff grace notes so that they do not collide with ledger lines. For example, running:

```sh
lilypond --output=grace-slur-repositioning --svg - <<EOS
\version "2.24.0"
\include "grace-slur-repositioning-engraver.ily"
\paper {
  page-breaking = #ly:one-line-auto-height-breaking
  top-margin = 0
  left-margin = 0
  right-margin = 0
  oddFooterMarkup= ##f
}
\layout {
  \context { \Voice \consists #Grace_slur_repositioning_engraver }
}
\pointAndClickOff
\relative {
  \acciaccatura g'''8 f4
}
EOS
```

will output:

<img src="grace-slur-repositioning.svg">
