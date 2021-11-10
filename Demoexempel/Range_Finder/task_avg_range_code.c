/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *      Avrage range source file.                                            *
 *      Rounds to average distance and print values on a monitor             *
 *****************************************************************************/

#include <stdio.h>
#include <alt_types.h>
#include <io.h>
#include <system.h>
#include <altera_avalon_sierra_ker.h>
#include "main_range_finder.h"
#include "def_var.h"

void task_avg_range_code(void)
{
    printf("Range Avg\n");
    task_periodic_start_union test;
    {
        init_period_time(500);
        while(1)
        {

            test = wait_for_next_period();
            if(test.periodic_start_integer & 0x01)
            printf("Deadline miss, Task_avg_Range_Code");

            dist_avg=(dist_sum/20);

            tty_print(160, 220, "Avg:", COLOR_GREEN,COLOR_BLACK);
            int_print(200, 220, dist_avg,3, COLOR_WHITE,COLOR_BLACK);
            dist_sum=0;
        }
    }
}
