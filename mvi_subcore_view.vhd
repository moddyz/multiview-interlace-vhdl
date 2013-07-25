----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:29:07 07/24/2013 
-- Design Name: 
-- Module Name:    mvi_core_0_view - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
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
	variable 
	
	begin
		if rising_edge(clk) then
			-- Initialize Variables
			v_pos_x := to_sfixed(signed(pos_x), v_pos_x);
			v_pos_y := to_sfixed(signed(pos_y), v_pos_y);
			-- Compute Root View (first view of the first red component of the row)
			-- Big problem with the library... doesn't support division and therefore modulus >=(
			v_view_root := v_pos_y * to_sfixed(0.125, v_pos_y);
			v_temp := v_view_root AND "11111111111111110000000000000000";
			v_temp := v_view_root - v_temp;
			v_view_root := v_temp * to_sfixed(signed(period_x), v_view_root);
			
			-- Compute the red component of the pixel in question
			v_sview_r := ((v_pos_x * 3) - v_view_root) mod period_x;
			-- Truncate down to 4 bit unsigned
			v_uview_r := unsigned(v_sview_r);
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

