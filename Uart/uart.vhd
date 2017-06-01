-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 222 10/21/2009 SJ Full Version"
-- CREATED		"Tue May 30 19:36:38 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		rxd :  IN  STD_LOGIC;
		xmit_cmd_p_in :  IN  STD_LOGIC;
		txdbuf_in :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_ready :  OUT  STD_LOGIC;
		txd_ou :  OUT  STD_LOGIC;
		txd_done_out :  OUT  STD_LOGIC;
		rec_buf :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END uart;

ARCHITECTURE bdf_type OF uart IS 

COMPONENT baud
	PORT(clk : IN STD_LOGIC;
		 resetb : IN STD_LOGIC;
		 bclk : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT reciever
GENERIC (framlenr : INTEGER
			);
	PORT(bclkr : IN STD_LOGIC;
		 resetr : IN STD_LOGIC;
		 rxdr : IN STD_LOGIC;
		 r_ready : OUT STD_LOGIC;
		 rbuf : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT transfer
GENERIC (framlent : INTEGER
			);
	PORT(bclkt : IN STD_LOGIC;
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
PORT MAP(clk => clk,
		 resetb => reset,
		 bclk => SYNTHESIZED_WIRE_2);


b2v_inst1 : reciever
GENERIC MAP(framlenr => 8
			)
PORT MAP(bclkr => SYNTHESIZED_WIRE_2,
		 resetr => reset,
		 rxdr => rxd,
		 r_ready => rec_ready,
		 rbuf => rec_buf);


b2v_inst2 : transfer
GENERIC MAP(framlent => 8
			)
PORT MAP(bclkt => SYNTHESIZED_WIRE_2,
		 resett => reset,
		 xmit_cmd_p => xmit_cmd_p_in,
		 txdbuf => txdbuf_in,
		 txd => txd_ou,
		 txd_done => txd_done_out);


END bdf_type;