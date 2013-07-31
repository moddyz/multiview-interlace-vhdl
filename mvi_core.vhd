library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- The Multi-view Interlacer core, all the computation is on this circuit
-- Composed of two main modules, a view compute module and sampling module

entity mvcore is
    Port ( fmt_width    : IN  UNSIGNED(11 downto 0);
           fmt_height   : IN  UNSIGNED(11 downto 0);
           pos_x        : IN  UNSIGNED(11 downto 0);
           pos_y        : IN  UNSIGNED(11 downto 0);
           period_y     : IN  SFIXED(15 downto -16);
           period_x     : IN  UNSIGNED(3 downto 0);
           out_rgb      : OUT UNSIGNED(23 downto 0);
           clk          : IN  STD_LOGIC);
end mvcore;

architecture Behavioral of mvcore is

-- Components ...
-- 1) View Computer --> Diverge
-- 2) Sub-Pixel Samplers
-- 3) Sub-Pixel Combiner

-- Internal Signals
signal view_r         : UNSIGNED(3 downto 0);
signal view_g         : UNSIGNED(3 downto 0);
signal view_b         : UNSIGNED(3 downto 0);
signal type_r         : UNSIGNED(1 downto 0);
signal type_g         : UNSIGNED(1 downto 0);
signal type_b         : UNSIGNED(1 downto 0);
signal out_r          : UNSIGNED(7 downto 0);
signal out_g          : UNSIGNED(7 downto 0);
signal out_b          : UNSIGNED(7 downto 0);
signal out_rgb        : UNSIGNED(23 downto 0);

COMPONENT mvcore_0_view
    PORT(
        pos_x       : IN UNSIGNED(11 downto 0);
        pos_y       : IN UNSIGNED(11 downto 0);
        period_x    : IN UNSIGNED(3 downto 0);
        period_y    : IN SFIXED(15 downto -16);
        clk         : IN STD_LOGIC;          
        view_r      : OUT UNSIGNED(3 downto 0);
        view_g      : OUT UNSIGNED(3 downto 0);
        view_b      : OUT UNSIGNED(3 downto 0)
        );
    END COMPONENT;
    
COMPONENT mvcore_0_sample
    PORT(
        fmt_width   : IN UNSIGNED(11 downto 0);
        fmt_height  : IN UNSIGNED(11 downto 0);
        pos_x       : IN UNSIGNED(11 downto 0);
        pos_y       : IN UNSIGNED(11 downto 0);
        type_comp   : IN UNSIGNED(1 downto 0);
        view        : IN UNSIGNED(3 downto 0);
        clk         : IN STD_LOGIC;          
        out_comp    : OUT UNSIGNED(7 downto 0)
        );
    END COMPONENT;

begin
    
    -- Assigning types for components
    type_r <= "00";
    type_g <= "10";
    type_b <= "11";
    
    -- Combining the component signals
    -- Combined!
    out_rgb <= out_r & out_g & out_b;
    
    -- View Component
    CORE_L0_VIEW: mvcore_0_view PORT MAP(
        pos_x => pos_x,
        pos_y => pos_y,
        period_x => period_x,
        period_y => period_y,
        view_r => view_r,
        view_g => view_g,
        view_b => view_b,
        clk => clk
    );
    
    -- Red Sampling Component
    CORE_L0_R_SAMPLE: mvcore_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => type_r,
        view => view_r,
        out_comp => out_r,
        clk => clk 
    );
    
    -- Green Sampling Component
    CORE_L0_G_SAMPLE: mvcore_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => type_g,
        view => view_g,
        out_comp => out_g,
        clk => clk
    );
    
    -- Blue Sampling Component
    CORE_L0_B_SAMPLE: mvcore_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => type_b,
        view => view_b,
        out_comp => out_b,
        clk => clk
    );
end Behavioral;
