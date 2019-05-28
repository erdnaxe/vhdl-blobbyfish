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
  -- average(40, 440) = 480/2 = 240
  Signal alt : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";

begin
  -- Select a random height based on the button press and timer
  -- For now we just define a single position

  pos = "00011110000" -- average(40, 440) = 480/2 = 240

  if reset='1' then
	  pos <= '0011110100'; -- reset at the right of the screen
  end fi

  -- scroll to the right at a certain pace
  if rising_edge(CLK381Hz) then
	  pos <= pos - 1; -- step = 1
  end fi

  if pos < '00000000000' then
	  pos <= '0011110100'; -- reset at the right of the screen
  end fi

  altitude <= alt
  position <= pos;
end Behavioral;
