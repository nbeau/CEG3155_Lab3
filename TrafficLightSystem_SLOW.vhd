library ieee;
use ieee.std_logic_1164.all;

entity TrafficLightSystem_SLOW is
  port (
    GClock : in  std_logic;
    GReset : in  std_logic;
    MSC    : in  std_logic_vector(3 downto 0);
    SSC    : in  std_logic_vector(3 downto 0);
    SSCS   : in  std_logic;
    MSTL   : out std_logic_vector(2 downto 0);
    SSTL   : out std_logic_vector(2 downto 0);
    BCD1   : out std_logic_vector(3 downto 0);
    BCD2   : out std_logic_vector(3 downto 0);
	 STATE_LED : out std_logic_vector(1 downto 0)
  );
end entity TrafficLightSystem_SLOW;

architecture Structural of TrafficLightSystem_SLOW is
  signal slow_clk   : std_logic;
  signal SSCS_clean : std_logic;
  signal M_done     : std_logic;
  signal S_done     : std_logic;
  signal M_count    : std_logic_vector(3 downto 0);
  signal S_count    : std_logic_vector(3 downto 0);
  signal enable_M   : std_logic;
  signal enable_S   : std_logic;
  signal reset_M    : std_logic;
  signal reset_S    : std_logic;
  signal MSTL_s     : std_logic_vector(2 downto 0);
  signal SSTL_s     : std_logic_vector(2 downto 0);
  signal disp_count : std_logic_vector(3 downto 0);
  signal state_flag_s : std_logic_vector(1 downto 0);

begin
  u_div: entity work.ClockDivider
	 
    port map (
      clk_in  => GClock,
      reset   => GReset,
      clk_out => slow_clk
    );


   u_db: entity work.Debouncer_FAST
	  port map (
		 clk       => slow_clk,
		 reset     => GReset,
		 noisy_in  => SSCS,
		 clean_out => SSCS_clean
	  );

  u_fsm: entity work.FSM_Controller
    port map (
      clk       => slow_clk,
      reset     => GReset,
      SSCS      => SSCS_clean,
      M_done    => M_done,
      S_done    => S_done,
      MSTL      => MSTL_s,
      SSTL      => SSTL_s,
      enable_M  => enable_M,
      enable_S  => enable_S,
      reset_M   => reset_M,
      reset_S   => reset_S,
		state_flag => state_flag_s 
    );

  u_mc: entity work.MainCounter
    port map (
      clk    => slow_clk,
      reset  => reset_M,
      enable => enable_M,
      limit  => MSC,
      count  => M_count,
      done   => M_done
    );

  u_sc: entity work.SideCounter
    port map (
      clk    => slow_clk,
      reset  => reset_S,
      enable => enable_S,
      limit  => SSC,
      count  => S_count,
      done   => S_done
    );

  disp_count <= M_count when enable_M = '1'
           else S_count when enable_S = '1'
           else (others => '0');

  u_bcd: entity work.BCD_Decoder
    port map (
      value => disp_count,
      BCD1  => BCD1,
      BCD2  => BCD2
    );
  STATE_LED <= state_flag_s;
  MSTL <= MSTL_s;
  SSTL <= SSTL_s;
end architecture;
