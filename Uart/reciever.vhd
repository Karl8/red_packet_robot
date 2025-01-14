library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity reciever is
generic(framlenr:integer:=8);	         
Port(
	bclkr,resetr,rxdr:in std_logic;                       --定义输入输出信号
	r_ready:out std_logic;
	rbuf:out std_logic_vector(7 downto 0)
	);
end reciever;
architecture behave of reciever is
type states is (r_start,r_center,r_wait,r_sample,r_stop);            --定义各子状态
signal state:states:=r_start;
signal rxd_sync:std_logic;
	begin
	pro1:process(rxdr)
	begin
		if rxdr='0' then 
			rxd_sync<='0';
		else 
			rxd_sync<='1';
		end if;
end process;

	pro2:process(bclkr,resetr,rxd_sync)                            --主控时序、组合进程
	variable count:std_logic_vector(3 downto 0);                    --定义中间变量
	variable rcnt:integer:=0;
	variable rbufs:std_logic_vector(7 downto 0);
	begin
		if resetr='0' then 
			state <= r_start; 
			count := "0000";                --复位
		elsif rising_edge(bclkr) then
			case state is
				when r_start =>	--状态1，等待起始位
					if rxd_sync='0' then 
						state <= r_center; 
						r_ready <= '0'; 
						rcnt := 0;
					else 
						state <= r_start; 
						r_ready <= '0';
					end if;                              
				when r_center =>	--状态2，求出每位的中点
					if rxd_sync='0' then
						if count="0100" then 
							state <= r_wait; 
							count := "0000";
						else 
							count := count+1; 
							state <= r_center;
						end if;
					else 
						state <= r_start;
					end if;                            
				when r_wait => 	--状态3，等待状态
					if count >= "1110" then
						if rcnt=framlenr then 
							state <= r_stop;
						else 
							state <= r_sample;
						end if;
						count := "0000";                    
					else 
						count := count+1; 
						state <= r_wait;
					end if;
				when r_sample =>
					rbufs(rcnt) := rxd_sync; 
					rcnt := rcnt+1;
					state <= r_wait;	--状态4，数据位采样检测
				when r_stop =>
					r_ready <= '1'; 
					rbuf <= rbufs; 
					state <= r_start; --状态4，输出帧接收完毕信号
				when others =>
					state <= r_start;
			end case;
		end if;
	end process;
end behave;
