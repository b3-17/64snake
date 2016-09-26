* = $c000 ; load our program into 49152, 4k ram after BASIC,             ; start address for 6502 code 

; set up screen and display memory
; set up our memory to hold character variables
setup	jsr clear ;
		lda #160 ; inverted (aka whiteblock) space character code
		sta whiteblock ;
		lda #$20 ; normal space (aka blackblock) character code
		sta blackblock ;
		
		lda #$19
		sta appleblock
		
		lda whiteblock ; little whiteblock guy
		ldx #70
		
		lda #87
		sta currentdirection
		;set border colour
		lda #01
		sta bordercolour
		lda #80
		sta snakespeed
		
		
jsr inithomescreen
jsr menuloop

rts