--###############################
--# Project Name : TESTBOARD
--# file : testboard.vhd
--# Author : Philippe THIRION
--# Description : 1 push button + 1 led + reset (or other push button)
--# Modification History
--###############################


library IEEE;
use IEEE.std_logic_1164.all;

entity TESTBOARD is
	port(
		MCLK		: in	std_logic;
		RSTN		: in	std_logic;
		KEYN		: in	std_logic;
		LED0		: out	std_logic
	);
end TESTBOARD;

architecture struct of TESTBOARD is

	component TIMER
		port(
			MCLK			: in	std_logic;
			RSTN			: in	std_logic;
			SEL30MS		: out	std_logic;
			SEL250MS		: out	std_logic
		);
	end component;
	
	component INCREMENTER
		port(
			MCLK		: in	std_logic;
			RSTN		: in	std_logic;
			SEL			: in	std_logic;
			DATA		: out	std_logic_vector(3 downto 0);
			LONG		: in	std_logic;
			RELEASE		: in	std_logic
		);
	end component;

	component DEBOUNCER
		port(
			MCLK		: in	std_logic;
			RSTN		: in	std_logic;
			SEL			: in	std_logic;
			KEYN		: in	std_logic;
			PUSH		: out	std_logic;
			RELEASE		: out	std_logic;
			WINDOW		: out	std_logic;
			LONG		: out	std_logic
		);
	end component;

	component BLINKLED
		port(
			MCLK		: in	std_logic;
			RSTN		: in	std_logic;
			SEL			: in	std_logic;
			DATA		: in	std_logic_vector(3 downto 0);
			LED			: out	std_logic;
			LEDN		: out	std_logic
		);
	end component;

	signal DATA		: std_logic_vector(3 downto 0);
	signal LED			: std_logic;
	signal PUSH			: std_logic;
	signal RELEASE		: std_logic;
	signal LONG			: std_logic;
	signal WINDOW		: std_logic;
	signal SEL30MS		: std_logic;
	signal SEL250MS		: std_logic;	

	signal xilinx_reset : std_logic;
	signal xilinx_key   : std_logic;

	begin
	
	xilinx_reset <= not RSTN;
	xilinx_key <= not KEYN;

	I_TIMER : TIMER
		port map (
			MCLK		=> MCLK,
			RSTN		=> xilinx_reset,
			SEL30MS	=> SEL30MS,
			SEL250MS	=> SEL250MS
		);
		
	I_INC : INCREMENTER
		port map (
			MCLK		=> MCLK,
			RSTN		=> xilinx_reset,
			SEL			=> SEL30MS,
			DATA		=> DATA,
			LONG		=> LONG,
			RELEASE		=> RELEASE
		);	

	I_KEYM : DEBOUNCER
		port map (
			MCLK		=> MCLK,
			RSTN		=> xilinx_reset,
			SEL			=> SEL30MS,
			KEYN		=> xilinx_key,
			PUSH		=> PUSH,
			RELEASE		=> RELEASE,
			WINDOW		=> WINDOW,
			LONG		=> LONG
		);

	I_LEDM : BLINKLED
	port map (
		MCLK		=> MCLK,
		RSTN		=> xilinx_reset,
		SEL			=> SEL250MS,
		DATA		=> DATA,
		LED			=> LED0,
		LEDN		=> LED
	);

end struct;
