library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- Sub-core module 'View'
-- Computes the view for the particular pixel at (pos_x, pos_y) based on the periods
-- Right now period_x actually represents the number of views (we're not doing anything fancy yet)
-- period_y is computed from the angle factor from the angle module outside the core

entity mvi_core_0_view is
    Port ( pos_x        : in  UNSIGNED(11 downto 0);
           pos_y        : in  UNSIGNED(11 downto 0);
           period_x     : in  UNSIGNED(3 downto 0);
           period_y     : in  SFIXED(15 downto -16);
           view_r       : out  UNSIGNED(3 downto 0);
           view_g       : out  UNSIGNED(3 downto 0);
           view_b       : out  UNSIGNED(3 downto 0);
           clk        : in     STD_LOGIC);
end mvi_core_0_view;

architecture Behavioral of mvi_core_0_view is

begin
    -- Output <- Signal assignment
    view_proc: process(clk)

    -- Process Variables
    variable view_root    : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
    variable temp         : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
    variable sview_r      : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
    variable pos_x        : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
    variable pos_y        : SFIXED(15 downto -16) := to_sfixed(0, 15, -16);
    variable uview_r      : UNSIGNED(3 downto 0)  := to_unsigned(0, 4);
    variable uview_g      : UNSIGNED(3 downto 0)  := to_unsigned(0, 4);
    variable uview_b      : UNSIGNED(3 downto 0)  := to_unsigned(0, 4);
    variable utemp        : UNSIGNED(31 downto 0) := to_unsigned(0, 32);
    
    begin
        if rising_edge(clk) then
    
            -- Initialize Variables
            sf_pos_x := to_sfixed(signed(pos_x), pos_x);
            sf_pos_y := to_sfixed(signed(pos_y), pos_y);
            
            -- Compute Root View (first view of the first red component of the row)
            -- Big problem with the library... doesn't support division and therefore modulus >=(
            -- Right now hardcoding it to be 8 views... supporting Y period = 8 and X period = 8 only
            -- Which means "Angle" is 18.435
            view_root := pos_y * to_sfixed(0.125, sf_pos_y);
            temp := view_root AND "11111111111111110000000000000000";
            temp := view_root - temp;
            view_root := temp * to_sfixed(period_x, view_root);
            
            -- Compute the red component of the pixel in question
            sview_r := ((pos_x * 3) - view_root);
            sview_r := sview_r * to_sfixed(0.125, pos_x);
            temp := sview_r AND "11111111111111110000000000000000";
            temp := sview_r - temp;
            sview_r := temp * to_sfixed(8, sview_r);
            
            -- Truncate down to 4 bit unsigned
            utemp := unsigned(sview_r);
            uview_r := utemp(3 downto 0);
            
            -- Compute Green view
            uview_g := uview_r + 1;
            if (uview_g >= period_x) then
                uview_g := uview_g - period_x;
            end if;
            
            -- Compute Blue View
            uview_b := uview_r + 2;
            if (uview_b >= period_x) then
                uview_b := uview_b - period_x;
            end if;
            
            -- Signal <- Variable Assignment
            view_r <= uview_r;
            view_g <= uview_g;
            view_b <= uview_b;
        end if;
    end process;
end Behavioral;

