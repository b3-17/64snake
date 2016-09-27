							
testcollisions				lda $11
							ldx #$00
							cmp #$04
							beq testtopcollisions
							ldx #$c0
							cmp #$07
							beq testbottomcollisions
							rts
	
testtopcollisions			cpx $10
							beq collisiongameover
							inx
							cpx #40 ; was using decimal!!! silly
							bne testtopcollisions
							rts
							
testbottomcollisions		lda $10
							cpx $10
							inx
							cpx #40 ; drop out of bottom testing
							bne testbottomcollisions
							rts
									
collided					brk ; later on can put game over routine here
						
collisiongameover	jsr clear ;
					jsr inithomescreen
					jmp menuloop ; later on can put game over routine here	

testsnakecollision	ldx currentpositionL
					lda currentpositionH
					cmp #$04
					beq testpageonesnakecollision 
					cmp #$05
					beq testpagetwosnakecollision
					cmp #$06
					beq testpagethreesnakecollision
					cmp #$07
					beq testpagefoursnakecollision
							
					rts
					
testpageonesnakecollision	lda $0400, x
							cmp whiteblock
							beq collisiongameover 
							rts

testpagetwosnakecollision	lda $0500, x
							cmp whiteblock
							beq collisiongameover
							rts

testpagethreesnakecollision	lda $0600, x
							cmp whiteblock
							beq collisiongameover
							rts

testpagefoursnakecollision	lda $0700, x
							cmp whiteblock
							beq collisiongameover
							rts





