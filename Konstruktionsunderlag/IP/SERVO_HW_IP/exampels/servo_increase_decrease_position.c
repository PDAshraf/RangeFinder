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

int m_pos;
char state;
enum state {increase_state,decrease_state};
int main()
{
	while(1)
	{

		switch(state){
		case increase_state:
			m_pos=m_pos+1;
			for(int i=0;i<10000000;i++);
			servo_position(m_pos);
			if(m_pos>=84)
			{
				state=decrease_state;
			}
			break;
		case decrease_state:
			m_pos=m_pos-1;
			for(int i=0;i<10000000;i++);
			servo_position(m_pos);
			if(m_pos<=14)
			{
				state=increase_state;
			}
			break;

		}

	}

  return 0;
}
