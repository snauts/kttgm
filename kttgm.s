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
	ldx	#$FF
	txs			; init stack
	cld			; disable decimal mode
	rti
