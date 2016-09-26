
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

finishedprinting rts
				
printheadertext	lda menutextline1,x
				cmp #$23
				beq finishedprinting
				sta $0500,x
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
							sta $0517,x;$0518,x
							sta $0518,x;$0517,x
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











