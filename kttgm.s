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
scroll_x:	.res 1
scroll_c:	.res 1
button_down:	.res 1
velocity:	.res 1
in_the_air:	.res 1
column_pos:	.res 1
column_tile:	.res 1
column_height:	.res 1
ppu_addr:	.res 2

var_start:
rooster_x:	.res 1
rooster_y:	.res 1
rooster_frame:	.res 1
platform:	.res 1
var_end:

.segment "BSS"

.segment "OAM"
oam_buffer:	.res 256

.segment "RODATA"
var_data:
.byte $40, $7C, $C0, $7C

palette:
.byte $0F, $03, $13, $23
.byte $0F, $09, $19, $29
.byte $0F, $08, $18, $28
.byte $0F, $0F, $0F, $0F

.byte $0F, $06, $16, $30
.byte $0F, $27, $28, $10
.byte $0F, $0F, $0F, $0F
.byte $0F, $0F, $0F, $0F

sprites:
.byte $10, $C0, $05, $08
.byte $10, $C1, $05, $10
.byte $00, $D4, $05, $10
.byte $08, $E4, $05, $10
.byte $08, $E3, $05, $08
.byte $10, $F1, $04, $08
.byte $10, $F2, $04, $10
.byte $08, $E2, $04, $10
.byte $08, $E1, $04, $08
.byte $08, $E0, $04, $00
.byte $00, $D0, $04, $00
.byte $00, $D1, $04, $08
.byte $00, $D2, $04, $10
rooster_end:
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
JOY1		= $4016
JOY2		= $4017

OAM_Y		= $00
OAM_X		= $03

nmi:
	pha
	txa
	pha
	tya
	pha

	inc	counter

	ldx	#%00000000
	stx	PPUMASK

	jsr	update_ppu

	stx	OAMADDR
	lda	#>oam_buffer
	sta	OAMDMA

	lda	scroll_x
	sta	PPUSCROLL
	stx	PPUSCROLL

	lda	scroll_c
	and	#%00000001
	ora	#%10000100
	sta	PPUCTRL

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
	jmp	clear_memory
done_clear_mem: ; clear will spoil stack so use jmp instead of jsr
	jsr	wait_vblank

	jsr	init_variables
	jsr	setup_pallete

	lda	#%00000100
	sta	PPUCTRL

	jsr	fill_background
	jsr	copy_sprites_to_oam

	jsr	wait_vblank
	lda	#%10000100
	sta	PPUCTRL

loop:
	lda	counter
spin:	cmp	counter
	beq 	spin

	jsr	check_button

	;; update every 1 frame
	jsr	scroll_screen
	jsr	move_rooster_position

	lda	counter
	and	#$03
	cmp	#$00
	bne	finally

	;; update every 4 frames
	jsr	animate_rooster_sprites

finally:
	jsr	move_rooster_sprites

	jmp	loop

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

copy_sprites_to_oam:
	ldx	#0
:
	lda	sprites, x
	sta	oam_buffer, x
	inx
	cpx	#(sprites_end - sprites)
	bne	:-
	rts

animate_rooster_sprites:
	clc
	lda	rooster_frame
	adc	#$02
	and	#$0F
	ora	#$C0
	sta	rooster_frame
	tax

	lda	in_the_air
	cmp	#0
	beq	:+
	ldx	#$B0
:
	stx	oam_buffer + 1
	inx
	stx	oam_buffer + 5

	sec
	lda	#$D4
	sbc	in_the_air
	sta	oam_buffer + 9
	rts

wait_vblank:
	bit	PPUSTATUS
	bpl	wait_vblank
	rts

init_variables:
	ldx	#0
:
	lda	var_data, x
	sta	var_start, x
	inx
	cpx	#(var_end - var_start)
	bne	:-

	rts

move_rooster_sprites:
	ldx	#0
:
	clc
	lda	sprites + OAM_X, x
	adc	rooster_x
	sta	oam_buffer + OAM_X, x

	lda	sprites + OAM_Y, x
	adc	rooster_y
	sta	oam_buffer + OAM_Y, x

	inx
	inx
	inx
	inx
	cpx	#(rooster_end - sprites)
	bne	:-
	rts

move_rooster_position:
	lda	in_the_air
	cmp	#$00
	beq	:+

	lda	velocity
	inc	velocity
	lsr	a
	lsr	a
	clc
	adc	#252 		; this controls jumping height
	clc
	adc	rooster_y
	sta	rooster_y

	;; landing
	cmp	platform
	bmi	:+
	lda	#$00
	sta	in_the_air
:
	rts

check_button:
	lda	#$01
	sta	JOY1
	lda	#$00
	sta	JOY1

	lda	JOY1
	and	#%00000001
	ldx	button_down
	sta	button_down
	cpx	#$00
	bne	:+
	cmp	#$01
	bne	:+
	lda	in_the_air
	cmp	#$00
	bne	:+
	lda	#$00
	sta	velocity
	inc	in_the_air
:
	rts

scroll_screen:
	clc
	lda	#1
	adc	scroll_x
	sta	scroll_x
	lda	#0
	adc	scroll_c
	sta	scroll_c
	rts

clear_memory:
	lda	#0
	ldx	#0
:
	sta	$0000, X
	sta	$0100, X
	sta	$0200, X
	sta	$0300, X
	sta	$0400, X
	sta	$0500, X
	sta	$0600, X
	sta	$0700, X
	inx
	bne	:-

	lda	#255
	ldx	#0
:
	sta	oam_buffer, X
	inx
	inx
	inx
	inx
	bne	:-
	jmp	done_clear_mem

fill_ground_cell:
	sta	PPUDATA
	adc	#16
	inx
	rts

fill_column:
	jsr	select_nametable
	ora	#$20
	sta	PPUADDR
	lda	column_pos
	and	#$1F
	sta	PPUADDR

	ldx	#0
fill_sky:
	stx	PPUDATA
	inx
	cpx	column_height
	bne	fill_sky

fill_grass:
	clc
	lda	column_tile
	jsr	fill_ground_cell
	jsr	fill_ground_cell

fill_rocks:
	jsr	fill_ground_cell
	cmp	#$80
	bmi	:+
	sbc	#$40
:
	cpx	#30
	bne	fill_rocks

	inc	column_pos
	rts

select_nametable:
	lda	column_pos
	and	#$20
	lsr
	lsr
	lsr
	rts

setup_attributes:
	rts

fill_double:
	sta	column_tile
	jsr	setup_attributes
	jsr	fill_column
	inc	column_tile
	jsr	fill_column
	rts

fill_background:
	ldy	#0
:
	lda	#$12
	sta	column_height
	lda	#$20
	jsr	fill_double
	lda	#$22
	jsr	fill_double
	iny
	cpy	#16
	bne	:-
	rts

update_ppu:
	rts
