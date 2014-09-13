library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;    -- for the unsigned type

entity counter_example is
generic ( WIDTH : integer := 32);
port (
  CLK, RESET, LOAD : in std_logic;
  DATA : in  unsigned(WIDTH-1 downto 0);  
  Q    : out unsigned(WIDTH-1 downto 0));
end entity counter_example;

architecture counter_example_a of counter_example is
type COMPLEX        is record RE, IM: integer; end record;
signal cnt : unsigned(WIDTH-1 downto 0);
begin
  process(RESET, CLK) is
  begin
    if RESET = '1' then
      cnt <= (others => '0');
    elsif rising_edge(CLK) then
      if LOAD = '1' then
        cnt <= DATA;
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  Q <= cnt;

end architecture counter_example_a;