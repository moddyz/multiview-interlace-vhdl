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
    Port (  pos_x   : IN  UFIXED(11 downto 6);
            pos_y   : IN  UFIXED(11 downto 6);
            val_00 : IN  UNSIGNED(8 downto 0);
            val_01 : IN  UNSIGNED(8 downto 0);
            val_10 : IN  UNSIGNED(8 downto 0);
            val_11 : IN  UNSIGNED(8 downto 0);
            out_val : OUT  UNSIGNED(23 downto 0);
            clk     : IN STD_LOGIC);
end alu_bilinear_interp;

architecture Behavioral of alu_bilinear_interp is
begin

    interp_proc: process(clk) is
    variable pos_00, pos_01, pos_10, pos_11 : UNSIGNED(11 downto 6);
    begin
        
    end process;
    
end Behavioral;

