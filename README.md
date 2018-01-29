# Beaglebone-PRU-Basic-timing-example

A couple examples of how to use the PRU on the Beaglebone Black for timing.


Basic PRU timing test
----------------------

Here is a link to the BeagleBone book -- very useful background:

https://www.amazon.com/Exploring-BeagleBone-Techniques-Building-Embedded/dp/1118935128

You may be able to find a pdf of it online.

Here is the companion website for the book -- Chapter 13 talks about the PRU:

http://exploringbeaglebone.com/chapter13/

In this repo:

- `overlay/` has the device tree overlay to enable the PRU. Run the
'build' script to create "EBB-PRU-Example-00A0.dtbo", then copy it to
`/lib/firmware`, then enable it with:

    $ echo EBB-PRU-Example > /sys/devices/bone_capemgr.9/slots

- `chp13.zip` has all the code from Chapter 13 of the Exploring
Beaglebone book. I suggest starting with the PRUClock example, which
uses the PRU to toggle the voltage on pin P9_27 to be a square wave.

- `_prudebug-0.25.tar` contains a debugger for the PRU, which you may find useful.


Now you should run the code in `01-Basic-timing-test`.


The PRU Cycle Counter
-------------------------

Next it would be good to learn about the PRU cycle counter, which is a register in the PRU that increments with every PRU clock tick (200MHz). This is what I have been using as a rudimentary clock for when the PRU samples the sensors and changes the actuator value. 

The directory `02-Cycle-counter` contains some code that demonstrates how a C program can read the PRU cycle counter.



Future work
--------------

I have PRU code that allows the PRU to pass the C program a "data buffer": an array of 32 pairs (ti, si), i=1,...,32, where the sensor value si was measured at time ti, where "ti" is some PRU cycle count. It would be good to be able to convert this PRU cycle count time in terms of the OS time.

As an example involving actuation, suppose node A (the BB running the control algorithm) sends node B (the BB connected to the motor) a "command schedule": an array of pairs (ti,vi) where voltage vi should be applied at time ti (where "ti" is in terms of the QoT-shared timeline). I have PRU code that can apply a voltage at a particular time, but that time needs to be expressed as a PRU cycle count. It would be good if node B could convert the OS-time ti into a PRU cycle count. Then we could use my code to send the PRU that command schedule.
