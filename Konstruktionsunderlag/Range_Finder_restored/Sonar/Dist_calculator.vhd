-------------------------------------------------------------------------------
--
-- Företag				: TEIS AB 
-- Författare			: Ashraf Tumah
-- 
-- Skapad				: 2021-04-07
-- Designnamn			: Range_Sensor_Component
-- Enhet					: DE10-Lite 10M50DAF484C7G
-- Verktygsversion	: Quartus Prime 18.1 och ModelSim 10.5b
-- Testbänk				: 
-- DO file				: 
--
-- Beskrivning :
-- 	Räknar upp fram till en puls når komponenten.
--		Räknade pulser  kalkyleras till Centimeter.
--		
--
--
-- Insignaler:
--		reset_n					Reset
--		clk						Systemklocka 50 MHz
--		reset_calc				Triggersignal			
--		pulse						echo pulse in(Sensor Receiver)
--
--	Utsignaler:
--		distance					Kalkylerad Distans Ut
--	
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Dist_calculator is
	port
	(
		clk			:	in std_logic;
		reset_n		:	in	std_logic;
		reset_calc	: 	in std_logic;
		pulse			: 	in std_logic;
		distance		:	out std_logic_vector (8 downto 0)
	);
end Dist_calculator;

architecture behavior of Dist_calculator is


	signal count							: unsigned (21 downto 0);
	signal pls_t1, pls_t2	   		: std_logic;
	

begin


	
	---Meta-in puls---
	process(reset_n,clk)
	begin
		if reset_n = '0' then
			pls_t1 <= '0';
			pls_t2 <= '0';
		elsif rising_edge(clk) then
			pls_t1 <= pulse;
			pls_t2 <= pls_t1;
		end if;
	end process;
	--Meta-in puls---
	

	-----CounterProcess----
	counter: process(clk,reset_n)
	begin
		if reset_n = '0' then
			count <=(others =>'0');
		elsif rising_edge(clk) then     
			if reset_calc = '1' then    --Reset Counter när trigger sänds
				count <= (others=>'0');
			elsif pls_t2 ='1' then
				count <= count+1;
			end if;
		end if;
	end process;
	-----CounterProcess----
	

	Distance_calculator : process(clk,reset_n)
	variable Result : integer := 0; 
	variable Multiplier : unsigned(23 downto 0);
	begin
		if reset_n='0' then 
			Distance <=(others=>'0');
			Result := 0;
		elsif rising_edge(clk) then
			if pls_t2='1'  then      														-- Sträcka-Centimeter--
				Multiplier := count * "11";												--count*20ns(50Mhz)=Nanosekunder
				Result := to_integer(unsigned(Multiplier(23 downto 13)));		--Nanosekunder / 58(Sensorfördröjning)/1000(ms)
			else
				if Result < 450 then     ----Sensor Max Range 450CM    
					Distance <= STD_LOGIC_VECTOR(to_unsigned(Result,9));
				else
					Distance <= "111111111";
				end if;
			end if;
		end if;
	end process;
	


end behavior;