library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.MATH_REAL.all;
use IEEE.numeric_std.all;

entity vga is
    Port ( 
      red_in	: in STD_LOGIC_VECTOR(2 downto 0);
      green_in	: in STD_LOGIC_VECTOR(2 downto 0);
      blue_in	: in STD_LOGIC_VECTOR(2 downto 0);
      hs_in   	: in STD_LOGIC;
      vs_in		: in STD_LOGIC;
      red_out	: out STD_LOGIC_VECTOR(2 downto 0);
      green_out	: out STD_LOGIC_VECTOR(2 downto 0);
      blue_out	: out STD_LOGIC_VECTOR(2 downto 0);
      hs_out	: out STD_LOGIC;
      vs_out	: out STD_LOGIC;
      btn_in 	: in std_logic;
      btn_out	: out std_logic
    );
end vga;

architecture Behavioral of vga is
begin
   red_out <= red_in;
   green_out <= green_in;
   blue_out <= blue_in;
   hs_out <= hs_in;
   vs_out <= vs_in;
   btn_out <= btn_in;
end Behavioral;
