library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipe is
    Port ( CLK381Hz : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           -- vertical position of the middle of the two pipes
		   altitude : out STD_LOGIC_VECTOR(10 downto 0)
		   -- horizontal position to scroll to the right
           position : out STD_LOGIC_VECTOR(10 downto 0) );
end Pipe;

architecture Behavioral of Pipe is

  -- Screen height : 480
  Constant min_height : STD_LOGIC_VECTOR(10 downto 0) := "00000101000"; -- 40
  Constant max_height : STD_LOGIC_VECTOR(10 downto 0) := "00110111000"; -- 440

  -- Starts at the right of the screen
  Signal pos : STD_LOGIC_VECTOR(10 downto 0) := "00111110100";
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
