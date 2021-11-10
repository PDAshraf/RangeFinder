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
-- 	Transmitter sänder ultraljud varje 250ms under en period på 100us.
--		Antal klockpulser räknas fram till receivern fångar uppljudvågorna.
--		Klockpulserna kalkyleras till heltal vilket reprecenterar avstånd i cm.
--	
--		
--
--
-- Insignaler:
--		sys_clk			System Klocka 50MHz
--		pulse				Ultraljud Receiver
--		reset				Resetsignal
--
--	Utsignaler:
--		o_trigger		Ultraljud Transmitter
--		centimeter		BCD-konverterad värde ut(centimeter)
--		decimeter		BCD-konverterad värde ut(decimeter)
--		meter				BCD-konverterad värde ut(meter)
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Range_Sensor_Component is
	port
		(
		 sys_clk		: 	in std_logic;
		 pulse		:	in std_logic;
		 reset		:	in	std_logic;
		 o_trigger  : out	std_logic;
		 centimeter : out std_logic_vector(3 downto 0);
		 decimeter 	: out std_logic_vector(3 downto 0);
		 meter		: out std_logic_vector(3 downto 0);
		 distance	: out std_logic_vector(8 downto 0)
		);
end entity;

architecture rtl of Range_Sensor_Component is

	component Dist_calculator is
		port
			 (
			  clk				:	in std_logic;
			  reset_n		:	in std_logic;
			  reset_calc	: 	in std_logic;
			  pulse			: 	in std_logic;
			  distance		:	out std_logic_vector (8 downto 0)
			 );
	end component;


	component Trig_Comp is
		port
			 (
			  reset_n	: in std_logic;
			  clk  		: in std_logic;
			  trig 		: out std_logic;
			  rst_out	: out std_logic
			 );
	end component;


	component BCD_Conv is
		port
			 (
			  clk		 : in	std_logic;
			  reset_n : in std_logic;
			  dist	:	in std_logic_vector(8 downto 0);
			  H,T,E : out std_logic_vector (3 downto 0)
			 );
	end component;
	
	signal trigger_out 	: std_logic;
	signal distance_out	: std_logic_vector(8 downto 0);
	signal s_rst 				: std_logic;

begin
	

	C1 : Dist_calculator
		port map
				(
				 clk => sys_clk,
				 reset_n => s_rst,
				 reset_calc => trigger_out,
				 pulse => pulse,
				 distance => distance_out
				);
				
   C2	: Trig_Comp
		port map
				(
				 reset_n => reset,
				 clk 	   => sys_clk,
				 trig	   => trigger_out,
				 rst_out => s_rst
				);
				
	C3	: BCD_Conv
		port map
				(
				 clk	=> sys_clk,
				 reset_n => s_rst,
				 dist => distance_out,
				 E => centimeter,
				 T => decimeter,
				 H => meter
				);
	 distance <= distance_out;
	 o_trigger <= trigger_out;
end rtl;
				 
