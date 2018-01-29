This program demonstrates how to use the cycle counter in the PRU to time how long various operations take.

Subsequent runs show the same cycle counter, since they load new code and restart the PRU.

Example output:

root@beaglebone:/home/debian/BB_PRU_stuff/Timing/01-Basic-timing-test# ./run.sh 


PRU Assembler Version 0.84
Copyright (C) 2005-2013 by Texas Instruments Inc.


Pass 2 : 0 Error(s), 0 Warning(s)

Writing Code Image of 17 word(s)

Hey, if you get a seg fault, make sure the EBB-PRU-Example device tree overlay has been loaded!!
Here's the cmd: root@beaglebone:~# echo EBB-PRU-Example > /sys/devices/bone_capemgr.9/slots
Executing bin file: ./timing-test.bin
Waiting...
Should be '0xbeefca1e': beefca1e
Cycle count before cmd: 5
Cycle count after cmd: 11
So it took 6 cycles to do the cmd (30 ns at 200MHz).
Shutting down.
