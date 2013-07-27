library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

-- Arithmetic Logic Unit: Bilinear Interpolation
-- Interpolate a value from 4 neighbouring values
-- 00 | 01
-- ---------
-- 10 | 11
-- Position of Neighbouring values labeled with (Y,X) 

entity alu_bilinear_interp is
    Port (  pos_x   : IN  UFIXED(11 downto -12);
            pos_y   : IN  UFIXED(11 downto -12);
            val_00  : IN  UNSIGNED(8 downto 0);
            val_01  : IN  UNSIGNED(8 downto 0);
            val_10  : IN  UNSIGNED(8 downto 0);
            val_11  : IN  UNSIGNED(8 downto 0);
            out_val : OUT  UNSIGNED(8 downto 0);
            clk     : IN STD_LOGIC);
end alu_bilinear_interp;

architecture Behavioral of alu_bilinear_interp is

signal i_out_val : UNSIGNED(8 downto 0) := (others => '0');

begin
    -- Signal to Output assignment
    out_val <= i_out_val;
    
    interp_proc: process(clk, pos_x, pos_y) is
    -- Variables for positions of neighbouring values
    variable weight_x_0, weight_x_1, weight_y_0, weight_y_1 : UFIXED(11 downto -12) := (others => '0');
             
    -- Temporary variables to aid in the resizing process
    variable v1, v2, v3, v4, v5, v6, v7, v8, v9 : UFIXED(11 downto -12) := (others => '0');
    variable temp : UFIXED (8 downto 0) := (others => '0');
    
    -- Storage of the intermediate interpolation values
    variable li_top, li_bot, bi : UFIXED(11 downto -12) := (others => '0');
    begin
        if rising_edge(clk) then
                -- Compute x weights
                v1(11 downto 0) := pos_x(11 downto 0);
                v1 := resize(pos_x - v1, pos_x'high, pos_x'low);
                weight_x_0(-1 downto -12) := v1(-1 downto -12);
                weight_x_1 := resize(to_ufixed(1, weight_x_0) - weight_x_0, weight_x_0'high, weight_x_0'low);
                
                -- Compute y weights
                v2(11 downto 0) := pos_y(11 downto 0);
                v2 := resize(pos_y - v2, pos_y'high, pos_y'low);
                weight_y_0(-1 downto -12) := v1(-1 downto -12);
                weight_y_1 := resize(to_ufixed(1, weight_y_0) - weight_y_0, weight_y_0'high, weight_y_0'low);
                
                -- Linearly interpolate 00 and 01 horizontally (the top two values)
                v3 := resize(to_ufixed(val_00, v3) * weight_x_0, weight_x_0'high, weight_x_0'low);
                v4 := resize(to_ufixed(val_01, v4) * weight_x_1, weight_x_1'high, weight_x_1'low);
                li_top := resize(v3 + v4, li_top'high, li_top'low);
                
                -- Linearly interpolate 10 and 11 horizontally (the bottom two values)
                v5 := resize(to_ufixed(val_10, v5) * weight_x_0, weight_x_0'high, weight_x_0'low);
                v6 := resize(to_ufixed(val_11, v6) * weight_x_1, weight_x_1'high, weight_x_1'low);
                li_bot := resize(v3 + v4, li_top'high, li_top'low);
                
                -- Linearly interpolate the top and bottom intermediate values vertically
                -- for final interpolated result
                v7 := resize(li_top * weight_y_0, li_top'high, li_top'low);
                v8 := resize(li_bot * weight_y_1, li_bot'high, li_bot'low);
                bi := resize(li_top + li_bot, bi'high, bi'low);
                
                temp := bi(8 downto 0);
                
                -- Variable to signal assignment
                i_out_val <= unsigned(temp);
        end if;
    end process;
    
end Behavioral;

