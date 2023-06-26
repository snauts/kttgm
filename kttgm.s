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
ppu_data:	.res 32
attributes:	.res 12
counter:	.res 1
scroll_x:	.res 1
scroll_c:	.res 1
button_down:	.res 1
button_diff:	.res 1
velocity:	.res 1
in_the_air:	.res 1
progress:	.res 1
column_pos:	.res 1

var_start:
rooster_x:	.res 1
rooster_y:	.res 1
rooster_frame:	.res 1
ppu_ctrl:	.res 1
seed:		.res 1
ppu_size:	.res 1
column_tile:	.res 1
column_height:	.res 1
platform:	.res 1
var_end:

.segment "BSS"

.segment "OAM"
oam_buffer:	.res 256

.segment "RODATA"
var_data:
.byte $40, $7C, $C0, $80
.byte $42, $1E, $20, $12
.byte $7C

palette:
.byte $0F, $03, $13, $23
.byte $0F, $06, $16, $26
.byte $0F, $08, $18, $28
.byte $0F, $09, $19, $29

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
sprites_end:

title_data:
.byte $05, $23, $DB, $05, $A5, $A5
.byte $06, $23, $D2, $A0, $A0, $A0, $50
.byte $10, $21, $69, $26, $27, $28, $00, $29, $27
.byte      $00, $29, $2A, $2B, $2C, $57, $58, $59
.byte $0B, $21, $8E, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3B
.byte $0B, $21, $AE, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4B
.byte $07, $21, $D2, $2D, $2E, $2F, $27, $36
.byte $00
title_end:

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

	jsr	update_ppu

	ldx	#%00000000
	stx	PPUMASK

	stx	OAMADDR
	lda	#>oam_buffer
	sta	OAMDMA

	lda	scroll_x
	sta	PPUSCROLL
	stx	PPUSCROLL

	lda	scroll_c
	and	#%00000001
	ora	ppu_ctrl
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
	;; Setup stack and stuff
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
	jsr	clear_memory
	jsr	wait_vblank

	jsr	init_variables
	jsr	setup_pallete

	jsr	wait_vblank
	lda	ppu_ctrl
	sta	PPUCTRL

loop:
	lda	counter
spin:	cmp	counter
	beq 	spin

	jsr	check_button

	lda	progress
	cmp	#00
	beq	title_screen
	cmp	#01
	beq	rooster_game

	jmp	loop

title_screen:
	jsr	draw_title_screen

	;; check start button
	lda	button_down
	and	button_diff
	and	#%00001000
	beq	loop

	;; start game
	lda	#$20
	sta	column_pos
	lda	#%10000100
	sta	ppu_ctrl
	jsr	copy_sprites_to_oam
	jsr	move_rooster_sprites
	inc	progress

	jmp	loop

rooster_game:
	;; update every 1 frame
	jsr	control_rooster
	jsr	fill_next_column
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
	cpx	#(sprites_end - sprites)
	bne	:-
	rts

move_rooster_position:
	lda	in_the_air
	cmp	#$00
	beq	:+

	lda	velocity
	inc	velocity
	lsr
	lsr
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
	lda	platform
	sta	rooster_y
:
	rts

check_button:
	lda	#$01
	sta	JOY1
	lda	#$00
	sta	JOY1

	ldx	#8
:
	pha
	lda	JOY1
	and	#%00000001
	cmp	#%00000001
	pla
	ror
	dex
	bne	:-

	tax
	eor	button_down
	sta	button_diff
	stx	button_down
	rts

control_rooster:
	lda	button_down
	and	button_diff
	and	#%00000001
	beq	:+
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
	rts

fill_ground_cell:
	sta	ppu_data + 2, x
	adc	#16
	inx
	rts

fill_column:
	jsr	select_nametable
	ora	#$20
	sta	ppu_data + 0

	lda	column_pos
	and	#$1F
	sta	ppu_data + 1

	ldx	#0
fill_sky:
	txa
	sta	ppu_data + 2, x
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

select_attributes:
	jsr	select_nametable
	ora	#$23
	tax

	lda	column_pos
	and	#$1C
	lsr
	lsr
	ora	#$C0
	rts

get_attribute:
	cpy	column_height
	bne	:+
	ora	#(1 << 6)
:
	bmi	:+
	ora	#(2 << 6)
:
	iny
	iny
	rts

shift_attribute:
	pha
	lda	column_pos
	and	#$02
	cmp	#$00
	bne	:+
	pla
	lsr
	lsr
	rts
:
	pla
	rts

setup_attributes:
	jsr	select_attributes
	stx	attributes + 0
	sta	attributes + 1

	inc	column_pos
	jsr	select_attributes
	stx	attributes + 2
	sta	attributes + 3
	dec	column_pos

	ldx	#0
	ldy	#0
attribute_loop:
	lda	#$CC
	jsr	shift_attribute
	eor	#$FF
	and	attributes + 4, x
	sta	attributes + 4, x

	lda	#$00
	jsr	get_attribute
	lsr
	lsr
	lsr
	lsr
	jsr	get_attribute
	jsr	shift_attribute
	ora	attributes + 4, x
	sta	attributes + 4, x
	inx
	cpx	#8
	bne	attribute_loop
	rts

update_column:
	jsr	setup_attributes
	jsr	fill_column
	inc	column_tile
	rts

update_ppu:
	;; update column of nametable
	lda	ppu_data + 0
	beq	bad_ppu_data
	sta	PPUADDR
	lda	ppu_data + 1
	sta	PPUADDR
	ldx	#0
:
	lda	ppu_data + 2, X
	sta	PPUDATA
	inx
	cpx	ppu_size
	bne	:-

	;; update column of attributes
	clc
	ldx	#0
	lda	attributes + 1
:
	ldy	attributes + 0
	beq	bad_ppu_data
	sty	PPUADDR
	sta	PPUADDR
	adc	#8
	ldy	attributes + 4, X
	sty	PPUDATA
	inx
	cpx	#8
	bne	:-

	;; read next attributes
	clc
	ldx	#0
	lda	attributes + 3
:
	ldy	attributes + 2
	beq	bad_ppu_data
	sty	PPUADDR
	sta	PPUADDR
	adc	#8
	ldy	PPUDATA
	ldy	attributes + 4, X
	inx
	cpx	#8
	bne	:-

bad_ppu_data:
	rts

get_random_number:
	lda	seed
	beq	do_eor
	asl
	beq	no_eor
	bcc	no_eor
do_eor:
	eor	#$1D
no_eor:
	sta	seed
	rts

fill_next_column:
	lda	#30
	sta	ppu_size
	lda	scroll_x
	and	#7
	cmp	#0
	bne	skip_column_update
	lda	column_tile
	cmp	#$24
	beq	generate_new_block
	cmp	#$26
	bne	continue_old_block
generate_new_block:
	jsr	get_random_number
	clc
	and	#$07
	asl
	adc	#$08
	sta	column_height
	jsr	get_random_number
	and	#$04
	ora	#$20
	sta	column_tile
continue_old_block:
	jsr	update_column
skip_column_update:
	rts

draw_title_screen:
	lda	#$00
	sta	scroll_x
	sta	scroll_c

	lda	#%10000000
	sta	ppu_ctrl

	ldx	column_pos
:
	lda	title_data, X
	bne	:+
	ldx	#$00
	jmp	:-
:
	sta	ppu_size
	ldy	#$00
	inx
:
	lda	title_data, X
	sta	ppu_data, Y
	inx
	iny
	cpy	ppu_size
	bne	:-

	dec	ppu_size
	dec	ppu_size

	stx	column_pos
	rts
