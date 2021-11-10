----------------------------------------------------------------------
-- Company: TEIS AB
-- Engineer: Ashraf Tumah  
-- 
-- Create Date       : 21-05-09
-- Design Name       : wd_timer 
-- Target Devices    : Max 10 FPGA
-- Tool versions     : Quartus 18.1 and ModelSim 10.5b
-- Testbench file    : wd_timer.vht
-- Do file           : wd_timer_run_msim_rtl_vhdl.do.do
-- 
-- Description: 
--    
-- 
-- In_signals:
-- clk            -- System Clock 50MHz
-- wdt_en_n       -- SW(0) To enable Watchdog
-- reset_n        -- Reset system
-- restart_n      -- Restart counter- Software PIO, Feed The Dog
--
-- Out_signals:
-- reset_out_n    -- Reset system if counter reaches 500ms  
-- led            -- Binary counter to show amount of wd_timer
--
-- verified with DE10-Lite board
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wd_timer is
   port
   (
      clk         :  in std_logic;  --System_clock 50MHz
      wdt_en_n    :  in std_logic;  --Enable watchdog
      reset_n     :  in std_logic;
      restart     :  in std_logic :='0';  --Restart timer, Feed the dog
      reset_out_n :  out std_logic;   --Watchdog system reset 
      led         :  out std_logic_vector(7 downto 0)
   );
end wd_timer;

architecture rtl of wd_timer is

   signal cnt_output                :  std_logic_vector(25 downto 0); 
   signal reset_n_t1, reset_n_t2    :  std_logic;
   signal wdt_en_n_t1, wdt_en_n_t2  :  std_logic;
   signal count                     :  natural range 0 to 50000000;
   signal s_restart                 :  std_logic;
   signal wd_count                  :  integer range 0 to 15;
 
begin



   
   ---Stable-Enable_wdt
   wdt_en: process(clk, reset_n)
   begin
      if reset_n ='0' then
         wdt_en_n_t1 <='1';
         wdt_en_n_t2 <='1';
      elsif rising_edge(clk) then
         wdt_en_n_t1 <= wdt_en_n;
         wdt_en_n_t2 <= wdt_en_n_t1;
      end if;
   end process;
   
   ----Simple Counter
   counter: process(clk, reset_n)
   begin
      if reset_n ='0' then
          count <= 0;
      elsif rising_edge(clk) then
         if s_restart='0' or restart ='1' then
            count <= 0;
         else
            count <= count+1;
         end if;
      end if;
   end process;
   
            
  
   -----Watchdog Process---
   process(clk,reset_n)
   constant ms1000 :  std_logic_vector(25 downto 0) := std_logic_vector(to_unsigned(50000000,26));
   begin
      if reset_n_t2 = '0' then
         wd_count    <= 0;
         reset_out_n <= '0';
         led <= (others =>'0');  
      elsif rising_edge(clk) then
         if wdt_en_n_t2 ='0' then
            if (cnt_output >= ms1000)  then                                                 
               reset_out_n <='0';                  -- If the timer count to 500ms, system reset
               wd_count <= wd_count + 1;           -- Binary counter for each system reset
               s_restart <='0';
            elsif (cnt_output < ms1000) then
               reset_out_n <='1';
               s_restart <='1';
               led <= std_logic_vector(to_unsigned(wd_count,led'length));
            end if;
               
         elsif (wdt_en_n_t2 ='1' and cnt_output >=ms1000) then
            led <=(others=>'1');
         end if;  
      end if;
   end process;
   cnt_output <= std_logic_vector(to_unsigned(count,cnt_output'length));
end rtl;
   	