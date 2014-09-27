library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------

entity determ_adc is
    generic (
        N : positive := 16
    );
	port(
        CLK1, spi_sck_i, spi_ssel_i: in std_logic;
        spi_miso_o: out std_logic
    );
end determ_adc;

---------------------------------------------------

architecture Behavioral of determ_adc is


    type state_type is (s0,s1,s2,s3,s4);  --type of state machine.
    signal current_s,next_s: state_type;  --current and next state declaration.

    signal di_i: std_logic_vector (N-1 downto 0) := "0000000000000000";
    signal di_req_o: std_logic;
    signal wren_i: std_logic := '0';
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
        variable currcount: unsigned (3 downto 0) := "0000";
    begin
        --if(cnt1_Q = 125000000) then
        if cnt1_Q = 100 then
            currcount := "0000";
            next_s_read_state <= "0001";
        elsif rising_edge(CLK1) then
            case s_read_state is
                when "0000" =>
                    if di_req_o = '1' then
                        next_s_read_state <= "0001";
                    end if;
                when "0001" =>
                    next_s_read_state <= "0010";
                    di_i <= std_logic_vector(currcount) & "000000000000";
                when "0010" =>
                    next_s_read_state <= "0011";
                    currcount := currcount + 1;
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
--        if s_read_state = "0000" and falling_edge(CLK1) and di_req_o = '1' then
--            next_s_read_state <= "0001";
--        elsif s_read_state = "0001" and rising_edge(CLK1) then
--            next_s_read_state <= "0010";
--            --di_i <= not di_i;
--        elsif s_read_state = "0010" and rising_edge(CLK1) then
--            next_s_read_state <= "0011";
--        elsif s_read_state = "0011" and rising_edge(CLK1) then
--            next_s_read_state <= "0100";
--            --wren_i <= '1';
--        elsif s_read_state = "0100" and rising_edge(CLK1) then
--            next_s_read_state <= "0000";
--            --wren_i <= '0';
--        end if;

    end process;
    

    --spi_ssel_i <= '0';
    cnt1_clear <= di_req_o;
    cnt1_Q <= unsigned(cnt1_Q_v);

end Behavioral;

