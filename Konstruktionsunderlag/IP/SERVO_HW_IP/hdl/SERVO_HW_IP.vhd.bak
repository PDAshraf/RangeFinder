--

LIBRARY  IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SERVO_HW_IP IS
	PORT
	(
		clk		:	IN	STD_LOGIC;
		reset_n	:	IN STD_LOGIC;
		--i_pos		:	IN STD_LOGIC_VECTOR(6 downto 0);
		--Avalon Read--
		cs_n		:	IN STD_LOGIC;
		write_n	:	IN STD_LOGIC;
		din		:	IN	STD_LOGIC_VECTOR(31 downto 0);
		--dout		:	IN	STD_LOGIC_VECTOR(31 downto 0);
		--Servo Position
		o_pos		:	OUT STD_LOGIC
	);
END SERVO_HW_IP;

ARCHITECTURE Behavioral OF SERVO_HW_IP IS

	SIGNAL s_serv_clk		:	STD_LOGIC := '0';
	SIGNAL i_data_reg		:	STD_LOGIC_VECTOR(6 downto 0);

	COMPONENT SERVO_CLK
	PORT
	(
		clk		:	IN STD_LOGIC;
		reset_n	:	IN STD_LOGIC;
		o_clk		:	OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT PWM_SERVO
	PORT
	(
		clk		:	IN STD_LOGIC;
		reset_n	:	IN STD_LOGIC;
		pos_in	:	IN STD_LOGIC_VECTOR(6 downto 0);
		pos_out	:	OUT STD_LOGIC
	);
	END COMPONENT;
		
BEGIN


 --write process
	bus_register_write_process: Process(clk, reset_n)
	Begin
	if reset_n = '0' then
		i_data_reg <= (others => '0');
	elsif rising_edge(clk) then
		if (cs_n = '0' and write_n = '0') then
			i_data_reg <= din(6 downto 0);
		else
			NULL;
		end if;
	else
		NULL;
	end if;
	End Process bus_register_write_process;
	
	
	inst_clk_div : SERVO_CLK
		PORT MAP
		(
			clk		=> clk,
			reset_n	=> reset_n,
			o_clk		=> s_serv_clk
		);
		
		
	inst_servo_pwm	:	PWM_SERVO
		PORT MAP
		(
			clk		=> s_serv_clk,
			reset_n	=> reset_n,
			pos_in	=> i_data_reg,
			pos_out	=> o_pos
		);
		
		
		
END Behavioral;