
sidset	LDA #$FF  ; maximum frequency value, finally made this work
		STA $D40E ; voice 3 frequency low byte
		STA $D40F ; voice 3 frequency high byte
		LDA #$80  ; noise waveform, gate bit off
		STA $D412 ; voice 3 control register
		rts

gameloop	ldx #00
			jsr showcollisionsquarestop
			ldx #00 
			jsr showcollisionsquaresbottom
			jsr setzerocollisionsidesquares
			clc
			lda #00
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
			jsr delaytop
			jsr scankey
			jsr move
			ldx #00
			jsr printscore
			
			jsr displayappleposition
			jmp gameloop						

setheadsnakesegments		lda #08 ; make snake length + 1 for the bne (so 4 = 3 segments) length in bytes
							sta snakelengthL
							lda #00
							sta snakelengthH
			
							lda #$60
							sta currentpositionL ; start with lo byte as $60 (the rightmost 00 in $0400)
							sta snakesegmentsL, x
							
							lda #$05
							sta currentpositionH ; start with hi byte as $05 (the leftmost $04 in $0400)
							sta snakesegmentsH, x
							ldx #00
							ldy #00
							jsr setbodysegments
							rts

; set up initial body segment coordinates
setbodysegments		lda #$c0
					sta snakesegmentsL,x
					lda #$04 
					sta snakesegmentsH,x
					inx
					inx 
					lda #$10
					sta snakesegmentsL,x
					lda #$05
					sta snakesegmentsH,x
					inx 
					inx
					lda #$60
					sta snakesegmentsL,x
					lda #$05
					sta snakesegmentsH,x
					rts

;just use this to set the current direction, the loop takes care of movement
scankey			jsr scnkey
				jsr getin 
				bne setdirection ; if something else, direct us off to a place where we can institute the new value
				rts
				
setdirection	sta currentdirection
				rts

; check directions and send to appropriate label that will increment or decrement screen ram address
move 			lda currentdirection
				cmp leftkey ;compare with a
				beq left ;
				cmp upkey ; compare with w
				beq up
				cmp rightkey ; compare with d
				beq right
				cmp downkey ; compare with s
				beq down
				rts

left	lda currentpositionL
		sec
		sbc #01
		sta currentpositionL
		
		bcc pageleft
		
		jsr displaynewposition
		
		rts
	
pageleft	dec currentpositionH
			jsr displaynewposition
			rts

up		sec
		lda currentpositionL
		sbc #40
		sta currentpositionL
		bcc pageup ; it's all about finding the right branching command - SBC CLEARS the carry when the operation doesn't overflow, so it's the opposite of 
					; bcs or bmi
		jsr displaynewposition
		
		rts

pageup	dec currentpositionH
		lda currentpositionH ; load and compare to 4 to kill on top collision

		jsr displaynewposition;
		rts
		
right	lda currentpositionL
		clc
		adc #01
		sta currentpositionL
		
		bcs pageright
		jsr displaynewposition
		
		rts

pageright	inc currentpositionH
			jsr displaynewposition
			rts

down	lda currentpositionL
		clc
		adc #40 ; 40 columns, a down move would be current + 40, (1024 then down would be 1064)
		sta currentpositionL ; store result in low byte, if a remainder, carry remainder to add to the new page, if any
		
		bcs pagedown ; go down into a fresh set of 255 bytes - ADC CREATES carry when the result is over 255
		lda currentpositionH
		
		jsr displaynewposition
		rts ; return to move from here, not from the display label, it seems to store presses and adds that latency

pagedown	inc currentpositionH
			jsr displaynewposition
			rts

commonmove		rts

displaynewposition	jsr testsnakecollision
					jsr eatapple
					jsr setblackblocktail
					
					jsr initsnakestore
					jsr rotatelosnakelocations	
					jsr initsnakestore
					jsr rotatehisnakelocations
					
					lda currentpositionL
					sta snakesegmentsL
					lda currentpositionH
					sta snakesegmentsH					
		
					; store snakeblocks in screen ram
					lda whiteblock
					ldy currentpositionH
					ldx currentpositionL
					cpy #$04
					beq loadpageoneitem
					cpy #$05
					beq loadpagetwoitem
					cpy #$06
					beq loadpagethreeitem
					cpy #$07	
					beq loadpagefouritem
					
					lda #00 ; make sure we are not carrying any weird a values that can throw move off
					rts					

; the last address pair in the snakesegments hi low chain set to black
setblackblocktail	ldx snakelengthL
					dex
					dex
					lda blackblock
					ldy snakesegmentsH,x
					cpy #$04
					beq displaypageonesnakesegment
					cpy #$05
					beq displaypagetwosnakesegment
					cpy #$06
					beq displaypagethreesnakesegment
					cpy #$07
					beq displaypagefoursnakesegment
					rts

displaypageonesnakesegment		ldy snakesegmentsL,x
								sta $0400,y
								rts

displaypagetwosnakesegment		ldy snakesegmentsL,x
								sta $0500,y
								rts
								
displaypagethreesnakesegment	ldy snakesegmentsL,x
								sta $0600,y
								rts
								
displaypagefoursnakesegment		ldy snakesegmentsL,x
								sta $0700,y
								rts

; maybe have tails that last and randomly split so that player has to go through the splits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GENERIC STORE IN SCREEN RAM LABELS
loadpageoneitem		sta $0400,x
					rts

loadpagetwoitem 	sta $0500,x
					rts

loadpagethreeitem	sta $0600,x
					rts

loadpagefouritem	sta $0700,x
					rts
					
; comb the routines book for better copy routines, but try my way first
initsnakestore			ldy snakelengthL
						rts
						
rotatelosnakelocations	;before popping off the last coords of the snake chain, turn that screen ram to black.
						; must work from the end, because if we work from the start, we overwrite the third in the chain, thats why it all goes to the same value
						dey
						dey
						lda snakesegmentsL,y
						iny
						iny
						sta snakesegmentsL,y
						dey
						dey
						cpy #00
						bne rotatelosnakelocations ; keep going for however many segments we have
						ldy #00 ; reset counters, seems like they stay set
						rts

rotatehisnakelocations	
						dey
						dey
						lda snakesegmentsH,y
						iny
						iny
						sta snakesegmentsH,y
						dey
						dey
						cpy #00
						bne rotatehisnakelocations ; keep going for however many segments we have
						ldy #00 ; reset counters, seems like they stay set
						rts

displayappleposition	lda appleblock
						ldy applepositionH
						ldx applepositionL
						cpy #$04
						beq loadpageoneitem
						cpy #$05
						beq loadpagetwoitem
						cpy #$06
						beq loadpagethreeitem
						cpy #$07
						beq loadpagefouritem
			
						rts
			
eatapple		lda applepositionL
			
			cmp currentpositionL
			beq comparehiapple
			
			rts

comparehiapple		lda applepositionH	
					cmp currentpositionH
					beq growsnake
					rts			

growsnake		lda snakelengthL
				
				clc
				adc #02 ; low and hi address needs two
				sta snakelengthL;
			
				bcs addsegmentH
				jsr addscore
				jsr increasespeed
				jsr generaterandomappleposition	
				rts

addscore		clc
				inc scoreones
				lda scoreones
				sec
				sbc #10
				;not entirely sure how this works
				cmp #$;00ff ; use twos compliment to check for -1 (which is ff, once the carry is set, jump into the top of 255)
				beq addtens		
				rts

addtens			inc scoretens
				lda #00
				sta scoreones
				rts

addsegmentH		lda snakelengthH
				adc #01
				sta snakelengthH
				rts

increasespeed		lda snakespeed
					sec
					sbc #02
					sta snakespeed
					rts

generaterandomappleposition	jsr generaterandomH
							jsr generaterandomL
							rts
				
generaterandomH		lda $d41b ;
					cmp #$04 ; make sure we have a 0-4 random number. We can add 4 later to get 04-07 randomly
					bcs generaterandomH ; keep going till we get what we want
					clc
					adc #$04 ;4 for 7
					sta applepositionH
							 
					rts

; task the lower byte generation with all the checking if non blackblock or offscreen setting
norightsidescollisionapple	lda applepositionL
							cmp #$07
							beq generaterandomL
							cmp #$1f
							beq generaterandomL
							cmp #$6f
							beq generaterandomL
							cmp #$27
							beq generaterandomL
							cmp #$4f
							beq generaterandomL
							cmp #$77
							beq generaterandomL
							cmp #$9f
							beq generaterandomL
							cmp #$c7
							beq generaterandomL
							cmp #$ef
							beq generaterandomL
							cmp #$3f
							beq generaterandomL
							cmp #$67
							beq generaterandomL
							cmp #$8f
							beq generaterandomL
							cmp #$b7
							beq generaterandomL
							cmp #$df
							beq generaterandomL
							cmp #$07
							beq generaterandomL
							cmp #$2f
							beq generaterandomL
							cmp #$57
							beq generaterandomL
							cmp #$7f
							beq generaterandomL
							cmp #$a7
							beq generaterandomL
							cmp #$ef
							beq generaterandomL
							cmp #$f7
							beq generaterandomL
							cmp #$47
							beq generaterandomL
							cmp #$6f
							beq generaterandomL
							cmp #$97
							beq generaterandomL
							rts	

storeapplenocollision	jsr noleftsidescollisionapple
						jsr norightsidescollisionapple
						lda applepositionH
						cmp #$04
						beq notopcollisionapple
						cmp #$07			
						beq nobottomcollisionapple
						
						rts

notopcollisionapple	lda applepositionL
					cmp #$29
					bcc generaterandomL
					rts

nobottomcollisionapple	lda applepositionL
						cmp #$bf
						bcs generaterandomL
						rts

generaterandomL		lda $d41b
					sta applepositionL
					jsr storeapplenocollision
		
					rts
					
noleftsidescollisionapple	lda applepositionL
							cmp #$18
							beq generaterandomL
							cmp #$08
							beq generaterandomL
							cmp #$20
							beq generaterandomL
							cmp #$28
							beq generaterandomL
							cmp #$50
							beq generaterandomL
							cmp #$78
							beq generaterandomL
							cmp #$a0
							beq generaterandomL
							cmp #$c8
							beq generaterandomL
							cmp #$f0
							beq generaterandomL
							cmp #$40
							beq generaterandomL
							cmp #$68
							beq generaterandomL
							cmp #$90
							beq generaterandomL
							cmp #$b8
							beq generaterandomL
							cmp #$e0
							beq generaterandomL
							cmp #$08
							beq generaterandomL
							cmp #$30
							beq generaterandomL
							cmp #$58
							beq generaterandomL
							cmp #$80
							beq generaterandomL
							cmp #$a8
							beq generaterandomL
							cmp #$d0
							beq generaterandomL
							cmp #$f8
							beq generaterandomL
							cmp #$48
							beq generaterandomL
							cmp #$70
							beq generaterandomL
							cmp #$98
							beq generaterandomL
							rts	

delaytop	ldx	#00

delaynest	inx 
			cpx #$ff
			 
			bne delaynest
			iny
			cpy snakespeed;#$80
			bne delaytop
			rts

