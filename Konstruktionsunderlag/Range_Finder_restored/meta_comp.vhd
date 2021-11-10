-------------------------------------------------------------------------------
--
-- Företag           : TEIS AB 
-- Författare        : Ashraf Tumah
-- 
-- Skapad            : 2021-07-29
-- Designnamn        : meta_comp
-- Enhet             : DE10-Lite 10M50DAF484C7G
-- Verktygsversion   : Quartus Prime 18.1 och ModelSim 10.5b
-- Testbänk          : 
-- DO file           : 
--
-- Beskrivning :
--    Komponent för att stabilisera signaler
--
--
-- Insignaler:
--		clk       Systemklocka 50MHz
--		reset_n	 Reset signal in
--		key_in	 Tryckknappar in
--		sw_in	    Switcha      in
--
-- Utsignaler:
--    key_o		Knappsignaler 	ut
--		sw_o		Switchsignaler ut
--		reset_o	Reset 			ut
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;



entity meta_comp is 
   port
      (
         clk		: in	std_logic;
			reset_n	: in	std_logic;
			key_in	: in std_logic_vector(1 downto 0);
			sw_in		: in std_logic_vector(8 downto 0);
			
			key_o		: out std_logic_vector(1 downto 0);
			sw_o		: out std_logic_vector(8 downto 0);
			reset_o	: out std_logic
      );
end meta_comp;

architecture rtl of meta_Comp is

   signal rst_n_t1, rst_n_t2 	: std_logic;
   signal key_t1, key_t2 		: std_logic_vector(1 downto 0);
   signal sw_t1, sw_t2 			: std_logic_vector(8 downto 0);
   

begin

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
	
	----Meta-Key---
   key : process(rst_n_t2,clk)
   begin
      if rst_n_t2='0' then
         key_t1 <=(others =>'1');
         key_t2 <=(others =>'1');
      elsif rising_edge(clk) then
         key_t1 <= key_in;
         key_t2 <= key_t1;
      end if;
   end process;
   ----Meta-Key---
	
	----Meta-switch---
   switch : process(rst_n_t2,clk)
   begin
      if rst_n_t2='0' then
         sw_t1 <=(others =>'0');
         sw_t2 <=(others =>'0');
      elsif rising_edge(clk) then
         sw_t1 <= sw_in;
         sw_t2 <= sw_t1;
      end if;
   end process;
   ----Meta-switch---
	
	key_o 	<= key_t2;
	sw_o 		<= sw_t2;
	reset_o 	<= rst_n_t2;

   
end rtl;