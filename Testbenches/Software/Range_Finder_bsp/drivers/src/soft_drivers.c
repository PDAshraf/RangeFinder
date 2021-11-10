/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *     Software Drivers
 *                                                            *
 *****************************************************************************/

#include <alt_types.h>
#include <altera_avalon_pio_regs.h>
#include <system.h>
#include <stdlib.h>
#include <soft_drivers.h>
#include <servo_motor_drivers.h>



volatile init_screen()
{
    clear_screen(0x0);
    tty_print(10,10,"TEIS AB 21-06-20",COLOR_WHITE,COLOR_BLACK);
    tty_print(10,20,"Examens Job",COLOR_WHITE,COLOR_BLACK);
    tty_print(10,40,"By Ashraf Tumah",COLOR_WHITE,COLOR_BLACK);
    tty_print(70,80,"Range Meter",COLOR_CYAN,COLOR_BLACK);
    tty_print(50,120,"Press Key0 to Test  Servo Motor",COLOR_CYAN,COLOR_BLACK);
    tty_print(50,140,"Press Key1 to Start Software",COLOR_CYAN,COLOR_BLACK);
}

void pattern()
{
    //bottom line
    draw_hline(10,200,300,COLOR_GREEN);

    //center vlines
    draw_vline(140,10,150,COLOR_GREEN);
    draw_vline(180,10,150,COLOR_GREEN);

    //left lines
    draw_angled_line(90,10,120,160,COLOR_GREEN);
    draw_angled_line(30,50,100,160,0x2);
    draw_angled_line(10,110,60,160,0x2);

    //right lines
    draw_angled_line(230,10,200,160,COLOR_GREEN);
    draw_angled_line(290,50,220,160,COLOR_GREEN);
    draw_angled_line(310,110,260,160,COLOR_GREEN);
}

void testFunction()
{
    alt_u8 key_r=1;
    while(1)
    {
        int key_in = KEY_1 & IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE);
        int sw=IORD_32DIRECT(SWITCH_PIO_BASE,0);

        tty_print(10,20,"Test ServoMotor by Switches",COLOR_GREEN,COLOR_BLACK);
        tty_print(30,60,"Switch0= Servo Angle 0 Degrees",COLOR_YELLOW,COLOR_BLACK);
        tty_print(30,80,"Switch1= Servo Angle 90 Degrees",COLOR_YELLOW,COLOR_BLACK);
        tty_print(30,100,"Switch3= Servo Angle 180 Degrees",COLOR_YELLOW,COLOR_BLACK);
        tty_print(10,200,"Key 1, Back to StartScreen",COLOR_RED,COLOR_BLACK);

        if(sw==1){
            servo_position(Degrees_0);
        }
        else if(sw==2){
            servo_position(Degrees_90);
        }
        else if (sw==4){
            servo_position(Degrees_180);
        }
        if(key_in!=KEY_1)
        {
            for( alt_u16 i=10000;i>0;i--);
            key_r=0;
        }
        if ((key_in==KEY_1) && (key_r==0)) break;
    }
}

volatile DELAY(size_t i)
{
	for(;i>0;i--);
}
