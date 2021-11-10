/**
 * \file       functionality_test.c
 * \details    Test different functionalities of the DE10-Lite VGA driver
 * \author     Jens Lind
 * \version    1.0
 * \date       2020
 * \copyright  AGSTU AB
 */

#include <altera_avalon_pio_regs.h>
#include <altera_avalon_timer_regs.h>
#include <char_map.h>
#include <DE10_Lite_VGA_Driver.h>
#include <draw_vga.h>
#include <stdlib.h>
#include <stdio.h>
#include <system.h>

enum EState
{
	EState_None = 0,
	EState_Home_Screen,
	EState_Color_Depth,
	EState_Lines_Print,
	EState_Overlapping_Circles,
	EState_Int_Print,
	EState_Last = EState_Int_Print,
};

static int g_current_number = 0;

//! \brief Home screen for test bench with instructions
void test_home_screen()
{
	printf("Running %s\n", __FUNCTION__);
	alt_32 x = 2;
	alt_32 y = 2;

	tty_print(x, y, "Welcome to test bench", Col_White, Col_Black);
	y += CHAR_PRINT_HEIGHT;
	tty_print(x, y, "for CASE GOLD DE10-Lite", Col_White, Col_Black);
	y += CHAR_PRINT_HEIGHT;
	tty_print(x, y, "VGA driver", Col_White, Col_Black);

	y = CANVAS_HEIGHT - 2*CHAR_PRINT_HEIGHT;
	tty_print(x, y, "Press key0 to go to next test", Col_White, Col_Black);
	y += CHAR_PRINT_HEIGHT;
	tty_print(x, y, "Press key1 to return here", Col_White, Col_Black);
}

//! \brief Test color range by printing rows of pixels of each color within the 3 bit range
void test_color_depth()
{
	printf("Running %s\n", __FUNCTION__);
	const alt_u32 rowsPerColor = CANVAS_HEIGHT / 8; // spread the colors across multiple rows
	alt_u8 rgb = 0;
	for (alt_u32 y = 0; y < CANVAS_HEIGHT; ++y)
	{
		for (alt_u32 x = 0; x < CANVAS_WIDTH; ++x)
		{
			write_pixel(x, y, rgb);
		}

		// Check if the color should change
		if (y > 0 && (y % rowsPerColor) == 0)
		{
			rgb = (rgb + 1) & 0b111; // 3 bit color depth, so mask it out in case we wrap around
		}
	}
}

//! \brief Splits screen with multiple horizontal, vertical and angled lines
void test_lines_print()
{
	printf("Running %s\n", __FUNCTION__);
	draw_hline(0, (CANVAS_HEIGHT>>1), CANVAS_WIDTH, Col_White);
	draw_vline((CANVAS_WIDTH>>1), 0, CANVAS_HEIGHT, Col_Magenta);
	draw_angled_line(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT, Col_Red);
	draw_angled_line(0, CANVAS_HEIGHT, CANVAS_WIDTH, 0, Col_Green);
}

/*! \brief Draw a randomly position and sized circle
    \param init If 1, assumes first time function is called
*/
void test_overlapping_circles(const int init)
{
	if (init == 1)
		printf("Running %s\n", __FUNCTION__);

	if (init == 1 || TIMER_READ() > 10000000) // update five times per second
	{
		const alt_u32 radius = (rand() % 9) + 1;
		const alt_32 x = (rand() % (CANVAS_WIDTH+radius)) - radius;
		const alt_32 y = (rand() % (CANVAS_HEIGHT+radius)) - radius;
		const alt_u32 total = x+y+radius;
		if ((rand()%2) == 0)
			draw_circle(x, y, radius, (total%7));
		else
			draw_filled_circle(x, y, radius, (total%7));
		TIMER_RESET();
		TIMER_START();
	}
}

/*! \brief Draw integer on screen from -10000 to +10000 over some time
    \param init If 1, update value on screen regardless of timer
*/
void test_int_print(const int init)
{
	if (init == 1)
		printf("Running %s\n", __FUNCTION__);

	if (init == 1 || TIMER_READ() > 2500000) // update number every 20th of a second
	{
		if (++g_current_number > 99999)
			g_current_number = 0;
		alt_32 x = (CANVAS_WIDTH>>1) - 3*CHAR_PRINT_WIDTH;
		alt_32 y = (CANVAS_HEIGHT>>1) - ((2*TTY_CHAR_HEIGHT)>>1);
		int_print(x, y, g_current_number, 5, Col_White, Col_Black);
		y += TTY_CHAR_HEIGHT;
		int_print(x, y, -g_current_number, 5, Col_Black, Col_White);
		TIMER_RESET();
		TIMER_START();
	}
}

int main()
{
	alt_u32 key0_last = 0;
	alt_u32 key1_last = 0;
	enum EState currentState = EState_None;
	enum EState newState = EState_Home_Screen;

	while (1) // loop forever
	{
		// check for state change (on discrete button press)
		const alt_u32 key_mask = IORD_ALTERA_AVALON_PIO_DATA(PIO_BUTTONS_IN_BASE);
		const alt_u32 key0_in = key_mask & 0x1;
		const alt_u32 key1_in = key_mask & 0x2;
		if (key0_in == 0 && key0_in != key0_last)
		{
			switch (currentState)
			{
			case EState_None:
			case EState_Last:
				newState = EState_Home_Screen;
				break;
			default:
				++newState;
				break;
			}
		}
		else if (key1_in == 0 && key1_in != key1_last)
		{
			newState = EState_Home_Screen;
		}
		key0_last = key0_in;
		key1_last = key1_in;

		if (currentState != newState)
		{
			// state exit
			clear_screen(Col_Black);
			TIMER_RESET();

			// state enter
			switch (newState)
			{
			case EState_Home_Screen:
				test_home_screen();
				break;
			case EState_Color_Depth:
				test_color_depth();
				break;
			case EState_Lines_Print:
				test_lines_print();
				break;
			case EState_Overlapping_Circles:
				test_overlapping_circles(1);
				TIMER_START();
				break;
			case EState_Int_Print:
				g_current_number = -1;
				test_int_print(1);
				TIMER_START();
				break;
			default:
				break;
			}

			// finalize new state
			currentState = newState;
		}

		// state update
		switch (currentState)
		{
		case EState_Overlapping_Circles:
			test_overlapping_circles(0);
			break;
		case EState_Int_Print:
			test_int_print(0);
			break;
		default:
			break;
		}
	}

	return 0;
}
