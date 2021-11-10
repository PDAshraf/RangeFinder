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
-- Generated on "07/05/2021 18:08:35"
                                                            
-- Vhdl Test Bench template for design  :  Sonar
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Sonar_vhd_tst IS
END Sonar_vhd_tst;
ARCHITECTURE Sonar_arch OF Sonar_vhd_tst IS
-- constants   
	CONSTANT sys_clk_period : TIME := 20 ns;
-- signals                                                   
	SIGNAL distance : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL i_clk : STD_LOGIC;
	SIGNAL i_pulse : STD_LOGIC;
	SIGNAL reset : STD_LOGIC;
	SIGNAL sseg0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sseg1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sseg2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL trigger : STD_LOGIC;
	
	COMPONENT Sonar
		PORT (
		distance : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0);
		i_clk : IN STD_LOGIC;
		i_pulse : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		sseg0 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
		sseg1 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
		sseg2 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
		trigger : BUFFER STD_LOGIC
		);
	END COMPONENT;
	
BEGIN
	i1 : Sonar
	PORT MAP (
-- list connections between master ports and signals
	distance => distance,
	i_clk => i_clk,
	i_pulse => i_pulse,
	reset => reset,
	sseg0 => sseg0,
	sseg1 => sseg1,
	sseg2 => sseg2,
	trigger => trigger
	);
	
	clock: process 
	begin -- Clock period 
		i_clk <= '0';
	WAIT FOR sys_clk_period/2; 
		i_clk <= '1';
	WAIT FOR sys_clk_period/2;
	end process clock;
	
	rst: process
	begin -- Reset at start up 
	-- Target running 
	reset <= '0';
	WAIT FOR 10*sys_clk_period;
	reset <='1';
	wait;
	end process rst;
	

	 virtuell_puls: process
      variable p : time := 58 us;
    begin
       i_pulse <= '0';
	  -- Wait for trigger pulse
	  wait until rising_edge(trigger);
	  
	  -- Simulera fördröjning
	  wait for 20 us;
	  
	  -- Skapa virtuell puls
	  i_pulse <= '1';        
	  wait for p;       
	  i_pulse <= '0';

	  --Öka fördröjning till nästa pulls med 58 us
	  p := p + 58 us;
        
    end process;
                                         
END Sonar_arch;
