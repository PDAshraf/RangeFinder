/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <servo_motor_drivers.h>
#include <alt_types.h>

int pos=0;

int main()
{
  while(1){


	  servo_center();
	  printf("center\n");
	  for(size_t i=0;i<1000000;i++);
	  servo_180();
	  printf("180\n");
	  for(size_t i=0;i<1000000;i++);
	  servo_0();
	  printf("0\n");
	  for(size_t i=0;i<1000000;i++);
  }

  return 0;
}
