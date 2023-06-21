.segment "HEADER"

.byte 'N', 'E', 'S', $1A
.byte $02, $01, $01, $00
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00

.segment "VECTORS"
.word nmi
.word rst
.word irq

.segment "TILES"
.incbin "kttgm.chr"

.segment "ZEROPAGE"
scroll_x:	.res 1
scroll_y:	.res 1

.segment "BSS"

.segment "OAM"

.segment "RODATA"
palette:
.byte $0F, $12, $22, $27	; blue/orage rayleigh
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F

.byte $0F, $06, $16, $30
.byte $0F, $28, $37, $10
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F

rooster:
.byte $30, $D4, $05, $48
.byte $40, $F3, $05, $40
.byte $40, $F4, $05, $48
.byte $38, $E4, $05, $48

.byte $38, $E3, $05, $40
.byte $40, $F1, $04, $40
.byte $40, $F2, $04, $48
.byte $38, $E2, $04, $48

.byte $38, $E1, $04, $40
.byte $38, $E0, $04, $38
.byte $30, $D0, $04, $38
.byte $30, $D1, $04, $40

.byte $30, $D2, $04, $48

.segment "CODE"

PPUCTRL		= $2000
PPUMASK		= $2001
PPUSTATUS	= $2002
OAMADDR		= $2003
OAMDATA		= $2004
PPUSCROLL	= $2005
PPUADDR		= $2006
PPUDATA		= $2007
DMC_FREQ	= $4010
OAMDMA		= $4014
JOY2		= $4017

nmi:
	pha
	txa
	pha
	tya
	pha

	lda	#%00000000
	sta	PPUMASK

	lda	scroll_x
	sta	PPUSCROLL
	lda	scroll_y
	sta	PPUSCROLL
	inc	scroll_x

	lda	#%00011110
	sta	PPUMASK

	pla
	tay
	pla
	tax
	pla
	rti

irq:
	rti

rst:
	sei
	cld
	ldx	#$40
	stx	JOY2
	ldx	#$ff
	txs
	inx
	stx	PPUCTRL
	stx	PPUMASK
	stx	DMC_FREQ

	;; Wait for PPU to stabilize
	jsr	wait_vblank
	jsr	wait_vblank

	lda	#$00
	sta	scroll_x
	sta	scroll_y

	lda	#$20
	jsr	fill_rayleigh
	lda	#$24
	jsr	fill_rayleigh
	jsr	setup_pallete
	jsr	show_cock

	jsr	wait_vblank
	lda	#%10000000
	sta	PPUCTRL

loop:
	jmp	loop

fill_rayleigh:
	sta	PPUADDR
	ldx	#$0
	stx	PPUADDR

	;; nametable
	ldy	#0
:
	ldx	#0
:
	sty	PPUDATA
	inx
	cpx	#32
	bcc	:-

	iny
	cpy	#30
	bcc	:--

	;; attributes
	ldx	#0
	ldy	#0
:
	sty	PPUDATA
	inx
	cpx	#64
	bcc	:-
	rts

setup_pallete:
	lda	#$3F
	sta	PPUADDR
	lda	#$00
	sta	PPUADDR

	ldx	#0
:
	lda	palette, x
	sta	PPUDATA
	inx
	cpx	#32
	bcc	:-
	rts

show_cock:
	lda	#$00
	sta	OAMADDR

	ldx	#0
:
	lda	rooster, x
	sta	OAMDATA
	inx
	cpx	#68
	bcc	:-
	rts

wait_vblank:
	bit	PPUSTATUS
	bpl	wait_vblank
	rts
