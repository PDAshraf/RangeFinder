/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *     Servo Motor Position                                                  *
 *      Sends new servo position values and                                  *
 *      prints a blue circle where the servo motor points                    *
 *****************************************************************************/

#include <stdio.h>
#include <alt_types.h>
#include <io.h>
#include <system.h>
#include <altera_avalon_sierra_ker.h>
#include <altera_avalon_timer_regs.h>
#include "main_range_finder.h"
#include "def_var.h"
#include <servo_motor_drivers.h>

typedef struct circleData_t{
	alt_u32 x0;
	alt_u32 y0;
	alt_u32 radius;
	alt_u32 color;
} circleData_t;


circleData_t circleData[] = { {160,5,2,COLOR_BLACK}, { 310,180,2,COLOR_BLACK},{10,75,2,COLOR_BLACK},
                              {300,75,2,COLOR_BLACK},{270,15,2,COLOR_BLACK}, {205,10,2,COLOR_BLACK},
							  {115,10,2,COLOR_BLACK}, {20,15,2,COLOR_BLACK}, {10,180,2,COLOR_BLACK},
                              {40,15,2,COLOR_BLACK}};

void task_servo_position_code(void)
{
    printf("Range Init\n");
    task_periodic_start_union test;
    {
        enum {increase_state,decrease_state}state;
        alt_u16 pos;
        init_period_time(10);
        while(1)
        {
            test = wait_for_next_period();
            if(test.periodic_start_integer & 0x01)
            printf("Deadline miss, Task_Servo_position_Code");

            switch(state){
            case increase_state:
                sem_take(SEM1);
                m_pos=m_pos+1;
                pos=m_pos;
                sem_release(SEM1);
                servo_position(pos);
                if(pos>=84)
                {
                	for(size_t i = 0; i < 10; ++i) {
                		draw_filled_circle(circleData[i].x0,circleData[i].y0,circleData[i].radius,COLOR_BLACK);
                	}
                    state=decrease_state;
                }
                break;
                
            case decrease_state:
                sem_take(SEM1);
                m_pos=m_pos-1;
                pos=m_pos;
                sem_release(SEM1);
                servo_position(pos);
                sem_release(SEM1);
                if(pos<=14)
                {
                	for(size_t i = 0; i < 10; ++i) {
                		draw_filled_circle(circleData[i].x0,circleData[i].y0,circleData[i].radius,COLOR_BLACK);
                	}
                    state=increase_state;
                }
                break;

            }

        }
    }
}


