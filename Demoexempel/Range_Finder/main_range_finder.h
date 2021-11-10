/*****************************************************************************
 *  Company  : AGSTU AB         *                                            *
 ********************************                                            *
 *  Engineer : Ashraf Tumah     *                                            *
 *  Date     : 21-06-20         *                                            *
 *  Task     : C_eng_job_b_M    *                                            *
 ********************************                                            *
 *   Description:                                                            *
 *      Main header file contains definitions and declarations.              *
 *****************************************************************************/

#ifndef MAIN_RANGE_FINDER_H_
#define MAIN_RANGE_FINDER_H_

//Tasks
#define IDLE                  0
#define Task_Avg_Range	      1
#define Task_Range            2
#define Task_Servo_Position   3
#define Task_Range_Print      4

//Semaphore
#define SEM1 1
#define SEM2 2
#define SEM3 3

//Stack
#define STACK_SIZE 800
char idle_stack[STACK_SIZE];
char task_avg_range_stack[STACK_SIZE];
char task_range_stack[STACK_SIZE];
char task_range_print_stack[STACK_SIZE];
char task_servo_position_stack[STACK_SIZE];

#endif /* MAIN_RANGE_FINDER_H_ */
