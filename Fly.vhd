library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Fly is
    Port ( CLK48Hz  : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           btn      : in  STD_LOGIC;
           altitude : out STD_LOGIC_VECTOR(10 downto 0) );
end Fly;

architecture Behavioral of Fly is
  -- position
  Signal pos_alti : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";
  Constant pos_alti_def : STD_LOGIC_VECTOR(10 downto 0) := "00011110000";

  -- vitesse
  Signal vit_alti : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
  Constant vit_alti_def : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
begin
  -- When user press button, increase altitude, else decrease
  btnActive: process(CLK48Hz, reset)
	begin
    if reset='1' then
      pos_alti <= pos_alti_def;
      vit_alti <= vit_alti_def;
    else
      if rising_edge(CLK48Hz) then
        pos_alti <= pos_alti + vit_alti;
        if btn='1' then
          vit_alti <= vit_alti - "00000000001";
        else
          if vit_alti < "00000000100" then
            vit_alti <= vit_alti + "00000000001";
          else
            vit_alti <= vit_alti;
          end if;
        end if;
      else
        pos_alti <= pos_alti;
        vit_alti <= vit_alti;
      end if;
    end if;
	end process;

  altitude <= pos_alti;
end Behavioral;