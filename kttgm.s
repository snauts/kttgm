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

.segment "ZEROPAGE"

.segment "BSS"

.segment "OAM"

.segment "RODATA"

.segment "CODE"

nmi:
	rti

irq:
	rti

rst:
	sei        		; ignore IRQs
	cld        		; disable decimal mode
	ldx	#$40
	stx	$4017		; disable APU frame IRQ
	ldx	#$ff
	txs			; Set up stack
	inx			; now X = 0
	stx	$2000		; disable NMI
	stx	$2001		; disable rendering
	stx	$4010		; disable DMC IRQs
	rti
