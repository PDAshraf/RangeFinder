
library ieee;
use ieee.std_logic_1164.all;

entity IRQ_IP is
	port(	CLK		:	in std_logic;
			reset_n	:	in std_logic;
			--AvalonBus--
			cs_n		:	in std_logic;
			write_n	:	in std_logic;
			din		:	in std_logic_vector(31 downto 0);
			
			ISR_ACK 	:	in std_logic;
			intr_out	:	out std_logic
		);
end entity;

architecture behavior of IRQ_IP is

	component interrupt_controller
	port
	(	I_CLK		:	in	std_logic;
		I_RST_n	:	in std_logic;
		IR			:	in std_logic_vector (2 downto 0); 
		
		ISR_ACK	:	in std_logic;
		O_INTR	:	out std_logic 
	);
	end component;
	
	signal s_data_reg :	std_logic_vector(2 downto 0);

begin

	 --write process
	bus_register_write_process: Process(clk, reset_n)
	Begin
	if reset_n = '0' then
		s_data_reg <= (others => '0');
	elsif rising_edge(clk) then
		if (cs_n = '0' and write_n = '0') then
			s_data_reg <= din(2 downto 0);
		else
			NULL;
		end if;
	else
		NULL;
	end if;
	End Process bus_register_write_process;
	
	
	inst_intr_cntrl : interrupt_controller
		port map
		(
			I_CLK 	=> CLK,
			I_RST_n 	=> reset_n,
			IR			=> s_data_reg,
			ISR_ACK	=> ISR_ACK,
			O_INTR	=>	intr_out
		);
	
	
end behavior;