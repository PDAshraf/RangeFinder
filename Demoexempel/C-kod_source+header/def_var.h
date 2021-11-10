/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *     def_var                                                               *
 *      header file which contains macros and                                *
 *      declares global variables                                            *
 *****************************************************************************/

#ifndef DEF_VAR_H_
#define DEF_VAR_H_

#define KEY_0 0x01
#define KEY_1 0x02

#define DELAY_1ms     50000
#define DELAY_10ms    500000
#define DELAY_100ms   5000000

#define COLOR_BLACK   0x00
#define COLOR_RED     0x01
#define COLOR_GREEN   0x02
#define COLOR_YELLOW  0x03
#define COLOR_BLUE    0x04
#define COLOR_MAGNETA 0x05
#define COLOR_CYAN    0x06
#define COLOR_WHITE   0x07

volatile alt_u32 distance,dist_sum,dist_avg,x_val,y_val;
volatile alt_u16 m_pos;

#endif /* DEF_VAR_H_ */
