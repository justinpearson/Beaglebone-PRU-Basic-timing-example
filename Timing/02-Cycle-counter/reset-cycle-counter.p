// Reset the cycle counter when it gets too big.

#define ADDR_PRU0_CTRL 0x00022000
#define ADDR_CYCLE_COUNTER 0x0002200C	
#define tmp0 r0
#define tmp1 r1
#define tmp2 r2
#define tmp3 r3
#define counter r4
#define offset r5

#define rPRU0_DATA_RAM r9
#define rCYCLE_COUNTER r10
#define cycles r11
#define rPRU0_CTRL r12
	
#define PRU0_ARM_INTERRUPT 19
.origin 0
.entrypoint START
START:
	


	
// Set up the PRU's ability to access memory outside its own private 8kB data ram
// http://exploringbeaglebone.com/chapter13/#The_Programs

// TRM 4.3.1.2 (Local Data Memory Map): The PRU accesses the external
//	Host memory map through the Interface / OCP Master port. (...)
//	The feature is enabled through teh PMAO register of the
//	PRU-ICSS CFG register space.


// The PRU has a bunch of registers in a so-called "Constants table"
// that contain commonly-used addresses. 
// Note: see am335x TRM, 4.4.1.1: Constants Table:
// C4 : PRU-ICSS CFG (local) 0x0002_6000
// TRM 4.5.7.2: SYSCFG register is 0x4 offset from the PRU_ICSS_CFG register base
// Bit 4: STANDBY_INIT field (0 = Enable OCP master ports.)

	
  // Enable the OCP master port -- allows transfer of data to Linux userspace
  LBCO    tmp0, C4, 4, 4     // load SYSCFG reg into tmp0 (use c4 const addr)
  CLR     tmp0, tmp0, 4        // clear bit 4 (STANDBY_INIT) (0 = Enable OCP master ports.)
  SBCO 	  tmp0, C4, 4, 4     // store the modified tmp0 back at the load addr
	
// Enable cycle counter
// http://www.embedded-things.com/bbb/understanding-bbb-pru-shared-memory-access/
// https://github.com/omcaree/bbb-prupwm/blob/master/include/pru.hp
// http://theembeddedkitchen.net/beaglelogic-building-a-logic-analyzer-with-the-prus-part-1/449

// 4.5.1.8	CTPPR0 Register (offset = 28h) [reset = 0h]:
//CONSTANT TABLE PROGRAMMABLE POINTER REGISTER 0. This register allows the PRU to set up
// the 256-byte page index for entries 28 and 29 in the PRU Constant Table which serve as general purpose
// pointers which can be configured to point to any locations inside the session router address map. This
// register is useful when the PRU needs to frequently access certain structures inside the session router
// address space whose locations are not hard coded such as tables in scratchpad memory

// Omg why bother editing the constants table just to get the cycle counter register into it,
//  just use up a damn register how about.
	
//#define CTBIR   0x22020  // Address for the Constant table Block Index Register (CTBIR)
//#define CTPPR_0 0x22028  // Address for the Constant table Programmable Pointer Register 0(CTPPR_0)
//#define CTPPR_1 0x2202C  // Address for the Constant table Programmable Pointer Register 1(CTPPR_1)
	
//  MOV    R1, CTPPR_0
//  MOV    R2, 0x00000220      // C28 = 00_0220_00h = PRU0 CFG Registers
//  SBBO   R2, R1, 0, 4

//  LBCO   R1, C28, 0, 4      // Enable CYCLE counter
//  SET    R1, 3
//  SBCO   R1, C28, 0, 4



  MOV rPRU0_CTRL, ADDR_PRU0_CTRL // PRU0 CTRL register -- reg where 'cycle ctr enable' lives (only do this once)

  // "Cycle counter": TRM 4.5.1 (PRU_ICSS_PRU_CTRL regs: 0x00022000 for PRU0), offset 0xC: 32-bit CYCLE register	
  MOV rCYCLE_COUNTER, ADDR_CYCLE_COUNTER // PRU0 cycle counter	


// Code:
// 5 times: reset the cycle counter, wait a second, then write the value of the cycle counter into the PRU0 data ram.
// After this, the data ram should show 1 second's worth of cycles, 5 times.

 MOV counter, 0
 MOV offset, 0 // where we're writing in the PRU data ram
#define PRU0_DATA_RAM 0x00000000
 MOV rPRU0_DATA_RAM, PRU0_DATA_RAM

BEGIN_LOOP:

	// Disable cycle counter
	// "Cycle counter enable": bit 3 of CTRL register (4.5.1.1):
	// 0h offset in PRU_ICSS_PRU_CTRL registers (4.5.1):
	// 0x00022000 in 4.3.1.2 Local Data Memory Map
	LBBO tmp0, rPRU0_CTRL, 0, 4   // read PRU_CTRL reg into register tmp0
	CLR  tmp0.t3  	              // clr 'cycle ctr enable' bit
	SBBO tmp0, rPRU0_CTRL, 0, 4         // push tmp0 back into the CTRL reg

	// Reset cycle counter to 0
	MOV tmp0, 0
	SBBO tmp0, rCYCLE_COUNTER, 0, 4

	// Enable cycle counter
	LBBO tmp0, rPRU0_CTRL, 0, 4   // read reg into register tmp0
	SET  tmp0.t3  	              // set 'cycle ctr enable' bit
	SBBO tmp0, rPRU0_CTRL, 0, 4         // push tmp0 back into the CTRL reg

	// Wait a second
	// 1 sec * (200e6 cyc/sec) * (1 instr/cycle) * (1 wait_loop/ 2 instrs) = 100e6 wait loops
	MOV tmp0, 100000000
WAIT:
	SUB tmp0, tmp0, 1
	QBNE WAIT, tmp0, 0

GET_AND_STORE_CYCLES:
	LBBO tmp0, rCYCLE_COUNTER, 0, 4
	SBBO tmp0, rPRU0_DATA_RAM, offset, 4
	ADD offset, offset, 4

MABYE_QUIT:	
	// If we've done it 5 times, quit.
	ADD counter, counter, 1
	QBNE BEGIN_LOOP, counter, 5
	QBA QUIT
	
QUIT:
        MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
        HALT
