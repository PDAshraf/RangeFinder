--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PWM_SERVO IS
	PORT
	(
		clk		:	IN STD_LOGIC;
		reset_n	:	IN STD_LOGIC;
		pos_in	:	IN STD_LOGIC_VECTOR(6 downto 0);
		pos_out	:	OUT STD_LOGIC	);
END PWM_SERVO;

ARCHITECTURE rtl OF PWM_SERVO IS
	-- 0 - 1279
	SIGNAL cnt	:	unsigned	(10 downto 0);
	--Signal för att generera pwm puls
	SIGNAL pwm	:	unsigned (6 downto 0);
	
BEGIN

	counter : PROCESS (clk,reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			cnt <=(others=>'0');
		ELSIF RISING_EDGE(clk) THEN
			IF (cnt = 640) THEN
				cnt <= (others=>'0');
			ELSE
				cnt <= cnt +1;
			END IF;
		END IF;
	END PROCESS;
	
	position : PROCESS (clk, pos_in)
	BEGIN
		IF (reset_n ='0') THEN
			pwm <=(others =>'0');
		ELSIF RISING_EDGE(clk) THEN
			pwm <= unsigned (pos_in);
		END IF;
	END PROCESS;
	
	pos_out <= '1' WHEN (cnt < pwm) ELSE '0';
	
END rtl;
			