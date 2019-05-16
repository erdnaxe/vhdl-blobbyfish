library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display is
  Port (
    blank    : in   STD_LOGIC; 
    hcount   : in   STD_LOGIC_VECTOR (10 downto 0); 
    vcount   : in   STD_LOGIC_VECTOR (10 downto 0);
    altitude : in   STD_LOGIC_VECTOR (10 downto 0);
    color    : out  STD_LOGIC_VECTOR (7 downto 0)
  );
end Display;

architecture Behavioral of Display is
  Signal is_bird: BOOLEAN;  -- True when x and y correspond to bird area
  Signal is_grass: BOOLEAN;  -- True when x and y correspond to grass area
  Signal is_bar: BOOLEAN;  -- True when x and y correspond to bar area

  -- Color of current pixel
  Signal mcolor: STD_LOGIC_VECTOR (7 downto 0);

  -- Constants
  Constant bird_X : STD_LOGIC_VECTOR (10 downto 0) := "00010101010";  -- X position of the bird
  Constant bird_size : STD_LOGIC_VECTOR (10 downto 0) := "00000100000";  -- Size of the bird
  Constant sky_height : STD_LOGIC_VECTOR (10 downto 0) := "00110110000";  -- Size of the sky
  Constant bar_height : STD_LOGIC_VECTOR (10 downto 0) := "00000000100";  -- Size of the bar

  -- Colors RRRGGGBB
  -- bin(int(0x71/255*2**3)),bin(int(0xc5/255*2**3)),bin(int(0xcf/255*2**2))
  Constant bird_color : STD_LOGIC_VECTOR (7 downto 0) := "11111110";
  Constant grass_color : STD_LOGIC_VECTOR (7 downto 0) := "11011010";
  Constant bar_color : STD_LOGIC_VECTOR (7 downto 0) := "01111000";
  Constant background_color : STD_LOGIC_VECTOR (7 downto 0) := "01101111";
begin
  is_bird <= (hcount > bird_X) and
             (hcount < bird_X + bird_size) and
             (vcount > altitude) and
             (vcount < altitude + bird_size);
  is_grass <= vcount > sky_height + bar_height;
  is_bar <= vcount > sky_height;

  -- Define current pixel color
  mcolor <= bird_color when is_bird=true else
            grass_color when is_grass=true else
            bar_color when is_bar=true else
            background_color;

  -- Color only in drawing area
  color <= mcolor when blank='0' else (others=>'0');
end Behavioral;