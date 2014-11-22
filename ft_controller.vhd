library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity ft_controller is
    generic (
            N : positive := 16;
            -- We have 4096 words in the RAM
            --ADDRWIDTH : positive := 12;
            ADDRWIDTH : positive := 10; -- 512 words on input, 512 on output

            -- DELAY:
            -- Time to wait in between capture sessions
            -- This will be irrelevant once we have output SPI
            -- INT_EXT_SEL:
            -- '0' for determ_adc, '1' for external.

            SIZE : positive := 512;
            SIZELOG : positive := 9;
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

            start_i: in std_logic; -- high when arduino is reading data
            busy_o: out std_logic; -- high when performing fft
            sck_i: in std_logic; -- to arduino
            miso_o: out std_logic; -- to arduino

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

    COMPONENT xfft_v7_1
        PORT (
                 clk : IN STD_LOGIC;
                 start : IN STD_LOGIC;
                 unload : IN STD_LOGIC;
                 xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
                 xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
                 fwd_inv : IN STD_LOGIC;
                 fwd_inv_we : IN STD_LOGIC;
                 scale_sch : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
                 scale_sch_we : IN STD_LOGIC;
                 rfd : OUT STD_LOGIC;
                 xn_index : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
                 busy : OUT STD_LOGIC;
                 edone : OUT STD_LOGIC;
                 done : OUT STD_LOGIC;
                 dv : OUT STD_LOGIC;
                 xk_index : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
                 xk_re : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                 xk_im : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    END COMPONENT;

    type state_type is (cc_write, fft_read, wait_for_valid, fft_write, oi_read);
    signal curr_state, next_state : state_type;

    signal start, unload, wnr : std_logic := '0';
    signal xn_re, xn_im : std_logic_vector(7 downto 0) := (others => '0');
    signal rfd, fftbusy, edone, done, dv : std_logic := '0';
    signal xn_index : std_logic_vector(8 downto 0) := (others => '0');
    signal xk_re, xk_im : std_logic_vector(7 downto 0) := (others => '0');
    signal xk_index : std_logic_vector(8 downto 0) := (others => '0');

    signal cc_out : std_logic_vector(N-1 downto 0);
    signal oi_in  : std_logic_vector(N-1 downto 0);
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
                    SIZELOG => SIZELOG,
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
                 dout => cc_out,
                 adc_conv => adc_conv,
                 adc_sck => adc_sck,
                 adc_miso => adc_miso,
                 rst => rst
             );

    br1 : RAMB16_S18
    generic map (
                INIT => X"00000", --  Value of output RAM registers at startup
                SRVAL => X"00000", --  Output value upon SSR assertion
                WRITE_MODE => "WRITE_FIRST") --  WRITE_FIRST, READ_FIRST or NO_CHANGE
    port map (
                 DO => br_douta,                    -- 16-bit Data Output
                 DOP => open,                       -- 2-bit parity Output
                 ADDR => theaddr,                   -- 10-bit Address Input
                 CLK => CLK1,                       -- Clock
                 DI => br_dina,                     -- 16-bit Data Input
                 DIP => (others => '0'),            -- 2-bit parity Input
                 EN => '1',                         -- RAM Enable Input
                 SSR => '0',                        -- Synchronous Set/Reset Input
                 WE => wnr                          -- Write Enable Input
             );


    fft_block : xfft_v7_1
    PORT MAP (
                 clk => CLK1,
                 start => start,
                 unload => unload,
                 xn_re => xn_re,
                 xn_im => xn_im,
                 fwd_inv => '1',
                 fwd_inv_we => '1',
                 scale_sch => "000000000111111111",
                 scale_sch_we => '1',
                 rfd => rfd,
                 xn_index => xn_index,
                 busy => fftbusy,
                 edone => edone,
                 done => done,
                 dv => dv,
                 xk_index => xk_index,
                 xk_re => xk_re,
                 xk_im => xk_im
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
                 din => oi_in,
                 addr => oi_addr_o
             );

    --theaddr <= br_addra when cc_busy = '1' else oi_addr_o;
    busy_o <= cc_busy or fftbusy;
    addr_rst <= cc_busy;

    curr_logic : process (CLK1, rst)
    begin
        if rising_edge(CLK1) then
            if rst = '1' or cc_busy = '1' then
                curr_state <= cc_write;
            else
                curr_state <= next_state;
            end if;
        end if;
    end process;

    next_logic : process (CLK1, curr_state)
        variable index : integer := 0;
        variable mbase : integer := 512;
    begin
        if rising_edge(CLK1) then
            Led <= br_douta(14 downto 7);
            case curr_state is
                when cc_write =>
                    wnr <= '1';
                    br_dina <= cc_out;
                    theaddr <= br_addra;
                    start <= '0';
                    index := 0;
                    if cc_busy = '0' then
                        next_state <= fft_read;
                    end if;
                when fft_read =>
                    wnr <= '0';
                    theaddr <= std_logic_vector(to_unsigned(index, theaddr'length));
                    xn_re <= br_douta(15 downto 8);
                    xn_im <= br_douta(7 downto 0);
                    start <= '1';
                    index := index + 1;
                    if done = '1' then
                        start <= '0';
                        index := 0;
                        next_state <= wait_for_valid;
                    end if;
                when wait_for_valid =>
                    if dv = '1' then
                        unload <= '1';
                        next_state <= fft_write;
                    end if;
                when fft_write =>
                    wnr <= '1';
                    index := mbase + to_integer(unsigned(xk_index));
                    br_dina <= xk_re & xk_im;            
                    theaddr <= std_logic_vector(to_unsigned(index, theaddr'length));
                    if dv = '0' then
                        unload <= '0';
                        index := 0;
                        next_state <= oi_read;
                    end if;
                when oi_read =>
                    wnr <= '0';
                    theaddr <= std_logic_vector(to_unsigned(mbase, theaddr'length)) & oi_addr_o;
                    oi_in <= br_douta;
                    if cc_busy = '1' then
                        next_state <= cc_write;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;

