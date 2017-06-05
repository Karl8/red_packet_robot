----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ov7670_top is
    Port ( 
      clk100        : in    STD_LOGIC;
      OV7670_SIOC  : out   STD_LOGIC;
      OV7670_SIOD  : inout STD_LOGIC;
      OV7670_RESET : out   STD_LOGIC;
      OV7670_PWDN  : out   STD_LOGIC;
      OV7670_VSYNC : in    STD_LOGIC;
      OV7670_HREF  : in    STD_LOGIC;
      OV7670_PCLK  : in    STD_LOGIC;
      OV7670_XCLK  : out   STD_LOGIC;
      OV7670_D     : in    STD_LOGIC_VECTOR(7 downto 0);

      led          : out    STD_LOGIC;
      vga_red      : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_green    : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_blue     : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_hsync    : out   STD_LOGIC;
      vga_vsync    : out   STD_LOGIC;
      mode        : in  STD_LOGIC_VECTOR(1 downto 0); 
	  finished    : out STD_LOGIC;
	  x           : out STD_LOGIC_VECTOR(8 downto 0);
	  y           : out STD_LOGIC_VECTOR(8 downto 0);
      btn           : in    STD_LOGIC
    );
end ov7670_top;

architecture Behavioral of ov7670_top is

   COMPONENT new_top
   PORT(
      clk100        : in    STD_LOGIC;
      OV7670_SIOC  : out   STD_LOGIC;
      OV7670_SIOD  : inout STD_LOGIC;
      OV7670_RESET : out   STD_LOGIC;
      OV7670_PWDN  : out   STD_LOGIC;
      OV7670_VSYNC : in    STD_LOGIC;
      OV7670_HREF  : in    STD_LOGIC;
      OV7670_PCLK  : in    STD_LOGIC;
      OV7670_XCLK  : out   STD_LOGIC;
      OV7670_D     : in    STD_LOGIC_VECTOR(7 downto 0);

      led          : out    STD_LOGIC;
      vga_red      : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_green    : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_blue     : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_hsync    : out   STD_LOGIC;
      vga_vsync    : out   STD_LOGIC;
      mode        : in  STD_LOGIC_VECTOR(1 downto 0); 
	  finished    : out STD_LOGIC;
	  x           : out STD_LOGIC_VECTOR(8 downto 0);
	  y           : out STD_LOGIC_VECTOR(8 downto 0);
      btn           : in    STD_LOGIC
 );
   END COMPONENT;
begin
	top: new_top
		port map(
	  clk100       	=> clk100,
      OV7670_SIOC  	=> OV7670_SIOC,
      OV7670_SIOD  	=> OV7670_SIOD,
      OV7670_RESET 	=> OV7670_RESET,
      OV7670_PWDN   => OV7670_PWDN,
      OV7670_VSYNC  => OV7670_VSYNC,
      OV7670_HREF   => OV7670_HREF,
      OV7670_PCLK   => OV7670_PCLK,
      OV7670_XCLK   => OV7670_XCLK,
      OV7670_D      => OV7670_D,

      led           => led,
      vga_red       => vga_red,
      vga_green     => vga_green,
      vga_blue      => vga_blue,
      vga_hsync     => vga_hsync,
      vga_vsync     => vga_vsync,
      mode          => mode,
	  finished      => finished,
	  x             => x,
	  y             => y,
      btn           => btn    
	);
end Behavioral;
