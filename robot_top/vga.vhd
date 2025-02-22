----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Generate analog 800x600 VGA, double-doublescanned from 19200 bytes of RAM
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;

entity vga is
    Port ( 
      clk50       : in  STD_LOGIC;
      vga_red     : out STD_LOGIC_VECTOR(2 downto 0);
      vga_green   : out STD_LOGIC_VECTOR(2 downto 0);
      vga_blue    : out STD_LOGIC_VECTOR(2 downto 0);
      vga_hsync   : out STD_LOGIC;
      vga_vsync   : out STD_LOGIC;
      frame_addr  : out STD_LOGIC_VECTOR(14 downto 0);
      frame_pixel : in  STD_LOGIC_VECTOR(15 downto 0);
      mode        : in  STD_LOGIC_VECTOR(1 downto 0); 
	  finished    : out STD_LOGIC;
	  x           : out STD_LOGIC_VECTOR(8 downto 0);
	  y           : out STD_LOGIC_VECTOR(8 downto 0)
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

   shared variable hCounter : integer := 0;
   shared variable vCounter : integer := 0;
   signal address : unsigned(16 downto 0) := (others => '0');
   signal blank : std_logic := '1';
   
   signal r, g, b: std_logic_vector(2 downto 0);
   signal cog : std_logic;
   
   shared variable hSum, vSum, cnt : integer := 0;
   shared variable count : integer := 0;
   shared variable lasth : integer := 0;
   shared variable lastv : integer := 0;
   
   
   signal clk25: std_logic := '0';
begin
   frame_addr <= std_logic_vector(address(15 downto 1));
   process(clk50)
	begin
		if (rising_edge(clk50)) then
			clk25<=not clk25;
		end if;
	end process;
   process(clk25)
   begin
      if rising_edge(clk25) then
         -- Count the lines and rows      
         if hCounter = hMaxCount-1 then
            hCounter := 0;
            if vCounter = vMaxCount-1 then
               vCounter := 0;
            else
               vCounter := vCounter+1;
            end if;
         else
            hCounter := hCounter+1;
         end if;
         if vCounter  >= vRez then
            address <= (others => '0');
            blank <= '1';
         else 
            if hCounter  < 320 then
               --if hCounter = 319 then
                --  if vCounter mod 2 /= 1 then
                --     address <= address - 639;
               --   else
           --           address <= address+1;
               --   end if;
           --    else
                  address <= address+1;
           --    end if;
            end if;
            if vCounter < 160 and hCounter  < 320 then
               blank <= '0';
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
         
         finished <= '0';
         
         if vCounter = 0 and hCounter = 0 then
			if mode /= "00" then
				if cog = '0' then 
					cog <= '1';
				elsif cnt >= 100 then
					cog <= '0';
					finished <= '1';
				end if;
			end if;
					
			if cnt < 100 then
				lasth := 100;
				lastv := 100;
            else
				lasth := hSum / cnt;
				lastv := vSum / cnt;
				x <= conv_std_logic_vector(lasth, 9);
				y <= conv_std_logic_vector(lastv, 9);
			end if;
            hSum := 0;
            vSum := 0;
            cnt := 0;
            count := 0;
		end if;
         
         if blank = '0' then
            if hCounter = 50 or hCounter = 100 or hCounter = 150 or hCounter = 200 or hCounter = 250 or hCounter = 300 or vCounter = 50 or vCounter = 100 or vCounter = 150 then
				r  <= (others => '1');
				g  <= (others => '1');
				b  <= (others => '1');
			
            elsif hCounter <= lasth + 3 and hCounter >= lasth - 3 and vCounter <= lastv + 3 and vCounter >= lastv - 3 then
              r  <= (others => '0');
              g  <= (others => '1');
              b  <= (others => '0');
             elsif mode = "10" and unsigned(frame_pixel(15 downto 11)) >= 28 and unsigned(frame_pixel(10 downto 6)) >= 28 and unsigned(frame_pixel(4 downto 0)) > 25 then
				count := count + 1;
				if (count >= 5) then
					hSum := hSum + hCounter;
					vSum := vSum + vCounter;
					cnt := cnt + 1;
				end if;
				r  <= (others => '1');
				g  <= (others => '0');
				b  <= (others => '0');
            elsif mode /= "10" and unsigned(frame_pixel(15 downto 11)) < 30 and unsigned(frame_pixel(15 downto 11)) > 22 and  unsigned(frame_pixel(10 downto 6)) > 20 and unsigned(frame_pixel(10 downto 6)) < 30 and unsigned(frame_pixel(4 downto 0)) > 20 then
				count := count + 1;
					if (count >= 5) then
						hSum := hSum + hCounter;
						vSum := vSum + vCounter;
						cnt := cnt + 1;
					end if; 
				r  <= (others => '1');
				g  <= (others => '0');
				b  <= (others => '0');
			
			
            else
				count := 0;
		--		r   <= (others => '0');
		--		g   <= (others => '0');
		--		b   <= (others => '0');
            r   <= frame_pixel(15 downto 13);
            g   <= frame_pixel(10 downto 8);
            b   <= frame_pixel(4 downto 2);
            end if;
         else
			count := 0;
            r   <= (others => '0');
            g   <= (others => '0');
            b   <= (others => '0');
         end if;
         vga_red <= std_logic_vector(r(2 downto 0));
         vga_green <= std_logic_vector(g(2 downto 0));
         vga_blue <= std_logic_vector(b(2 downto 0));
      end if;
	end process;
end Behavioral;
