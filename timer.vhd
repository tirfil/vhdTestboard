--###############################
--# Project Name : TESTBOARD
--# file : timer.vhd
--# Author : Philippe THIRION
--# Description : generate every 30 ms and 250 ms pulse from 50 Mhz
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity TIMER is
	port(
		MCLK			: in	std_logic; -- 50 MHz
		RSTN			: in	std_logic;
		SEL30MS		    	: out	std_logic; -- 30 ms
		SEL250MS		: out	std_logic  -- 250 ms
	);
end TIMER;


architecture rtl of TIMER is
	signal COUNTER: std_logic_vector(21 downto 0);
	signal SEL_I : std_logic; -- 30 ms
	signal CNT8	: std_logic_vector(2 downto 0);
	signal C30  : std_logic;
	
begin

	C30 <= COUNTER(19) and COUNTER(20);


	MASTER: process(MCLK,RSTN)
	begin
		if (RSTN = '0') then
			COUNTER <= (others=>'0');
			SEL_I <= '0';
		elsif (MCLK'event and MCLK='1') then
			if (C30 = '1') then 
				COUNTER <= (others=>'0');
				SEL_I <= '1';
			else
				COUNTER <= COUNTER + 1;
				SEL_I <= '0';
			end if;
		end if;
	end process MASTER;

	SEL30MS <= SEL_I;
	
	C8: process(MCLK, RSTN)
	begin
		if (RSTN = '0') then
			CNT8 <= "000";
			SEL250MS <= '0';
		elsif (MCLK'event and MCLK='1') then
			if (SEL_I = '1') then
				if (CNT8 = "111") then
					CNT8 <= "000";
					SEL250MS <= '1';
				else
					CNT8 <= CNT8 + 1;
					SEL250MS <= '0';
				end if;
			else
				SEL250MS <= '0';
			end if;
		end if;
	end process C8;
	
end rtl;

-- 
-- 20 ns
-- period			half
-- 0  =  40 ns;			20 ns
-- 8  =  10.240 us;		5.120 us
-- 16 =   2.621440 ms;		1.31072 ms;
-- 19 =  20.971520 ms;		10,48576 ms;
-- 20 =  41.943040 ms;		20.971520 ms;
-- 21 =  83.886080 ms;		41.943040 ms;
-- 22 = 167.772160 ms;
-- 24 = 671.088640 ms;
	
	
