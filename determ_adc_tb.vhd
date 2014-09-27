--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:13:01 09/17/2014
-- Design Name:   
-- Module Name:   C:/Users/John/Downloads/spi_master_slave/trunk/spi_clean/determ_adc_tb.vhd
-- Project Name:  spi_clean
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: determ_adc
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
use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY determ_adc_tb IS
END determ_adc_tb;
 
ARCHITECTURE behavior OF determ_adc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT determ_adc
    PORT(
         CLK1 : IN  std_logic;
         spi_sck_i : IN  std_logic;
         spi_miso_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK1 : std_logic := '0';
   signal spi_sck_i : std_logic := '0';

 	--Outputs
   signal spi_miso_o : std_logic;

   -- Clock period definitions
   constant CLK1_period : time := 10 ns;
   
   signal cnt: std_logic_vector(3 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: determ_adc PORT MAP (
          CLK1 => CLK1,
          spi_sck_i => spi_sck_i,
          spi_miso_o => spi_miso_o
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
      wait for 100 ns;	

      wait for CLK1_period*100;

      -- insert stimulus here 
      for J in 0 to 7 loop
          for I in 0 to 7 loop
            spi_sck_i <= '1';
            wait for CLK1_period*2;
            spi_sck_i <= '0';
            wait for CLK1_period*2;
          end loop;
          wait for CLK1_period * 16;
       end loop;
       
       wait for 2000 ns;
       
      for J in 0 to 7 loop
          for I in 0 to 7 loop
            spi_sck_i <= '1';
            wait for CLK1_period*2;
            spi_sck_i <= '0';
            wait for CLK1_period*2;
          end loop;
          wait for CLK1_period * 16;
       end loop;

      wait;
   end process;

END;
