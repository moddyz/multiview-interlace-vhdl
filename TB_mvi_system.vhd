--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:03:57 07/24/2013
-- Design Name:   
-- Module Name:   C:/FPGA/interlacer_v1_0/TB_mvi_system.vhd
-- Project Name:  interlacer_v1_0
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mvi_system
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE, IEEE_PROPOSED;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee_proposed.fixed_pkg.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_mvi_system IS
END TB_mvi_system;
 
ARCHITECTURE behavior OF TB_mvi_system IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mvi_system
    PORT(
         fmt_width : IN  UNSIGNED(11 downto 0);
         fmt_height : IN  UNSIGNED(11 downto 0);
         angle : IN  SFIXED(31 downto 0);
         views : IN  UNSIGNED(3 downto 0);
         clk : IN  std_logic;
         fin : OUT  std_logic;
         c0_out_rgb : OUT  UNSIGNED(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal fmt_width : UNSIGNED(11 downto 0) := "011110000000";
   signal fmt_height : UNSIGNED(11 downto 0) := "010000111000";
   signal angle : SFIXED(31 downto 0) := (others => '0');
   signal views : UNSIGNED(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal fin : std_logic;
   signal c0_out_rgb : UNSIGNED(23 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mvi_system PORT MAP (
          fmt_width => fmt_width,
          fmt_height => fmt_height,
          angle => angle,
          views => views,
          clk => clk,
          fin => fin,
          c0_out_rgb => c0_out_rgb
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
