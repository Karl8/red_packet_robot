LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

entity sram is 
port(
	data_in		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	rdaddress		: IN STD_LOGIC_VECTOR (19 DOWNTO 0);
	rdclock		: IN STD_LOGIC ;
	wraddress		: IN STD_LOGIC_VECTOR (19 DOWNTO 0);
	wrclock		: IN STD_LOGIC ;
	wren		: IN STD_LOGIC ;
	data_out: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	----
	BASERAMWE           : out std_logic;   --write                    
	BASERAMOE           : out std_logic;    --read                   
	BASERAMCE           : out std_logic;		--cs
	BASERAMADDR         : out std_logic_vector(19 downto 0);                                                              
	BASERAMDATA         : inout std_logic_vector(31 downto 0)
);
end sram;

architecture logic_memy of sram is
begin         
	process(wrclock, rdclock)
	begin 
		if rising_edge(rdclock) then
			BASERAMCE<='0';                                 
			BASERAMOE<='0';  
			BASERAMWE<='1';
			BASERAMADDR<=rdaddress;                                                                    
			--data_out<=BASERAMDATA;
		elsif rising_edge(wrclock) then
			if (wren = '1') then
				BASERAMCE<='0';                                 
				BASERAMOE<='1';  
				BASERAMWE<='0';
				BASERAMADDR<=wraddress;--addr_in;                                                                    
				--BASERAMDATA<=data_in;--date_in;			
			end if;
		end if;
	end process;
	process(rdclock)
	begin 
		if rising_edge(rdclock) then
			data_out<=BASERAMDATA;
		end if;
	end process;
	process(wrclock)
	begin 
		if rising_edge(wrclock) then
			if (wren = '1') then
				BASERAMDATA<=data_in;--date_in;			
			end if;
		end if;
	end process;
end architecture;