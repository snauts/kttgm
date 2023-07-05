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

.if PAL=1
.out "Hey PAL!"
.endif

.segment "ZEROPAGE"
ppu_data:	.res 32
platforms:	.res 16
attributes:	.res 12
sky_tiles:	.res 30
counter:	.res 2
scroll_x:	.res 1
scroll_c:	.res 1
scroll_7:	.res 1
scroll_f:	.res 1
button_down:	.res 1
button_diff:	.res 1
button_last:	.res 1
velocity:	.res 1
progress:	.res 1
column_pos:	.res 1
column_tile:	.res 1
column_height:	.res 1
fade_start:	.res 1
sky_counter:	.res 1
star_counter:	.res 1
star_random:	.res 1
platform_idx:	.res 1
footing_prev:	.res 1
footing_next:	.res 1
footing_snap:	.res 1
music_delay:	.res 1
rooster_py:	.res 1
image_ptr:	.res 1
music_idx:	.res 1
gold_mode:	.res 1
crashed:	.res 1
delta_x:	.res 1
delta_y:	.res 1
flash:		.res 1
pause:		.res 1
lives:		.res 1

outro_extend:	.res 1
outro_scroll:	.res 1
outro_column:	.res 1
outro_delay:	.res 1
outro_jumps:	.res 1
outro_input:	.res 1
outro_note:	.res 1
lady_state:	.res 1

level_idx:	.res 1
level_block:	.res 1
level_loops:	.res 1
level_done:	.res 1
current_input:	.res 2

var_start:
rooster_x:	.res 1
rooster_y:	.res 1
rooster_frame:	.res 1
ppu_ctrl:	.res 1
ppu_size:	.res 1
in_the_air:	.res 1
gravity:	.res 1
sky_offset:	.res 1
music_cfg:	.res 8
var_end:

.segment "BSS"

.segment "OAM"
oam_buffer:	.res 256

.segment "RODATA"
var_data:
.byte $38, $00, $C0, $80
.byte $1E, $02, $01, $14
;; music_cfg
.byte $10, $01, $A0, $00
.byte $30, $03, $60, $00

palette:
.byte $0F, $03, $13, $23
.byte $0F, $0F, $0F, $0F
.byte $0F, $08, $18, $28
.byte $0F, $09, $19, $29

.byte $0F, $06, $16, $30
.byte $0F, $27, $28, $10
.byte $0F, $06, $16, $37
.byte $0F, $06, $16, $17

sprites:
.byte $10, $10, $05, $08
.byte $10, $11, $05, $10
.byte $00, $21, $05, $10
.byte $08, $19, $45, $00
.byte $00, $15, $45, $08
.byte $08, $31, $05, $10
.byte $08, $30, $05, $08
.byte $10, $33, $04, $08
.byte $10, $34, $04, $10
.byte $08, $24, $04, $10
.byte $08, $23, $04, $08
.byte $08, $22, $04, $00
.byte $00, $12, $04, $00
.byte $00, $13, $04, $08
.byte $00, $14, $04, $10
sprites_end:
.byte $08, $25, $05, $00
.byte $10, $35, $05, $00
.byte $10, $16, $05, $10
.byte $08, $19, $85, $10
.byte $00, $15, $45, $08
.byte $08, $29, $05, $08
.byte $10, $39, $05, $08
.byte $10, $37, $04, $08
.byte $10, $38, $04, $10
.byte $08, $28, $04, $10
.byte $08, $27, $04, $08
.byte $08, $26, $04, $00
.byte $10, $36, $04, $00
.byte $00, $17, $04, $08
.byte $00, $18, $04, $10

lady_sprites:
.byte $57, $41, $05, $9F
.byte $57, $40, $04, $9F
.byte $5F, $50, $04, $9F
.byte $5F, $51, $04, $A7
.byte $57, $41, $45, $C8
.byte $57, $40, $46, $C8
.byte $5F, $50, $46, $C8
.byte $5F, $51, $46, $C0
.byte $57, $41, $45, $88
.byte $57, $40, $47, $88
.byte $5F, $50, $47, $88
.byte $5F, $51, $47, $80
lady_mirror:
.byte $57, $41, $45, $A8
.byte $57, $40, $44, $A8
.byte $5F, $50, $44, $A8
.byte $5F, $51, $44, $A0
.byte $57, $41, $05, $BF
.byte $57, $40, $06, $BF
.byte $5F, $50, $06, $BF
.byte $5F, $51, $06, $C7
.byte $57, $41, $05, $7F
.byte $57, $40, $07, $7F
.byte $5F, $50, $07, $7F
.byte $5F, $51, $07, $87

crash_sprites:
.byte $3D, $3E, $1D, $FF, $FF, $2E, $2D
.byte $3B, $3C, $2C, $2B, $2A, $1A, $1B, $1C

crash_dust_sprites:
.byte $FF, $00, $30, $85, $29, $05, $39, $85
.byte $19, $45, $15, $85, $31, $45, $30, $05

life_sprites:
.byte $0C, $1E, $04, $04
.byte $0C, $1E, $04, $0D
.byte $0C, $1E, $04, $16

title_data:
.byte $06, $3F, $04, $0F, $06, $16, $26
.byte $05, $23, $DB, $05, $A5, $A5
.byte $06, $23, $D2, $A0, $A0, $A0, $50
.byte $10, $21, $69, $26, $27, $28, $00, $29, $27
.byte      $00, $29, $2A, $2B, $2C, $57, $58, $59
.byte $0B, $21, $8E, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3B
.byte $0B, $21, $AE, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4B
.byte $07, $21, $D2, $2D, $2E, $2F, $27, $36
.byte $00
game_over_text:
.byte $06, $23, $DA, $AA, $AA, $AA, $AA
.byte $0B, $21, $8B, $46, $2E, $2D, $2A, $00, $3F, $4F, $2A, $28
.byte $00

house_data:
.byte $6F, $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $6F, $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

.byte $6F, $7F, $6E, $68, $6E, $6E, $6E, $6E, $6E, $68, $8C, $76, $00
.byte $6F, $7F, $66, $69, $88, $84, $84, $8A, $66, $69, $6C, $7C, $80
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $66, $67, $81
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $66, $79, $82
.byte $6F, $7F, $66, $69, $89, $85, $85, $8B, $66, $69, $66, $7D, $83
.byte $6F, $7F, $66, $69, $88, $84, $84, $8A, $66, $69, $66, $7E, $00
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $6A, $7A, $00
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $6B, $7B, $00
.byte $6F, $7F, $66, $69, $89, $85, $85, $8B, $66, $69, $66, $77, $00
.byte $6F, $7F, $66, $69, $88, $84, $84, $8A, $66, $69, $66, $6D, $80
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $66, $79, $81
.byte $6F, $7F, $66, $69, $86, $FF, $FF, $87, $66, $69, $66, $67, $82
.byte $6F, $7F, $66, $69, $89, $85, $85, $8B, $66, $69, $8D, $77, $83
.byte $6F, $7F, $66, $69, $66, $66, $66, $66, $66, $69, $66, $78, $00

.byte $6F, $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $6F, $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

outro_palette:
.byte $08, $18, $19

random_sequence:
.byte $8D, $DC, $3B, $5C, $59, $18, $52, $AA
.byte $37, $B3, $11, $A1, $FA, $59, $E4, $E7
.byte $10, $5F, $1A, $C4, $25, $63, $2B, $BA
.byte $E1, $05, $DF, $2C, $79, $EE, $F6, $5C

.include "notes.h"

.include "levels.h"

.segment "SAMPLE"

crowing:
.include "crowing.h"

.segment "CODE"

PPUCTRL		= $2000
PPUMASK		= $2001
PPUSTATUS	= $2002
OAMADDR		= $2003
OAMDATA		= $2004
PPUSCROLL	= $2005
PPUADDR		= $2006
PPUDATA		= $2007
SQ1_VOL		= $4000
SQ1_SWEEP	= $4001
SQ1_LO		= $4002
SQ1_HI		= $4003
SQ2_VOL		= $4004
SQ2_SWEEP	= $4005
SQ2_LO		= $4006
SQ2_HI		= $4007
NOISE_VOL	= $400C
NOISE_LO	= $400E
NOISE_HI	= $400F
DMC_FREQ	= $4010
DMC_RAW		= $4011
DMC_START	= $4012
DMC_LEN		= $4013
OAMDMA		= $4014
SND_CHN		= $4015
JOY1		= $4016
JOY2		= $4017

OAM_Y		= $00
OAM_X		= $03
OAM_A		= $02
OAM_T		= $01

BUTTON_A	= %00000001
BUTTON_B	= %00000010
BUTTON_SELECT	= %00000100
BUTTON_START	= %00001000
BUTTON_UP	= %00010000
BUTTON_DOWN	= %00100000

VELOCITY	= 252
GRAVITATION	= 4
NEXT_IDX	= 5
FALLING		= 12
BUMPING		= 0
LIFE_OFFSET	= 128
OUTRO_WALK_IN	= 22
NORMAL_LEVELS	= 13

GAME_OVER	= (game_over_text - title_data)
SPRITE_BLOCK	= (sprites_end - sprites)
LADY_BLOCK	= (lady_mirror - lady_sprites)
MAIN_SPRITES	= SPRITE_BLOCK / 4

nmi:
	pha
	txa
	pha
	tya
	pha

	inc	counter + 0
	bne	:+
	inc	counter + 1
:
	jsr	update_ppu

	ldx	#%00000000
	stx	PPUMASK

	stx	OAMADDR
	lda	#>oam_buffer
	sta	OAMDMA

	lda	scroll_x
	sta	PPUSCROLL
	stx	PPUSCROLL

	jsr	update_ppu_ctrl

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
	lda	#%00001111
	sta	SND_CHN

	;; Wait for PPU to stabilize
	jsr	wait_vblank
	jsr	clear_memory
	jsr	wait_vblank

	jsr	init_variables
	jsr	setup_pallete

	jsr	wait_vblank
	jsr	update_ppu_ctrl

loop:
	lda	counter
spin:	cmp	counter
	beq 	spin

	jsr	check_button
	jsr	play_sound

	lda	progress
	cmp	#00
	beq	title_screen
	cmp	#01
	beq	prepare_game
	cmp	#02
	beq	rooster_game
	cmp	#03
	beq	rooster_crash
	cmp	#04
	beq	outro_scene

	jmp	fade_screen

title_screen:
	jsr	draw_title_screen
	jsr	launch_game
	jmp	loop

prepare_game:
	jsr	update_sky_tiles
	jsr	fill_even_ground
	jmp	loop

rooster_game:
	jsr	control_rooster
	jsr	update_sky_tiles_on_one
	jsr	fill_next_column
	jsr	scroll_screen
	jsr	move_rooster_position
	jsr	move_rooster_sprites
	jmp	loop

rooster_crash:
	jsr	crash_slide
	jsr	use_crash_sprites
	jsr	adjust_sprite_positions
	jsr	crash_epilogue
	jmp	loop

outro_scene:
	jsr	update_sky_tiles_on_one
	jsr	update_outro_palette
	jsr	fill_outro_column
	jsr	scroll_until_home
	jsr	move_rooster_position
	jsr	move_rooster_sprites
	jsr	animate_rooster_beak
	jsr	release_rooster_note
	jsr	outro_check_input
	jmp	loop

fade_screen:
	jsr	blank_ppu_buffer
	jsr	sweep_screen
	jmp	loop

start_title:
	lda	#$00
	sta	progress
	lda	image_ptr
	sta	column_pos
	lda	#%10001000
	sta	ppu_ctrl
	jsr	reset_scroll
	jsr	hide_all_sprites
	rts

start_game:
	lda	#$01
	sta	progress
	sta	gravity
	lda	#$00
	sta	velocity
	sta	rooster_y
	sta	column_pos
	lda	#$02
	sta	in_the_air
	lda	#$20
	sta	column_tile
	lda	#$12
	sta	column_height
	lda	#$7C
	sta	footing_prev
	sta	footing_next
	jsr	reset_scroll
	rts

start_rooster:
	lda	#$02
	sta	progress
	jsr	update_sky_tiles
	jsr	move_rooster_sprites
	rts

start_crash:
	lda	#$03
	sta	progress
	lda	#$20
	sta	crashed

	clc
	lda	rooster_x
	adc	#$10
	sta	delta_x
	lda	#$08
	sta	delta_y

	clc
	lda	rooster_py
	adc	#16
	sta	rooster_py

	jsr	reset_level_counters

	jsr	crash_sound
	jsr	take_life
	rts

take_life:
	lda	gold_mode
	bne	:+
	dec	lives
	lda	lives
	cmp	#$FF
	beq	:+
	clc
	asl
	asl
	tax
	lda	#$FF
	sta	oam_buffer + LIFE_OFFSET, x
:
	rts

start_fade:
	sta	progress
	lda	#$00
	sta	column_pos
	lda	#%10001100
	sta	ppu_ctrl
	jsr	hide_half_sprites
	jsr	get_fade_start
	rts

crash_epilogue:
	jsr	adjust_crash_dust
	lda	crashed
	bne	:++
	lda	#$F1
	ldx	lives
	cpx	#$FF
	bne	:+
	lda     #GAME_OVER
	sta     image_ptr
	lda	#$F0
:
	jmp	start_fade
:
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

copy_sprites_to_oam:
	ldx	#0
:
	lda	sprites, y
	sta	oam_buffer, x
	inx
	iny
	cpx	#SPRITE_BLOCK
	bne	:-
	rts

copy_ladies_to_oam:
	ldx	#0
	ldy	lady_state
:
	lda	lady_sprites, y
	sta	oam_buffer + 64, x
	inx
	iny
	cpx	#48
	bne	:-
	rts

animate_rooster_sprites:
	lda	in_the_air
	cmp	#2
	beq	@exit

	inc	rooster_frame
	lda	rooster_frame
	lsr
	and	#%00001110

	tax
	ldy	#$20

	lda	in_the_air
	beq	:+
	ldx	#$10
	ldy	#$21
:
	stx	oam_buffer + 1
	inx
	stx	oam_buffer + 5
	sty	oam_buffer + 9

	lda	#$FF
	sta	oam_buffer + 12
	sta	oam_buffer + 16
	rts
@exit:
	lda	#$FF
	sta	oam_buffer + 20
	sta	oam_buffer + 24
	rts

adjust_crash_dust:
	ldx	#$00
	lda	crashed
	cmp	#$10
	bcc	:+
	and	#%00001110
	tax
:
	lda	crash_dust_sprites + 0, x
	sta	oam_buffer + 13
	sta	oam_buffer + 17
	lda	crash_dust_sprites + 1, x
	sta	oam_buffer + 18
	eor	#%10000000
	sta	oam_buffer + 14

	lda	delta_x
	sta	oam_buffer + 19
	sec
	sbc	#4
	sta	oam_buffer + 15
	dec	delta_x

	clc
	lda	delta_y
	lsr
	adc	rooster_py
	sta	oam_buffer + 12

	sec
	lda	rooster_py
	sbc	delta_y
	sta	oam_buffer + 16
	inc	delta_y

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

flip_rooster_sprites:
	ldx	#0
:
	sec
	lda	#$10
	sbc	oam_buffer + OAM_X, x
	sta	oam_buffer + OAM_X, x

	lda	#$10
	sbc	oam_buffer + OAM_Y, x
	sta	oam_buffer + OAM_Y, x

	lda	oam_buffer + OAM_A, x
	eor	#%11000000
	sta	oam_buffer + OAM_A, x

	inx
	inx
	inx
	inx
	cpx	#SPRITE_BLOCK
	bne	:-
	rts

use_crash_sprites:
	ldy	#$00
	jsr	copy_sprites_to_oam

	ldx	#$00
	ldy	#$00
:
	lda	crash_sprites, x
	sta	oam_buffer + OAM_T, y
	inx
	iny
	iny
	iny
	iny
	cpx	#MAIN_SPRITES
	bne	:-
	rts

prepare_rooster_sprites:
	lda	#0
	ldx	in_the_air
	cpx	#2
	bne	:+
	lda	counter
:
	pha
	ldy	#$00
	and	#$02
	beq	:+
	ldy	#SPRITE_BLOCK
:
	jsr	copy_sprites_to_oam
	pla
	and	#$04
	beq	:+
	jsr	flip_rooster_sprites
:
	rts

adjust_sprite_positions:
	ldx	#0
:
	clc
	lda	oam_buffer + OAM_X, x
	adc	rooster_x
	sta	oam_buffer + OAM_X, x

	lda	oam_buffer + OAM_Y, x
	adc	rooster_y
	sta	oam_buffer + OAM_Y, x

	inx
	inx
	inx
	inx
	cpx	#SPRITE_BLOCK
	bne	:-
	rts

move_rooster_sprites:
	jsr	prepare_rooster_sprites
	jsr	adjust_sprite_positions
	jsr     animate_rooster_sprites

	rts

get_footing:
	lda	scroll_f
	cmp	#BUMPING
	bne	:+

	lda	footing_next
	sta	footing_prev

	clc
	lda	#NEXT_IDX
	adc	platform_idx
	and	#$0F
	tax

	lda	platforms, X
	sta	footing_next
:
	ldx	footing_next
	lda	scroll_f
	cmp	#FALLING
	bcs	:+
	cpx	footing_prev
	bcc	:+
	ldx	footing_prev
:
	stx	footing_snap
	rts

move_rooster_position:
	jsr	get_footing

	lda	rooster_y
	sta	rooster_py

	lda	in_the_air
	beq	snap_to_platform

	dec	gravity
	bne	adjust_vertical_pos
	inc	velocity
	lda	#GRAVITATION
	sta	gravity

adjust_vertical_pos:
	clc
	lda	velocity
	adc	rooster_y
	sta	rooster_y

	lda	velocity
	cmp	#$80
	bcc	snap_to_platform

	lda	rooster_py
	cmp	rooster_y
	bcs	snap_to_platform

	lda	rooster_py
	sta	rooster_y

snap_to_platform:
	lda	rooster_y
	cmp	footing_snap
	bcc	consider_falling

	lda	footing_snap
	cmp	rooster_py
	bcs	:+
	jmp	start_crash
:
	lda	in_the_air
	beq	:+
	lda	#$00
	sta	in_the_air
	jsr	ck_sound
:
	lda	footing_snap
	sta	rooster_y

consider_falling:
	lda	in_the_air
	bne	exit_move_rooster

	lda	scroll_f
	cmp	#FALLING
	bne	exit_move_rooster

	lda	rooster_y
	cmp	footing_next
	bcs	exit_move_rooster

	lda	#$01
	jmp	jump_rooster

exit_move_rooster:
	rts

crash_slide:
	dec	crashed
	lda	rooster_y
	cmp	footing_prev
	bcs	@exit
	inc	rooster_y
	rts
@exit:
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
	and	button_down
	sta	button_last
	rts

jump_rooster:
	sta	velocity
	lda	#GRAVITATION
	sta	gravity
	inc	in_the_air
	rts

control_rooster:
	lda	button_last
	and	#BUTTON_START
	beq	:+
	lda	pause
	eor	#1
	sta	pause
:
	lda	pause
	beq	:+
	jmp	loop
:
	lda	button_last
	and	#BUTTON_A
	beq	:+
	lda	in_the_air
	cmp	#2
	beq	:+
	lda	#VELOCITY
	jsr	jump_rooster
:
	lda	button_last
	and	#BUTTON_SELECT
	beq	:+
	lda	#1
	sta	gold_mode
	lda	#5
	sta	oam_buffer + 130
	sta	oam_buffer + 134
	sta	oam_buffer + 138
:
	rts

reset_scroll:
	lda	#$00
	sta	scroll_x
	sta	scroll_c
	sta	scroll_7
	sta	scroll_f
	rts

scroll_screen:
	clc
	lda	#1
	adc	scroll_x
	sta	scroll_x
	and	#$0F
	sta	scroll_f
	and	#$07
	sta	scroll_7
	lda	#0
	adc	scroll_c
	sta	scroll_c
	rts

scroll_until_home:
	lda	outro_scroll
	beq	:+
	jsr	scroll_screen
	lda	scroll_7
	bne	:++
	dec	outro_scroll
	rts
:
	lda	#$00
	sta	rooster_frame

	lda	outro_jumps
	cmp	#3
	beq	show_ladies

	jsr	shush_music

	inc	outro_delay
	lda	outro_delay
	cmp	#120
	bne	:+
	lda	#$00
	sta	outro_delay
	lda	#VELOCITY
	jsr	jump_rooster
	lda	#$70
	sta	outro_note
	inc	outro_jumps
	jsr	play_audio_sample
:
	rts

outro_check_input:
	lda	outro_input
	beq	:+

	lda	button_last
	and	#BUTTON_START
	beq	:+
	lda     #$00
	sta	image_ptr
	lda	#$F0
	jmp	start_fade
:
	rts

show_ladies:
	lda	outro_delay
	cmp	#60
	bne	@wait

	lda	#$00
	sta	music_cfg + 3
	sta	music_cfg + 7

	lda	#$60
	sta	outro_input
	jsr	copy_ladies_to_oam
	rts
@wait:
	jsr	shush_music
	inc	outro_delay
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

	jsr	hide_all_sprites
	rts

hide_all_sprites:
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

hide_half_sprites:
	lda	#255
	ldx	#0
:
	sta	oam_buffer, X
	inx
	inx
	inx
	inx
	cpx	#128
	bne	:-
	rts

fill_ground_cell:
	sta	ppu_data + 2, x
	adc	#16
	inx
	rts

fill_column:
	lda	#30
	sta	ppu_size

	jsr	select_nametable
	ora	#$20
	sta	ppu_data + 0

	lda	column_pos
	and	#$1F
	sta	ppu_data + 1

	ldx	#0
fill_sky:
	txa
	lda	sky_tiles, x
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
	bcc	:+
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
	pha
	lda	progress
	cmp	#4
	beq	get_outro_attribute
	pla
	jmp	get_regular_attribute

get_outro_attribute:
	lda	outro_scroll
	cmp	#OUTRO_WALK_IN - 1
	bcs	@regular
	cmp	#OUTRO_WALK_IN - 3
	bcs	@roof
	cmp	#OUTRO_WALK_IN - 19
	bcc	@regular
	cmp	#OUTRO_WALK_IN - 17
	bcc	@roof

	cpy	#6
	bcc	@regular
	cpy	#18
	bcs	@regular
	cpy	#16
	bne	@brown
	pla
	ora	#(1 << 6)
	iny
	iny
	rts
@roof:
	cpy	#6
	bne	@regular
@brown:
	pla
	ora	#(2 << 6)
	iny
	iny
	rts

@regular:
	pla
	jmp	get_regular_attribute

get_regular_attribute:
	cpy	column_height
	bne	:+
	ora	#(1 << 6)
:
	bcc	:+
	ora	#(2 << 6)
:
	iny
	iny
	rts

shift_attribute:
	pha
	lda	column_pos
	and	#$02
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
	jsr	update_platforms
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

start_outro:
	dec	outro_extend
	bne	:+
	lda	#$04
	sta	progress
	lda	#OUTRO_WALK_IN
	sta	outro_scroll
	lda	#$00
	sta	outro_delay
	sta	outro_jumps
	sta	outro_column
	sta	outro_input
	sta	lady_state
	lda	#$FF
	sta	outro_note
:
	lda	#$12
	sta	column_height
	lda	#$20
	sta	column_tile
	rts

produce_looped_level:
	inc	level_block
	inc	level_block

	ldy	#1
	lda	(current_input), Y
	cmp	level_block
	bne	:+
	lda	#2
	sta	level_block
	inc	level_loops
:
	ldy	level_block
	lda	(current_input), Y
	sta	column_height
	iny
	lda	(current_input), Y
	sta	column_tile

	ldy	#0
	lda	(current_input), Y
	cmp	level_loops
	bne	:+
	lda	#1
	sta	level_done
:
	rts

produce_block:
	ldx	level_done
	bne	@done
	lda	current_input + 0
	ora	current_input + 1
	beq	@the_end
	lda	gold_mode
	bne	@next
	lda	level_idx
	cmp	#(2 * (NORMAL_LEVELS + 1))
	beq	@the_end
@next:
	jmp	produce_looped_level
@the_end:
	jmp	start_outro
@done:
	inc	level_done
	cpx	#10
	bcc	:+
	lda	#12
	sta	flash
	jsr	load_level
:
	lda	#$12
	sta	column_height
	lda	#$20
	sta	column_tile
	rts

fill_next_column:
	lda	scroll_7
	bne	palette_flash
	lda	column_tile
	cmp	#$24
	beq	generate_new_block
	cmp	#$26
	bne	continue_old_block
generate_new_block:
	jsr	produce_block
continue_old_block:
	jsr	update_column
	rts

palette_flash:
	lda	flash
	beq	@exit

	jsr	level_complete_sound

	ldx	#$01
	stx	ppu_size
	ldx	#$3F
	stx	ppu_data + 0
	ldx	#$10
	stx	ppu_data + 1
	ldx	#$0F
	and	#1
	bne	:+
	ldx	#$30
:
	stx	ppu_data + 2
	dec	flash
@exit:
	rts

fill_outro_column:
	lda	outro_scroll
	beq	@exit
	lda	scroll_7
	bne	@exit
	lda	column_tile
	and	#$03
	ora	#$20
	sta	column_tile
	jsr	update_column
	jsr	update_home
@exit:
	rts

draw_title_screen:
	lda	#$00
	sta	attributes + 0
	sta	attributes + 2

	lda	#%10001000
	sta	ppu_ctrl

	ldx	column_pos
:
	lda	title_data, X
	bne	:+
	ldx	image_ptr
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

update_platforms:
	lda	column_pos
	and	#$01
	bne	:+
	lda	column_height
	clc
	asl
	asl
	asl
	sec
	sbc	#20
	ldx	platform_idx
	sta	platforms, X
	inx
	txa
	and	#$0f
	sta	platform_idx
:
	rts

blank_ppu_buffer:
	lda	#30
	sta	ppu_size
	lda	#$00
	ldx	#$00
:
	sta	ppu_data + 2, X
	inx
	cpx	#30
	bne	:-
	rts

get_fade_start:
	lda	scroll_c
	ror
	lda	scroll_x
	ror
	lsr
	lsr
	sta	fade_start
	rts

update_ppu_ctrl:
	lda	scroll_c
	and	#%00000001
	ora	ppu_ctrl
	sta	PPUCTRL
	rts

sweep_screen:
	clc
	lda	column_pos
	cmp	#$40
	beq	fade_done
	adc	fade_start
	and	#$20
	lsr
	lsr
	lsr
	ora	#$20
	sta	ppu_data + 0
	lda	column_pos
	adc	fade_start
	and	#$1F
	sta	ppu_data + 1
	inc	column_pos
	rts
fade_done:
	lda	progress
	cmp	#$F0
	beq	@l0
	cmp	#$F1
	beq	@l1
@l0:
	jmp	start_title
@l1:
	jmp	start_game

fill_even_ground:
	jsr	update_column

	lda	column_tile
	cmp	#$24
	bne	:+
	lda	#$20
	sta	column_tile
:
	lda	column_pos
	cmp	#$20
	bne	:+
	jsr	start_rooster
:
	rts

launch_game:
	lda	button_last
	and	#BUTTON_START
	beq	:+
	lda	#3
	sta	lives
	lda	#0
	sta	level_idx
	sta	gold_mode
	jsr	load_level
	jsr	restart_music
	jsr	setup_lives
	lda	#$F1
	jsr	start_fade
	lda	#$14
	sta	sky_offset
	lda	#$08
	sta	outro_extend
:
	rts

load_level:
	ldx	level_idx

	lda	level_inputs + 0, X
	sta	current_input + 0
	lda	level_inputs + 1, X
	sta	current_input + 1

	inc	level_idx
	inc	level_idx

	lda	sky_offset
	cmp	#1
	beq	:+
	dec	sky_offset
:
	jsr	reset_level_counters
	rts

reset_level_counters:
	lda	#0
	sta	level_done
	sta	level_block
	lda	#0
	sta	level_loops
	rts

setup_lives:
	ldx	#0
:
	lda	life_sprites, x
	sta	oam_buffer + LIFE_OFFSET, x
	inx
	cpx	#12
	bne	:-
	rts

produce_vol:
	lda	music_delay
	lsr
	lsr
	clc
	adc	music_cfg + 1, X
	ora	music_cfg + 2, X
	rts

play_channel:
	bit	rest_bit
	beq	:+
	lda	#$30
	sta	SQ1_VOL, X
	rts
:
	clc
	adc	music_cfg + 0, X
	tay

	jsr	produce_vol
	sta	SQ1_VOL, X
	lda	#$08
	sta	SQ1_SWEEP, X
	lda	music_notes + 0, Y
	sta	SQ1_LO, X
	lda	music_notes + 1, Y
	ora	music_cfg + 3, X
	sta	SQ1_HI, X

	cpx	#0
	bne	:+
	lda	lady_state
	eor	#$30
	sta	lady_state
:
	rts

restart_music:
	lda	#0
	sta	music_idx
	sta	music_delay

	clc
	lda	#$10
	adc	music_cfg + 0
	and	#$30
	sta	music_cfg + 0
	bne	:+
	lda	#$10
	adc	music_cfg + 4
	and	#$30
	sta	music_cfg + 4
:
	rts

play_sound:
	lda	progress
	beq	@pause_music
	lda	pause
	bne	@pause_music
	lda	music_delay
	bne	@exit
:
	ldx	music_idx
	lda	note_length, X
	bne	:+
	jsr	restart_music
	jmp	:-
:
	sta	music_delay

	ldy	music_idx
	lda	music1, Y
	ldx	#0
	jsr	play_channel

	ldy	music_idx
	lda	music2, Y
	ldx	#4
	jsr	play_channel

	inc	music_idx
@exit:
	dec	music_delay
	rts

@pause_music:
	lda	#$30
	sta	SQ1_VOL
	sta	SQ2_VOL
	rts

crash_sound:
	lda	#$04
	sta	NOISE_VOL
	lda	#$08
	sta	NOISE_LO
	lda	#$C0
	sta	NOISE_HI
	rts

ck_sound:
	lda	#$00
	sta	NOISE_VOL
	lda	#$0F
	sta	NOISE_LO
	lda	#$10
	sta	NOISE_HI
	rts

level_complete_sound:
	ldx	#$8F
	stx	SQ1_VOL

	pha
	clc
	asl
	asl
	asl
	asl
	sta	SQ1_LO
	pla

	ldx	#$0
	stx	SQ1_HI
	rts

update_sky_tiles:
	lda	#0
	ldx	#0
@back:
	ldy	star_counter
	bne	@empty
	lda	star_random
	and	#$1F
	tay

	lda	random_sequence, y
	and	#$1F
	sta	star_counter
	inc	star_counter

	lda	random_sequence, y
	clc
	and	#$03
	adc	#$1C

	inc	star_random
@empty:
	dec	star_counter
	sta	sky_tiles + $00, x
	lda	#$00
	inx
	cpx	sky_offset
	bne	@back

	lda	#$01
	sta	sky_tiles + $02, x
	lda	#$02
	sta	sky_tiles + $05, x

	lda	sky_counter
	and	#$1F
	tay

	clc
	lda	random_sequence, y
	and	#3
	adc	#4
	sta	sky_tiles + $00, x
	adc	#4
	sta	sky_tiles + $01, x
	adc	#4
	sta	sky_tiles + $03, x
	adc	#4
	sta	sky_tiles + $04, x
	adc	#4
	sta	sky_tiles + $06, x
	adc	#4
	sta	sky_tiles + $07, x

	txa
	adc	#8
	tax

	lda	#3
:
	sta	sky_tiles + $00, x
	inx
	cpx	#30
	bne	:-

	inc	sky_counter

	rts

update_sky_tiles_on_one:
	lda	scroll_7
	cmp	#1
	bne	@exit
	jsr	update_sky_tiles
@exit:
	rts

update_outro_palette:
	lda	scroll_7
	cmp	#2
	bcc	@exit
	cmp	#5
	bcs	@exit

	sec
	sbc	#2
	tax
	clc
	adc	#5
	tay

	lda	#$01
	sta	ppu_size
	lda	#$3F
	sta	ppu_data + 0
	sty	ppu_data + 1
	lda	outro_palette, x
	sta	ppu_data + 2
@exit:
	rts

update_home:
	lda	outro_scroll
	cmp	#OUTRO_WALK_IN - 1
	bcs	@exit
	cmp	#OUTRO_WALK_IN - 19
	bcc	@exit

	ldy	outro_column
	ldx	#8
:
	lda	house_data, y
	beq	@skip_tile
	sta	ppu_data, x
@skip_tile:
	inx
	iny
	cpx	#21
	bne	:-
	sty	outro_column

@exit:
	rts

animate_rooster_beak:
	lda	outro_input
	beq	@exit

	ldy	#$20
	lda	lady_state
	beq	:+
	ldy	#$21
:
	sty	oam_buffer + 9
@exit:
	rts

release_rooster_note:
	lda	outro_note
	cmp	#$FF
	beq	:+
	sec
	sbc	#1
	cmp	#$50
	bne	:+
	lda	#$FF
:
	sta	outro_note
	sta	oam_buffer + 60
	lda	#$1F
	sta	oam_buffer + 61
	lda	#$04
	sta	oam_buffer + 62
	lda	#$50
	sta	oam_buffer + 63

	rts

play_audio_sample:
	lda	#$0F
	sta	SND_CHN
	lda	#$0C
	sta	DMC_FREQ
	lda	#$00
	sta	DMC_RAW
	lda	#$00
	sta	DMC_START
	lda	#255
	sta	DMC_LEN
	lda	#$1F
	sta	SND_CHN
	rts

shush_music:
	lda	#$F8
	sta	music_cfg + 3
	sta	music_cfg + 7

	lda	SQ1_VOL
	and	#$C0
	ora	#$12
	sta	SQ1_VOL

	lda	SQ2_VOL
	and	#$C0
	ora	#$12
	sta	SQ2_VOL

	rts
