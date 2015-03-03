# Modified from Make Magazine project: Internet Speedometer
# Original Authors: Jon Marve & Tyler Worman
# Author: Tingzhi Li

import subprocess
import time
import pypruss
import sys

interval = 2
while 1:
	cmdstr = 'wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip 2>&1 | grep -o \'\([0-9.]\+ [KM]B/s\)\' | grep -o \'\([0-9.]\+\)\''
	cmd = subprocess.Popen(cmdstr, shell=True, stdout=subprocess.PIPE)
	lines = [line.strip() for line in open('speed.txt')]
	speed = [line.strip() for line in cmd.stdout]
	print lines[0]	# Need a file (speed.txt) with a number in it for this to work
	print speed[0]
	percentChange = ( ( float(speed[0]) - float(lines[0])) / float(lines[0])) * 100 	# Calculate the percentage change
	print percentChange

	# Write the most recent speed to speed.txt file.
	f = open('speed.txt', 'w')
	f.write (speed[0])
	f.close()

	pypruss.modprobe() 			  				       	
	pypruss.init()										# Initiate the PRU
	pypruss.open(0)										# Open PRU event 0 which is PRU0_ARM_INTERRUPT
	pypruss.pruintc_init()								# Initiate the interrupt controller

	if percentChange < -10:
		pypruss.exec_program(0,"./red.bin")				# Indicate worst case
	else: 
		if percentChange < -2:
			pypruss.exec_program(0,"./yellow.bin") 		# Indicate moderate case
		else:
			if percentChange > -2:
				pypruss.exec_program(0,"./green.bin")	# Indicate good case
			else:
				pypruss.exec_program(0,"./other.bin")   # Exception handle
		
	pypruss.wait_for_event(0)							# Wait for event 0 which is connected to PRU0_ARM_INTERRUPT
	pypruss.clear_event(0)								# Clear the event
	pypruss.pru_disable(0)								# Disable PRU 0, this is already done by the firmware
	pypruss.exit()										# Exits pypruss 
	time.sleep(interval)                        		# restarts speed evaluation after 'interval' seconds

