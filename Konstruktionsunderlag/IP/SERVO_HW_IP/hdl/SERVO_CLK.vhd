--64khz

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SERVO_CLK IS
	PORT
	(
		clk		:	IN	STD_LOGIC;
		reset_n	:	IN	STD_LOGIC;
		o_clk		:	OUT STD_LOGIC
	);
END SERVO_CLK;

ARCHITECTURE rtl of SERVO_CLK IS

	SIGNAL temp_clk	:	std_LOGIC;
	SIGNAL cnt			:	integer range 0 to 780 := 0;
	
BEGIN

	clk_div : PROCESS(clk,reset_n)
	BEGIN
		IF (reset_n ='0') THEN
			temp_clk 	<= '0';
			cnt 	<= 0;
		ELSIF RISING_EDGE(clk) THEN
			IF (cnt = 780) THEN
				temp_clk <= NOT temp_clk;
				CNT <= 0;
			ELSE
				cnt <= cnt +1;
			END IF;
		END IF;
	END PROCESS;

	o_clk <= temp_clk;
END rtl;