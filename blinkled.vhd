--###############################
--# Project Name : TESTBOARD
--# file : blinkled.vhd
--# Author : Philippe THIRION
--# Description : blinking led sequence
--# Modification History
--###############################

-- ******************************************************************************
--
-- LEDM: led manager
-- 
-- SEL pulse must be 250 ns wide
-- DATA contains the number of blinking
-- except for 0   : led is always off
-- except for 0xf : led is always on
-- blinking sequences are spaced with led off during 4 SEL pulses.
-- 


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity BLINKLED is
	port(
		MCLK		: in	std_logic;
		RSTN		: in	std_logic;
		SEL		: in	std_logic;
		DATA		: in	std_logic_vector(3 downto 0);
		LED		: out	std_logic;
		LEDN		: out	std_logic
	);
end BLINKLED;

architecture rtl of BLINKLED is
	signal LED_I : std_logic;
	signal STATE : std_logic_vector(2 downto 0);
	signal COUNTER : std_logic_vector(3 downto 0);
begin
	OTO: process(MCLK,RSTN)
	begin
		if (RSTN = '0')	then
			STATE <= "000";
			LED_I <= '0';
			COUNTER <= "0000"; -- always off
		elsif (MCLK'event and MCLK='1') then
			if (SEL = '1') then
				if ( COUNTER = "1111") then -- always on
					LED_I <= '1';
					COUNTER <= DATA;
					STATE <= "000";
				else
					if (STATE = "000") then --- "000" to "011" always off
						LED_I <= '0';
						COUNTER <= DATA;
						STATE <= "001";
					elsif (STATE = "001") then
						LED_I <= '0';
						STATE <= "010";
					elsif (STATE = "010") then
						LED_I <= '0';
						STATE <= "011";
					elsif (STATE = "011") then
						if (COUNTER = "0000") then
							LED_I <= '0';	
							STATE <= "000";
						else				--- blinking sequence
							LED_I <= '1';
							STATE <= "100";
							COUNTER <= (COUNTER - 1);
						end if;
					elsif (STATE = "100") then
						LED_I <= '0';
						STATE <= "011";
					else
						LED_I <= '0';
						STATE <= "000";
					end if;
				end if;
			end if;
		end if;
	end process OTO;
		
			
	LED <= LED_I;
	LEDN <= not(LED_I);

end rtl;
