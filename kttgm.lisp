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

(defparameter *music1*
  '((#x5 #x8 #x6 #x5 #x5 #x8 #x6 #x5 #x8 #x4 #x4 #x4 #xF)
    (#x4 #x6 #x5 #x4 #x4 #x6 #x5 #x4 #x5 #x3 #x3 #x3 #xF)
    (#x6 #x9 #xB #xA #x9 #x9 #x8 #x8)
    (#x9 #x8 #x6 #x5 #x4 #x5 #x4 #x3)))

(defparameter *music2*
  '((#x2 #x4 #x3 #x2 #x2 #x4 #x3 #x2 #x4 #x1 #x1 #x1 #xF)
    (#x1 #x3 #x2 #x1 #x1 #x3 #x2 #x1 #x2 #x0 #x0 #x0 #xF)
    (#x3 #x5 #x8 #x7 #x5 #x5 #x4 #x4)
    (#x5 #x4 #x3 #x2 #x1 #x2 #x1 #x0)))

(defparameter *rest-value* #b10000000)

(defun preprocess (note)
  (if (= #xF note) *rest-value* (* 2 note)))

(defun save-music (out label notes)
  (format out "~A:~%" label)
  (dolist (parts notes)
    (format out ".byte ")
    (print-asm-hex out "2" (mapcar #'preprocess parts))
    (format out "~%")))

(defun save-rest-bit-variable (out)
  (format out "rest_bit:~%")
  (format out ".byte $~X~%" *rest-value*))

(defparameter *notes*
'(;; C     D     E     F     G     A     Bb    B
; (16.35 18.35 20.60 21.83 24.50 27.50 29.14 30.87) ; 0
; (32.70 36.71 41.20 43.65 49.00 55.00 58.27 61.74) ; 1
  (65.41 73.42 82.41 87.31 98.00 110.0 116.5 123.5) ; 2
  (130.8 146.8 164.8 174.6 196.0 220.0 233.1 246.9) ; 3
  (261.6 293.7 329.6 349.2 392.0 440.0 466.2 493.9) ; 4
  (523.3 587.3 659.3 698.5 784.0 880.0 932.3 987.8) ; 5
  (1047. 1175. 1319. 1397. 1568. 1760. 1865. 1976.) ; 6
; (2093. 2349. 2637. 2794. 3136. 3520. 3729. 3951.) ; 7
; (4186. 4699. 5274. 5588. 6272. 7040. 7459. 7902.) ; 8
  ))

(defun get-cpu-freq ()
  (/ (if (= *pal* 1) 1662607.0 1789773.0) 16))

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
    (save-rest-bit-variable out)
    (save-music out "music1" *music1*)
    (save-music out "music2" *music2*)
    (save-note-values out)
    (save-frequencies out)))

(defun read-crowing ()
  (let ((samples nil))
    (with-open-file (in "rooster.raw" :element-type '(signed-byte 16))
      (loop for value = (read-byte in nil :eof) until (eq value :eof) do
	(push value samples)))
    (reverse samples)))

(defparameter *step* 512)

(defun stuff-audio (out sample)
  (let ((snd 0) (val 0) (bit 0))
    (dolist (x sample)
      (setf val (ash val -1))
      (cond ((< snd x)
	     (incf snd *step*)
	     (setf val (logior val #x80)))
	    (t (decf snd *step*)))
      (incf bit)
      (when (= bit 8)
	(format out "~A," val)
	(setf val 0 bit 0)))))

(defun save-crowing ()
  (with-open-file (out "crowing.h" :if-exists :supersede :direction :output)
    (format out ".byte ")
    (stuff-audio out (read-crowing))
    (format out "0~%")))

(save-crowing)
(save-sprites)
(save-notes)
(quit)
