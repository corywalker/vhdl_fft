library ieee;
use ieee.std_logic_1164.all;

entity cap_controller is
    generic (
        N : positive := 16
    );
	port(
        CLK1: in std_logic;
        rst: in std_logic
    );
end cap_controller;

architecture Behavioral of cap_controller is

    signal slower_spi_clock: std_logic := '0';
    signal determ_spi_sck: std_logic;
    signal determ_spi_miso: std_logic;
    signal spi_sck: std_logic;
    signal spi_miso: std_logic;

begin

    da1: entity work.determ_adc
        generic map (N => N)
        port map (
            CLK1 => CLK1,
            spi_sck_i => determ_spi_sck,
            spi_miso_o => determ_spi_miso
        );
        
    smux1: entity work.spi_mux
        port map (
            sck_a_o => determ_spi_sck,
            sck_i => spi_sck,
            miso_a_i => determ_spi_miso,
            miso_b_i => '0',
            miso_o => spi_miso,
            sel_i => '0'
        );
        
    sm1: entity work.spi_master
        generic map (N => N)
        port map (
            sclk_i => slower_spi_clock,
            pclk_i => slower_spi_clock,
            rst_i => rst,
            di_i => (others => '0'),
            wren_i => '1',
            spi_sck_o => spi_sck,
            spi_miso_i => spi_miso
        );
        
    process(CLK1)
    begin
    
        if rising_edge(CLK1) then
            slower_spi_clock <= not slower_spi_clock;
        end if;
    
    end process;


end Behavioral;

