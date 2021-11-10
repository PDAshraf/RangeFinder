--
library ieee;
use ieee.std_logic_1164.all;

entity sseg is
	port
	(
		reset_n,	clk		:	in std_logic;
		in0,in1,in2			:	in std_logic_vector(3 downto 0);
		sseg0,sseg1,sseg2	:	out std_logic_vector(6 downto 0)
	);
end sseg;

architecture rtl of sseg is



begin


	sseg : process(reset_n,clk)
	begin
		if reset_n ='0' then
			sseg0 <= "0111111";
			sseg1	<= "0111111";
			sseg2	<= "0111111";
		elsif rising_edge(clk) then
			if in0= "0000" then		sseg0 <= "1000000";--0
			elsif in0= "0001" then	sseg0 <= "1111001";--1
			elsif in0= "0010" then 	sseg0 <= "0100100";--2
			elsif	in0= "0011"	then	sseg0 <= "0110000";--3
			elsif	in0= "0100"	then	sseg0 <= "0011001";--4
			elsif	in0= "0101"	then	sseg0 <= "0010010";--5
			elsif	in0= "0110"	then	sseg0 <= "0000010";--6
			elsif	in0= "0111"	then	sseg0 <= "1111000";--7
			elsif	in0= "1000"	then	sseg0 <= "0000000";--8
			elsif	in0= "1001"	then	sseg0 <= "0010000";--0
			else							sseg0 <=	"1111111";
			end if;
			
			if in1= "0000" then		sseg1 <= "1000000";--0
			elsif in1= "0001" then	sseg1 <= "1111001";--1
			elsif in1= "0010" then 	sseg1 <= "0100100";--2
			elsif	in1= "0011"	then	sseg1 <= "0110000";--3
			elsif	in1= "0100"	then	sseg1 <= "0011001";--4
			elsif	in1= "0101"	then	sseg1 <= "0010010";--5
			elsif	in1= "0110"	then	sseg1 <= "0000010";--6
			elsif	in1= "0111"	then	sseg1 <= "1111000";--7
			elsif	in1= "1000"	then	sseg1 <= "0000000";--8
			elsif	in1= "1001"	then	sseg1 <= "0010000";--0
			else							sseg1 <=	"1111111";
			end if;
			
			if in2= "0000" then		sseg2 <= "1000000";--0
			elsif in2= "0001" then	sseg2 <= "1111001";--1
			elsif in2= "0010" then 	sseg2 <= "0100100";--2
			elsif	in2= "0011"	then	sseg2 <= "0110000";--3
			elsif	in2= "0100"	then	sseg2 <= "0011001";--4
			elsif	in2= "0101"	then	sseg2 <= "0010010";--5
			elsif	in2= "0110"	then	sseg2 <= "0000010";--6
			elsif	in2= "0111"	then	sseg2 <= "1111000";--7
			elsif	in2= "1000"	then	sseg2 <= "0000000";--8
			elsif	in2= "1001"	then	sseg2 <= "0010000";--0
			else							sseg2 <=	"1111111";
			end if;
		end if;
	end process;
end rtl;