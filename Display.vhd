library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display is
    Port (
      blank    : in   STD_LOGIC; 
      hcount   : in   STD_LOGIC_VECTOR (10 downto 0); 
      vcount   : in   STD_LOGIC_VECTOR (10 downto 0);
      altitude : in   STD_LOGIC_VECTOR (8 downto 0);
      R        : out  STD_LOGIC_VECTOR (2 downto 0);
      G        : out  STD_LOGIC_VECTOR (2 downto 0);
      B        : out  STD_LOGIC_VECTOR (1 downto 0)
    );
end Display;

architecture Behavioral of Display is
  Constant bird_height : STD_LOGIC_VECTOR (3 downto 0) := "1111";
  Constant bird_X : STD_LOGIC_VECTOR (9 downto 0) := "10101010";
begin
  R <= "000" when blank='0'
              and (vcount < bird_altitude + bird_height)
              and (vcount > bird_altitude - bird_height)
              and (hcount < bird_X + bird_height)
              and (hcount > bird_X - bird_height)
       else "111";
  G <= "000" when blank='0' else "000";
  B <= "11" when blank='0' else "00";
end Behavioral;