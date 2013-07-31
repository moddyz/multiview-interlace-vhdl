library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- The Multi-view Interlacer core, all the computation is on this circuit
-- Composed of two main modules, a view compute module and sampling module

entity mvi_core is
    Port ( fmt_width    : IN  UNSIGNED(11 downto 0);
           fmt_height   : IN  UNSIGNED(11 downto 0);
           pos_x        : IN  UNSIGNED(11 downto 0);
           pos_y        : IN  UNSIGNED(11 downto 0);
           period_y     : IN  SFIXED(15 downto -16);
           period_x     : IN  UNSIGNED(3 downto 0);
           out_rgb      : OUT UNSIGNED(23 downto 0);
           clk          : IN  STD_LOGIC);
end mvi_core;

architecture Behavioral of mvi_core is

-- Components ...
-- 1) View Computer --> Diverge
-- 2) Sub-Pixel Samplers
-- 3) Sub-Pixel Combiner

-- Internal Signals
signal view_r         : UNSIGNED(3 downto 0);
signal view_g         : UNSIGNED(3 downto 0);
signal view_b         : UNSIGNED(3 downto 0);
-- types for R, G, B
signal i_type_r         : UNSIGNED(1 downto 0);
signal i_type_g         : UNSIGNED(1 downto 0);
signal i_type_b         : UNSIGNED(1 downto 0);
-- for output
signal i_out_r          : UNSIGNED(7 downto 0);
signal i_out_g          : UNSIGNED(7 downto 0);
signal i_out_b          : UNSIGNED(7 downto 0);
signal i_out_rgb        : UNSIGNED(23 downto 0);

COMPONENT mvi_core_0_view
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
    
COMPONENT mvi_core_0_sample
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
    i_type_r <= "00";
    i_type_g <= "10";
    i_type_b <= "11";
    
    -- Combining the component signals
    -- Combined!
    out_rgb <= i_out_r & i_out_g & i_out_b;
    
    -- View Component
    CORE_L0_VIEW: mvi_core_0_view PORT MAP(
        pos_x => pos_x,
        pos_y => pos_y,
        period_x => period_x,
        period_y => period_y,
        view_r => view_r,
        view_g => view_g,
        view_b => view_b,
        clk => i_view_clk -- ??? DONT KNOW
    );
    
    -- Red Component Sampling Component
    CORE_L0_R_SAMPLE: mvi_core_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => i_type_r,
        view => view_r,
        out_comp => i_out_r,
        clk => clk -- ??? DONT KNOW
    );
    
    -- Green Component Sampling Component
    CORE_L0_G_SAMPLE: mvi_core_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => i_type_g,
        view => view_g,
        out_comp => i_out_g,
        clk => clk -- ??? DONT KNOW
    );
    
    -- Blue Component Sampling Component
    CORE_L0_B_SAMPLE: mvi_core_0_sample PORT MAP(
        fmt_width => fmt_width,
        fmt_height => fmt_height,
        pos_x => pos_x,
        pos_y => pos_y,
        type_comp => i_type_b,
        view => view_b,
        out_comp => i_out_b,
        clk => clk
    );
end Behavioral;
