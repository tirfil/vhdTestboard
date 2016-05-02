--###############################
--# Project Name : TESTBOARD
--# file : debouncer.vhd
--# Author : Philippe THIRION
--# Description : key debouncer + press long ; active = logic 0
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;


entity DEBOUNCER is
        port(
                MCLK            : in    std_logic;
                RSTN            : in    std_logic;
                SEL             : in    std_logic; -- 100 ms pulse
                KEYN            : in    std_logic;
                PUSH            : out   std_logic;
                RELEASE         : out   std_logic;
                WINDOW          : out   std_logic;
                LONG            : out   std_logic
        );
end DEBOUNCER;

architecture rtl of DEBOUNCER is

	signal FF_RSY0, FF_RSY : std_logic;
	signal DELAY0, DELAY1, DELAY2 : std_logic;
	signal ALLONE, ALLZERO : std_logic;
	signal ALLONE_RSY, ALLZERO_RSY : std_logic;
	signal COUNTER : integer range 0 to 63;
	signal WINDOW_I : std_logic;
	
begin

	RSY: process(MCLK,RSTN)
	begin
		if (RSTN = '0') then
			FF_RSY0 <= '1'; -- inactive
			FF_RSY <= '1';
		elsif (MCLK'event and MCLK = '1') then
			FF_RSY0 <= KEYN;
			FF_RSY <= FF_RSY0;
		end if;
	end process RSY;
	
	DLY: process(MCLK, RSTN)
	begin
		if (RSTN = '0') then
			DELAY0 <= '1'; -- inactive
			DELAY1 <= '1';
			DELAY2 <= '1';
		elsif (MCLK'event and MCLK = '1') then
			if (SEL = '1') then
				DELAY0 <= FF_RSY;
				DELAY1 <= DELAY0;
				DELAY2 <= DELAY1;
			end if;
		end if;
	end process DLY;
	
	ALLONE <= DELAY0 and DELAY1 and DELAY2;
	ALLZERO <= not(DELAY0) and not(DELAY1) and not(DELAY2);
	
	PULSES: process(MCLK, RSTN)
	begin
		if (RSTN = '0') then
			ALLONE_RSY <= '1';
			ALLZERO_RSY <= '0';
			PUSH <= '0';
			RELEASE <= '0';
			WINDOW_I <= '0';
			LONG <= '0';
			COUNTER <= 0;
		elsif (MCLK'event and MCLK = '1') then
			if (SEL = '1') then
				ALLONE_RSY <= ALLONE;
				ALLZERO_RSY <= ALLZERO;
				-- press key
				if (ALLZERO_RSY = '0' and ALLZERO = '1') then
					PUSH <= '1';
					WINDOW_I <= '1';
				else
					PUSH <= '0';
				end if;
				-- release key
				if (ALLONE_RSY = '0' and ALLONE = '1') then
					RELEASE <= '1';
					WINDOW_I <= '0';
				else
					RELEASE <= '0';
				end if;
				-- press long (1.5 sec)
				if (WINDOW_I = '1') then
					if (COUNTER = 63) then
						LONG <= '1';
					else
						COUNTER <= COUNTER + 1;
					end if;
				else
					LONG <= '0';
					COUNTER <= 0;
				end if;
			end if;
		end if;
	end process PULSES;
	
	WINDOW <= WINDOW_I;
	
end rtl;				
