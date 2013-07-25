library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

entity mvi_core_0_view is
    Port ( pos_x 	  : in  UNSIGNED(11 downto 0);
           pos_y 	  : in  UNSIGNED(11 downto 0);
           period_x : in  UNSIGNED(3 downto 0);
           period_y : in  SFIXED(15 downto -16);
           view_r   : out  UNSIGNED(3 downto 0);
           view_g   : out  UNSIGNED(3 downto 0);
           view_b   : out  UNSIGNED(3 downto 0);
			  clk		  : in 	STD_LOGIC);
end mvi_core_0_view;

architecture Behavioral of mvi_core_0_view is

signal i_view_r : UNSIGNED(3 downto 0);
signal i_view_g : UNSIGNED(3 downto 0);
signal i_view_b : UNSIGNED(3 downto 0);
begin
	-- Output <- Signal assignment
	view_r <= i_view_r;
	view_g <= i_view_r + 1;
	view_b <= i_view_r + 2;
	view_proc: process(clk)

	-- Process Variables
	variable v_view_root : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
	variable v_temp 	 	: SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
	variable v_sview_r 	: SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
	variable v_pos_x 		: SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
	variable v_pos_y 		: SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
	variable v_uview_r 	: UNSIGNED(3 downto 0) 	:= to_unsigned(0, 4);
	variable v_uview_g 	: UNSIGNED(3 downto 0) 	:= to_unsigned(0, 4);
	variable v_uview_b 	: UNSIGNED(3 downto 0) 	:= to_unsigned(0, 4);
	variable v_utemp		: UNSIGNED(31 downto 0) := to_unsigned(0, 32);
	
	begin
		if rising_edge(clk) then
			-- Initialize Variables
			v_pos_x := to_sfixed(signed(pos_x), v_pos_x);
			v_pos_y := to_sfixed(signed(pos_y), v_pos_y);
			-- Compute Root View (first view of the first red component of the row)
			-- Big problem with the library... doesn't support division and therefore modulus >=(
			-- Right now hardcoding it to be 8 views... supporting Y period = 8 and X period = 8 only
			-- Which means "Angle" is 18.435
			v_view_root := v_pos_y * to_sfixed(0.125, v_pos_y);
			v_temp := v_view_root AND "11111111111111110000000000000000";
			v_temp := v_view_root - v_temp;
			v_view_root := v_temp * to_sfixed(8, v_view_root);
			
			-- Compute the red component of the pixel in question
			v_sview_r := ((v_pos_x * 3) - v_view_root);
			v_sview_r := v_sview_r * to_sfixed(0.125, v_pos_x);
			v_temp := v_sview_r AND "11111111111111110000000000000000";
			v_temp := v_sview_r - v_temp;
			v_sview_r := v_temp * to_sfixed(8, v_sview_r);
			-- Truncate down to 4 bit unsigned
			v_utemp := unsigned(v_sview_r);
			v_uview_r := v_utemp(3 downto 0);
			-- Compute Green view
			v_uview_g := v_uview_r + 1;
			if (v_uview_g >= period_x) then
				v_uview_g := v_uview_g - period_x;
			end if;
			-- Compute Blue View
			v_uview_b := v_uview_r + 2;
			if (v_uview_b >= period_x) then
				v_uview_b := v_uview_b - period_x;
			end if;
			
			-- Signal <- Variable Assignment
			i_view_r <= v_uview_r;
			i_view_g <= v_uview_g;
			i_view_b <= v_uview_b;
		end if;
	end process;

end Behavioral;

