/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *     Range Print                                                           *
 *      In relation to the servo position and distance value,                *
 *      a yellow circle is painted on the monitor to                         *
 *      visualize an object's position                                       *
 *****************************************************************************/

#include <stdio.h>
#include <alt_types.h>
#include <io.h>
#include <system.h>
#include <altera_avalon_sierra_ker.h>
#include "main_range_finder.h"
#include "def_var.h"
#include <DE10_Lite_VGA_Driver.h>



void task_range_print_code(void)
{
    printf("Range Init\n");
    task_periodic_start_union test;
    {
        init_period_time(15);
        alt_u16 x_pos[]={0,25,50,75,90,115,140,165,180}; //Var for each angle(9 angles)
        alt_u16 y_pos[]={0,25,50,75,90,115,140,165,180};
        alt_u16 pos;
        alt_u16 range;
        while(1)
        {
            test = wait_for_next_period();
            if(test.periodic_start_integer & 0x01)
            printf("Deadline miss, Task_Range_print_Code");
            sem_take(SEM1);
             pos=m_pos;
             range=distance;
             sem_release(SEM1);

            //Angle 90 Degrees
            if(pos<52&&pos>46){
                draw_filled_circle(160,5,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[4],y_pos[4],5,COLOR_BLACK);
                    x_pos[4]=160;
                    y_pos[4]=150-range;
                    draw_filled_circle(x_pos[4],y_pos[4],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[4],y_pos[4],5,COLOR_BLACK);
                }
            }

            //Angle 0 Degrees
            else if(pos<16&&pos>13){
                draw_filled_circle(310,180,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[0],y_pos[0],5,COLOR_BLACK);
                    x_pos[0]=180+range;
                    y_pos[0]=180;
                    draw_filled_circle(x_pos[0],y_pos[0],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[0],y_pos[0],5,COLOR_BLACK);
                }
            }

            //Angle 180 Degrees
            else if(pos<84&&pos>79){
                draw_filled_circle(10,180,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[8],y_pos[8],5,COLOR_BLACK);
                    x_pos[8]=140-range;
                    y_pos[8]=180;
                    draw_filled_circle(x_pos[8],y_pos[8],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[8],y_pos[8],5,COLOR_BLACK);
                }
            }

            //Angle 25 Degrees
            else if(pos<25&&pos>16){
                draw_filled_circle(300,75,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[1],y_pos[1],5,COLOR_BLACK);
                    x_pos[1]=(255+range/3);
                    y_pos[1]=(150-range/2);
                    draw_filled_circle(x_pos[1],y_pos[1],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[1],y_pos[1],5,COLOR_BLACK);
                }
            }

            //Angle 50 Degrees
            else if(pos<34&&pos>25){
                draw_filled_circle(270,15,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[2],y_pos[2],5,COLOR_BLACK);
                    x_pos[2]=(210+range/3);
                    y_pos[2]=(150-range);
                    draw_filled_circle(x_pos[2],y_pos[2],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[2],y_pos[2],5,COLOR_BLACK);
                }
            }

            //Angle 75 Degrees
            else if(pos<46&&pos>34){
                draw_filled_circle(205,10,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[3],y_pos[3],5,COLOR_BLACK);
                    x_pos[3]=(190+range/5);
                    y_pos[3]=(150-range);
                    draw_filled_circle(x_pos[3],y_pos[3],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[3],y_pos[3],5,COLOR_BLACK);
                }
            }

            //Angle 115 Degrees
            else if(pos<61&&pos>52){
                draw_filled_circle(115,10,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[5],y_pos[5],5,COLOR_BLACK);
                    x_pos[5]=(130-range/5);
                    y_pos[5]=(150-range);
                    draw_filled_circle(x_pos[5],y_pos[5],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[5],y_pos[5],5,COLOR_BLACK);
                }
            }

            //Angle 140 Degrees
            else if(pos<70&&pos>61){
                draw_filled_circle(40,15,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[6],y_pos[6],5,COLOR_BLACK);
                    x_pos[6]=(110-range/3);
                    y_pos[6]=(150-range);
                    draw_filled_circle(x_pos[6],y_pos[6],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[6],y_pos[6],5,COLOR_BLACK);
                }
            }

            //Angle 165 Degrees
            else if(pos<79&&pos>70){
                draw_filled_circle(10,75,2,COLOR_CYAN);
                if(range>0 && range<130){
                    draw_filled_circle(x_pos[7],y_pos[7],5,COLOR_BLACK);
                    x_pos[7]=(65-range/3);
                    y_pos[7]=(150-range/2);
                    draw_filled_circle(x_pos[7],y_pos[7],5,COLOR_YELLOW);
                }
                else{
                    draw_filled_circle(x_pos[7],y_pos[7],5,COLOR_BLACK);
                }
            }

        }
    }
}
