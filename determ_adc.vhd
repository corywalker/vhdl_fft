----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:50:16 09/17/2014 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity determ_adc is
  port(CLK1, spi_sck_i: in STD_LOGIC;
  spi_miso_o: out STD_LOGIC);
end determ_adc;

architecture Behavioral of determ_adc is

component spi_slave
  port (clk_i: in STD_LOGIC;
  spi_sck_i: in STD_LOGIC;
  spi_ssel_i: in STD_LOGIC;
  di_i: in STD_LOGIC_VECTOR (31 downto 0);
  wren_i: in STD_LOGIC;
  spi_miso_o: out STD_LOGIC);
end component;

signal di_i: STD_LOGIC_VECTOR (31 downto 0);
signal wren_i: STD_LOGIC;
signal spi_ssel_i: STD_LOGIC;

begin

	ss1: spi_slave port map (
		clk_i => CLK1,
		spi_sck_i => spi_sck_i,
		spi_ssel_i => spi_ssel_i,
		di_i => di_i,
		wren_i => wren_i,
		spi_miso_o => spi_miso_o);

	di_i <= X"1234ABCD";
	wren_i <= '1';
	spi_ssel_i <= '0';

end Behavioral;

