-------------------------------------------------------------------------------
--
-- Företag           : TEIS AB 
-- Författare        : Ashraf Tumah
-- 
-- Skapad            : 2021-04-07
-- Designnamn        : Pix_Gen
-- Enhet             : DE10-Lite 10M50DAF484C7G
-- Verktygsversion   : Quartus Prime 18.1 och ModelSim 10.5b
-- Testbänk          : 
-- DO file           : 
--
-- Beskrivning :
--    Topnivån för anvståndsmätaren
--       innehåller komponenter-
--    Pix_Gen och Range_Sensor_Component
--
--
-- Insignaler:
--    i_clk       System Klocka 50MHz
--    i_pulse     Ultraljud in
--    sw          Switch 0 och 1
--    reset       Reset Switch
--
-- Utsignaler:
--    trigger     Ultraljud ut
--    sseg0       7SegDisplay,visar värden i c
--    sseg1       7SegDisplay,visar värden i dm
--    sseg2       7SegDisplay,visar värden i m
--    addr        Pixeladdress ut
--    we          Write Enable(RAM)
--    data        Pixeldata ut
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sonar is
   port
      (
       i_clk   				: in std_logic;
		 wd_en_n					: in std_logic;
		 wd_restart				: in std_logic;
       i_pulse 				: in std_logic;
       reset   				: in std_logic;
       trigger 				: out std_logic;
		 rst_out					: out std_logic;
		 distance				: out std_logic_vector(8 downto 0);
       sseg0,sseg1,sseg2	: out std_logic_vector (6 downto 0)
      );
end entity;

architecture rtl of Sonar is


   
   
   component Range_Sensor_Component is
      port
         (
          sys_clk    :  in std_logic;
          reset      :  in std_logic;
          pulse      :  in std_logic;
          o_trigger  : out std_logic;
          centimeter : out std_logic_vector(3 downto 0);
          decimeter  : out std_logic_vector(3 downto 0);
          meter      : out std_logic_vector(3 downto 0);
			 distance	: out std_logic_vector(8 downto 0)
         );
   end component;
	
	component sseg is
		port
		(
			reset_n,	clk		:	in std_logic;
			in0,in1,in2			:	in std_logic_vector(3 downto 0);
			sseg0,sseg1,sseg2	:	out std_logic_vector(6 downto 0)
		);
	end component;
	
		component wd_timer is
   port
   (
      clk         :  in std_logic;
      wdt_en_n    :  in std_logic;
      reset_n     :  in std_logic;
      restart     :  in std_logic :='0';
      reset_out_n :  out std_logic;
      led         :  out std_logic_vector(7 downto 0)
   );
	end component;
   
   signal s_cm,s_dm,s_m : std_logic_vector(3 downto 0);
	signal s_rst_n	:	std_logic;
   
begin
   

         
   Komp1 :  Range_Sensor_Component
      port map
         (
          sys_clk => i_clk,
          reset => s_rst_n,
          pulse => i_pulse,
          o_trigger => trigger,
          centimeter => s_cm,
          decimeter => s_dm,
          meter => s_m,
			 distance => distance
         );
			
	Komp2	: sseg
		port map 
			(
			 clk 		=> i_clk,
			 reset_n => s_rst_n,
			 in0		=> s_cm,
			 in1		=> s_dm,
			 in2		=> s_m,
			 sseg0 	=> sseg0,
			 sseg1 	=> sseg1,
			 sseg2 	=> sseg2
			);
			
	Komp3	:	wd_timer
		port map
			(
				clk			=> i_clk,
				wdt_en_n		=>	wd_en_n,
				reset_n		=> reset,
				restart		=> wd_restart,
				reset_out_n	=> s_rst_n
			);
			
	rst_out <= s_rst_n;
          
end rtl;
	