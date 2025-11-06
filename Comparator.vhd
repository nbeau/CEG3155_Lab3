library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Comparator is
  port (
    a    : in  std_logic_vector(3 downto 0);
    b    : in  std_logic_vector(3 downto 0);
    eq   : out std_logic
  );
end entity Comparator;

architecture Behavioral of Comparator is
begin
  eq <= '1' when unsigned(a) = unsigned(b) else '0';
end architecture Behavioral;
