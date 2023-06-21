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
counter:	.res 1
nmi_taken:	.res 1
scroll_x:	.res 1
scroll_y:	.res 1
rooster_frame:	.res 1

.segment "BSS"

.segment "OAM"

.segment "RODATA"
palette:
.byte $0F, $03, $13, $23
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F

.byte $0F, $06, $16, $30
.byte $0F, $28, $37, $10
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F

ROOSTER_X = $40
ROOSTER_Y = $80

sprites:
.byte ROOSTER_Y + $10, $C0, $05, ROOSTER_X + $08
.byte ROOSTER_Y + $10, $C1, $05, ROOSTER_X + $10
.byte ROOSTER_Y + $00, $D4, $05, ROOSTER_X + $10
.byte ROOSTER_Y + $08, $E4, $05, ROOSTER_X + $10
.byte ROOSTER_Y + $08, $E3, $05, ROOSTER_X + $08
.byte ROOSTER_Y + $10, $F1, $04, ROOSTER_X + $08
.byte ROOSTER_Y + $10, $F2, $04, ROOSTER_X + $10
.byte ROOSTER_Y + $08, $E2, $04, ROOSTER_X + $10
.byte ROOSTER_Y + $08, $E1, $04, ROOSTER_X + $08
.byte ROOSTER_Y + $08, $E0, $04, ROOSTER_X + $00
.byte ROOSTER_Y + $00, $D0, $04, ROOSTER_X + $00
.byte ROOSTER_Y + $00, $D1, $04, ROOSTER_X + $08
.byte ROOSTER_Y + $00, $D2, $04, ROOSTER_X + $10
sprites_end:

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

	inc	counter
	inc	nmi_taken

	lda	#%00000000
	sta	PPUMASK

	ldx	rooster_frame

	lda	#$01
	sta	OAMADDR
	stx	OAMDATA
	inx
	lda	#$05
	sta	OAMADDR
	stx	OAMDATA

	lda	scroll_x
	sta	PPUSCROLL
	lda	scroll_y
	sta	PPUSCROLL

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
	sta	counter
	sta	nmi_taken
	sta	scroll_x
	sta	scroll_y

	lda	#$C0
	sta	rooster_frame

	lda	#$20
	jsr	fill_rayleigh
	lda	#$24
	jsr	fill_rayleigh
	jsr	setup_pallete
	jsr	init_sprites

	jsr	wait_vblank
	lda	#%10000000
	sta	PPUCTRL

loop:
	lda	#$00
	cmp	nmi_taken
	beq	loop

	sta	nmi_taken

	;; update every 1 frame
	inc	scroll_x

	lda	counter
	and	#$03
	cmp	#$00
	bne	loop

	;; update every 4 frames
	lda	rooster_frame
	adc	#$01
	and	#$0F
	ora	#$C0
	sta	rooster_frame

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

init_sprites:
	lda	#$00
	sta	OAMADDR

	ldx	#0
:
	lda	sprites, x
	sta	OAMDATA
	inx
	cpx	sprites_end - sprites
	bcc	:-
	rts

wait_vblank:
	bit	PPUSTATUS
	bpl	wait_vblank
	rts
