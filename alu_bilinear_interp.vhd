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

signal weight_x_0, weight_x_1, : UFIXED(11 downto -12) := (others => '0');
signal lerp_x_t, lerp_x_b, lerp_y UFIXED(11 downto -12) := (others => '0');

begin
    out_val <= unsigned(lerp_y(8 downto 0));
    
    -- Weight Compute is parallel set
    weight_x_proc: process(clk) is
        variable flr, tmp: UFIXED (11 downto -12) := (others => '0');
        begin
            if rising_edge(clk) then 
                flr(11 downto 0) := pos_x(11 downto 0);
                tmp := resize(pos_x - flr, pos_x'high, pos_x'low);
                weight_x_0(-1 downto -12) <= tmp(-1 downto -12); 
                weight_x_1 <= resize(to_ufixed(1, weight_x_0) - weight_x_0, weight_x_0'high, weight_x_0'low); 
           end if; 
        end process;
    
    weight_y_proc: process(clk) is
        variable flr, tmp: UFIXED (11 downto -12) := (others => '0');
        begin
            if rising_edge(clk) then 
                flr(11 downto 0) := pos_y(11 downto 0);
                tmp := resize(pos_y - flr, pos_y'high, pos_y'low);
                weight_y_0(-1 downto -12) <= tmp(-1 downto -12); 
                weight_y_1 <= resize(to_ufixed(1, weight_y_0) - weight_y_0, weight_y_0'high, weight_y_0'low);
            end if; 
        end process;
    
    -- Two horizontal linear interp. parallel set
    lerp_x_t_proc: process(weight_x_0, weight_x_1) is 
        variable val_x_0, val_x_1 : UFIXED(11 downto -12) := (others => '0');
        begin
            val_x_0 := resize(to_ufixed(val_00, val_x_0) * weight_x_1, weight_x_0'high, weight_x_0'low);
            val_x_1 := resize(to_ufixed(val_01, val_x_1) * weight_x_0, weight_x_1'high, weight_x_1'low);
            lerp_x_t <= resize(val_x_0 + val_x_1, lerp_x_t'high, lerp_x_t'low);
        end process;
    
    lerp_x_b_proc: process(weight_x_0, weight_x_1) is 
        variable val_x_0, val_x_1 : UFIXED(11 downto -12) := (others => '0');
        begin
            val_x_0 := resize(to_ufixed(val_10, val_x_0) * weight_x_1, weight_x_0'high, weight_x_0'low);
            val_x_1 := resize(to_ufixed(val_11, val_x_1) * weight_x_0, weight_x_1'high, weight_x_1'low);
            lerp_x_b <= resize(val_x_0 + val_x_1, lerp_x_b'high, lerp_x_b'low);
        end process;
    
    -- Final vertical linear interp. based on previous linear interp values
    lerp_y_proc: process(lerp_x_t, lerp_x_b) is
        variable val_y_0, val_y_1 : UFIXED(11 downto -12) := (others => '0');
        begin
            val_y_0 := resize(lerp_x_t * weight_y_1, lerp_x_t'high, lerp_x_b'low);
            val_y_1 := resize(lerp_x_b * weight_y_0, lerp_x_t'high, lerp_x_b'low);
            lerp_y <= resize(val_y_0 + val_y_1, lerp_y'high, lerp_y'low);
        end if;
    end process;

end Behavioral;

