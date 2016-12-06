
menuloop	ldx #00
			jsr showcollisionsquarestop
			ldx #00 
			jsr showcollisionsquaresbottom
			jsr setzerocollisionsidesquares
			clc
			lda #00
			sta scoreones
			sta scoretens
			jsr showpageonesidesquares
			clc
			lda #00			
			jsr showpagetwosidesquares
			clc 
			lda #00
			jsr showpagethreesidesquares
			clc
			lda #00
			jsr showpagefoursidesquares
			jsr menukeyscan
			
			jsr generaldelay
			jsr customdelay
			jsr animatesnakehead
			jsr snakemenuattract
			jmp menuloop

menukeyscan		jsr scnkey
				jsr getin 
				bne menuselection ; if something else, direct us off to a place where we can institute the new value
				rts

menuselection	cmp startkey
				beq startgame ; jump to core, to start the gameloop
				cmp quitkey
				beq gamequit
				cmp optionskey
				beq showoptions
				cmp controlskey
				beq showcontrols
				cmp returntomenukey
				beq showmenu
				
				rts

snakemenuattract	dec $d000
					dec $d002
					rts
				
; check directions and send to appropriate label that will increment or decrement screen ram address
;smove			ldx #00
;				cmp $c1fe ;compare with a
;				beq sleft ;
;				cmp $c200 ; compare with w
;				beq sup
;				cmp $c1fd ; compare with d
;				beq sright
;				cmp $c1ff ; compare with s
;				beq sdown
;				rts
				
;sup		dec $d001
;		dec $d003
;		inx
;		cpx #07
;		bne sup
;		rts
		
;sleft	dec $d000
;		dec $d002
;		inx
;		cpx #07
;		bne sleft
;		rts

;sright	inc $d000
;		inc $d002
;		inx
;		cpx #07
;		bne sright
;		rts
			
;sdown	inc $d001
;		inc $d003
;		inx
;		cpx #07
;		bne sdown
;		rts
		
startgame		jsr clear
				jsr sidset
				jsr setbodysegments
				jsr setheadsnakesegments
				jsr generaterandomappleposition
				jsr displayappleposition
				jsr gameloop

showmenu		jsr clear
				jsr inithomescreen
				jmp menuloop

showoptions		jsr clear
				jsr initoptionsscreen
				jmp menuloop

showcontrols	jsr clear
				jsr initcontrolsscreen
				jmp menuloop
			
customdelay		ldx #00

customdelaynest	inx
				cpx snakeattractdelaytimer
				bne customdelaynest
				rts
				
generaldelay	ldx #00

generaldelaynest	inx
					cpx #$ff
					bne generaldelaynest
					rts
				
borderdelay 	ldx #00

borderdelaynest	inx 
				cpx #$ff
				 
				bne borderdelaynest
				iny
				cpy #$ff
				bne borderdelay
				;jsr borderflash
				rts

gamequit		brk
