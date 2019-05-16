library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Fly is
    Port ( CLK381Hz : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           btn      : in  STD_LOGIC;
           altitude : out STD_LOGIC_VECTOR(10 downto 0) );
end Fly;

architecture Behavioral of Fly is
  Constant altitude_def : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";
  Signal alti : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";
begin
  -- When user press button, increase altitude, else decrease
  btnActive: process(CLK381Hz, reset)
	begin
    if reset='1' then
      alti <= altitude_def;
    else
      if rising_edge(CLK381Hz) then
        if btn='1' then
          alti <= alti - 1;
        else
          alti <= alti + 1;
        end if;
      else
        alti <= alti;
      end if;
    end if;
	end process;

  altitude <= alti;
end Behavioral;