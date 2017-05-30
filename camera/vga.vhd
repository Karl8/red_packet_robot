----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Generate analog 800x600 VGA, double-doublescanned from 19200 bytes of RAM
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_arith.all;

entity vga is
    Port ( 
      clk50       : in  STD_LOGIC;
      vga_red     : out STD_LOGIC_VECTOR(2 downto 0);
      vga_green   : out STD_LOGIC_VECTOR(2 downto 0);
      vga_blue    : out STD_LOGIC_VECTOR(2 downto 1);
      vga_hsync   : out STD_LOGIC;
      vga_vsync   : out STD_LOGIC;
      frame_addr  : out STD_LOGIC_VECTOR(14 downto 0);
      frame_pixel : in  STD_LOGIC_VECTOR(15 downto 0)
    );
end vga;

architecture Behavioral of vga is
   -- Timing constants
   constant hRez       : natural := 640;
   constant hStartSync : natural := 640+16;
   constant hEndSync   : natural := 640+16+96;
   constant hMaxCount  : natural := 800;

   constant vRez       : natural := 480;
   constant vStartSync : natural := 480+10;
   constant vEndSync   : natural := 480+10+2;
   constant vMaxCount  : natural := 480+10+2+33;
   constant hsync_active : std_logic := '1';
   constant vsync_active : std_logic := '1';

   signal hCounter : unsigned(10 downto 0) := (others => '0');
   signal vCounter : unsigned(9 downto 0) := (others => '0');
   signal address : unsigned(16 downto 0) := (others => '0');
   signal blank : std_logic := '1';
   
   signal r, g: std_logic_vector(2 downto 0);
   signal b : std_logic_vector(1 downto 0);
begin
   frame_addr <= std_logic_vector(address(15 downto 1));
   
   process(clk50)
   begin
      if rising_edge(clk50) then
         -- Count the lines and rows      
         if hCounter = hMaxCount-1 then
            hCounter <= (others => '0');
            if vCounter = vMaxCount-1 then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter+1;
            end if;
         else
            hCounter <= hCounter+1;
         end if;
         if vCounter  >= vRez then
            address <= (others => '0');
            blank <= '1';
         else 
            if hCounter  < hRez then
               blank <= '0';
               if hCounter = hRez - 1 then
                  if vCounter(1 downto 0) /= "11" then
                     address <= address - 639;
                  else
                      address <= address+1;
                  end if;
               else
                  address <= address+1;
               end if;
            else
               blank <= '1';
            end if;
         end if;
   
         -- Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
         if hCounter > hStartSync and hCounter <= hEndSync then
            vga_hSync <= hsync_active;
         else
            vga_hSync <= not hsync_active;
         end if;

         -- Are we in the vSync pulse?
         if vCounter >= vStartSync and vCounter < vEndSync then
            vga_vSync <= vsync_active;
         else
            vga_vSync <= not vsync_active;
         end if;
         
         vga_red <= std_logic_vector(r(2 downto 0));
         vga_green <= std_logic_vector(g(2 downto 0));
         vga_blue <= std_logic_vector(b(1 downto 0));
      end if;
	end process;
	process(r, g, b, blank)
    begin
         if blank = '0' then
            if hCounter = 100 or hCounter = 400 then
				r   <= (others => '1');
				g   <= (others => '1');
				b   <= (others => '1');
			elsif unsigned(frame_pixel(15 downto 11)) < 31 and unsigned(frame_pixel(15 downto 11)) > 26 and unsigned(frame_pixel(10 downto 6)) > 24 and unsigned(frame_pixel(10 downto 6)) < 28 and unsigned(frame_pixel(4 downto 0)) > 25 then
				r  <= (others => '1');
				g  <= (others => '0');
				b  <= (others => '0');
            else
				r   <= (others => '0');
				g   <= (others => '0');
				b   <= (others => '0');
            --r   <= frame_pixel(15 downto 13);
           -- g   <= frame_pixel(10 downto 8);
           -- b   <= frame_pixel(4 downto 3);
            end if;
         else
            r   <= (others => '0');
            g   <= (others => '0');
            b   <= (others => '0');
         end if;
   end process;
end Behavioral;
