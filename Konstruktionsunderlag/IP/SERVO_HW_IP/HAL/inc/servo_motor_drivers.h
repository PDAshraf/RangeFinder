////////////////////////////////////////////
// Author: 	Ashraf Tumah
// Date:	2021-06-16
//
// Drivers for interfacing with Servo Motor component
// for the DE10-Lite board.
//
// Functionality is implemented as macros that
// writes to registers.
//

#ifndef SERVO_MOTOR_DRIVERS_H_
#define SERVO_MOTOR_DRIVERS_H_

#include <system.h>
#include <io.h>

#define servo_position(position) IOWR_32DIRECT(SERVO_HW_IP_0_BASE,0,position)
#define servo_center() IOWR_32DIRECT(SERVO_HW_IP_0_BASE,0,48)
#define servo_180() IOWR_32DIRECT(SERVO_HW_IP_0_BASE,0,84)
#define servo_0() IOWR_32DIRECT(SERVO_HW_IP_0_BASE,0,14)

#endif /* SERVO_MOTOR_DRIVERS_H_ */
