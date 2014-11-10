library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spi_mux is
	port(
        sck_a_o: out std_logic;
        sck_b_o: out std_logic;
        sck_i: in std_logic;
        conv_a_o: out std_logic;
        conv_b_o: out std_logic;
        conv_i: in std_logic;
        miso_a_i: in std_logic;
        miso_b_i: in std_logic;
        miso_o: out std_logic;
        sel_i: in std_logic
    );
end spi_mux;

architecture Behavioral of spi_mux is

begin

    sck_a_o <= sck_i when sel_i = '0' else 'Z';
    sck_b_o <= sck_i when sel_i = '1' else 'Z';
    conv_a_o <= conv_i when sel_i = '0' else 'Z';
    conv_b_o <= conv_i when sel_i = '1' else 'Z';
    miso_o <= miso_a_i when sel_i = '0' else miso_b_i;

end Behavioral;

