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
    Port (  pos_x   : IN  UNSIGNED(11 downto 0);
            pos_y   : IN  UNSIGNED(11 downto 0);
            nval_00 : IN  UNSIGNED(8 downto 0);
            nval_01 : IN  UNSIGNED(8 downto 0);
            nval_10 : IN  UNSIGNED(8 downto 0);
            nval_11 : IN  UNSIGNED(8 downto 0);
            out_val : OUT  UNSIGNED(23 downto 0);
            clk     : IN STD_LOGIC);
end alu_bilinear_interp;
