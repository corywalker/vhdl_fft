library ieee;
use ieee.std_logic_1164.all;

entity cap_controller is
    generic (
        N : positive := 16
    );
	port(
        CLK1: in std_logic
    );
end cap_controller;

architecture Behavioral of cap_controller is

    signal slower_spi_clock: std_logic := '0';
    signal spi_sck: std_logic := '0';
    signal spi_miso: std_logic;

begin

    da1: entity work.determ_adc
        generic map (N => N)
        port map (
            CLK1 => CLK1,
            spi_sck_i => spi_sck,
            spi_miso_o => spi_miso
        );
        
    sm1: entity work.spi_master
        generic map (N => N)
        port map (
            sclk_i => slower_spi_clock,
            pclk_i => slower_spi_clock,
            rst_i => '0',
            spi_miso_i => spi_miso
        );
        
    process(CLK1)
    begin
    
        if rising_edge(CLK1) then
            slower_spi_clock <= not slower_spi_clock;
        end if;
    
    end process;
    
    process(slower_spi_clock)
    begin
    
        if rising_edge(slower_spi_clock) then
            spi_sck <= not spi_sck;
        end if;
    
    end process;


end Behavioral;

