// from
	// https://github.com/Teknoman117/beaglebot/tree/master/encoders
	// beaglebot/encoders/patches/sources/tieqep.c

// justin
	// aug 23, 2016
	// we're trying to make a PRU .p program that 

// pg 183 (memory map) of am335x trm
#define EQEP0_BASE_ADDR 0x48300180
#define EQEP1_BASE_ADDR 0x48302180
#define EQEP2_BASE_ADDR 0x48304180

// eQEP register offsets from its base IO address
#define QPOSCNT    0x0000
#define QPOSINIT   0x0004
#define QPOSMAX    0x0008
#define QPOSCMP    0x000C
#define QPOSILAT   0x0010
#define QPOSSLAT   0x0014
#define QPOSLAT    0x0018
#define QUTMR      0x001C
#define QUPRD      0x0020    
#define QWDTMR     0x0024
#define QWDPRD     0x0026
#define QDECCTL    0x0028
#define QEPCTL     0x002A
#define QCAPCTL    0x002C
#define QPOSCTL    0x002E
#define QEINT      0x0030
#define QFLG       0x0032
#define QCLR       0x0034
#define QFRC       0x0036
#define QEPSTS     0x0038
#define QCTMR      0x003A
#define QCPRD      0x003C
#define QCTMRLAT   0x003E
#define QCPRDLAT   0x0040
#define QREVID     0x005C

// Bits for the QDECTL register
#define QSRC1      (0x0001 << 15)
#define QSRC0      (0x0001 << 14)
#define SOEN       (0x0001 << 13)
#define SPSEL      (0x0001 << 12)
#define XCR        (0x0001 << 11)
#define SWAP       (0x0001 << 10)
#define IGATE      (0x0001 << 9)
#define QAP        (0x0001 << 8)
#define QBP        (0x0001 << 7)
#define QIP        (0x0001 << 6)
#define QSP        (0x0001 << 5)

// Bits for the QEPCTL register
#define FREESOFT1  (0x0001 << 15)
#define FREESOFT0  (0x0001 << 14)
#define PCRM1      (0x0001 << 13)
#define PCRM0      (0x0001 << 12)
#define SEI1       (0x0001 << 11)
#define SEI0       (0x0001 << 10)
#define IEI1       (0x0001 << 9)
#define IEI0       (0x0001 << 8)
#define SWI        (0x0001 << 7)
#define SEL        (0x0001 << 6)
#define IEL1       (0x0001 << 5)
#define IEL0       (0x0001 << 4)
#define PHEN       (0x0001 << 3)
#define QCLM       (0x0001 << 2)
#define UTE        (0x0001 << 1)
#define WDE        (0x0001 << 0)

// Bits for the QCAPCTL register
#define CEN        (0x0001 << 15)
#define CCPS2      (0x0001 << 6)
#define CCPS0      (0x0001 << 5)
#define CCPS1      (0x0001 << 4)
#define UPPS3      (0x0001 << 3)
#define UPPS2      (0x0001 << 2)
#define UPPS1      (0x0001 << 1)
#define UPPS0      (0x0001 << 0)

// Bits for the QPOSCTL register
#define PCSHDW     (0x0001 << 15)
#define PCLOAD     (0x0001 << 14)
#define PCPOL      (0x0001 << 13)
#define PCE        (0x0001 << 12)
#define PCSPW11    (0x0001 << 11)
#define PCSPW10    (0x0001 << 10)
#define PCSPW9    (0x0001 << 9)
#define PCSPW8    (0x0001 << 8)
#define PCSPW7    (0x0001 << 7)
#define PCSPW6    (0x0001 << 6)
#define PCSPW5    (0x0001 << 5)
#define PCSPW4    (0x0001 << 4)
#define PCSPW3    (0x0001 << 3)
#define PCSPW2    (0x0001 << 2)
#define PCSPW1    (0x0001 << 1)
#define PCSPW0    (0x0001 << 0)

// Bits for the interrupt registers
#define EQEP_INTERRUPT_MASK (0x0FFF)
#define UTOF                (0x0001 << 11)

// Bits to control the clock in the PWMSS subsystem
#define PWMSS_EQEPCLK_EN        BIT(4)
#define PWMSS_EQEPCLK_STOP_REQ  BIT(5)
#define PWMSS_EQEPCLK_EN_ACK    BIT(4)

// Modes for the eQEP unit
//  Absolute - the position entry represents the current position of the encoder.
//             Poll this value and it will be notified every period nanoseconds
//  Relative - the position entry represents the last latched position of the encoder
//             This value is latched every period nanoseconds and the internal counter
//             is subsequenty reset
#define TIEQEP_MODE_ABSOLUTE    0
#define TIEQEP_MODE_RELATIVE    1

// Maybe if we've loaded the DTO, maybe it's already running.




	
	
    #define PRU0_ARM_INTERRUPT 19

// Next we `#define` the ADC offset registers.

    #define ADDR_OF_ADC         0x48302180 // HACK!!!: // EQEP0_BASE_ADDR // old: 0x44e0d000
    #define OFFSET_CTRL         0x0040
    #define OFFSET_ADCSTAT      0x0044
    #define OFFSET_ADC_CLKDIV   0x004c
    #define OFFSET_STEPENABLE   0x0054
    #define OFFSET_STEPCONFIG1  0x0064
    #define OFFSET_STEPDELAY1   0x0068
    #define OFFSET_FIFO0COUNT   0x00e4
    #define ADDR_OF_FIFO0DATA   (ADDR_OF_ADC + 0x0100)

// We'll set up these variable names instead of using the raw register names: 

    // Scratch registers:
    #define tmp0        r1
    #define tmp1        r2
    #define tmp2        r3
    #define tmp3        r4
    #define tmp4        r5

    // Regs for memory addrs (eg, ADDR_OF_FIFO0DATA etc.)
    #define reg_ADDR_OF_ADC        r6
    #define reg_ADDR_OF_FIFO0DATA   r7
    #define out_buff    r8
    #define reg_PRU_DATA_RAM_BASE      r9   // Data RAM addr 0x00000000

    #define value       r10
    #define channel     r11
    #define ema         r12
    #define encoders    r13
    #define cap_delay   r14


// Start the code:

    .origin 0
    .entrypoint START

    START:





	

// Set up the PRU's ability to access memory outside its own private 8kB data ram
	// http://exploringbeaglebone.com/chapter13/#The_Programs
	LBCO r0, C4, 4, 4		// Load Bytes Constant Offset (?)
	CLR  r0, r0, 4			// Clear bit 4 in reg 0
	SBCO r0, C4, 4, 4		// Store Bytes Constant Offset



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



	

        MOV reg_ADDR_OF_ADC, ADDR_OF_ADC                  // I guess it should be in a register, not just a #define
        MOV reg_ADDR_OF_FIFO0DATA, ADDR_OF_FIFO0DATA      // same.
        MOV reg_PRU_DATA_RAM_BASE, 0                      // same. 


	
// // Next, before we configure the ADC, we should disable it. 
// // Looks like we just set the lowest bit to "off":        

//         // Disable ADC
//         LBBO tmp0, reg_ADDR_OF_ADC, OFFSET_CTRL, 4
//         CLR  tmp0.t0
//         SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_CTRL, 4


// // To set at full speed, set the clock-divider to 0:

//         // Put ADC capture to its full speed
//         MOV tmp0, 0    // just write 0 to the whole reg?
//         SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_ADC_CLKDIV, 4

// // Now we configure the first step of the ADC-conversion-state-machine. 

// // Initially disable all steps of the state machine.
// // We'll trigger a sample by enabling one later on.
// // See "single-shot" vs "continuous" in TRM.

//         LBBO tmp0, reg_ADDR_OF_ADC, OFFSET_STEPENABLE, 4
//         CLR  tmp0, 16   // top 16 bits are reserved.
//         SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_STEPENABLE, 4


// // Configure the 1st step: 
 

// // Use `SET` and `CLR` here to set the bits correctly. (Note: everything's spelled out here for pedagogical purposes; could shorten the code a lot.)

//         LBBO tmp0, reg_ADDR_OF_ADC, OFFSET_STEPCONFIG1, 4
//         CLR tmp0.t27   // disable range-check
//         CLR tmp0.t26   // store in FIFO0
//         CLR tmp0.t25   // differential ctrl pin (?)


//         // SEL_RFM pins SW configuration. (?)
//         CLR tmp0.t24
//         CLR tmp0.t23   


//         // SEL_INP pins SW configuration. (0000 = Channel 1, 0111 = Channel 8)
//         CLR tmp0.t22
//         CLR tmp0.t21
//         CLR tmp0.t20
//         CLR tmp0.t19

//         // SEL_INM pins for negative differential. (?) (0000 = Channel 1, 0111 = Channel 8)
//         CLR tmp0.t18
//         CLR tmp0.t17
//         CLR tmp0.t16
//         CLR tmp0.t15

//         // SEL_RFP pins SW configuration. (000 = VDDA_ADC)
//         CLR tmp0.t14
//         CLR tmp0.t13
//         CLR tmp0.t12

//         // WPNSW pin SW configuration (, YPNSW, XNPSW, ... ) (???)
//         CLR tmp0.t11
//         CLR tmp0.t10
//         CLR tmp0.t9
//         CLR tmp0.t8        
//         CLR tmp0.t7        
//         CLR tmp0.t6        
//         CLR tmp0.t5        

//         // Number of samplings to average: 
//         // 000 = No average.
//         // 001 = 2 samples average.
//         // 010 = 4 samples average.
//         // 011 = 8 samples average. 100 = 16 samples average.
//         CLR tmp0.t4
//         CLR tmp0.t3
//         CLR tmp0.t2

//         // Mode:
//         // 00 = SW enabled, one-shot.
//         // 01 = SW enabled, continuous.
//         // 10 = HW synchronized, one-shot. 
//         // 11 = HW synchronized, continuous.        
//         CLR tmp0.t1
//         CLR tmp0.t0


// // Q: If it's one-shot, does that mean we have to re-enable not the whole ADC but the STEPENABLE reg each time? Yes, I think so.

//         // Write it back to the ADC register:
//         SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_STEPCONFIG1, 4

// // Now we're ready to enable the ADC:
//         LBBO tmp0, reg_ADDR_OF_ADC, OFFSET_CTRL, 4

//         SET  tmp0.t2 // 1 = Step configuration registers are writable. Needed to trigger a sample.
//         SET  tmp0.t1 // 1 = Store the Step ID number with the captured ADC data in the FIFO. (good to verify correct channel is being read)
//         SET  tmp0.t0 // 1 = Turn on the ADC. 

//         SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_CTRL, 4

// // Sample:
// 	MOV tmp0, 2   // don't want 0th bit: "enable TS charge step", want bit 1: enable step 1.
// 	SBBO tmp0, reg_ADDR_OF_ADC, OFFSET_STEPENABLE, 4   // triggers a capture / sample!


// ENABLE_EQEP:
// 	LBBO tmp0, reg_ADDR_OF_ADC, QEPCTL, 4
// 	OR tmp0, tmp0, PHEN
// 	SBBO tmp0, reg_ADDR_OF_ADC, QEPCTL, 4

// // Spin while there's nothing in the FIFO:

//     WAIT_FOR_FIFO0:
//         LBBO tmp0, reg_ADDR_OF_ADC, OFFSET_FIFO0COUNT, 4
//         AND tmp0, tmp0, 127    // only bits 0 thru 6 are unreserved, so turn others off and keep only bits 0-6.
//         QBEQ WAIT_FOR_FIFO0, tmp0, 0

    RETRIEVE_VALUE:
        LBBO tmp0, reg_ADDR_OF_ADC, QPOSCNT, 4 // read eqep0 position counter 
	LBCO tmp2, C28, 0xC, 4     // Load cycle count into reg tmp2
	SBBO tmp0, reg_PRU_DATA_RAM_BASE, 0, 4 //  copy eqep  value to PRU data ram
	SBBO tmp2, reg_PRU_DATA_RAM_BASE, 4, 4  // "start" time

	// reset cycle counter (just for testing)
	LBCO   tmp3, C28, 0, 4
	CLR    tmp3.t3
	SBCO   tmp3, C28, 0, 4
	SET    tmp3.t3
	SBCO   tmp3, C28, 0, 4
	
	
	MOV tmp1, 10000  // this many iters, read encoder and write to data ram
WAIT:	
	SUB tmp1, tmp1, 1
	QBNE WAIT, tmp1, 0
	QBA RETRIEVE_VALUE

	// never quits



    QUIT:
        MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
        HALT
