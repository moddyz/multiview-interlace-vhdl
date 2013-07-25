--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:58:35 07/24/2013
-- Design Name:   
-- Module Name:   C:/FPGA/interlacer_v1_0/TB_main_out_dispatcher.vhd
-- Project Name:  interlacer_v1_0
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main_out_dispatcher
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
 
ENTITY TB_main_core_dispatcher IS
END TB_main_core_dispatcher;
 
ARCHITECTURE behavior OF TB_main_core_dispatcher IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mvi_core_dispatcher
    PORT(
         fmt_width : IN  UNSIGNED(11 downto 0);
         fmt_height : IN  UNSIGNED(11 downto 0);
         clk : IN  std_logic;
         c0_x : OUT  UNSIGNED(11 downto 0);
         c0_y : OUT  UNSIGNED(11 downto 0);
         fin : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal fmt_width  : UNSIGNED(11 downto 0) := "011110000000";
   signal fmt_height : UNSIGNED(11 downto 0) := "010000111000";
   signal clk : std_logic := '0';

 	--Outputs
   signal c0_x : UNSIGNED(11 downto 0);
   signal c0_y : UNSIGNED(11 downto 0);
   signal fin : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mvi_core_dispatcher PORT MAP (
          fmt_width => fmt_width,
          fmt_height => fmt_height,
          clk => clk,
          c0_x => c0_x,
          c0_y => c0_y,
          fin => fin
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
