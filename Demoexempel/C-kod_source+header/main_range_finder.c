/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *      Main file in which contain a state machine.                          *
 *      start_screen_state - Generate start screen with information          *
 *      test_state - Function which by switches 0-2 generates positions      *
 *                     values for the servo motor                            *
 *      range_run_state - the software starts, distance measurement at       *
 *                        different angles is visualized on a vga screen     *
 *                         and writes the distance values on screen in       *
 *                         real time                                         *
 *****************************************************************************/

//Sierra RTK
#include <altera_avalon_sierra_ker.h>
#include <altera_avalon_sierra_io.h>
#include <altera_avalon_sierra_regs.h>
#include <altera_avalon_sierra_name.h>


#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include <system.h>
#include <alt_types.h>


//Tasks
#include "task_idle_code.h"
#include "task_avg_range_code.h"
#include "task_range_code.h"
#include "task_servo_position_code.h"
#include "task_range_print_code.h"

#include "def_var.h"
#include "main_range_finder.h"

//Drivers & Functions
#include <altera_avalon_pio_regs.h>
#include <altera_avalon_timer_regs.h>
#include <soft_drivers.h>
#include <draw_vga.h>
#include <DE10_Lite_VGA_Driver.h>
#include <servo_motor_drivers.h>



/********************
 * MAIN             *
 ********************/
int main (void)
{
    enum {start_screen_state,test_state, range_run_state}state ;
    //Sierra Help function
    Sierra_Initiation_HW_and_SW();

    //Printa HW/SW Versioner
    printf(" Sierra HW version = %d\n", sierra_HW_version());
    printf(" Sierra SW driver version = %d\n", sierra_SW_driver_version());


    /*******************************************
     * 50MHz Systemfrekvens                    *
     * 20ms(50Hz) Tick periodtid               *
     * ----------------------------------------*
     * 20ms x 50Mhz / 1000 => 1000(dec)        *
     * Resultat: set_timebase(1000)            *
     *******************************************/
    set_timebase(1000);

    //TaskCreate
    task_create(IDLE, 0, READY_TASK_STATE,task_idle_code, idle_stack, STACK_SIZE);
    task_create(Task_Avg_Range,1, READY_TASK_STATE,task_avg_range_code, task_avg_range_stack, STACK_SIZE);
    task_create(Task_Range,2, READY_TASK_STATE, task_range_code, task_range_stack, STACK_SIZE);
    task_create(Task_Servo_Position,3, READY_TASK_STATE, task_servo_position_code, task_servo_position_stack,STACK_SIZE);
    task_create(Task_Range_Print,4, READY_TASK_STATE, task_range_print_code, task_range_print_stack,STACK_SIZE);


    while(1)
    {
        switch(state)
        {
                case start_screen_state:
                    printf("StarScreen\n");
                    init_screen();
                    while(1)
                    {
                    	int key_in0 = KEY_0 ^ (KEY_0 & IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE));
                    	int key_in1 = KEY_1 ^ (KEY_1 & IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE));

                        if(key_in0)
                        {
                            DELAY(DELAY_1ms);
                            state=test_state;
                            break;
                        }

                        else if(key_in1)
                        {
                        	DELAY(DELAY_1ms);
                            state=range_run_state;
                            break;
                        }
                    }
                break;


                case test_state:
                    printf("Test");
                    clear_screen(COLOR_BLACK);
                    testFunction();
                    state=start_screen_state;

                break;


                case range_run_state:
                    printf("range_run\n");
                    clear_screen(COLOR_BLACK);
                    pattern();
                    tsw_on();
                    state = range_run_state;

                    break;

                default:
                    state = start_screen_state;

        }
    }

    printf("* Error! SYSTEM FAILED *\n");
}


