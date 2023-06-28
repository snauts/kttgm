PAL := nil

all:
	make build
	fceux kttgm.nes

build:
	convert -compress none kttgm.png kttgm.ppm
	sbcl --eval "(defparameter *pal* $(PAL))" --load kttgm.lisp
	ca65 kttgm.s -g -o kttgm.o
	ld65 -o kttgm.nes -C kttgm.cfg kttgm.o

clean:
	rm -f kttgm.o kttgm.nes kttgm.ppm kttgm.chr kttgm.fasl \
		kttgm.fdb notes.h
