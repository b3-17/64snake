
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
				
borderdelay 	ldx #00

borderdelaynest	inx 
				cpx #$ff
				 
				bne borderdelaynest
				iny
				cpy #$ff
				bne borderdelay
				jsr borderflash
				rts

gamequit		brk
