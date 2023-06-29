(defun read-color (in)
  (list (read in) (read in) (read in)))

(defun read-ppm ()
  (with-open-file (in "kttgm.ppm" :direction :input)
    (read-line in) ; consume P3
    (let* ((width (read in))
	   (height (read in))
	   (picture (make-array (list width height))))
      (read-line in) ; consume 255
      (dotimes (y height)
	(dotimes (x width)
	  (setf (aref picture x y) (read-color in))))
      picture)))

(defun make-sprite ()
  (make-array (list 8 8)))

(defun color-intensity (color)
  (reduce #'max color))

(defun get-color-index (color)
  (floor (color-intensity color) 64))

(defun index-to-color (index)
  (list (* 64 index) (* 64 index) (* 64 index)))

(defun clean-up-colors (palette)
  (let ((clean (remove-duplicates palette :test #'equal)))
    (loop for i from 0 to 3 while (< (length clean) 4) do
      (unless (member i (mapcar #'get-color-index clean))
	(push (index-to-color i) clean)))
    (sort clean #'< :key #'color-intensity)))

(defun lookup-color (color palette)
  (position color palette :test #'equal))

(defun color-to-index (sprite n palette)
  (when (> (length palette) 4)
    (format t "ERROR: SPRITE(~A) has to many colors~%" n)
    (quit :unix-status 1))
  (dotimes (j 8)
    (dotimes (i 8)
      (setf (aref sprite i j) (lookup-color (aref sprite i j) palette))))
  sprite)

(defun serialize-sprite (sprite)
  (let ((plane0 nil)
	(plane1 nil))
  (dotimes (j 8)
    (let ((b0 0) (b1 0))
      (dotimes (i 8)
	(let ((val (aref sprite i j)))
	  (setf b0 (ash b0 1))
	  (setf b1 (ash b1 1))
	  (when (/= 0 (logand val 1))
	    (setf b0 (logior b0 1)))
	  (when (/= 0 (logand val 2))
	    (setf b1 (logior b1 1)))))
      (push b0 plane0)
      (push b1 plane1)))
    (append (reverse plane0) (reverse plane1))))

(defun select-sprite (picture n)
  (let ((sprite (make-sprite))
	(palette nil))
    (dotimes (j 8)
      (dotimes (i 8)
	(let* ((x (+ i (* 8 (mod n 16))))
	       (y (+ j (* 8 (floor n 16))))
	       (color (aref picture x y)))
	  (setf (aref sprite i j) color)
	  (push color palette))))
    (serialize-sprite (color-to-index sprite n (clean-up-colors palette)))))

(defun sprite-count (picture)
  (destructuring-bind (w h) (array-dimensions picture)
    (floor (* w h) 64)))

(defun save-bytes (out bytes)
  (dolist (c bytes)
    (write-byte c out)))

(defun save-picture (out picture)
  (dotimes (i (sprite-count picture))
    (save-bytes out (select-sprite picture i))))

(defun save-sprites ()
  (with-open-file (out "kttgm.chr" :element-type 'unsigned-byte
				   :if-exists :supersede
				   :direction :output)
    (save-picture out (read-ppm))))

(defparameter *tempo* 12)

(defparameter *note-values*
  '((1 1 1 1 1 1 1 1 2 1 1 3 1)
    (1 1 1 1 1 1 1 1 2 1 1 3 1)
    (2 2 2 1 1 2 2 4)
    (2 2 2 1 1 2 2 4)
    (0)))

(defun value-to-ticks (value)
  (* value *tempo*))

(defun print-asm-hex (out pad values)
  (format out (concatenate 'string "~{$~" pad ",'0X~^,~}") values))

(defun save-note-values (out)
  (format out "note_length:~%")
  (dolist (parts *note-values*)
    (format out ".byte ")
    (print-asm-hex out "2" (mapcar #'value-to-ticks parts))
    (format out "~%")))

(defparameter *notes*
'(;; C     D     E     F     G     A     Bb    B
; (16.35 18.35 20.60 21.83 24.50 27.50 29.14 30.87) ; 0
; (32.70 36.71 41.20 43.65 49.00 55.00 58.27 61.74) ; 1
  (65.41 73.42 82.41 87.31 98.00 110.0 116.5 123.5) ; 2
  (130.8 146.8 164.8 174.6 196.0 220.0 233.1 246.9) ; 3
  (261.6 293.7 329.6 349.2 392.0 440.0 466.2 493.9) ; 4
  (523.3 587.3 659.3 698.5 784.0 880.0 932.3 987.8) ; 5
  (1047. 1175. 1319. 1397. 1568. 1760. 1865. 1976.) ; 6
  (2093. 2349. 2637. 2794. 3136. 3520. 3729. 3951.) ; 7
  (4186. 4699. 5274. 5588. 6272. 7040. 7459. 7902.) ; 8
  ))

(defun get-cpu-freq ()
  (/ (if *pal* 1662607.0 1789773.0) 16))

(defun convert-note (note)
  (round (- (/ (get-cpu-freq) note) 1)))

(defun save-frequencies (out)
  (format out "music_notes:~%")
  (dolist (octave *notes*)
    (format out ".word ")
    (print-asm-hex out "4" (mapcar #'convert-note octave))
    (format out "~%")))

(defun save-notes ()
  (with-open-file (out "notes.h" :if-exists :supersede :direction :output)
    (save-note-values out)
    (save-frequencies out)))

(save-sprites)
(save-notes)
(quit)
