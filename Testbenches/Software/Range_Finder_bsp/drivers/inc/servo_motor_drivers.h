/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *     Servo Motor Drivers                                                   *
 *      Drivers for interfacing with Servo Motor component                   *
 *      for the DE10-Lite board.                                             *
 *                                                                           *
 *      Functionality is implemented as macros that                          *
 *      writes to registers.                                                 *
 *****************************************************************************/

#ifndef SERVO_MOTOR_DRIVERS_H_
#define SERVO_MOTOR_DRIVERS_H_

#include <system.h>
#include <io.h>

#define Degrees_0   0x0E
#define Degrees_90  0x30
#define Degrees_180 0x50


#define servo_position(position) IOWR_32DIRECT(SERVO_HW_IP_0_BASE,0,position)


#endif /* SERVO_MOTOR_DRIVERS_H_ */
