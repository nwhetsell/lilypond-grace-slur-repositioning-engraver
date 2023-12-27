\version "2.25.0"

\include "grace-slur-repositioning-engraver.ily"

\layout {
  \context {
    \Voice
    \consists #Grace_slur_repositioning_engraver
  }
}

\relative {
  \acciaccatura g'''8 f
}
