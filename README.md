# 64 SNAKE!

A snake game project, built for the commodore 64 in 6502 assembly.

* Inspiration taken from this website https://skilldrick.github.io/easy6502/. 
* Resources heavily leveraged from http://dustlayer.com/tutorials/ http://sta.c64.org/cbm64scr.html http://www.6502.org/tutorials/6502opcodes.html
http://sta.c64.org/cbm64mem.html
* Custom tailored for the commodore 64 memory map.
* Doesn't use zero page addresses to keep BASIC functional.
* Project layout based on dustlayer project layouts (with high level index.asm as assembly target).
* Assemble with acme assembler - using acme opcodes.
* Default controls with W,A,S,D - no joystick support.
* Builds to .prg file which works in VICE.

SOURCES

* acmecrosscompiler: https://sourceforge.net/projects/acme-crossass/
Download or pull from svn repo, extract to folder then copy / symlink acme bin file to /usr/local/bin/acme
* Vice - commodore 64 / 128 emulator: http://vice-emu.sourceforge.net/
Download tarball, extract and run /src/x64 binary from terminal. To run .prgs it might be required to set PRG autostart mode to virtual FS (File/autostartsettings/prg autostartmode/virtualFS)
* Compatible with eclipse or any text editor.

ASSEMBLY

* In a terminal run acme path-to-file/index.asm (depending on permissions, elevate to sudo) (if acme is not installed to system bin, use extracted acme path). This assembles
the .asm sources into a .prg file (as specified in the index.asm file)
* From the index.asm file, sources are read to the other files in the project - make sure dependancies are in logical order (if you have a jsr or jmp or call to a symbol from one file to another, that file with the 
reference must be included first).
* Main.asm is the entry point to the program (where the * load instruction is located).

VICE

* To run in VICE, select file/smart attach disk/tape/ select assembled .prg file from file browser.

CURRENT FEATURES

* Control a snake through four directions of movement, up, down, left, right to eat the randomly placed apple!
* Beat your high score!
* Each apple eaten increases both the length of the snake and the speed of the snakes movement - see how long you can survive!
* Don't touch the sides or yourself! 

UPDATES TO COME

* Timer - timed windows in which to eat the apple. Extra points for less time taken to eat the apple.
* Levels - Point threasholds for levels which increase diffilculty for player and introduce different maps.
* Graphical updates - apple and snake actually look like snakes and apples! Realistic movement animations, character attributes.
* Diffilculty settings, playmodes - faster start speed, snake tail unpredictablility (i.e. the snake tail can break off and become an enemy), mines, random ai enemies
* Powerups, boosts, status modifiers - invincibilty for limited periods of time (enemies have no effect, player can kill enemies), wrap mode (can pass from one side of the screen to the other) for a limited time, speed modifers (can slow snake speed), tail shortening (snake tail can be removed and converted to points) - these modifications would balance the game.
* Music. 
* Move graphical commands to be run on the raster interrupt.
* User controls setup.
* High scores (remember the top 5 high scores).
* Attract mode.

KNOWN BUGS / ISSUES
 
* Text layout not centered etc.
* Flickering in menu transition.
* Options menu not implemented.
* Initial start has blackblock tail.
* Game is not balanced - diffilcult to progress much further than 30 points.
* Apple displays in score text on occasion.
 