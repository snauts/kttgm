(defun read-color (in)
  (list (read in) (read in) (read in)))

(defun read-ppm ()
  (with-open-file (in "kttgm.ppm" :direction :input)
    (read-line in) ; consume P3
    (read-line in) ; consume coment
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
  (reduce #'+ color))

(defun clean-up-colors (palette)
  (sort (remove-duplicates palette :test #'equal) #'< :key #'color-intensity))

(defun lookup-color (color palette)
  (position color palette :test #'equal))

(defun color-to-index (sprite palette)
  (when (> (length palette) 4)
    (format t "ERROR: SPRITE(~A) has to many colors~%" (length palette))
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
    (serialize-sprite (color-to-index sprite (clean-up-colors palette)))))

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

(save-sprites)
(quit)
