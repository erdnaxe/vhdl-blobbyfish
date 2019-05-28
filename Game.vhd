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
  Signal clk_div: STD_LOGIC_VECTOR (17 downto 0);
  alias CLK25MHz: STD_LOGIC is clk_div(0);
  alias CLK381Hz: STD_LOGIC is clk_div(16);
  alias CLK191Hz: STD_LOGIC is clk_div(17);

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
      blank    : in   STD_LOGIC; 
      hcount   : in   STD_LOGIC_VECTOR (10 downto 0); 
      vcount   : in   STD_LOGIC_VECTOR (10 downto 0);
      altitude : in   STD_LOGIC_VECTOR (10 downto 0);
      pos_pipe : in   STD_LOGIC_VECTOR (10 downto 0);
      alt_pipe : in   STD_LOGIC_VECTOR (10 downto 0);
      color    : out   STD_LOGIC_VECTOR (7 downto 0)
    );
  END component ;

  -- Fly
  component Fly
    PORT (
      CLK381Hz : in    STD_LOGIC;
      reset    : in    STD_LOGIC;
      btn      : in    STD_LOGIC;
      altitude : out   STD_LOGIC_VECTOR(10 downto 0)
    );
  END component ;
  Signal altitude : STD_LOGIC_VECTOR(10 downto 0);

  -- Pipe
  component Pipe
    PORT (
      CLK191Hz : in    STD_LOGIC;
      reset    : in    STD_LOGIC;
      alt_pipe : out   STD_LOGIC_VECTOR(10 downto 0);
      pos_pipe : out   STD_LOGIC_VECTOR(10 downto 0)
    );
  END component ;
  Signal pos_pipe : STD_LOGIC_VECTOR(10 downto 0);
  Signal alt_pipe : STD_LOGIC_VECTOR(10 downto 0);

  -- Collision detection then death
  component Collision
    PORT (
      CLK381Hz : in    STD_LOGIC;
      altitude : in    STD_LOGIC_VECTOR(10 downto 0);
      alt_pipe : in    STD_LOGIC_VECTOR(10 downto 0);
      pos_pipe : in    STD_LOGIC_VECTOR(10 downto 0);
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
    pos_pipe => pos_pipe,
    alt_pipe => alt_pipe,
    color => color
  );

  -- Fly
  FLYMOD : Fly
  port map (
    CLK381Hz => CLK381Hz,
    reset => reset,
    btn => BTN,
    altitude => altitude
  );

  -- Pipe
  PIPEMOD : Pipe
  port map (
    CLK191Hz => CLK191Hz,
    reset => reset,
    pos_pipe => pos_pipe,
    alt_pipe => alt_pipe
  );

  -- Collision detection then death
  DEAMOD : Collision
  port map (
    CLK381Hz => CLK381Hz,
    altitude => altitude,
    pos_pipe => pos_pipe,
    alt_pipe => alt_pipe,
    reset => reset
  );

end Behavioral;
