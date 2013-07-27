library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- Core's submodule 'Sample'
-- Based on target coordinates, we sample from a certain view
-- Sampling translates to bilinear interpolation in our case, and we are doing it for a particular sub-pixel

entity mvi_core_0_sample is
     Port ( fmt_width  : IN  UNSIGNED(11 downto 0);  -- Total width of frame
            fmt_height : IN  UNSIGNED(11 downto 0);  -- Total height of frame
            pos_x      : IN  UNSIGNED(11 downto 0);  -- Position X we're writing color to
            pos_y      : IN  UNSIGNED(11 downto 0);  -- Position Y we're writing the color to
            type_comp  : IN  UNSIGNED(1 downto 0);   -- Type of color component 00 R, 01 G, 10 B, 11 ERROR
            view       : IN  UNSIGNED(3 downto 0);   -- View we are to sample from
            out_comp   : OUT UNSIGNED(7 downto 0);   -- Output color
            clk        : IN  STD_LOGIC);
end mvi_core_0_sample;

architecture Behavioral of mvi_core_0_sample is

-- Internal Signals
signal i_samp_x    :  UNSIGNED(11 downto 0);     -- sampling x pos 
signal i_samp_y    :  UNSIGNED(11 downto 0);     -- sampling y pos
signal i_out_comp  :  UNSIGNED(7 downto 0);     -- calculated output color for pixel

begin

    sample_coords: process(sensitivity_list)
    
    -- Variable declaration
    variable x         : UNSIGNED(11 downto 0);    -- scaled x value for sampling
    variable y         : UNSIGNED(11 downto 0);    -- scaled y value for sampling
    variable x_mod     : UNSIGNED(11 downto 0);
    variable y_mod     : UNSIGNED(11 downto 0);
    
    begin
    
    -- Compute modulus of input
    x_mod := pos_x mod 3; --Compiler complaining about mod
    y_mod := pos_y mod 8; --Compiler complaining about mod
    x := pos_x - x_mod;
    y := pos_y - y_mod;

    -- Compute pixel sample given view number
    case (view) is
    when 1 =>                             -- view number 1
        x := x/3;
        y := y*3/8;
    when 2 =>                             -- view number 2
        x := x/3 + fmt_width/3;
        y := y*3/8;
    when 3 =>                             -- view number 3
        x := x/3 + fmt_width*2/3;
        y := y*3/8;
    when 4 =>                             -- view number 4
        x := x/3;
        y := y_in * 3/8 + fmt_height*3/8;
    when 5 =>                             -- view number 5
        x := x/3 + fmt_width/3;
        y := y_in * 3/8 + fmt_height*3/8;
    when 6 =>                             -- view number 6
        x := x/3 + fmt_width*2/3;
        y := y*3/8 + fmt_height*3/8;
    when 7 =>                            -- view number 7
        if(y_in > fmt_height/3) then                 -- bottom
            x := x/3 ;
            y := y*3/8 + 5*fmt_height/8;
        else                                      -- top
            x := x/3 + fmt_width/3;
            y := y*3/8 + fmt_height*6/8;
        end if;
    when others =>                            -- view number 8
        if(y_in > fmt_height*2/3) then                -- bottom 
            x := x/3 + fmt_width / 3;
            y := y*3/8 + fmt_height*5/8;
        else                            -- top
            x := x/3 + fmt_width * 2/3;
            y := y*3/8 + fmt_height*6/8;
        end if;
    end case;

    -- set output
    i_samp_x <= x;
    i_samp_y <= y;
    
    end process;

    -- Bilinear Interpolation Code
    bilinear_interp: process(sensitivity_list)
    variable v_out_comp : UNSIGNED(7 downto 0);
    begin
    -- Assign variable to signal
    i_out_comp <= v_out_comp;
    end process;

    -- Assign signal to output
    out_comp <= i_out_comp; 

end Behavioral;

