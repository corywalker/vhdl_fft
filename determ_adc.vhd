library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------

entity determ_adc is
    generic (
        N : positive := 16
    );
	port(
        CLK1, spi_sck_i: in std_logic;
        spi_miso_o: out std_logic
    );
end determ_adc;

---------------------------------------------------

architecture Behavioral of determ_adc is

    signal di_i: std_logic_vector (N-1 downto 0) := "1010101010101010";
    signal di_req_o: std_logic;
    signal wren_i: std_logic := '0';
    signal spi_ssel_i: std_logic;
    signal cnt1_clear: std_logic;
    signal cnt1_Q: unsigned (31 downto 0);
    signal cnt1_Q_v: std_logic_vector (31 downto 0);
    signal state_debug: unsigned (3 downto 0) := "0000";

begin

    ss1: entity work.spi_slave
        generic map (N => N)
        port map (
            clk_i => CLK1,
            spi_sck_i => spi_sck_i,
            spi_ssel_i => spi_ssel_i,
            di_i => di_i,
            di_req_o => di_req_o,
            wren_i => wren_i,
            spi_miso_o => spi_miso_o
        );

    cnt1: entity work.counter
        generic map (n => 32)
        port map (
            clock => CLK1,
            clear => cnt1_clear,
            count => '1',
            Q => cnt1_Q_v
        );
		
    process(CLK1)
        variable sig1_state : unsigned (3 downto 0) := "0000";
    begin
    
        if sig1_state = "0000" and falling_edge(CLK1) and di_req_o = '1' then
            sig1_state := "0001";
        elsif sig1_state = "0001" and rising_edge(CLK1) then
            sig1_state := "0010";
            di_i <= not di_i;
        elsif sig1_state = "0010" and rising_edge(CLK1) then
            sig1_state := "0011";
        elsif sig1_state = "0011" and rising_edge(CLK1) then
            sig1_state := "0100";
            wren_i <= '1';
        elsif sig1_state = "0100" and rising_edge(CLK1) then
            sig1_state := "0000";
            wren_i <= '0';
        end if;
        
        state_debug <= sig1_state;

    end process;

    spi_ssel_i <= '0';
    cnt1_clear <= di_req_o;
    cnt1_Q <= unsigned(cnt1_Q_v);

end Behavioral;

