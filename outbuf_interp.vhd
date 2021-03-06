library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------

entity outbuf_interp is
    generic (
        N : positive := 16;
        ADDRWIDTH : positive := 12
    );
	port(
        CLK1, spi_sck_i, addr_rst: in std_logic;
        spi_miso_o: out std_logic;
        addr : OUT STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0) := "0000000000";
        din : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
end outbuf_interp;

---------------------------------------------------

architecture Behavioral of outbuf_interp is


    type state_type is (s0,s1,s2,s3,s4);  --type of state machine.
    signal current_s,next_s: state_type;  --current and next state declaration.

    signal di_i: std_logic_vector (N-1 downto 0) := "0000000000000000";
    signal di_req_o: std_logic;
    signal wren_i: std_logic := '0';
    signal spi_ssel_i: std_logic := '1';
    signal cnt1_clear: std_logic;
    signal cnt1_Q: unsigned (31 downto 0);
    signal cnt1_Q_v: std_logic_vector (31 downto 0);
    signal slower_spi_clock: std_logic := '0';
    signal s_read_state: unsigned (3 downto 0) := "0000";
    signal next_s_read_state: unsigned (3 downto 0) := "0010";

begin

    ss1: entity work.spi_slave
        generic map (N => N)
        port map (
            clk_i => slower_spi_clock,
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
    begin
    
        s_read_state <= next_s_read_state;
        if rising_edge(CLK1) then
            slower_spi_clock <= not slower_spi_clock;
        end if;
    
    end process;
    
    process(s_read_state, CLK1)
        variable currcount: unsigned (ADDRWIDTH-1 downto 0) := (OTHERS => '0');
    begin
        if(addr_rst = '1') then
            currcount := (OTHERS => '0');
            addr <= std_logic_vector(currcount);
            next_s_read_state <= "0001";
            spi_ssel_i <= '1';
        elsif rising_edge(CLK1) then
            case s_read_state is
                when "0000" =>
                    if di_req_o = '1' then
                        next_s_read_state <= "0001";
                    end if;
                when "0001" =>
                    next_s_read_state <= "0010";
                when "0010" =>
                    next_s_read_state <= "0011";
                    di_i <= din;
                    currcount := currcount + 1;
                    addr <= std_logic_vector(currcount);
                    -- We toggle ssel like this because it resets the position
                    -- if we change our mind about di_i.
                    spi_ssel_i <= '0';
                when "0011" =>
                    next_s_read_state <= "0100";
                when "0100" =>
                    next_s_read_state <= "0101";
                when "0101" =>
                    next_s_read_state <= "0110";
                    wren_i <= '1';
                    
                when "0110" =>
                    next_s_read_state <= "0111";
                when "0111" =>
                    next_s_read_state <= "1000";
                    
                when "1000" =>
                    next_s_read_state <= "0000";
                    wren_i <= '0';
                when others =>
                    next_s_read_state <= "0000";
            end case;
        end if;

    end process;
    
    cnt1_clear <= di_req_o;
    cnt1_Q <= unsigned(cnt1_Q_v);

end Behavioral;

