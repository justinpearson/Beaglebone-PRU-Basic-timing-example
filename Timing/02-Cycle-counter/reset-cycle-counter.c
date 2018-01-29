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
   const char* binname =  "./reset-cycle-counter.bin";
   printf("Executing bin file: %s\n",binname);
   prussdrv_exec_program (PRU_NUM, binname);

   printf("Waiting for 6 seconds...\n"); 
   sleep(6);

   unsigned int* addr = pru0DataMemory_int;
   int i;
   for( i=0; i<5; i++ ) {
     unsigned int val = *(addr++);
       printf("Iter %d: cycles: %u (%lf sec)\n",i,val,5.0*val/1e9);
   }

   printf("Shutting down.\n");
   prussdrv_pru_disable(PRU_NUM);
   prussdrv_exit ();
   return EXIT_SUCCESS;
}
