library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;
--use UNISIM.VComponents.all;

-- 'mvi_system' is the top-level module of the design, encapsulating all 
-- the cores and the core dispatchers

entity mvi_system is
    Port ( fmt_width    : IN  UNSIGNED(11 downto 0);
           fmt_height   : IN  UNSIGNED(11 downto 0);
           angle        : IN  SFIXED(31 downto 0);
           views        : IN  UNSIGNED(3 downto 0);
           clk          : IN  STD_LOGIC;
           fin          : OUT STD_LOGIC;
           c0_out_rgb   : OUT UNSIGNED(23 downto 0)); -- Testing purposes only, core RGB output
end mvi_system;

architecture Behavioral of mvi_system is
    
    -- System Internal Signals
    signal i_fmt_width      : UNSIGNED(11 downto 0);
    signal i_fmt_height     : UNSIGNED(11 downto 0);
    signal i_angle          : SFIXED(31 downto 0);
    signal i_views          : UNSIGNED(3 downto 0);
    signal i_clk            : STD_LOGIC;
    signal i_fin            : STD_LOGIC;
    
    -- Core Internal Signals
    signal i_c0_clk         : STD_LOGIC;
    signal i_c0_x           : UNSIGNED(11 downto 0);
    signal i_c0_y           : UNSIGNED(11 downto 0);
    signal i_c0_out_rgb     : UNSIGNED(23 downto 0);
    

    -- Core Dispatcher Component
    COMPONENT mvi_core_dispatcher
    PORT(
        fmt_width       : IN UNSIGNED(11 downto 0);
        fmt_height      : IN UNSIGNED(11 downto 0);      
        c0_x            : OUT UNSIGNED(11 downto 0);
        c0_y            : OUT UNSIGNED(11 downto 0);
        c0_clk          : OUT STD_LOGIC;
        clk             : IN STD_LOGIC;   
        fin             : OUT STD_LOGIC
        );
    END COMPONENT;
    
    -- Core 
    COMPONENT mvi_core
    PORT(
        fmt_width       : IN  UNSIGNED(11 downto 0);
        fmt_height      : IN  UNSIGNED(11 downto 0);
        pos_x           : IN UNSIGNED(11 downto 0);
        pos_y           : IN UNSIGNED(11 downto 0);
        period_y        : IN SFIXED(15 downto -16);
        period_x        : IN UNSIGNED(3 downto 0);          
        out_rgb         : OUT UNSIGNED(23 downto 0);
        clk             : IN STD_LOGIC
        );
    END COMPONENT;

begin
    
    -- Input signal assignment
    i_fmt_width <= fmt_width;
    i_fmt_height <= fmt_height;
    i_angle <= angle;
    i_views <= views;
    i_clk <= clk;
    
    -- Output signal assignment
    fin <= i_fin;
    c0_out_rgb <= i_c0_out_rgb;
    
    -- Dispatcher Instantiation
    CORE_DISPATCHER: mvi_core_dispatcher PORT MAP(
        fmt_width => i_fmt_width,
        fmt_height => i_fmt_height,
        clk => i_clk,
        c0_x => i_c0_x,
        c0_y => i_c0_y,
        c0_clk => i_c0_clk,
        fin => i_fin
    );
    
    -- Insantiation of Core(s)
    CORE_N0: mvi_core PORT MAP(
        fmt_width => i_fmt_width,
        fmt_height => i_fmt_height,
        pos_x => i_c0_x,
        pos_y => i_c0_y,
        period_y => i_angle, -- Need to add an angle to period.y converter
        period_x => i_views,
        out_rgb =>  i_c0_out_rgb,
        clk => i_c0_clk
    );
    
end Behavioral;

