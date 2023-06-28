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

(defparameter *notes*
'(;; C     C#    D     Eb    E     F     F#    G     G#    A     Bb    B
; (16.35 17.32 18.35 19.45 20.60 21.83 23.12 24.50 25.96 27.50 29.14 30.87) ; 0
; (32.70 34.65 36.71 38.89 41.20 43.65 46.25 49.00 51.91 55.00 58.27 61.74) ; 1
  (65.41 69.30 73.42 77.78 82.41 87.31 92.50 98.00 103.8 110.0 116.5 123.5) ; 2
  (130.8 138.6 146.8 155.6 164.8 174.6 185.0 196.0 207.7 220.0 233.1 246.9) ; 3
  (261.6 277.2 293.7 311.1 329.6 349.2 370.0 392.0 415.3 440.0 466.2 493.9) ; 4
  (523.3 554.4 587.3 622.3 659.3 698.5 740.0 784.0 830.6 880.0 932.3 987.8) ; 5
  (1047. 1109. 1175. 1245. 1319. 1397. 1480. 1568. 1661. 1760. 1865. 1976.) ; 6
  (2093. 2217. 2349. 2489. 2637. 2794. 2960. 3136. 3322. 3520. 3729. 3951.) ; 7
  (4186. 4435. 4699. 4978. 5274. 5588. 5920. 6272. 6645. 7040. 7459. 7902.) ; 8
  ))

(defun get-cpu-freq ()
  (/ (if *pal* 1662607.0 1789773.0) 16))

(defun convert-note (note)
  (round (- (/ (get-cpu-freq) note) 1)))

(defun save-notes ()
  (with-open-file (out "notes.h" :if-exists :supersede :direction :output)
    (dolist (octave *notes*)
      (format out ".word ")
      (format out "~{$~4,'0X~^,~}" (mapcar #'convert-note octave))
      (format out "~%"))))

(save-sprites)
(save-notes)
(quit)
