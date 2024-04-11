LIBRARY ieee;
USE ieee.std_logic_1164.all, IEEE.std_logic_arith.all, IEEE.std_logic_unsigned.all;		

ENTITY decoder IS
	PORT(
		DATA_IN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END decoder;

ARCHITECTURE behavior_decoder of decoder IS
COMPONENT hex_to_7seg IS
	PORT(
		data: IN STD_LOGIC_VECTOR(7 downto 0);
		seg: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
END COMPONENT;

SIGNAL num			:	integer;
SIGNAL decenas		: 	integer;
SIGNAL unidades	: 	integer;


SIGNAL decenas_byte		: 	std_logic_vector(7 downto 0);
SIGNAL unidades_byte		: 	std_logic_vector(7 downto 0);
BEGIN
	
	num <= conv_integer(unsigned(DATA_IN));
	
	decenas <= num/10;
	unidades <= num rem 10;
	decenas_byte <= conv_std_logic_vector(decenas,decenas_byte'length);
	unidades_byte <= conv_std_logic_vector(unidades,unidades_byte'length);
	
	uni: hex_to_7seg PORT MAP(
		unidades_byte, HEX0);
	
	dec:	hex_to_7seg PORT MAP(
		decenas_byte, HEX1);
	
END behavior_decoder;