library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Fly is
    Port ( CLK381Hz : in  STD_LOGIC;
           btn : in  STD_LOGIC;
           altitude : out  STD_LOGIC_VECTOR(8 downto 0));
end Fly;

architecture Behavioral of Fly is
  Signal alti: STD_LOGIC_VECTOR(8 downto 0) := "011110000";
begin
  -- When user press button, increase altitude, else decrease
  btnActive: process(CLK381Hz)
	begin
		if btn='1' then
			alti <= alti + 1;
		else
			alti <= alti - 1;
		end if;
	end process;

  altitude <= alti;
end Behavioral;