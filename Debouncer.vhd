library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
  generic (
    N : integer := 20
  );
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    noisy_in : in  std_logic;
    clean_out: out std_logic
  );
end entity Debouncer;

architecture Behavioral of Debouncer is
  signal sync_0, sync_1 : std_logic := '0';
  signal counter : unsigned(N-1 downto 0) := (others => '0');
  signal debounced : std_logic := '0';
begin
  process(clk, reset)
  begin
    if reset = '1' then
      sync_0 <= '0';
      sync_1 <= '0';
      counter <= (others => '0');
      debounced <= '0';
    elsif rising_edge(clk) then
      sync_0 <= noisy_in;
      sync_1 <= sync_0;
      if sync_1 = debounced then
        counter <= (others => '0');
      else
        counter <= counter + 1;
        if counter = (2**N - 1) then
          debounced <= sync_1;
          counter <= (others => '0');
        end if;
      end if;
    end if;
  end process;
  clean_out <= debounced;
end architecture Behavioral;
