PAL=0

all:
	make build
	fceux kttgm.nes

build:
	convert -compress none kttgm.png kttgm.ppm
	sbcl --eval "(defparameter *pal* $(PAL))" --load kttgm.lisp
	ca65 -D PAL=$(PAL) kttgm.s -g -o kttgm.o
	ld65 -o kttgm.nes -C kttgm.cfg kttgm.o

pal:
	make PAL=1 build

clean:
	rm -f kttgm.o kttgm.nes kttgm.ppm kttgm.chr kttgm.fasl \
		kttgm.fdb notes.h
