library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;

--use UNISIM.VComponents.all;

-- This module dispatches core(s) to process each pixel of a given frame
-- fmt_width, fmt_height are the target output dimensions
-- c#_x, c#_y are the the inputs to the #th core for processing of the pixel at (X,Y)
-- fin - finished signal
entity mvi_core_dispatcher is
    Port ( fmt_width, fmt_height : in  UNSIGNED (11 downto 0);
           c0_x : out  UNSIGNED(11 downto 0);
           c0_y : out  UNSIGNED(11 downto 0);
	   c0_clk : out STD_LOGIC;
	   fin : out STD_LOGIC;
	   clk : in  STD_LOGIC);
end mvi_core_dispatcher;

architecture Behavioral of mvi_core_dispatcher is

-- Counters for pixel coordinates X, Y
signal cnt_x : UNSIGNED (11 downto 0) := (others => '0');
signal cnt_y : UNSIGNED (11 downto 0) := (others => '0');

-- Signal if all the pixels are finished processing
signal s_fin : STD_LOGIC := '0';

begin
	-- Core Processing Pixel Dispatching Process
	dispatch_proc: process(clk)
	begin
		if rising_edge(clk) then
			-- if x has not passed the frame width, increment x
			if ((cnt_x + 1) < fmt_width) then
				cnt_x <= cnt_x + 1;
			else
			-- if x passed the frame width, reset x, increment y
				cnt_y <= cnt_y + 1;
				cnt_x <= "000000000000";
				-- if y have passed the frame height, send "finished' signal
				if ((cnt_y + 1) = fmt_height) then
					s_fin <= '1';
				end if;
			end if;
		end if;
	end process;

fin  <= s_fin; -- Are all the pixels processed?
c0_x <= cnt_x; -- Core 0 to process pixel (X, 
c0_y <= cnt_y; -- Y)
c0_clk <= clk;

end Behavioral;

