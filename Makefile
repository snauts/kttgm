all:
	convert -compress none kttgm.png kttgm.ppm
	sbcl --load kttgm.lisp
	ca65 kttgm.s -g -o kttgm.o
	ld65 -o kttgm.nes -C kttgm.cfg kttgm.o
	fceux kttgm.nes

clean:
	rm -f kttgm.o kttgm.nes kttgm.ppm kttgm.chr
