-------------------------------------------------------------------------------
--
-- Företag           : TEIS AB 
-- Författare        : Ashraf Tumah
-- 
-- Skapad            : 2021-04-07
-- Designnamn        : Range_Sensor_Component
-- Enhet             : DE10-Lite 10M50DAF484C7G
-- Verktygsversion   : Quartus Prime 18.1 och ModelSim 10.5b
-- Testbänk          : 
-- DO file           : 
--
-- Beskrivning :
--    Var 250ms sänder komponenten 
--    ultraljudsvågor under en period på 100μs
--       
--       
--
--
-- Insignaler:
--    reset_n              Reset
--    clk                  Systemklocka 50 MHz           
--
-- Utsignaler:
--    trig                 Ultraljud ut(Transmitter)
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Trig_Comp is 
   port
      (
         reset_n : in std_logic;
         clk     : in std_logic;
         trig    : out std_logic;
         rst_out : out std_logic
      );
end Trig_Comp;

architecture behavior of Trig_Comp is

   signal rst_n_t1, rst_n_t2 : std_logic;
   signal rst_trg            : std_logic;                      ---reset_counter
   signal out_cnt            : unsigned(23 downto 0);
      

begin
		
	rst_out <=rst_n_t2;
   ----Meta-Reset---
   reset : process(reset_n,clk)
   begin
      if reset_n ='1' then
         rst_n_t1 <='1';
         rst_n_t2 <='1';
      elsif rising_edge(clk) then
         rst_n_t1 <= '0';
         rst_n_t2 <= rst_n_t1;
      end if;
   end process;
   ----Meta-Reset---
   
   ---Trigger--räknare-----
 counter: process(clk,rst_n_t2)
   begin
      if rst_n_t2='0' then
         out_cnt <=(others =>'0');
      elsif rising_edge(clk) then
         if rst_trg ='1' then
            out_cnt <=(others =>'0');
         else
            out_cnt <=out_cnt + 1;
         end if;
      end if;
   end process;
   ---Trigger-räknare-----
  
   ----Trigger-process---
-- 250ms fördröjning mellan trigger pulser vilket är 4Hz.
--  Systemklocka 50MHz/4Hz=12500000counts
   trigger : process(rst_n_t2,clk)                                    
   constant ms250: unsigned(23 downto 0) := to_unsigned(12500000,24);        -- 12500000(/4Hz) = 250ms
   constant ms250and100us: unsigned(23 downto 0) := to_unsigned(12501000,24);-- 12501000(50MHz/4Hz) = 250ms + 100μs(Utsändning UltraSonic)
   begin
      if rst_n_t2 ='0' then
         rst_trg <='0';
         trig    <='0';
         rst_trg <='0';
      elsif rising_edge(clk) then
      
         -----Sänder Ultraljud i 100us
      if (out_cnt > ms250 and out_cnt < ms250and100us) then
            trig <='1';
         else 
            trig <='0';
         end if;
         
         ----Återställer räknaren
       if (out_cnt >= ms250and100us ) then
            rst_trg <='1';
         else 
            rst_trg <='0';
         end if;
      end if;
   end process;
   ----Trigger-process---
   
end behavior;