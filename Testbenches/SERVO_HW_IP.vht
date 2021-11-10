-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "06/15/2021 20:54:27"
                                                            
-- Vhdl Test Bench template for design  :  SERVO_HW_IP
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY SERVO_HW_IP_vhd_tst IS
END SERVO_HW_IP_vhd_tst;
ARCHITECTURE SERVO_HW_IP_arch OF SERVO_HW_IP_vhd_tst IS
-- constants
CONSTANT sys_clk_period : TIME := 20 ns;                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL cs_n : STD_LOGIC;
SIGNAL din : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL o_pos : STD_LOGIC;
SIGNAL reset_n : STD_LOGIC;
SIGNAL write_n : STD_LOGIC;
COMPONENT SERVO_HW_IP
	PORT (
	clk : IN STD_LOGIC;
	cs_n : IN STD_LOGIC;
	din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	o_pos : OUT STD_LOGIC;
	reset_n : IN STD_LOGIC;
	write_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : SERVO_HW_IP
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	cs_n => cs_n,
	din => din,
	o_pos => o_pos,
	reset_n => reset_n,
	write_n => write_n
	);

	clock_process : process
	begin
		clk <='0';
		wait for sys_clk_period/2;
		clk <='1';
		wait for sys_clk_period/2;
	end process;
	
	reset_process : process
	begin
		reset_n <='0';
		wait for 50 ns;
		reset_n <='1';
		wait;
	end process;
	
	stimuli	:	process
	begin
		cs_n 	  <='0';
		write_n <='0';
		wait for 50 ns;
		din(6 downto 0) <="0010000";
		din (31 downto 7) <=(others=>'0');
		wait for 20 ms;
		din(6 downto 0) <="0110010";
		din (31 downto 7) <=(others=>'0');
		wait for 20 ms;
		din(6 downto 0) <="1010000";
		din (31 downto 7) <=(others=>'0');
		wait for 20 ms;
	end process;
END SERVO_HW_IP_arch;
