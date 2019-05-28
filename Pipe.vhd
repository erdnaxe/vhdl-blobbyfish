library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipe is
    Port ( CLK191Hz : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           alt_pipe : out STD_LOGIC_VECTOR(10 downto 0);
           -- horizontal position to scroll to the right
           pos_pipe : out STD_LOGIC_VECTOR(10 downto 0) );
end Pipe;

architecture Behavioral of Pipe is

  -- Screen height : 480
  Constant min_height : STD_LOGIC_VECTOR(10 downto 0) := "00000101000"; -- 40
  Constant max_height : STD_LOGIC_VECTOR(10 downto 0) := "00110111000"; -- 440

  -- Starts at the right of the screen
  Constant pos_def : STD_LOGIC_VECTOR(10 downto 0) := "01011000000";
  Signal pos : STD_LOGIC_VECTOR(10 downto 0) := "01011000000";
  -- average(40, 440) = 480/2 = 240
  Signal alt : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";

begin
  -- Select a random height based on the button press and timer
  -- For now we just define a single position
  alt <= "00011110000"; -- average(40, 440) = 480/2 = 240

  clockActive: process(CLK191Hz, reset)
	begin
    if reset='1' then
      pos <= pos_def; -- reset at the right of the screen
    else
      if rising_edge(CLK191Hz) then
        if pos > "00000000000" then
          pos <= pos - 1; -- scroll to the right at a certain pace
        else
          pos <= pos_def; -- reset at the right of the screen
        end if;
      else
        pos <= pos;
      end if;
    end if;
	end process;

  alt_pipe <= alt;
  pos_pipe <= pos;
end Behavioral;
