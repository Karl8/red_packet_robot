LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY uart IS
	PORT(
		clk 			:  IN  STD_LOGIC;
		reset 			:  IN  STD_LOGIC;
		cmd				: in std_logic;
		txdbuf_in 		:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		txd_ou 			:  OUT  STD_LOGIC;
		txd_done_out 	:  OUT  STD_LOGIC
	);
END uart;

ARCHITECTURE bdf_type OF uart IS

    COMPONENT baud
    	PORT(clk : IN STD_LOGIC;
    		 resetb : IN STD_LOGIC;
    		 bclk : OUT STD_LOGIC
    	);
    END COMPONENT;


    COMPONENT transfer
        GENERIC (
            framlent : INTEGER
    	);
    	PORT(
            bclkt : IN STD_LOGIC;
            resett : IN STD_LOGIC;
            xmit_cmd_p : IN STD_LOGIC;
            txdbuf : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            txd : OUT STD_LOGIC;
            txd_done : OUT STD_LOGIC
    	);
    END COMPONENT;

    SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
BEGIN
    b2v_inst : baud
    PORT MAP(
        clk => clk,
    	resetb => reset,
    	bclk => SYNTHESIZED_WIRE_2
    );

    b2v_inst2 : transfer
    GENERIC MAP(
        framlent => 8
    )
    PORT MAP(
        bclkt => SYNTHESIZED_WIRE_2,
    	resett => reset,
    	xmit_cmd_p => cmd,
    	txdbuf => txdbuf_in,
    	txd => txd_ou,
    	txd_done => txd_done_out
    );

END bdf_type;
