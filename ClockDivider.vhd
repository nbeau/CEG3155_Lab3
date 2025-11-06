library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockDivider is
  generic (
    DIVISOR : integer := 25000000
  );
  port (
    clk_in  : in  std_logic;
    reset   : in  std_logic;
    clk_out : out std_logic
  );
end entity ClockDivider;

architecture Behavioral of ClockDivider is
  signal counter : integer range 0 to DIVISOR := 0;
  signal clk_int : std_logic := '0';
begin
  process(clk_in, reset)
  begin
    if reset = '1' then
      counter <= 0;
      clk_int <= '0';
    elsif rising_edge(clk_in) then
      if counter = DIVISOR - 1 then
        counter <= 0;
        clk_int <= not clk_int;
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

  clk_out <= clk_int;
end architecture Behavioral;
