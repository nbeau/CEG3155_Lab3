library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD_Decoder is
  port (
    value : in  std_logic_vector(3 downto 0);
    BCD1  : out std_logic_vector(3 downto 0);
    BCD2  : out std_logic_vector(3 downto 0)
  );
end entity BCD_Decoder;

architecture Behavioral of BCD_Decoder is
  signal n    : unsigned(3 downto 0);
  signal tens : unsigned(3 downto 0);
  signal ones : unsigned(3 downto 0);
begin
  n    <= unsigned(value);
  tens <= "0001" when n >= 10 else "0000";
  ones <= n - 10  when n >= 10 else n;
  BCD1 <= std_logic_vector(tens);
  BCD2 <= std_logic_vector(ones);
end architecture Behavioral;