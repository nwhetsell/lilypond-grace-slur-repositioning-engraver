\version "2.25.0"

#(define (Grace_slur_repositioning_engraver context)
  (let (
      (would-end-grace-slur #f)
      (grace-note-heads '())
      (slur '())
      (first-grace-stem '()))

    (make-engraver
      (acknowledgers
        ((note-head-interface engraver grob source-engraver)
          (if (eqv? (ly:moment-grace (ly:context-current-moment context)) 0)
            (set! would-end-grace-slur #t)
          ; else
            (set! grace-note-heads (cons grob grace-note-heads))))
        ((slur-interface engraver grob source-engraver)
          (when (and (not (eqv? (ly:moment-grace (ly:context-current-moment context)) 0))
                     (eq? (ly:grob-property grob 'spanner-id) 'grace))
            (set! slur grob)))
        ((stem-interface engraver grob source-engraver)
          (when (and (not (eqv? (ly:moment-grace (ly:context-current-moment context)) 0))
                     (null? first-grace-stem))
            (set! first-grace-stem grob))))

      ((stop-translation-timestep engraver)
        (when would-end-grace-slur
          (unless (null? slur)
            (let* (
                (grace-note-head (car grace-note-heads))
                (grace-note-head-Y-extent (ly:grob-extent grace-note-head (ly:grob-parent grace-note-head Y) Y))
                (staff-symbol (ly:grob-object grace-note-head 'staff-symbol))
                (top-line-position (/ (car (ly:grob-property staff-symbol 'line-positions)) 2))
                (distance-to-top-line (- (car grace-note-head-Y-extent)
                                         top-line-position)))

              ; When the bottom of the grace note is more than 2 staff spaces
              ; above the staff, there are probably ledger lines that will be
              ; concealed by a slur underneath.
              (when (> distance-to-top-line 2)
                ; Put the slur above the grace notes.
                (ly:grob-set-property! slur 'direction UP)
                ; Discourage having the slur intersect the grace note’s stem.
                (ly:grob-set-nested-property! slur '(details stem-encompass-penalty) (ly:assoc-get 'head-encompass-penalty (ly:grob-property slur 'details)))
                ; When there is just 1 grace note, position the slur so that its
                ; endpoints are just above the grace note’s stem and the
                ; following note.
                (when (eqv? (length grace-note-heads) 1)
                  (let* (
                      (first-grace-stem-Y-extent (ly:grob-property first-grace-stem 'Y-extent))
                      (free-head-distance (ly:assoc-get 'free-head-distance (ly:grob-property slur 'details)))
                      (slur-left-position (+ (cdr first-grace-stem-Y-extent) free-head-distance)))
                    (ly:grob-set-property! slur 'positions `(,slur-left-position . 0))))))

            (set! slur '()))

          (set! would-end-grace-slur #f)
          (set! grace-note-heads '())
          (set! first-grace-stem '()))))))
