------------------
-- Company: TEIS AB
-- Engineer: Ashraf Tumah  
-- 
-- Create Date			: 20210115
-- Design Name			: Test_komp 
-- Target Devices		: Max 10 FPGA
-- Tool versions		: Quartus 18.1 and ModelSim 10.5b
-- Testbench file		: --
-- Do file				: --
--	Uppdaterad			: 2021-04-07
-- Description: 
--    VGA controller ritar pixlar enligt datavarden i blockram
--
--		 			----Uppdatering 2021-04-07-----
--			Modifikation av VGA_Controller och DPRAM
-- 
-- In_signals:
-- sys_clk           -- 25 MHz clock(PLL)
-- resetn            -- reset signal
-- data_in           -- pixel value from RAM
-- address           -- address to RAM
--
-- Out_signals:
-- VGA_HS          -- Horisontal sync to VGA-display
-- VGA_VS          -- Vertical sync to VGA-display
-- VGA_BL          -- Signal Blank low when pixels outside write range
-- VGA_R           -- 4 bit red color to VGA-display
-- VGA_G           -- 4 bit green color to VGA-display
-- VGA_B           -- 4 bit blue color to VGA-display
--
-- verified with DE10-Lite board

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY VGA_Controller IS 
   PORT
   (
      clk :  IN std_logic;
      resetn  :  IN std_logic;
      data_in :  IN std_logic_vector (2 downto 0);

      VGA_HS  :  OUT   std_logic;
      VGA_VS  :  OUT   std_logic;
      VGA_BL  :  OUT   std_logic;    
      VGA_R   :  OUT   std_logic_vector(3 downto 0);
      VGA_G   :  OUT   std_logic_vector(3 downto 0);
      VGA_B   :  OUT   std_logic_vector(3 downto 0);
      ADDRESS :  OUT   std_logic_vector(16 downto 0)
   );
   
END VGA_Controller;

ARCHITECTURE rtl OF VGA_Controller IS
   signal x_counter : unsigned(9 downto 0);
	signal y_counter : unsigned(9 downto 0);
	
	---Address Till minnet---
	---Upplösning skalas ned till 320x240---
	function to_address(x: natural; y: natural) return std_logic_vector is
	begin
		return std_logic_vector(to_unsigned(x / 2 + y / 2 * 320, 17));
	end function;
	---Address Till minnet---
	
BEGIN

   ----PixelCounter-----
	process(clk, resetn)
	begin
		if resetn = '0' then
			x_counter <= (others => '0');
			y_counter <= (others => '0');
		elsif rising_edge(clk) then
			------------ x_counter ------------
			if x_counter >= 799 then
				x_counter <= (others => '0');
			else
				x_counter <= x_counter + 1;
			end if;
			------------ x_counter ------------

			------------ y_counter ------------
			if x_counter = 707 then 
				if y_counter = 525 then 
					y_counter <= (others => '0');
				else
					y_counter <= y_counter + 1; 
				end if;
			end if;
			------------ y_counter ------------
		end if;
	end process;
   
   --synkrona pulser--
   VGA_HS <= '0' when x_counter >= 660 and x_counter <= 756 else '1';
   VGA_VS <= '0' when y_counter >= 494 and y_counter <=495  else '1';
	---Blank då pixeln är utanför ramen(640x480)---
   VGA_BL <= '1' when x_counter < 640 and y_counter <= 479 	else '0';
	
   --- ADDRESS -- 
   --Sänder Aktuell Pixeladress till minnet--
	ADDRESS <= to_address(to_integer(x_counter), to_integer(y_counter)) when x_counter < 640 and y_counter < 480	
		else (others => '0');
 
 ----------RGB-Signaler----------  
   VGA_R <= "1111" when data_in(0)='1' and (x_counter>=0 and x_counter<=640) and (y_counter>=0 and y_counter<=480) else "0000";                       
   VGA_G <= "1111" when data_in(1)='1' and (x_counter>=0 and x_counter<=640) and (y_counter>=0 and y_counter<=480) else "0000";                      
   VGA_B <= "1111" when data_in(2)='1' and (x_counter>=0 and x_counter<=640) and (y_counter>=0 and y_counter<=480) else "0000";
 ----------RGB-Signaler---------
END rtl;