# RYG Tri-color Internet Speedometer

Using red, yellow, and green to indicate the current internet speed.
## Hardware
Each LED is connected to a 330Ohm resistor.

- Red LED: P8_12
- Yellow LED: P8_11
- Green LED: P9_27

## Software
Copy the device tree file BB-BONE-PRU-RYG-00A0.dts to /lib/firmware

To compile 
	
	dtc -O dtb -o BB-BONE-PRU-RYG-00A0.dtbo -b O -@ BB-BONE-PRU-RYG-00A0.dts

Make sure this is run on each boot:

	export PINS=/sys/kernel/debug/pinctrl/44e10800.pinmux/pins
	export SLOTS=/sys/devices/bone_capemgr.*/slots
	echo BB-BONE-PRU-RYG > $SLOTS
	
To run the program
	
	python RYGspeedTest.py

