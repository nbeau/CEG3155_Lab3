library ieee;
use ieee.std_logic_1164.all;

entity StateFlag2bit is
  port (
    clk        : in  std_logic;
    reset_n    : in  std_logic;
    A          : in  std_logic;
    B          : in  std_logic;
    state_flag : out std_logic_vector(1 downto 0)
  );
end entity;

architecture rtl of StateFlag2bit is
  signal y1, y0 : std_logic;
  signal z1, z0 : std_logic;
begin
  z1 <= (y1 and (not A)) or (y0 and A);
  z0 <= (y0 and (not A)) or ((not y1) and y0) or ((not y1) and A and B);

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      y1 <= '0';
      y0 <= '0';
    elsif rising_edge(clk) then
      y1 <= z1;
      y0 <= z0;
    end if;
  end process;

  state_flag <= y1 & y0;
end architecture;
