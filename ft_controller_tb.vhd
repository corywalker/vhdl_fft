--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:26:21 10/22/2014
-- Design Name:   
-- Module Name:   C:/Users/John/Code/vhdl_fft/ft_controller_tb.vhd
-- Project Name:  fft
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ft_controller
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
 
ENTITY ft_controller_tb IS
END ft_controller_tb;
 
ARCHITECTURE behavior OF ft_controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ft_controller
    generic (
        SIZE : positive;
        SIZELOG : positive;
        DELAY : positive;
        INT_EXT_SEL: std_logic;
        SPI_2X_CLK_DIV: positive;
        DA_RESET_DELAY: positive
    );
    PORT(
         CLK1 : IN  std_logic;
         rst : IN  std_logic;
         adc_miso : IN  std_logic;
         start_i : IN  std_logic;
         busy_o : OUT std_logic;
         sck_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK1 : std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal busy : std_logic;
   signal sck : std_logic := '0';

   -- Clock period definitions
   constant CLK1_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ft_controller
        generic map (
            SIZE => 512,
            SIZELOG => 9,
            DELAY => 300,
            INT_EXT_SEL => '0',
            SPI_2X_CLK_DIV => 2,
            DA_RESET_DELAY => 200
        )
        PORT MAP (
          CLK1 => CLK1,
          rst => rst,
          start_i => start,
          busy_o => busy,
          sck_i => sck,
          adc_miso => '0'
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
      
      loop
      
      start <= '1';
      wait for 30 ns;	
      start <= '0';

      wait for CLK1_period*10;
      
      wait until busy = '0';
      wait for 1us;
      
      for I in 0 to 512*16 loop
          sck <= '1';
          wait for 30 ns;
          sck <= '0';
          wait for 30 ns;
      end loop;
      
      wait for 10us;
      
      end loop;

      wait;
   end process;

END;
