!cpu 6502 

!to "snake.prg",cbm    ; output file 



; useful links  

; http://sta.c64.org/cbm64scr.html 

; http://www.1000bit.it/support/manuali/commodore/c64/Machine_Code_Games_Routines_for_the_Commodore_64.pdf 

; aa 

; http://sta.c64.org/cbm64mem.html 

; http://www.binaryhexconverter.com/decimal-to-hex-converter 

; http://sta.c64.org/cbm64krnfunc.html 



;============================================================ 

; BASIC loader with start address $c000 

;============================================================ 

* = $2000
!bin "sprites/snakeHeadAnimation.spr",256,3
* = $2100
!bin "sprites/snakeattractbody.spr",64,3

* = $0801                                ; BASIC start address (#2049) 

!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000... 

!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152 

!source "symbols.asm"
!source "graphics.asm"
!source	"menu.asm"
!source "core.asm" 
!source "collision.asm"

!source "main.asm"

