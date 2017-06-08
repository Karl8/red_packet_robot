library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.definitions.all;

entity action is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        x           : in std_logic_vector(8 downto 0);
        y           : in std_logic_vector(8 downto 0);
        act         : in std_logic; --使能
        txd         : out std_logic;
        --cmd         : in std_logic;
        finished    : out std_logic
    );


function degree_to_arm(sita:in std_logic_vector) return std_logic_vector is
        variable div:std_logic_vector(7 downto 0):="01011001";
        variable add:std_logic_vector(15 downto 0):="0000000111110100";
        variable temp:std_logic_vector(15 downto 0);
        variable ans:std_logic_vector(15 downto 0);  
 
        begin
        temp:=div*sita;
        ans:=("000"&temp(15 downto 3))+add;
        return ans;
    end function;
    
function cal_0(x,y:in std_logic_vector) return std_logic_vector is
       --variable idle_x:std_logic_vector(7 downto 0):="10010110";--150
       --variable idle_y:std_logic_vector(7 downto 0):="01100100";--100
       variable div:std_logic_vector(4 downto 0):="10111";
       variable ans:std_logic_vector(7 downto 0);
       --variable idle_sita:std_logic_vector(7 downto 0):="01010001";
    variable a:std_logic_vector(13 downto 0);
  
 begin
  if(x>=idle_x)then
  a:=(x-idle_x)*div;
  ans:=idle_sita_0-(a(13 downto 6));
  else
  a:=(idle_x-x)*div;
  ans:=idle_sita_0+(a(13 downto 6));
  end if;
       return ans;
   end function;
function cal_1(x,y:in std_logic_vector) return std_logic_vector is
       --variable idle_x:std_logic_vector(7 downto 0):="10010110";
       --variable idle_y:std_logic_vector(7 downto 0):="01100100";
       variable div:std_logic_vector(7 downto 0):="10000101";
       variable ans:std_logic_vector(7 downto 0);
       --variable idle_sita:std_logic_vector(7 downto 0):="00111111";
  variable a:std_logic_vector(16 downto 0); 
 begin
  if(x>=idle_x)then
  a:=(x-idle_x)*div;
  ans:=(a(16 downto 9))+idle_sita_1;
  else
  a:=(idle_x-x)*div;
  ans:=idle_sita_1-(a(16 downto 9));
  end if;      
       return ans;
   end function;
function cal_2(x,y:in std_logic_vector) return std_logic_vector is
       --variable idle_x:std_logic_vector(7 downto 0):="10010110";
       --variable idle_y:std_logic_vector(7 downto 0):="01100100";
       variable div:std_logic_vector(3 downto 0):="1001";
       variable ans:std_logic_vector(7 downto 0);
       --variable idle_sita:std_logic_vector(7 downto 0):="10001100";
  variable a:std_logic_vector(12 downto 0);
  
 begin
  if(y>=idle_y)then
  a:=(y-idle_y)*div;
  ans:=("0"&a(12 downto 6))+idle_sita_2;
  else
  a:=(idle_y-y)*div;
  ans:=idle_sita_2-("0"&a(12 downto 6));  
  end if;
  return ans;
  end function;
  
  
function adjust(y :in std_logic_vector) return std_logic_vector is  
       --variable idle_y:std_logic_vector(7 downto 0):="01100100";
       variable div:std_logic_vector(5 downto 0):="101001";
       variable ans:std_logic_vector(7 downto 0);
  variable a:std_logic_vector(14 downto 0);
  
 begin
  if(y>=idle_y)then
  a:=(y-idle_y)*div;
  ans:=("000"&a(14 downto 10));
  else
  a:=(idle_y-y)*div;
  ans:="000"&a(14 downto 10);  
  end if;
  return ans;
  end function;
end action;

architecture behave of action is
    component baud is
        Port(
            clk : in std_logic;
            resetb : in std_logic;
            bclk   : out std_logic
        );
    end component;

    component transfer is
        Port(
    		bclkt				: in std_logic;
    		resett				: in std_logic;
    		xmit_cmd_p			: in std_logic;
    		buf0				: in std_logic_vector(7 downto 0);
            buf1				: in std_logic_vector(7 downto 0);
            buf2				: in std_logic_vector(7 downto 0);
            buf3				: in std_logic_vector(7 downto 0);
            buf4				: in std_logic_vector(7 downto 0);
    		txd					: out std_logic;
    		txd_done			: out std_logic
    	);
    end component;

    type states is (s_idle, s_reset, s_cal, s_tran, s_wait, s_end);
    signal state        : states := s_idle;

    signal bclk         : std_logic;
    signal buf0         : std_logic_vector(7 downto 0);
    signal buf1         : std_logic_vector(7 downto 0);
    signal buf2         : std_logic_vector(7 downto 0);
    signal buf3         : std_logic_vector(7 downto 0);
    signal buf4         : std_logic_vector(7 downto 0);
    signal cmd          : std_logic := '0';
    signal txd_done     : std_logic;

	signal isreset		: std_logic := '0';

begin
    bd : baud
    port map(
        clk     => clk,
        resetb  => reset,
        bclk    => bclk
    );

    tran : transfer port map(
        bclkt       => bclk,
        resett      => reset,
        xmit_cmd_p  => cmd,
        buf0        => buf0,
        buf1        => buf1,
        buf2        => buf2,
        buf3        => buf3,
        buf4        => buf4,
        txd         => txd,
        txd_done    => txd_done
    );

    process(clk, reset, act)
        variable cnt        : integer := 0;
        variable wait_time  : integer := 0;
        variable action_num : integer := 1;
    begin
        if reset = '0' then
            isreset <= '1';
            state <= s_idle;
            cnt := 0;
            finished <= '0';
        elsif rising_edge(clk) then
            case state is
                when s_idle =>
                    cnt := 0;
                    finished <= '0';
                    if isreset = '1' then
						state <= s_reset;
                    elsif act = '1' then state <= s_cal;
                    else state <= s_idle; end if;
                when s_reset =>
                    --reeset...
                    action_num := 5;    
                    if cnt = 0 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000101";
                        buf3 <= "00001000";
                        buf4 <= "00001000";
                    elsif cnt = 1 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000100";
                        buf3 <= "01101101";
                        buf4 <= "00000101";
                    elsif cnt = 2 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000011";
                        buf3 <= "11011100";
                        buf4 <= "00000101";
                    elsif cnt = 3 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= "11101000";
                        buf4 <= "00000011";
                    elsif cnt = 4 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000001";
                        buf3 <= "10110000";
                        buf4 <= "00000100";
                    end if;
                    cmd <= '1';
                    if txd_done = '0' then
                        cmd <= '0';
                        state <= s_tran;
                    end if;
                when s_cal =>
					action_num := 15;
                    --calculating...
                    if cnt = 0 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000101";
                        buf3 <= arm5_l;
                        buf4 <= arm5_h;
                    elsif cnt = 1 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000100";
                        buf3 <= arm4_l;
                        buf4 <= arm4_h;
                    elsif cnt = 2 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000011";
                        buf3 <= arm3_l;
                        buf4 <= arm3_h;
                    elsif cnt = 3 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= arm2_l;
                        buf4 <= arm2_h;
                    elsif cnt = 4 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000001";
                        buf3 <= arm1_l;
                        buf4 <= arm1_h;    
                    elsif cnt = 5 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000101";
                        buf3 <= degree_to_arm(cal_2(x,y))(7 downto 0);
                        buf4 <= degree_to_arm(cal_2(x,y))(15 downto 8);                  
                        
                    elsif cnt = 6 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000011";
                        buf3 <= degree_to_arm(cal_1(x,y)-adjust(y))(7 downto 0);
                        buf4 <= degree_to_arm(cal_1(x,y)-adjust(y))(15 downto 8);
                    elsif cnt = 7 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= degree_to_arm(cal_0(x,y)+adjust(y))(7 downto 0);
                        buf4 <= degree_to_arm(cal_0(x,y)+adjust(y))(15 downto 8);
                    elsif cnt = 8 then    --click
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= arm2_l_click;
                        buf4 <= arm2_h_click;
                    elsif cnt = 9 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= arm2_l;
                        buf4 <= arm2_h;
                    
                    elsif cnt = 10 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000101";
                        buf3 <= arm5_l;
                        buf4 <= arm5_h;
                    elsif cnt = 11 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000100";
                        buf3 <= arm4_l;
                        buf4 <= arm4_h;
                    elsif cnt = 12 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000011";
                        buf3 <= arm3_l;
                        buf4 <= arm3_h;
                    elsif cnt = 13 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000010";
                        buf3 <= arm2_l;
                        buf4 <= arm2_h;
                    elsif cnt = 14 then
                        buf0 <= "11111111";
                        buf1 <= "00000010";
                        buf2 <= "00000001";
                        buf3 <= arm1_l;
                        buf4 <= arm1_h;
                    end if;
                    cmd <= '1';
                    if txd_done = '0' then
                        cmd <= '0';
                        state <= s_tran;
                    end if;
                when s_tran =>
                    if txd_done = '1' then
                        cnt := cnt + 1;
                        state <= s_wait;
                    end if;
                when s_wait =>
                    wait_time := wait_time + 1;
                    if wait_time >= 200000000 then
                        wait_time := 0;
                        if cnt < action_num then
							if isreset = '1' then
								state <= s_reset;
							else
								state <= s_cal;
							end if;
                        else state <= s_end; finished <= '1'; end if;
                    end if;
                when s_end =>
					if isreset = '1' then isreset <= '0'; state <= s_idle; end if;
                    if act = '0' then state <= s_idle; end if;
                when others =>
                    state <= s_idle;
            end case;
        end if;
    end process;
end behave;
