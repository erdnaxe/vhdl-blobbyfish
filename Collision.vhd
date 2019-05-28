library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Collision is
    Port ( CLK381Hz : in    STD_LOGIC;
           altitude : in    STD_LOGIC_VECTOR(10 downto 0);
           alt_pipe : in    STD_LOGIC_VECTOR(10 downto 0);
           pos_pipe : in    STD_LOGIC_VECTOR(10 downto 0);
           reset    : out   STD_LOGIC);
end Collision;

architecture Behavioral of Collision is
  Signal do_reset : STD_LOGIC;

  -- Altitude collision
  Signal altitude_ok : BOOLEAN;
  Constant max_altitude : STD_LOGIC_VECTOR(10 downto 0) := "00110010000";
  Constant min_altitude : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";

  -- Pipe collision
  Signal pipe_ok : BOOLEAN;
  Constant bird_X : STD_LOGIC_VECTOR (10 downto 0) := "00010101010";
  Constant bird_size : STD_LOGIC_VECTOR (10 downto 0) := "00000100000";
  Constant pipe_width : STD_LOGIC_VECTOR (10 downto 0) := "00001000000";
  Constant pipe_gap   : STD_LOGIC_VECTOR (10 downto 0) := "00001100000";
begin
  altitude_ok <= (min_altitude < altitude) and (altitude < max_altitude);
  pipe_ok <= (pos_pipe < bird_X) or -- pipe is before
             (pos_pipe > bird_X + bird_size + pipe_width) or -- pipe is after
             ((altitude > alt_pipe) and
              (altitude + bird_size < alt_pipe + pipe_gap)); -- bird is in pipe gap

  do_reset <= '0' when altitude_ok and pipe_ok else '1';
  reset <= do_reset when rising_edge(CLK381Hz);  -- D flip-flop
end Behavioral;