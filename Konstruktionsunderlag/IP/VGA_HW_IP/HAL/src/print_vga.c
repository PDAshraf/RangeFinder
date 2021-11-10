/*
 * print_vga.c
 *
 *  Created on: 30 Apr 2021
 *      Author: Ashraf Tumah med referens
 *      Reference: draw_vga.c - Calle Melander med flera
 *      VGA-drivers för linjer, text och circlar
 */

#include <alt_types.h>
#include <string.h>
#include "char_map.h"
#include "print_vga.h"
#include <DE10_Lite_VGA_Driver.h>

extern alt_u32 upper_char_line(alt_u8 char_pos); //__attribute__((section("My_glypt")));
extern alt_u32 lower_char_line(alt_u8 char_pos); //__attribute__((section("My_glypt")));

void print_pix(alt_u16 x,alt_u16 y,alt_u16 color){
	write_pixel(x,y,color);
}

void clear_screen(alt_u16 color) {
	alt_u16 x,y;
	for(y=0;y<240;y++) {
		for(x=0;x<320;x++) {
			write_pixel(x,y,color);
		}
	}
}

void print_hline(alt_u32 x_start,alt_u32 y_start,alt_u32 line_lenght,alt_u32 color){
	alt_u32 x;
	for(x=0;x<line_lenght;x++){
		write_pixel(x_start+x,y_start,color);
	}
}

void print_vline(alt_u32 x_start,alt_u32 y_start,alt_u32 line_lenght,alt_u32 color){
	alt_u32 x;
	for(x=0;x<line_lenght;x++){
		write_pixel(x_start,y_start+x,color);
	}

}

void tty_print(alt_32 x_start, alt_32 y_start, alt_8 *tty_string,alt_32 color, alt_u32 BGcolor){
	 alt_u8 *tpek;
	 alt_u32 n = strlen(tty_string);
	 tpek = tty_string;
	 for(alt_u32 i=0;i<n;i++){ // antal tecken
		 alt_u8 tkn = *tpek;
		 alt_u32 pry = y_start ;
		 alt_u32 half_tkn = upper_char_line(tkn-0x20);
		 alt_u32 dot =  half_tkn;
			 for(alt_u32 ii=0;ii<4;ii++){ // rader per ½ tecken
				 alt_u32 prx = x_start +i*8;
					 for(alt_u32 jj=0;jj<8;jj++){ // pixlar på rad (8)
					 alt_u32 dotcolor = (0x80000000 &dot)?color:BGcolor;
					 write_pixel(prx,pry,dotcolor);
					 dot = dot<<1;
					 prx++;
				 }
				 pry++;
			 }
			// nederdel
			 half_tkn = lower_char_line(tkn-0x20);
			  dot =  half_tkn;  // på/av färg  // 0x80000000 &
				 for(alt_u32 ii=0;ii<4;ii++){ // rader per ½ tecken
					 alt_u32 prx = x_start +i*8;
						 for(alt_u32 jj=0;jj<8;jj++){ // pixlar på rad (8)
						 alt_u32 dotcolor = (0x80000000 &dot)?color:BGcolor;
						 write_pixel(prx,pry,dotcolor);
						 dot = dot<<1;
						 prx++;
					 }
					 pry++;
				 }
		 tpek ++;
	 }
 };

void print_char(alt_u32 x_start, alt_u32 y_start, alt_u8 tty_char,alt_u32 color, alt_u32 BGcolor){
	 alt_u8 tkn = tty_char;
		 alt_u32 pry = y_start ;
		 alt_u32 dot = upper_char_line(tkn-0x20);
			 for(alt_u32 ii=0;ii<4;ii++){ // rader per ½ tecken
				 alt_u32 prx = x_start;
				 for(alt_u32 jj=0;jj<8;jj++){ // pixlar på rad (8)
					 alt_u32 dotcolor = (0x80000000 &dot)?color:BGcolor;
					 write_pixel(prx,pry,dotcolor);
					 dot = dot<<1;
					 prx++;
				 }
				 pry++;
			 }
			// nederdel
			 dot = lower_char_line(tkn-0x20);
				 for(alt_u32 ii=0;ii<4;ii++){ // rader per ½ tecken
					 alt_u32 prx = x_start;
					 for(alt_u32 jj=0;jj<8;jj++){ // pixlar på rad (8)
						 alt_u32 dotcolor = (0x80000000 &dot)?color:BGcolor;
						 write_pixel(prx,pry,dotcolor);
						 dot = dot<<1;
						 prx++;
					 }
					 pry++;
				 }
 };

unsigned read_pixel_ram_int(alt_u16 x, alt_u16 y){
	alt_u16 pixel_data = read_pixel(x,y);
	printf("Ram Pixel = %d\n",pixel_data);
	return pixel_data;
}

void print_circle(alt_u32 x_start,alt_u32 y_start,alt_u32 radius,alt_u32 color){
	//  Bresenham's circle algorithm
    alt_32 x = radius-1;
    alt_32 y = 0;
    alt_32 dx = 1;
    alt_32 dy = 1;
    alt_32 err = dx - (radius << 1);
    while (x >= y)
    {
    	write_pixel(x_start + x, y_start + y, color);
        write_pixel(x_start + y, y_start + x, color);
        write_pixel(x_start - y, y_start + x, color);
        write_pixel(x_start - x, y_start + y, color);
        write_pixel(x_start - x, y_start - y, color);
        write_pixel(x_start - y, y_start - x, color);
        write_pixel(x_start + y, y_start - x, color);
        write_pixel(x_start + x, y_start - y, color);

        if (err <= 0)
        {
            y++;
            err += dy;
            dy += 2;
        }
        if (err > 0)
        {
            x--;
            dx += 2;
            err += dx - (radius << 1);
        }
    }
}

