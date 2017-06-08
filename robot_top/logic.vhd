library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logic is
    port(
        clk             : in std_logic;
        reset           : in std_logic;
        cam_finished    : in std_logic;
        act_finished    : in std_logic;
        btn             : in std_logic;
        mode            : out std_logic_vector(1 downto 0);
        act             : out std_logic := '0';
        m_cnt			: out std_logic_vector(1 downto 0)
    );
end entity logic;

architecture behav of logic is
    type states is (s_idle, s_cam, s_act);
    signal state        : states := s_idle;

begin
	process(clk, reset)
        variable mode_cnt   : std_logic_vector(1 downto 0) := "00";
    begin
		m_cnt <= mode_cnt;
        if reset = '0' then
            state <= s_idle;
            mode <= "00";
            mode_cnt := "00";
        elsif rising_edge(clk) then
            case state is
                when s_idle =>
                    mode <= "00";
                    mode_cnt := "00";
                    if btn = '0' then state <= s_cam; mode_cnt := "01"; 
                    else state <= s_idle; end if;
                when s_cam =>
                    mode <= mode_cnt;
                    if cam_finished = '1' then state <= s_act; end if;
                when s_act =>
					mode <= "00";
                    act <= '1';
                    if act_finished = '1' then
                        act <= '0';
                        if mode_cnt = "10" then
                            state <= s_idle;
                        else state <= s_cam; mode_cnt := std_logic_vector(unsigned(mode_cnt) + 1); end if;
                    end if;
                when others =>
                    state <= s_idle;
            end case;
        end if;
    end process;
end architecture behav;
