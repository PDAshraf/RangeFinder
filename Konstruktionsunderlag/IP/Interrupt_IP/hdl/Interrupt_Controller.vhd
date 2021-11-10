
library ieee;
use ieee.std_logic_1164.all;

entity interrupt_controller is
	port
	(	I_CLK		:	in	std_logic;                     -- Systemclock 50MHz
		I_RST_n	:	in std_logic;                     -- Reset active low
		IR			:	in std_logic_vector (2 downto 0); -- Interrupt from Pio
		
		ISR_ACK	:	in std_logic;                     -- Interrupt Acknowledge
		O_INTR	:	out std_logic                     -- Interrupt to CPU irq pin
	);
end interrupt_controller;

architecture rtl of interrupt_controller is

	signal rst_n_t1, rst_n_t2	:	std_logic;
	type state is (reset_state,wait_intr_state, intr_state, wait_ack_state);
	signal next_state : state := reset_state;
	signal s_intr	:	std_logic_vector(2 downto 0);
	
	
begin
	
	
	reset: process(I_CLK, I_RST_n)
	begin
		if (I_RST_n ='1') then
			rst_n_t1 <= '1';
			rst_n_t2 <= '1';
		elsif rising_edge(I_CLK) then
			rst_n_t1 <= '0';
			rst_n_t2 <= rst_n_t1;
		end  if;
	end process;
	
	
	interrupt : process (I_CLK, rst_n_t2)
	begin
		if (rst_n_t2 ='0') then
			next_state <= reset_state;
		elsif rising_edge(I_CLK) then
			case next_state is
				when reset_state =>
					if (rst_n_t2 ='1') then
						O_INTR <='0';
						next_state <= wait_intr_state;
					else 
						next_state <= reset_state;
					end if;
					
					
				when wait_intr_state =>
					if(IR(0)='1' or IR(1)='1' or IR(2)='1') then
						s_intr <= IR;
						next_state <= intr_state;
					else	
						next_state <= wait_intr_state;
					end if;
					
				when intr_state => 
					if (s_intr(0)='1' and ISR_ACK='0') then
						O_INTR 	 <='1';
						s_intr(0) <='0';
						next_state <= wait_ack_state;
					elsif (s_intr(1)='1' and ISR_ACK='0') then
						O_INTR 	 <='1';
						s_intr(1) <='0';
						next_state <= wait_ack_state;
					elsif (s_intr(2)='1' and ISR_ACK='0') then
						O_INTR 	 <='1';
						s_intr(2) <='0';
						next_state <= wait_ack_state;
					else
						next_state <= wait_intr_state;
					end if;
				
					
				when wait_ack_state =>
					if (ISR_ACK='1') then
						O_INTR <= '0';
						next_state <= wait_intr_state;
					else
						next_state <= wait_ack_state;
					end if;
					
			end case;
		end if;
	end process;
	
end rtl;