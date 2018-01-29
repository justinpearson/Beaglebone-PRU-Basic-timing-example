// timing-test.p: simple test of the CYCLE counter on the PRU
// justin
// aug 19, 2016

#define PRU0_ARM_INTERRUPT 19
	
    .origin 0
    .entrypoint START

    START:


// Enable cycle counter

	// First define some regs
	// source: http://www.embedded-things.com/bbb/understanding-bbb-pru-shared-memory-access/
	// Source: https://github.com/omcaree/bbb-prupwm/blob/master/include/pru.hp

	// Address for the Constant table Block Index Register (CTBIR)
	#define CTBIR          0x22020

	// Address for the Constant table Programmable Pointer Register 0(CTPPR_0)
	#define CTPPR_0         0x22028

	// Address for the Constant table Programmable Pointer Register 1(CTPPR_1)
	#define CTPPR_1         0x2202C
	

	// source:
	// http://theembeddedkitchen.net/beaglelogic-building-a-logic-analyzer-with-the-prus-part-1/449
	MOV    R1, CTPPR_0
	MOV    R2, 0x00000220      // C28 = 00_0220_00h = PRU0 CFG Registers
	SBBO   R2, R1, 0, 4

	LBCO   R1, C28, 0, 4      // Enable CYCLE counter
	SET    R1, 3
	SBCO   R1, C28, 0, 4


	MOV R3, 0 // PRU Data Ram
	MOV R4, 0xbeefca1e // silly val to copy into pru data ram
	
	// So, whenever we need to time a section of the code, we can do something like:
	LBCO R1, C28, 0xC, 4     // Load "before" cycle count into R1
	// your assembly code here
	// ...
	SBBO R4, R3, 0, 4 // copy silly value into data ram
	
	LBCO R2, C28, 0xC, 4     // Load "after" cycle count into R2

	SBBO R1, R3, 4, 4  // "start" time
	
	SBBO R2, R3, 8, 4  // "end" time


        MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
        HALT
