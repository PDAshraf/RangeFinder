/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *      Range source file                                                    *
 *      Read distance values to print on a monitor and resets                *
 *      the watchdog timer.                                                  *
 *****************************************************************************/

#include <stdio.h>
#include <alt_types.h>
#include <io.h>
#include <system.h>
#include <altera_avalon_sierra_ker.h>
#include "main_range_finder.h"
#include "def_var.h"

void task_range_code(void)
{
    printf("Range Init\n");
    task_periodic_start_union test;
    {
        init_period_time(25);
        alt_u16 range;
        while(1)
        {
            test = wait_for_next_period();
            if(test.periodic_start_integer & 0x01)
            printf("Deadline miss, Task_Range_Code");
            sem_take(SEM3);
            distance = IORD_32DIRECT(DISTANCE_IN_BASE, 0);
            range = distance;
            dist_sum = dist_sum + range;
            sem_release(SEM3);
            printf("%ld cm\n",range);
            tty_print(5, 220, "Distance:", COLOR_GREEN,COLOR_BLACK);
            int_print(75, 220, range,3, COLOR_WHITE,COLOR_BLACK);

            //Watchdog Timer
            IOWR_8DIRECT(PIO_OUT_WD_BASE,0,1);      // restart(HW) std_logic = '1'. To reset Watchdog Hardware timer
            IOWR_8DIRECT(PIO_OUT_WD_BASE,0,0);      // restart(HW) std_logic = '0'. Watchdog Hardware timer counting


        }
    }
}

