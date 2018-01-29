// Time how long it takes the PRU to do something.
// Justin Pearson
// Aug 19, 2016

#include <stdio.h>
#include <stdlib.h>
#include <prussdrv.h>
#include <pruss_intc_mapping.h>
#include <unistd.h> // for sleep, usleep

#define PRU_NUM	   0   // using PRU0 for these examples
#define MMAP_LOC   "/sys/class/uio/uio0/maps/map0/"

int main (void)
{

  printf("Hey, if you get a seg fault, make sure the EBB-PRU-Example device tree overlay has been loaded!!\n");

  printf("Here's the cmd: root@beaglebone:~# echo EBB-PRU-Example > /sys/devices/bone_capemgr.9/slots\n");

   if(getuid()!=0){
      printf("You must run this program as root. Exiting.\n");
      exit(EXIT_FAILURE);
   }
   // Initialize structure used by prussdrv_pruintc_intc
   // PRUSS_INTC_INITDATA is found in pruss_intc_mapping.h
   tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

   // Allocate and initialize memory
   prussdrv_init ();
   prussdrv_open (PRU_EVTOUT_0);

   // Map PRU's interrupts
   prussdrv_pruintc_init(&pruss_intc_initdata);

   // Get pointer to PRU data RAM:
   void *pru0DataMemory;
   unsigned int *pru0DataMemory_int;
   prussdrv_map_prumem(PRUSS0_PRU0_DATARAM, &pru0DataMemory);
   pru0DataMemory_int = (unsigned int *) pru0DataMemory;

   // Load and execute the PRU program on the PRU
   const char* binname =  "./timing-test.bin";
   printf("Executing bin file: %s\n",binname);
   prussdrv_exec_program (PRU_NUM, binname);

   printf("Waiting...\n"); 
   usleep(100000);

   unsigned int val =  *pru0DataMemory_int;
   unsigned int val2 =  *(pru0DataMemory_int+1);
   unsigned int val3 =  *(pru0DataMemory_int+2);

   printf("Should be '0xbeefca1e': %x\nCycle count before cmd: %u\nCycle count after cmd: %u\n",val,val2,val3);

   printf("So it took %u cycles to do the cmd (%u ns at 200MHz).\n",(val3-val2),5*(val3-val2));

   printf("Shutting down.\n");
   prussdrv_pru_disable(PRU_NUM);
   prussdrv_exit ();
   return EXIT_SUCCESS;
}
