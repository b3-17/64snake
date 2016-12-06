
initattractsprites		; initialise sprite frame counters
						lda #00
						sta snakeanimationcurrentframe
						
						jsr enablespritesmulticolour
						jsr setspritecolours
						
						jsr initsnakeheadsprite
						jsr initsnakebodysprite
						jsr enablesprites
						rts ; remember to jump back to calling routine or borderflash will execute! 

enablespritesmulticolour	; enable multi colour
							lda #$03
							sta $d01c
							
							rts
							
setspritecolours 		;set green as multi colour 1
						lda #$05
						sta $d025
						
						;set yellow as multi colour 2
						lda #$07
						sta $d026
						
						;set purple as sprite colour
						lda #$04
						sta $d027
						rts

enablesprites		lda #$03 ; to enable sprites set bits in $d015 based by position
					sta $d015
					rts

initsnakeheadsprite	lda #$80 ; set sprite block 1 x 64 into sprite 1 pointer
					sta $07f8
					lda #$86; set x,y for sprite, sprite one's x and y are at d000 and d001
					sta $d000
					lda #$40
					sta $d001
					rts
						
animatesnake		lda snakeanimationcurrentframe
					clc
					adc #$80 ; load initial sprite block to sprite pointer register 0 and add focus frame
					sta $07f8
					
					rts


initsnakebodysprite     lda #$84 ; set sprite block 4 x 64 into sprite 1 pointer
						sta $07f9
						lda #$9e ; coords
						sta $d002
						lda #$40
						sta $d003
						
						rts
						
animatesnakebody	lda snakeanimationcurrentframe
					clc
					adc #$84 ; load initial sprite block to sprite pointer register 0 and add focus frame
					sta $07f9
					
					rts

checkendframe		lda snakeanimationcurrentframe
					
					cmp #03
					beq refreshsnakeheadframes
					inc snakeanimationcurrentframe
					rts

refreshsnakeheadframes	lda #$00
						sta snakeanimationcurrentframe
						rts

borderflash		sty $4001
				
				iny
				cpy #01
				beq skipcolour
				cpy #16
				beq resetcolour
				sty $d020
				bne borderflash
				rts

skipcolour		jmp borderflash

resetcolour		ldy #00
				jmp borderflash

inithomescreen	lda #$01
				sta $d020 ; set border colour
				lda #$00
				sta $d021
				ldx #00
				jsr printheadertext
				ldx #00
				jsr printoption1
				ldx #00
				jsr printoption2
				ldx #00
				jsr printoption3
				ldx #00
				jsr printoption4
				
				rts
			
printheadertext	lda #$13
				sta $0500
				lda #$0e
				sta $0501
				lda #$01
				sta $0502
				lda #$0b
				sta $0503
				lda #$05 
				sta $0504
				lda #$21
				sta $0505
				lda menutextline1,x
				cmp #$23
				beq finishedprinting
				lda #$01
				sta $d900,x
				inx
				bne printheadertext
				rts

printoption1	lda menutextline2,x
				cmp #$23
				beq finishedprinting
				sta $0541,x
				lda #$01
				sta $d941,x
				inx
				bne printoption1
				rts
				
printoption2	lda menutextline3,x
				cmp #$23
				beq finishedprinting
				sta $0569,x
				lda #$01
				sta $d969,x
				inx
				bne printoption2
				rts
				
printoption3	lda menutextline4,x
				cmp #$23
				beq finishedprinting
				sta $0591,x
				lda #$01
				sta $d991,x
				inx
				bne printoption3
				rts
				
printoption4	lda menutextline5,x
				cmp #$23
				beq finishedprinting
				sta $05b9,x
				lda #$01
				sta $d9b9,x
				inx
				bne printoption4
				rts

finishedprinting rts

printscore		lda scoretext,x
				sta $0460,x
				
				lda #01
				sta $d860,x
				inx
				cpx #07
				bne printscore
				clc
				lda scoreones
				adc #$30
				
				sta $0468
				lda #01 
				sta $d868
				lda scoretens
				adc #$30
				sta $0467
				lda #01
				sta $d867	
				rts

initcontrolsscreen		lda #$01
						sta $d020 ; set border colour
						lda #$00
						sta $d021
						ldx #00
						jsr printcontrolsheadertext
						ldx #00
						jsr printcontrolsup
						ldx #00
						jsr printcontrolsleft
						ldx #00
						jsr printcontrolsdown
						ldx #00
						jsr printcontrolsright
						ldx #00
						jsr printcontrolsquit
						ldx #00
						jsr printcontrolsstart
						ldx #00
						jsr printcontrolsreturn
						
						rts

printcontrolsheadertext		lda controlstextline1,x
							cmp #$23
							beq finishedprinting
							sta $04f9,x
							lda #$01
							sta $d8f9,x
							inx
							bne printcontrolsheadertext
							rts

printcontrolsup		lda controlstextup,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $0541,x
					lda #$01
					sta $d941,x
					inx
					bne printcontrolsup
					rts
				
printcontrolsleft	lda controlstextleft,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $0569,x
					lda #$01
					sta $d969,x
					inx
					bne printcontrolsleft
					rts
				
printcontrolsdown	lda controlstextdown,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $0591,x
					lda #$01
					sta $d991,x
					inx
					bne printcontrolsdown
					rts
				
printcontrolsright	lda controlstextright,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $05b9,x
					lda #$01
					sta $d9b9,x
					inx
					bne printcontrolsright
					rts

printcontrolsquit	lda controlstextquit,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $05e1,x
					lda #$01
					sta $d9e1,x
					inx
					bne printcontrolsquit
					rts

printcontrolsstart	lda controlstextstart,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $0609,x
					lda #$01
					sta $da09,x
					inx
					bne printcontrolsstart
					rts

printcontrolsreturn	lda controlstextreturn,x
					cmp #$23
					beq finishedcontrolsprinting
					sta $0631,x
					lda #$01
					sta $da31,x
					inx
					bne printcontrolsreturn
					rts

finishedcontrolsprinting rts

initoptionsscreen		lda #$01
						sta $d020 ; set border colour
						lda #$00
						sta $d021
						ldx #00
						jsr printoptionsheadertext
						ldx #00
						jsr printdiffilcultyoption
						ldx #00
						jsr printcontrolsreturn
						
						rts

printoptionsheadertext	lda optionstextline1,x
						cmp #$23
						beq finishedcontrolsprinting
						sta $04f9,x
						lda #$01
						sta $d8f9,x
						inx
						bne printoptionsheadertext
						rts

printdiffilcultyoption	lda optionscomingsoon,x
						cmp #$23
						beq finishedcontrolsprinting
						sta $05e1,x
						lda #$01
						sta $d9e1,x
						inx
						bne printdiffilcultyoption
						rts

showcollisionsquarestop		lda whiteblock
							sta $0400,x
							lda #01
							sta $d800,x
							inx
							cpx #40
							bne showcollisionsquarestop
							rts
							
showcollisionsquaresbottom		lda whiteblock
								sta $07c0,x
								lda #01
								sta $dbc0,x
								inx
								cpx #40
								bne showcollisionsquaresbottom
								rts

setzerocollisionsidesquares				lda whiteblock
										sta $0400
										sta $03ff
										sta $0517
										sta $0518
										sta $0608
										sta $0607
										sta $0720
										sta $071f
										lda #01
										sta $d828
										sta $d827
										sta $d918
										sta $d917
										sta $db20
										sta $db1f
										sta $da08
										sta $da07
										rts


showpageonesidesquares	    adc #$28
							bcs iscarryset
							tax
							lda whiteblock
							sta $0400,x ; comes back around after carry set
							sta $03ff,x
							lda #01
							sta $d828,x
							sta $d827,x
							txa
											
							bcc showpageonesidesquares ; keep going if no carry is set
							
							rts		

iscarryset rts		
											
showpagetwosidesquares		adc #$28
							bcs iscarryset
							tax
							lda whiteblock
							sta $0517,x
							sta $0518,x
							lda #01
							sta $d918,x
							sta $d917,x
							txa

							bcc showpagetwosidesquares

							rts

showpagethreesidesquares	adc #$28
							bcs iscarryset
							tax
							lda whiteblock
							sta $0608,x
							sta $0607,x
							lda #01
							sta $da08,x
							sta $da07,x
							txa
			
							bcc showpagethreesidesquares
				
							rts 

showpagefoursidesquares		adc #$28
							bcs iscarryset
							tax
							lda whiteblock
							sta $0720,x
							sta $071f,x
							lda #01
							sta $db20,x
							sta $db1f,x
							txa
							bcc showpagefoursidesquares
							
							rts












