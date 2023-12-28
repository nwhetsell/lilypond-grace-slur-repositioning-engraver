# lilypond-grace-slur-repositioning-engraver

You can use the file [grace-slur-repositioning-engraver.ily](grace-slur-repositioning-engraver.ily) in this repository with LilyPond v2.25.0 or later to reposition slurs attached to above-staff grace notes so they don’t collide with ledger lines, as recommended by [Elaine Gould, _Behind Bars_ (London: Faber Music, 2011)](https://www.fabermusic.com/shop/behind-bars-the-definitive-guide-to-music-notation-p6284), p 129. For example, running:

```sh
lilypond --output=grace-slur-repositioning --svg - <<EOS
\version "2.25.0"
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
