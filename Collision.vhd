library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Collision is
    Port ( altitude : in    STD_LOGIC_VECTOR(10 downto 0);
           reset    : out   STD_LOGIC);
end Collision;

architecture Behavioral of Collision is
  Signal altitude_ok : BOOLEAN;
  Constant max_altitude : STD_LOGIC_VECTOR(10 downto 0) := "00110010000";
  Constant min_altitude : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
begin
  altitude_ok <= (min_altitude < altitude) and (altitude < max_altitude);
  reset <= '0' when altitude_ok else '1';
end Behavioral;