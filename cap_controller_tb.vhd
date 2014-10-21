--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:23:48 10/19/2014
-- Design Name:   
-- Module Name:   C:/Users/John/Code/vhdl_fft/cap_controller_tb.vhd
-- Project Name:  fft
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cap_controller
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cap_controller_tb IS
END cap_controller_tb;
 
ARCHITECTURE behavior OF cap_controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cap_controller
    PORT(
         CLK1 : IN  std_logic;
         rst  : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK1 : std_logic := '0';
   signal rst  : std_logic := '0';

   -- Clock period definitions
   constant CLK1_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cap_controller PORT MAP (
          CLK1 => CLK1,
          rst => rst
        );

   -- Clock process definitions
   CLK1_process :process
   begin
		CLK1 <= '0';
		wait for CLK1_period/2;
		CLK1 <= '1';
		wait for CLK1_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for 100 ns;	
      rst <= '0';

      wait for CLK1_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
