library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- The Multi-view Interlacer core, all the computation is on this circuit
-- Composed of two main modules, a view compute module and sampling module

entity mvi_core is
    Port ( fmt_width  : IN  UNSIGNED(11 downto 0);
           fmt_height : IN  UNSIGNED(11 downto 0);
	   pos_x : in  UNSIGNED(11 downto 0);
           pos_y : in  UNSIGNED(11 downto 0);
	   period_y : in  SFIXED(15 downto -16);
	   period_x : in  UNSIGNED(3 downto 0);
           out_rgb : OUT  UNSIGNED(23 downto 0);
	  clk : in STD_LOGIC);
end mvi_core;

architecture Behavioral of mvi_core is

-- Components ...
-- 1) View Computer --> Diverge
-- 2) Sub-Pixel Samplers
-- 3) Sub-Pixel Combiner

-- Internal Signals
-- from input
signal i_pos_x 		: UNSIGNED(11 downto 0);
signal i_pos_y 		: UNSIGNED(11 downto 0);
signal i_fmt_width 	: UNSIGNED(11 downto 0);
signal i_fmt_height 	: UNSIGNED(11 downto 0);
signal i_period_y     	: SFIXED(15 downto -16);
signal i_period_x 	: UNSIGNED(3 downto 0);
-- between components
signal i_view_clk 	: STD_LOGIC;
signal i_view_r 	: UNSIGNED(3 downto 0);
signal i_view_g 	: UNSIGNED(3 downto 0);
signal i_view_b 	: UNSIGNED(3 downto 0);
-- types for R, G, B
signal i_type_r		: UNSIGNED(1 downto 0);
signal i_type_g		: UNSIGNED(1 downto 0);
signal i_type_b		: UNSIGNED(1 downto 0);
-- for output
signal i_out_r		: UNSIGNED(7 downto 0);
signal i_out_g		: UNSIGNED(7 downto 0);
signal i_out_b		: UNSIGNED(7 downto 0);
signal i_out_rgb 	: UNSIGNED(23 downto 0);

COMPONENT mvi_core_0_view
	PORT(
		pos_x : IN std_logic_vector(11 downto 0);
		pos_y : IN std_logic_vector(11 downto 0);
		period_x : IN std_logic_vector(3 downto 0);
		period_y : IN std_logic_vector(15 downto -16);
		clk : IN std_logic;          
		view_r : OUT std_logic_vector(3 downto 0);
		view_g : OUT std_logic_vector(3 downto 0);
		view_b : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
COMPONENT mvi_core_0_sample
	PORT(
		fmt_width : IN std_logic_vector(11 downto 0);
		fmt_height : IN std_logic_vector(11 downto 0);
		pos_x : IN std_logic_vector(11 downto 0);
		pos_y : IN std_logic_vector(11 downto 0);
		type_comp : IN std_logic_vector(1 downto 0);
		view : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;          
		out_comp : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin
	
	-- Assigning inputs to internal signals
	i_pos_x <= pos_x;
	i_pos_y <= pos_y;
	i_fmt_width <= fmt_width;
	i_fmt_height <= fmt_height;
	
	-- Assigning types for components
	i_type_r <= "00";
	i_type_g <= "10";
	i_type_b <= "11";
	
	-- Assign signal to output
	out_rgb <= i_out_rgb;

	-- View Component
	CORE_L0_VIEW: mvi_core_0_view PORT MAP(
		pos_x => i_pos_x,
		pos_y => i_pos_y,
		period_x => i_period_x,
		period_y => i_period_y,
		view_r => i_view_r,
		view_g => i_view_g,
		view_b => i_view_b,
		clk => i_view_clk -- ??? DONT KNOW
	);
	
	-- Red Component Sampling Component
	CORE_L0_R_SAMPLE: mvi_core_0_sample PORT MAP(
		fmt_width => i_fmt_width,
		fmt_height => i_fmt_height,
		pos_x => i_pos_x,
		pos_y => i_pos_y,
		type_comp => i_type_r,
		view => i_view_r,
		out_comp => i_out_r,
		clk => clk -- ??? DONT KNOW
	);
	
	-- Green Component Sampling Component
	CORE_L0_G_SAMPLE: mvi_core_0_sample PORT MAP(
		fmt_width => i_fmt_width,
		fmt_height => i_fmt_height,
		pos_x => i_pos_x,
		pos_y => i_pos_y,
		type_comp => i_type_g,
		view => i_view_g,
		out_comp => i_out_g,
		clk => clk -- ??? DONT KNOW
	);
	
	-- Blue Component Sampling Component
	CORE_L0_G_SAMPLE: mvi_core_0_sample PORT MAP(
		fmt_width => i_fmt_width,
		fmt_height => i_fmt_height,
		pos_x => i_pos_x,
		pos_y => i_pos_y,
		type_comp => i_type_b,
		view => i_view_b,
		out_comp => i_out_b,
		clk => clk -- ??? DONT KNOW
	);
	
	-- I'm confused on how to chain the components together based on an initial clock tick...
	-- So say the core is initialized, the clk signal gets fed into the view component... 
	-- How do we know when the view component has spit out the required outputs (view_r, view_g, view_b)
	-- Once it has spit it out, how do we tell the sample module to do it's job?
	view_proc: process(clk)
	begin
		if rising_edge(clk) then
			i_view_clk <= clk;
		end if;
	end process;
	
end Behavioral;

