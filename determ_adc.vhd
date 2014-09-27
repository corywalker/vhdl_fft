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

    signal di_i: std_logic_vector (N-1 downto 0) := (others => '0');
    signal di_req_o: std_logic;
    signal wren_i: std_logic;
    signal spi_ssel_i: std_logic;
    signal cnt1_clear: std_logic;
    signal cnt1_Q: unsigned (31 downto 0);
    signal cnt1_Q_v: std_logic_vector (31 downto 0);

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

