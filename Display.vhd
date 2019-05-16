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
    R        : out  STD_LOGIC_VECTOR (2 downto 0);
    G        : out  STD_LOGIC_VECTOR (2 downto 0);
    B        : out  STD_LOGIC_VECTOR (1 downto 0)
  );
end Display;

architecture Behavioral of Display is
  Signal is_bird_X: BOOLEAN;  -- True when x correspond to bird area
  Signal is_bird_Y: BOOLEAN;  -- True when y correspond to bird area

  Constant bird_X : STD_LOGIC_VECTOR (10 downto 0) := "00010101010";  -- X position of the bird
  Constant bird_size : STD_LOGIC_VECTOR (10 downto 0) := "00000001111";  -- Size of the bird
begin
  is_bird_X <= (hcount < bird_X);
  is_bird_Y <= (vcount < altitude);

  R <= "111" when blank='0' and is_bird_X=true else "000";       
  G <= "111" when blank='0' and is_bird_Y=true else "000";
  B <= "11" when blank='0' else "00";
end Behavioral;