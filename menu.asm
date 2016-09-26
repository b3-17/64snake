
menuloop		
			ldx #00
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

menuselection			sta $3fff
				cmp #$45
				beq startgame ;gameloop
				cmp #81
				beq gamequit
				rts

startgame			jsr $e544
				jsr sidset
				jsr setbodysegments
				jsr setheadsnakesegments
				jsr generaterandomappleposition
				jsr displayappleposition
				jsr gameloop
				rts
				
borderdelay ldx #00

borderdelaynest	inx 
				cpx #$ff
				 
				bne borderdelaynest
				iny
				cpy #$ff
				bne borderdelay
				jsr borderflash
				rts

gamequit		brk
