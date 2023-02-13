# VHDL_drivers
This repository contains all the drivers i have created for the CMOD A7 fpga in vhdl.

The DriverTester can aid in the incorporating of the drivers as inspiration
The DriverTesterConstraints IS ONLY ment to be used if all pins are connected to the right pins on the SAME board (CMOD A7).
If you dont use this board please change the pins accordingly and result the datasheet of your FPGA. Not doing this can result of the destruction of your FPGA.

The LCD_driver drives a standard 16x2 display such as those typically used in arduino projects. It has been inspired by the project linked below by: Maeur1
https://github.com/Maeur1/16x2-LCD-Controller-VHDL
I primarily added the convertions from binary to a string making in easier to change the text. 
The rest of the characters can be added in the case statement following the same protocol. I just dont need them

The 7SEG_driver drives a standard 8 segment display (7 number led's and one dot led).
This one is quite simple and has been constructed solely by me
