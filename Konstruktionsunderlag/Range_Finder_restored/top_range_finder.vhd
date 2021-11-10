--
library ieee;
use ieee.std_logic_1164.all;


entity top_range_finder is
	port
	(
		MAX10_CLK1_50		:	in	std_logic;
		KEY					:	in std_logic_vector(1 downto 0);
		SW						:	in std_logic_vector(9 downto 0);
		Echo					:	in	std_logic;
		Trig					:	out std_logic;
		servo0				:	out std_logic;
		LEDR					:	out std_logic_vector(9 downto 0);
		HEX0,HEX1,HEX2		:	out std_logic_vector(6 downto 0);
		VGA_R,VGA_G,VGA_B :	out std_logic_vector(3 downto 0);
		VGA_VS,VGA_HS		:	out std_logic
	);
end entity;

architecture rtl of top_range_finder is

	component Range_finder is
	port (
		clk_clk            : in  std_logic                    := '0';             --         clk.clk
		distance_in_export : in  std_logic_vector(8 downto 0) := (others => '0'); -- distance_in.export
		ext_irq_export     : in  std_logic_vector(1 downto 0) := (others => '0'); --     ext_irq.export
		key_in_export      : in  std_logic_vector(1 downto 0) := (others => '0'); --      key_in.export
		reset_reset_n      : in  std_logic                    := '0';             --       reset.reset_n
		servo_pos_export   : out std_logic;                                       --   servo_pos.export
		sw_in_export       : in  std_logic_vector(7 downto 0) := (others => '0'); --       sw_in.export
		task_id_export     : out std_logic_vector(2 downto 0);                    --     task_id.export
		vga_b_export       : out std_logic_vector(3 downto 0);                    --       vga_b.export
		vga_g_export       : out std_logic_vector(3 downto 0);                    --       vga_g.export
		vga_hs_export      : out std_logic;                                       --      vga_hs.export
		vga_r_export       : out std_logic_vector(3 downto 0);                    --       vga_r.export
		vga_vs_export      : out std_logic;                                       --      vga_vs.export
		wd_rst_export      : out std_logic                                        --      wd_rst.export
	);
	end component;
	
	
	component Sonar is
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
	end component;
	
	component meta_comp is 
   port
      (
         clk		: in	std_logic;
			reset_n	: in	std_logic;
			key_in	: in std_logic_vector(1 downto 0);
			sw_in		: in std_logic_vector(8 downto 0);
			key_o		: out std_logic_vector(1 downto 0);
			sw_o		: out std_logic_vector(8 downto 0);
			reset_o	: out std_logic
      );
	end component;
	
	
	
	signal s_dist,s_sw	:	std_logic_vector(8 downto 0);
	signal s_key			:	std_logic_vector(1 downto 0);
	signal s_rst_n			:	std_logic;
	signal s_wd_rst		:	std_logic;
	signal s_rst_out		:	std_logic;

	
begin

	

	inst_ecs	:	Range_finder
		port map
			(
				clk_clk					=> MAX10_CLK1_50,
				distance_in_export 	=> s_dist,
				--ext_irq_export
				key_in_export			=> s_key,
				reset_reset_n			=>	s_rst_out xnor s_rst_n,
				servo_pos_export		=>	servo0,
				sw_in_export			=>	s_sw(7 downto 0),
				task_id_export			=>	LEDR(2 downto 0),
				vga_b_export			=>	VGA_B,
				vga_g_export			=>	VGA_G,
				vga_hs_export			=>	VGA_HS,
				vga_r_export			=> VGA_R,
				vga_vs_export			=>	VGA_VS,
				wd_rst_export			=> s_wd_rst
			);
			
	inst_sonar	:	sonar
		port map
			(
				i_clk			=>	MAX10_CLK1_50,
				wd_en_n 		=> s_sw(8),
				wd_restart  => s_wd_rst,
				i_pulse		=> Echo,
				reset			=> s_rst_n,
				trigger		=> Trig,
				distance		=> s_dist,
				rst_out		=> s_rst_out,
				sseg0			=>	HEX0,
				sseg1			=>	HEX1,
				sseg2			=>	HEX2
			);
			
	inst_meta_comp : meta_comp
		port map
			(
				clk		=> MAX10_CLK1_50,
				reset_n  => SW(9),
				key_in	=> KEY,
				sw_in		=> SW(8 downto 0),
				key_o		=> s_key,
				sw_o		=> s_sw,
				reset_o	=> s_rst_n
			);
			
end rtl;