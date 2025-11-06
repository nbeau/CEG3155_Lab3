library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SideCounter is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    enable  : in  std_logic;
    limit   : in  std_logic_vector(3 downto 0);
    count   : out std_logic_vector(3 downto 0);
    done    : out std_logic
  );
end entity SideCounter;

architecture Behavioral of SideCounter is
  signal cnt : unsigned(3 downto 0) := (others => '0');
begin
  process(clk, reset)
  begin
    if reset = '1' then
      cnt <= (others => '0');
    elsif rising_edge(clk) then
      if enable = '1' then
        if cnt = unsigned(limit) then
          cnt <= cnt + 1;
        else
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

  count <= std_logic_vector(cnt);
  done <= '1' when cnt = unsigned(limit) else '0';
end architecture Behavioral;
