library ieee;
use ieee.std_logic_1164.all;

entity display is
	port(
		clk : in std_logic;
		entrada : in std_logic_vector(4 downto 0);
		disp1 : out std_logic_vector (7 downto 0);
		disp2 : out std_logic_vector(7 downto 0)
		);
end display;

architecture behavior of display is
begin
	
end behavior;