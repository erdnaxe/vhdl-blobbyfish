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
    R         : out   STD_LOGIC_VECTOR (2 downto 0);
    G         : out   STD_LOGIC_VECTOR (2 downto 0);
    B         : out   STD_LOGIC_VECTOR (1 downto 0);

    -- Inputs
    BTN       : in    STD_LOGIC
  );
end Game;

architecture Behavioral of Game is
  -- Clock divider at 25MHz
  Signal clk_div: STD_LOGIC_VECTOR (16 downto 0);
  alias CLK25MHz: STD_LOGIC is clk_div(0);
  alias CLK381Hz: STD_LOGIC is clk_div(16);

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
  Signal vga_blank:  STD_LOGIC;
  Signal vga_hcount: STD_LOGIC_VECTOR (10 downto 0);
  Signal vga_vcount: STD_LOGIC_VECTOR (10 downto 0);

  -- Display
  component Display
    PORT (
      blank    : in   STD_LOGIC; 
      hcount   : in   STD_LOGIC_VECTOR (10 downto 0); 
      vcount   : in   STD_LOGIC_VECTOR (10 downto 0);
      altitude : in   STD_LOGIC_VECTOR (10 downto 0);
      R        : out   STD_LOGIC_VECTOR (2 downto 0);
      G        : out   STD_LOGIC_VECTOR (2 downto 0);
      B        : out   STD_LOGIC_VECTOR (1 downto 0)
    );
  END component ;

  -- Fly
  component Fly
    PORT (
      CLK381Hz : in    STD_LOGIC;
      btn      : in    STD_LOGIC;
      altitude : out   STD_LOGIC_VECTOR(10 downto 0)
    );
  END component ;
  Signal altitude :  STD_LOGIC_VECTOR(10 downto 0);

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
    blank => vga_blank,
    hcount => vga_hcount,
    vcount => vga_vcount
  );

  -- Display generation
  DISMOD : Display
  port map (
    blank => vga_blank,
    hcount => vga_hcount,
    vcount => vga_vcount,
    altitude => altitude,
    R => R,
    G => G,
    B => B
  );

  -- Fly
  FLYMOD : Fly
  port map (
    CLK381Hz => CLK381Hz,
    btn => BTN,
    altitude => altitude
  );

end Behavioral;
