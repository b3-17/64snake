* = $c000 ; load our program into 49152, 4k ram after BASIC

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
		;sta $0400,x 
		;sta (currentpositionL, x) ; cool little trick, get the low byte from address, and then piece together with the hi byte from next address up (or 		;whatever x is)
						; which we can increment / decrement when we run over 255 lo byte on down, up, left right movements
						; i.e. we can store $05 in hi when overrunning 255 (carry flag) from $04 low byte page
						; have to have this here, else wise end up with weird double quit action etc. (so we can return to the caller, which 										;is main from move, not here)
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


