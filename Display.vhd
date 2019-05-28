library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Display Module
-- It calculates the current pixel color to output
-- depending on current game state

entity Display is
  Port (
    CLK_BG    : in   STD_LOGIC_VECTOR (6 downto 0); -- clock for background animation

    -- VGA controller
    blank     : in   STD_LOGIC;
    hcount    : in   STD_LOGIC_VECTOR (10 downto 0);
    vcount    : in   STD_LOGIC_VECTOR (10 downto 0);

    -- Game state
    altitude  : in   STD_LOGIC_VECTOR (10 downto 0);
    pos_pipe1 : in   STD_LOGIC_VECTOR (10 downto 0);
    alt_pipe1 : in   STD_LOGIC_VECTOR (10 downto 0);
    pos_pipe2 : in   STD_LOGIC_VECTOR (10 downto 0);
    alt_pipe2 : in   STD_LOGIC_VECTOR (10 downto 0);

    -- Output
    color     : out  STD_LOGIC_VECTOR (7 downto 0)
  );
end Display;

architecture Behavioral of Display is

  Signal is_bird:  BOOLEAN; -- True when area corresponds to bird
  Signal is_grass: BOOLEAN; -- True when area corresponds to grass
  Signal is_bar:   BOOLEAN; -- True when area corresponds to bar (on top of grass)
  Signal is_pipe1: BOOLEAN; -- True when area corresponds to pipe 1
  Signal is_pipe2: BOOLEAN; -- True when area corresponds to pipe 2

  Constant bird_X : STD_LOGIC_VECTOR (10 downto 0) := "00001000000"; -- X position of the bird
  Constant bird_size : STD_LOGIC_VECTOR (10 downto 0) := "00000100000"; -- Size of the bird
  Constant sky_height : STD_LOGIC_VECTOR (10 downto 0) := "00110110000"; -- Size of the sky
  Constant bar_height : STD_LOGIC_VECTOR (10 downto 0) := "00000000100"; -- Size of the bar
  Constant pipe_width : STD_LOGIC_VECTOR (10 downto 0) := "00001000000"; -- Width of one pipe
  Constant pipe_gap   : STD_LOGIC_VECTOR (10 downto 0) := "00001100000"; -- Gap between two pipes

  -- Colors RRRGGGBB
  -- Generate with : bin(int(0x71/255*2**3)),bin(int(0xc5/255*2**3)),bin(int(0xcf/255*2**2))
  Constant bird_color : STD_LOGIC_VECTOR (7 downto 0) := "11000100";
  Constant grass_color : STD_LOGIC_VECTOR (7 downto 0) := "11011010";
  Constant bar_color : STD_LOGIC_VECTOR (7 downto 0) := "01111000";
  Signal animated_pipe_color : STD_LOGIC_VECTOR (4 downto 0);
  Signal pipe_color : STD_LOGIC_VECTOR (7 downto 0) := "00010000";
  Signal animated_bg_color : STD_LOGIC_VECTOR (6 downto 0);
  Signal background_color : STD_LOGIC_VECTOR (7 downto 0) := "01101111";

begin

  -- Test areas
  is_bird <= (hcount > bird_X) and
             (hcount < bird_X + bird_size) and
             (vcount > altitude) and
             (vcount < altitude + bird_size);
  is_pipe1 <= (hcount + pipe_width > pos_pipe1) and
              (hcount + pipe_width < pos_pipe1 + pipe_width) and
              ((vcount < alt_pipe1) or
              (vcount > alt_pipe1 + pipe_gap));
  is_pipe2 <= (hcount + pipe_width > pos_pipe2) and
              (hcount + pipe_width < pos_pipe2 + pipe_width) and
              ((vcount < alt_pipe2) or
              (vcount > alt_pipe2 + pipe_gap));
  is_grass <= vcount > sky_height + bar_height;
  is_bar <= vcount > sky_height;

  -- Animated background
  animated_bg_color <= vcount(6 downto 0) - hcount(6 downto 0) - CLK_BG;
  background_color <= "01101111" when animated_bg_color(6)='1' else "01001011";

  -- Animated pipes
  animated_pipe_color <= vcount(4 downto 0) + hcount(4 downto 0) - pos_pipe1(4 downto 0);
  pipe_color <= "00010000" when animated_pipe_color(4)='1' else "00001100";

  -- Define current pixel color
  color <= (others=>'0') when blank='1'     else
            bird_color   when is_bird=true  else
            grass_color  when is_grass=true else
            bar_color    when is_bar=true   else
            pipe_color   when (is_pipe1=true or is_pipe2=true) else
            background_color;

end Behavioral;
