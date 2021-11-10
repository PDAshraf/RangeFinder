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
-- 	Binary Coded Decimal Converter
--		Konverterar det binära värdet av "dist" till heltal.
--    
--	
--		
--
--
-- Insignaler:
--		clk						System Klocka 50MHz
--		reset_n					Reset
--		dist						Det kalkylerade avståndet(Distance)
--
--	Utsignaler:
--		H							Hundratal ut
--		T							Tiotal 	 ut
--		E							Ental		 ut
--	
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity BCD_Conv is
	port
		(
		 clk		: in std_logic;
		 reset_n	: in std_logic;
		 dist		:	in std_logic_vector(8 downto 0);
		 
		 ---Hundratal, Tiotal, Ental
		 H,T,E 	: out std_logic_vector (3 downto 0) --upp till "1001" ut (Sifror 0-9) 
		);
end BCD_Conv;

architecture rtl of BCD_Conv is

	

begin

	
	

	conversion : process (reset_n,clk)
	variable i : integer := 0;
	variable bcd : std_logic_vector(20 downto 0); -- Binary Coded Deciml
	begin
		bcd := (others => '0');
		bcd(8 downto 0) := dist;
		if reset_n ='0' then
			bcd := (others => '0');
			H	<=	"0000";
			T	<=	"0000";
			E	<=	"0000";
			bcd := (others => '0');
		elsif rising_edge(clk) then
			-- 9 itterationer
			for i in 0 to 8 loop
				---Binär delningsmetod 
				bcd(19 downto 0) := bcd(18 downto 0) & '0';
				
				--Ental 1-9(loop)
				if(i < 8 and bcd(12 downto 9) > "0100") then
					bcd(12 downto 9) := bcd(12 downto 9) + "0011";
				end if;
				
				--Tiotal 10-90(loop)
				if(i < 8 and bcd(16 downto 13) > "0100") then
					bcd(16 downto 13) := bcd(16 downto 13)  + "0011";
				end if;
				
				--Hundratal 100-900(loop)
				if(i < 8 and bcd(20 downto 17) > "0100") then
					bcd(20 downto 17) := bcd(20 downto 17) + "0011";
				end if;	
			end loop;
			H <= bcd(20 downto 17); --Hundratal
			T <= bcd(16 downto 13); --Tiotal
			E <= bcd(12 downto 9);  --Ental
			bcd := (others => '0');
		end  if;
	end process;



end rtl;
	 
		