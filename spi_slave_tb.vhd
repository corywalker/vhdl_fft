--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:23:24 09/17/2014
-- Design Name:   
-- Module Name:   C:/Users/John/Downloads/spi_master_slave/trunk/spi_clean/spi_slave_tb.vhd
-- Project Name:  spi_clean
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_slave
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
 
ENTITY spi_slave_tb IS
END spi_slave_tb;
 
ARCHITECTURE behavior OF spi_slave_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_slave
    PORT(
         clk_i : IN  std_logic;
         spi_ssel_i : IN  std_logic;
         spi_sck_i : IN  std_logic;
         spi_mosi_i : IN  std_logic;
         spi_miso_o : OUT  std_logic;
         di_req_o : OUT  std_logic;
         di_i : IN  std_logic_vector(31 downto 0);
         wren_i : IN  std_logic;
         wr_ack_o : OUT  std_logic;
         do_valid_o : OUT  std_logic;
         do_o : OUT  std_logic_vector(31 downto 0);
         do_transfer_o : OUT  std_logic;
         wren_o : OUT  std_logic;
         rx_bit_next_o : OUT  std_logic;
         state_dbg_o : OUT  std_logic_vector(3 downto 0);
         sh_reg_dbg_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal spi_ssel_i : std_logic := '0';
   signal spi_sck_i : std_logic := '0';
   signal spi_mosi_i : std_logic := '0';
   signal di_i : std_logic_vector(31 downto 0) := (others => '0');
   signal wren_i : std_logic := '0';

 	--Outputs
   signal spi_miso_o : std_logic;
   signal di_req_o : std_logic;
   signal wr_ack_o : std_logic;
   signal do_valid_o : std_logic;
   signal do_o : std_logic_vector(31 downto 0);
   signal do_transfer_o : std_logic;
   signal wren_o : std_logic;
   signal rx_bit_next_o : std_logic;
   signal state_dbg_o : std_logic_vector(3 downto 0);
   signal sh_reg_dbg_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_slave PORT MAP (
          clk_i => clk_i,
          spi_ssel_i => spi_ssel_i,
          spi_sck_i => spi_sck_i,
          spi_mosi_i => spi_mosi_i,
          spi_miso_o => spi_miso_o,
          di_req_o => di_req_o,
          di_i => di_i,
          wren_i => wren_i,
          wr_ack_o => wr_ack_o,
          do_valid_o => do_valid_o,
          do_o => do_o,
          do_transfer_o => do_transfer_o,
          wren_o => wren_o,
          rx_bit_next_o => rx_bit_next_o,
          state_dbg_o => state_dbg_o,
          sh_reg_dbg_o => sh_reg_dbg_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
	
	
   spi_sck_i_process :process
   begin
		spi_sck_i <= '0';
		wait for clk_i_period;
		spi_sck_i <= '1';
		wait for clk_i_period;
   end process;
	
	di_i <= X"1234ABCD";
	wren_i <= '1';
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
