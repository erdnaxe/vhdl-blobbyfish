library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Game is
  Port (
    -- Clock
    CLK_50MHz : in    STD_LOGIC;

    -- VGA display
    HS        : out   STD_LOGIC;
    VS        : out   STD_LOGIC;
    color     : out   STD_LOGIC_VECTOR (7 downto 0);

    -- Inputs
    BTN       : in    STD_LOGIC
  );
end Game;

architecture Behavioral of Game is
  -- Clock divider at 25MHz
  Signal clk_div: STD_LOGIC_VECTOR (19 downto 0);
  alias CLK25MHz: STD_LOGIC is clk_div(0);
  alias CLK381Hz: STD_LOGIC is clk_div(16);
  alias CLK191Hz: STD_LOGIC is clk_div(17);
  alias CLK48Hz: STD_LOGIC is clk_div(19);

  -- VGA display
  component vga_controller_640_60
    PORT (
      rst       : in    STD_LOGIC;
      pixel_clk : in    STD_LOGIC;
      HS        : out   STD_LOGIC; 
      VS        : out   STD_LOGIC; 
      blank     : out   STD_LOGIC; 
      hcount    : out   STD_LOGIC_VECTOR (10 downto 0); 
      vcount    : out   STD_LOGIC_VECTOR (10 downto 0)
    );
  END component ;
  Signal blank:  STD_LOGIC;
  Signal hcount: STD_LOGIC_VECTOR (10 downto 0);
  Signal vcount: STD_LOGIC_VECTOR (10 downto 0);

  -- Display
  component Display
    PORT (
      blank     : in   STD_LOGIC;
      hcount    : in   STD_LOGIC_VECTOR (10 downto 0);
      vcount    : in   STD_LOGIC_VECTOR (10 downto 0);
      altitude  : in   STD_LOGIC_VECTOR (10 downto 0);
      pos_pipe1 : in   STD_LOGIC_VECTOR (10 downto 0);
      alt_pipe1 : in   STD_LOGIC_VECTOR (10 downto 0);
      pos_pipe2 : in   STD_LOGIC_VECTOR (10 downto 0);
      alt_pipe2 : in   STD_LOGIC_VECTOR (10 downto 0);
      color     : out   STD_LOGIC_VECTOR (7 downto 0)
    );
  END component ;

  -- Fly
  component Fly
    PORT (
      CLK48Hz  : in    STD_LOGIC;
      reset    : in    STD_LOGIC;
      btn      : in    STD_LOGIC;
      started  : out   STD_LOGIC;
      altitude : out   STD_LOGIC_VECTOR(10 downto 0)
    );
  END component ;
  Signal altitude : STD_LOGIC_VECTOR(10 downto 0);
  Signal started : STD_LOGIC;

  -- Pipe
  component Pipe
    Generic (
      pos_def : STD_LOGIC_VECTOR(10 downto 0);
      alt_def : STD_LOGIC_VECTOR(10 downto 0)
    );
    Port (
      CLK191Hz : in    STD_LOGIC;
      reset    : in    STD_LOGIC;
      started  : in    STD_LOGIC;
      alt_pipe : out   STD_LOGIC_VECTOR(10 downto 0);
      pos_pipe : out   STD_LOGIC_VECTOR(10 downto 0)
    );
  END component ;
  Signal pos_pipe1 : STD_LOGIC_VECTOR(10 downto 0);
  Signal alt_pipe1 : STD_LOGIC_VECTOR(10 downto 0);
  Signal pos_pipe2 : STD_LOGIC_VECTOR(10 downto 0);
  Signal alt_pipe2 : STD_LOGIC_VECTOR(10 downto 0);

  -- Collision detection then death
  component Collision
    PORT (
      CLK381Hz : in    STD_LOGIC;
      altitude : in    STD_LOGIC_VECTOR(10 downto 0);
      alt_pipe1 : in    STD_LOGIC_VECTOR(10 downto 0);
      pos_pipe1 : in    STD_LOGIC_VECTOR(10 downto 0);
      alt_pipe2 : in    STD_LOGIC_VECTOR(10 downto 0);
      pos_pipe2 : in    STD_LOGIC_VECTOR(10 downto 0);
      reset    : out   STD_LOGIC
    );
  END component ;
  Signal reset : STD_LOGIC;

begin

  -- Clock divider at 25MHz
  clk_div <= clk_div + 1 when rising_edge(CLK_50MHz);

  -- VGA display
  VGAMOD : vga_controller_640_60
  port map (
    rst => '0',  -- keep reset off
    pixel_clk => CLK25MHz,
    HS => HS,
    VS => VS,
    blank => blank,
    hcount => hcount,
    vcount => vcount
  );

  -- Display generation
  DISMOD : Display
  port map (
    blank => blank,
    hcount => hcount,
    vcount => vcount,
    altitude => altitude,
    pos_pipe1 => pos_pipe1,
    alt_pipe1 => alt_pipe1,
    pos_pipe2 => pos_pipe2,
    alt_pipe2 => alt_pipe2,
    color => color
  );

  -- Fly
  FLYMOD : Fly
  port map (
    CLK48Hz => CLK48Hz,
    reset => reset,
    btn => BTN,
    started => started,
    altitude => altitude
  );

  -- Pipe 1
  PIPEMOD1 : Pipe
  generic map (
    pos_def => "01011000000", -- (640+64)
    alt_def => "00011110000"  -- 480/2
  )
  port map (
    CLK191Hz => CLK191Hz,
    reset => reset,
    started => started,
    pos_pipe => pos_pipe1,
    alt_pipe => alt_pipe1
  );

  -- Pipe 2
  PIPEMOD2 : Pipe
  generic map (
    pos_def => "00101100000", -- (640+64)/2
    alt_def => "00010110000"  -- 480/2 - 64
  )
  port map (
    CLK191Hz => CLK191Hz,
    reset => reset,
    started => started,
    pos_pipe => pos_pipe2,
    alt_pipe => alt_pipe2
  );

  -- Collision detection then death
  DEAMOD : Collision
  port map (
    CLK381Hz => CLK381Hz,
    altitude => altitude,
    pos_pipe1 => pos_pipe1,
    alt_pipe1 => alt_pipe1,
    pos_pipe2 => pos_pipe2,
    alt_pipe2 => alt_pipe2,
    reset => reset
  );

end Behavioral;
