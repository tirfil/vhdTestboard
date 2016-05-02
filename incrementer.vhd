--###############################
--# Project Name : TESTBOARD
--# file : incrementer.vhd
--# Author : Philippe THIRION
--# Description : 4 bit counter
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity INCREMENTER is
	port(
		MCLK		: in	std_logic;
		RSTN		: in	std_logic;
		SEL		    : in	std_logic;
		DATA		: out	std_logic_vector(3 downto 0);
		LONG		: in	std_logic;
		RELEASE		: in	std_logic
	);
end INCREMENTER;

architecture rtl of INCREMENTER is
	signal COUNTER : std_logic_vector(3 downto 0);
begin
	
	DATA <= COUNTER;
	
	CNT: process( MCLK, RSTN)
	begin
		if (RSTN = '0') then
			COUNTER <= "0000";
		elsif (MCLK'event and MCLK='1') then
			if (SEL = '1') then
				if (RELEASE = '1') then
					if (LONG = '1') then
						COUNTER <= "0000";
					else
						COUNTER <= COUNTER + 1;
					end if;
				end if;
			end if;
		end if;
	end process CNT;
end rtl;
	