library ieee;
use ieee.std_logic_1164.all;

entity action is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        x           : in std_logic_vector(7 downto 0);
        y           : in std_logic_vector(7 downto 0);
        act         : in std_logic; --使能
        txd         : out std_logic;
        --cmd         : in std_logic;
        finished    : out std_logic
    );
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

    type states is (s_idle, s_cal, s_tran, s_wait, s_end);
    signal state        : states := s_idle;

    signal bclk         : std_logic;
    signal buf0         : std_logic_vector(7 downto 0);
    signal buf1         : std_logic_vector(7 downto 0);
    signal buf2         : std_logic_vector(7 downto 0);
    signal buf3         : std_logic_vector(7 downto 0);
    signal buf4         : std_logic_vector(7 downto 0);
    signal cmd          : std_logic := '0';
    signal txd_done     : std_logic;


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
        variable action_num : integer := 3;
    begin
        if reset = '0' then
            state <= s_idle;
            cnt := 0;
            finished <= '0';
        elsif rising_edge(clk) then
            case state is
                when s_idle =>
                    cnt := 0;
                    finished <= '0';
                    if act = '0' then state <= s_cal;
                    else state <= s_idle; end if;
                when s_cal =>
                    --calculating...
                    if cnt = 0 then
                        buf0 <= "11110000";
                        buf1 <= "11110001";
                        buf2 <= "11110010";
                        buf3 <= "11110011";
                        buf4 <= "11110100";
                    elsif cnt = 1 then
                        buf0 <= "00000000";
                        buf1 <= "00000001";
                        buf2 <= "00000010";
                        buf3 <= "00000011";
                        buf4 <= "00000100";
                    elsif cnt = 2 then
                        buf0 <= "10100000";
                        buf1 <= "10100001";
                        buf2 <= "10100010";
                        buf3 <= "10100011";
                        buf4 <= "10100100";
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
                    if wait_time >= 100000000 then
                        wait_time := 0;
                        if cnt < action_num then state <= s_cal;
                        else state <= s_end; finished <= '1'; end if;
                    end if;
                when s_end =>
                    if cmd = '0' then state <= s_idle; end if;
                when others =>
                    state <= s_idle;
            end case;
        end if;
    end process;
end behave;
