
BUG_CANDIDATE: 
It seems that the command "synth_ice40" is NOT idempotent.

To reproduce you will need an ice40 based card that has at least one led.

This code is for the Go Board:
https://www.nandland.com/goboard/introduction.html

If you do not have a Go Board change the file "GO_BOARD.pcf" with the specs for the led in your board.
And then:

-	make
-	make prog

The led WILL turn ON !

If you comment the line in "rtl/synth.tcl" with the first "synth_ice40" command and then 

-	make 
-	make prog

The led WILL NOT turn ON !

