this program shows how to reset the PRU cycle counter.

// Code:
// 5 times: reset the cycle counter, wait a second, then write the value of the cycle counter into the PRU0 data ram.
// After this, the data ram should show 1 second's worth of cycles, 5 times.

Sample output:


root@beaglebone:/home/debian/BB_PRU_stuff/Timing/02-Cycle-counter# ./run.sh


PRU Assembler Version 0.84
Copyright (C) 2005-2013 by Texas Instruments Inc.


Pass 2 : 0 Error(s), 0 Warning(s)

Writing Code Image of 30 word(s)

Hey, if you get a seg fault, make sure the EBB-PRU-Example device tree overlay has been loaded!!
Here's the cmd: root@beaglebone:~# echo EBB-PRU-Example > /sys/devices/bone_capemgr.9/slots
Executing bin file: ./reset-cycle-counter.bin
Waiting for 6 seconds...
Iter 0: cycles: 200000004 (1.000000 sec)
Iter 1: cycles: 200000004 (1.000000 sec)
Iter 2: cycles: 200000004 (1.000000 sec)
Iter 3: cycles: 200000004 (1.000000 sec)
Iter 4: cycles: 200000004 (1.000000 sec)
Shutting down.


