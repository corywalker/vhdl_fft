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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--library work;
--use work.all;

entity determ_adc is
	generic (   
	  N : positive := 16
	  );
  port(CLK1, spi_sck_i: in STD_LOGIC;
  spi_miso_o: out STD_LOGIC);
end determ_adc;

architecture Behavioral of determ_adc is

signal di_i: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
signal di_req_o: STD_LOGIC;
signal wren_i: STD_LOGIC;
signal spi_ssel_i: STD_LOGIC;
signal cnt1_clear: STD_LOGIC;
signal cnt1_Q: UNSIGNED (31 downto 0);
signal cnt1_Q_v: std_logic_vector (31 downto 0);

begin

	ss1: entity work.spi_slave
	  Generic map (N => N)
	  port map (
		clk_i => CLK1,
		spi_sck_i => spi_sck_i,
		spi_ssel_i => spi_ssel_i,
		di_i => di_i,
		di_req_o => di_req_o,
		wren_i => wren_i,
		spi_miso_o => spi_miso_o);
		
	cnt1: entity work.counter
	  Generic map (n => 32)
	  port map (
		clock => CLK1,
		clear => cnt1_clear,
		count => '1',
		Q => cnt1_Q_v);
		
		process(di_req_o, cnt1_Q)
			variable sig1_state : unsigned (3 downto 0) := "0000";
		begin
			if(di_req_o'event and di_req_o='1') then
				sig1_state := sig1_state + 1;
			end if;
			if(cnt1_q = 125000000) then
				sig1_state := "0000";
			end if;
			di_i <= std_logic_vector(sig1_state) & "000000000000";
		end process;

	wren_i <= '1';
	spi_ssel_i <= '0';
	cnt1_clear <= di_req_o;
	cnt1_Q <= unsigned(cnt1_Q_v);

end Behavioral;

