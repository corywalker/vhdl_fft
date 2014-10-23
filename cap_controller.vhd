library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cap_controller is
    generic (
        N : positive := 16;
        ADDRWIDTH : positive := 10;
        SIZE : positive := 64
    );
	port(
        CLK1: in std_logic;
        start: in std_logic;
        busy: out std_logic := '0';
        wea : out std_logic_vector(0 DOWNTO 0);
        addr : out std_logic_vector(ADDRWIDTH-1 DOWNTO 0);
        dout : out std_logic_vector(N-1 DOWNTO 0);
        rst: in std_logic
    );
end cap_controller;

architecture Behavioral of cap_controller is

    signal slower_spi_clock: std_logic := '0';
    signal gated_spi_clock: std_logic := '0';
    signal determ_spi_sck: std_logic;
    signal determ_spi_miso: std_logic;
    signal spi_sck: std_logic;
    signal thebusy: std_logic;
    signal spi_miso: std_logic;
    signal sm_data_buf: std_logic_vector (N-1 downto 0);
    signal sm_valid: std_logic;
    signal theaddress : integer range SIZE-1 downto 0 := 0;

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
            sclk_i => gated_spi_clock,
            pclk_i => gated_spi_clock,
            rst_i => rst,
            wren_i => '1',
            do_o => sm_data_buf,
            do_valid_o => sm_valid,
            spi_sck_o => spi_sck,
            spi_miso_i => spi_miso
        );
        
    busy <= thebusy;
    wea(0) <= sm_valid and thebusy;
    addr <= std_logic_vector(to_unsigned(theaddress, addr'length));
    dout <= sm_data_buf;
        
    process(CLK1)
        variable address : integer range SIZE-1 downto 0 := 0;
        variable is_busy: std_logic := '0';
        variable already_stepped : std_logic := '0';
    begin
    
        if rising_edge(CLK1) then
        
            slower_spi_clock <= not slower_spi_clock;
            
            if is_busy = '1' then
                if sm_valid = '1' and already_stepped = '0' then
                    already_stepped := '1';
                    if address = SIZE-1 then
                        is_busy := '0';
                        address := 0;
                    else
                        address := address + 1;
                    end if;
                elsif sm_valid = '0' then
                    already_stepped := '0';
                end if;
            else
                if start = '1' then
                    is_busy := '1';
                end if;
            end if;
            
            thebusy <= is_busy;
            theaddress <= address;
    
            gated_spi_clock <= is_busy and (not slower_spi_clock);
            
        end if;
            
    
    end process;


end Behavioral;

