/*
 * print_vga.h
 *
 *  Created on: 30 Apr 2021
 *      Author: Ashraf Tumah
 *      VGA-drivers för linjer, text och circlar
 */

#ifndef PRINT_VGA_H_
#define PRINT_VGA_H_

void print_pix(alt_u16 x,alt_u16 y,alt_u16 color);
void clear_screen(alt_u16 color);
void print_hline(alt_u32 x_start,alt_u32 y_start,alt_u32 line_lenght,alt_u32 color);
void print_vline(alt_u32 x_start,alt_u32 y_start,alt_u32 line_lenght,alt_u32 color);
void tty_print(alt_32 x_start, alt_32 y_start, alt_8 *tty_string,alt_32 color, alt_u32 BGcolor);
void print_char(alt_u32 x_start, alt_u32 y_start, alt_u8 tty_char,alt_u32 color, alt_u32 BGcolor);
unsigned read_pixel_ram_int(alt_u16 x, alt_u16 y);
void print_circle(alt_u32 x_start,alt_u32 y_start,alt_u32 radius,alt_u32 color);

#endif /* PRINT_VGA_H_ */
