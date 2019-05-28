library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipe is
    Generic ( pos_def : STD_LOGIC_VECTOR(10 downto 0);
              alt_def : STD_LOGIC_VECTOR(10 downto 0) );
    Port ( CLK191Hz : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           started  : in  STD_LOGIC;
           -- vertical position of the pipe (should be random in the future)
           alt_pipe : out STD_LOGIC_VECTOR(10 downto 0);
           -- horizontal position to scroll to the right
           pos_pipe : out STD_LOGIC_VECTOR(10 downto 0) );
end Pipe;

architecture Behavioral of Pipe is
  Signal pos : STD_LOGIC_VECTOR(10 downto 0);

  -- position to teleport the pipe to the right side
  Constant pos_bordure : STD_LOGIC_VECTOR(10 downto 0) := "01011000000";
begin
  -- scroll pipe
  clockActive: process(CLK191Hz, reset)
	begin
    if reset='1' or started='0' then
      pos <= pos_def; -- reset at the default position
    else
      if rising_edge(CLK191Hz) then
        if pos > "00000000000" and started='1' then
          pos <= pos - 1; -- scroll to the right at a certain pace
        else
          pos <= pos_bordure; -- reset at right border
        end if;
      else
        pos <= pos;
      end if;
    end if;
	end process;

  alt_pipe <= alt_def;
  pos_pipe <= pos;
end Behavioral;
