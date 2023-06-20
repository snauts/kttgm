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

.segment "BSS"

.segment "OAM"

.segment "RODATA"

.segment "CODE"

PPUCTRL		= $2000
PPUMASK		= $2001
PPUSTATUS	= $2002
DMC_FREQ	= $4010
JOY2		= $4017

nmi:
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
	bit	PPUSTATUS
@vblank_wait_1:
	bit	PPUSTATUS
	bpl	@vblank_wait_1
@vblank_wait_2:
	bit	PPUSTATUS
	bpl	@vblank_wait_2

	rti
