library ieee;
use ieee.std_logic_1164.all;

entity ft_controller is
    generic (
        N : positive := 16;
        -- We have 4096 words in the RAM
        ADDRWIDTH : positive := 12;
        
        -- DELAY:
        -- Time to wait in between capture sessions
        -- This will be irrelevant once we have output SPI
        -- INT_EXT_SEL:
        -- '0' for determ_adc, '1' for external.
        
        SIZE : positive := 512;
        DELAY : positive := 10000;
        INT_EXT_SEL: std_logic := '1';
        SPI_2X_CLK_DIV: positive := 40;
        DA_RESET_DELAY: positive := 10000
    );
	port(
        CLK1: in std_logic;
        adc_conv: out std_logic;
        adc_sck: out std_logic;
        adc_miso: in std_logic;
        
        start_i: in std_logic;
        busy_o: out std_logic;
        sck_i: in std_logic;
        miso_o: out std_logic;
        
        Led : out std_logic_vector(7 downto 0) := "10001000";
        rst : in std_logic
    );
end ft_controller;

architecture Behavioral of ft_controller is

    COMPONENT bram
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
      );
    END COMPONENT;

    signal cc_start: std_logic := '1';
    signal addr_rst: std_logic := '1';
    signal cc_busy: std_logic;
    signal br_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal br_addra : STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0);
    signal oi_addr_o : STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0);
    signal theaddr : STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0);
    signal br_dina : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    signal br_douta : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

begin

    cc1: entity work.cap_controller
        generic map (
            N => N,
            SIZE => SIZE,
            ADDRWIDTH => ADDRWIDTH,
            INT_EXT_SEL => INT_EXT_SEL,
            SPI_2X_CLK_DIV => SPI_2X_CLK_DIV,
            DA_RESET_DELAY => DA_RESET_DELAY
        )
        port map (
            CLK1 => CLK1,
            start => start_i,
            busy => cc_busy,
            wea => br_wea,
            addr => br_addra,
            dout => br_dina,
            adc_conv => adc_conv,
            adc_sck => adc_sck,
            adc_miso => adc_miso,
            rst => rst
        );
        
    br1 : bram
        port map (
            clka => CLK1,
            wea => br_wea,
            addra => theaddr,
            dina => br_dina,
            douta => br_douta
        );
        
    oi1: entity work.outbuf_interp
        generic map (
            N => N,
            ADDRWIDTH => ADDRWIDTH
        )
        port map (
            CLK1 => CLK1,
            spi_sck_i => sck_i,
            addr_rst => addr_rst,
            spi_miso_o => miso_o,
            din => br_douta,
            addr => oi_addr_o
        );
        
    theaddr <= br_addra when cc_busy = '1' else oi_addr_o;
    busy_o <= cc_busy;
    addr_rst <= cc_busy;
        
    process(cc_busy)
    begin
    
        if falling_edge(cc_busy) then
            Led <= br_douta(14 downto 7);
        end if;
    
    end process;


end Behavioral;

