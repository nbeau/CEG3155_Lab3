library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_Controller is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    SSCS     : in  std_logic;
    M_done   : in  std_logic;
    S_done   : in  std_logic;
    MSTL     : out std_logic_vector(2 downto 0);
    SSTL     : out std_logic_vector(2 downto 0);
    enable_M : out std_logic;
    enable_S : out std_logic;
    reset_M  : out std_logic;
    reset_S  : out std_logic;
    state_dbg: out std_logic_vector(1 downto 0);
	 state_flag   : out std_logic_vector(1 downto 0)
  );
end entity;

architecture Behavioral of FSM_Controller is
  type state_t is (S0_MG, S1_MY, S2_SG, S3_SY);
  signal ps, ns : state_t := S0_MG;
  signal prev   : state_t := S0_MG;
  signal ycnt   : unsigned(3 downto 0) := (others=>'0');
  constant YMAX : unsigned(3 downto 0) := "0010";
  constant L_G : std_logic_vector(2 downto 0) := "001";
  constant L_Y : std_logic_vector(2 downto 0) := "010";
  constant L_R : std_logic_vector(2 downto 0) := "100";
  signal rstM_pulse, rstS_pulse : std_logic := '0';
begin
  process(clk, reset)
  begin
    if reset='1' then
      ps <= S0_MG;
      prev <= S0_MG;
      ycnt <= (others=>'0');
      rstM_pulse <= '1';
      rstS_pulse <= '1';
    elsif rising_edge(clk) then
      prev <= ps;
      ps <= ns;
      if ps/=prev then
        ycnt <= (others=>'0');
      elsif ps= S1_MY or ps= S3_SY then
        ycnt <= ycnt + 1;
      end if;
      rstM_pulse <= '0';
      rstS_pulse <= '0';
      if ps/=prev then
        if ns= S0_MG or ns= S1_MY then
          rstM_pulse <= '1';
        end if;
        if ns= S2_SG or ns= S3_SY then
          rstS_pulse <= '1';
        end if;
      end if;
    end if;
  end process;

  process(ps, SSCS, M_done, S_done, ycnt)
  begin
    ns <= ps;
    case ps is
      when S0_MG =>
        if SSCS='1' and M_done='1' then
          ns <= S1_MY;
        else
          ns <= S0_MG;
        end if;
      when S1_MY =>
        if ycnt = YMAX then
          ns <= S2_SG;
        else
          ns <= S1_MY;
        end if;
      when S2_SG =>
        if S_done='1' then
          ns <= S3_SY;
        else
          ns <= S2_SG;
        end if;
      when S3_SY =>
        if ycnt = YMAX then
          ns <= S0_MG;
        else
          ns <= S3_SY;
        end if;
    end case;
  end process;

  process(ps)
  begin
    case ps is
      when S0_MG => MSTL <= L_G; SSTL <= L_R;
      when S1_MY => MSTL <= L_Y; SSTL <= L_R;
      when S2_SG => MSTL <= L_R; SSTL <= L_G;
      when S3_SY => MSTL <= L_R; SSTL <= L_Y;
    end case;
  end process;

  enable_M <= '1' when (ps= S0_MG or ps= S1_MY) else '0';
  enable_S <= '1' when (ps= S2_SG or ps= S3_SY) else '0';
  reset_M  <= rstM_pulse;
  reset_S  <= rstS_pulse;

  with ps select
    state_flag <= "00" when S0_MG,
                 "01" when S1_MY,
                 "11" when S2_SG,
                 "10" when S3_SY;
end architecture;
