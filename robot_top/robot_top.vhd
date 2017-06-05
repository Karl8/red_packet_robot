----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity robot_top is
    Port ( 
      clk100        : in    STD_LOGIC;
      reset			: in	std_logic;
      OV7670_SIOC  : out   STD_LOGIC;
      OV7670_SIOD  : inout STD_LOGIC;
      OV7670_RESET : out   STD_LOGIC;
      OV7670_PWDN  : out   STD_LOGIC;
      OV7670_VSYNC : in    STD_LOGIC;
      OV7670_HREF  : in    STD_LOGIC;
      OV7670_PCLK  : in    STD_LOGIC;
      OV7670_XCLK  : out   STD_LOGIC;
      OV7670_D     : in    STD_LOGIC_VECTOR(7 downto 0);

      
      vga_red      : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_green    : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_blue     : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_hsync    : out   STD_LOGIC;
      vga_vsync    : out   STD_LOGIC;
      
      btn			: in std_logic;
      
      -- test
      led_m1		: out std_logic;
      led_m2		: out std_logic;
      af			: in std_logic;
      
      -- RUBBISH
      TMDled          : out    STD_LOGIC;
       TMDbtn           : in    STD_LOGIC
    );
end robot_top;

architecture Behavioral of robot_top is

   COMPONENT ov7670_top
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

component logic is
    port(
        clk             : in std_logic;
        reset           : in std_logic;
        cam_finished    : in std_logic;
        act_finished    : in std_logic;
        btn             : in std_logic;
        mode            : out std_logic_vector(1 downto 0);
        act             : out std_logic;
        m_cnt			: out std_logic_vector(1 downto 0)
    );
end component;
   
	signal mode        	: STD_LOGIC_VECTOR(1 downto 0); 
	signal x           	: STD_LOGIC_VECTOR(8 downto 0);
	signal y           	: STD_LOGIC_VECTOR(8 downto 0);
	signal cam_finished	: std_logic;
	signal act_finished : std_logic;
	signal act			: std_logic;
	
	signal  m_cnt		: std_logic_vector(1 downto 0);
begin
	led_m1 <= m_cnt(0);
	led_m2 <= m_cnt(1);
	act_finished <= not af;


	cam: ov7670_top
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

      led           => TMDled,
      vga_red       => vga_red,
      vga_green     => vga_green,
      vga_blue      => vga_blue,
      vga_hsync     => vga_hsync,
      vga_vsync     => vga_vsync,
      mode          => mode,
	  finished      => cam_finished,
	  x             => x,
	  y             => y,
      btn           => TMDbtn    
	);
	
	lg : logic port map(
		clk				=> clk100,
		reset			=> reset,
		cam_finished	=> cam_finished,
		act_finished	=> act_finished,
		btn				=> btn,
		mode			=> mode,
		act				=> act,
		m_cnt			=> m_cnt
	);
end Behavioral;
