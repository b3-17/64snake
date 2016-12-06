* = $c000 ; load our program into 49152, 4k ram after BASIC,             ; start address for 6502 code 

; set up screen and display memory
; set up our memory to hold character variables
setup	lda #81
		sta quitkey ; store q as the quit key
		lda #69
		sta startkey ; store e as the start game key
		lda #65
		sta leftkey
		lda #87
		sta upkey
		lda #68
		sta rightkey
		lda #83
		sta downkey
		lda #67
		sta controlskey
		lda #79
		sta optionskey
		lda #82
		sta returntomenukey
		lda #01
		sta currentscreen
		sta menuscreen
		lda #02
		sta controlsscreen
		
		jsr clear ;
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
		
		lda #$7f
		sta snakeattractdelaytimer
		jsr initattractsprites
		
jsr inithomescreen
jsr menuloop

rts