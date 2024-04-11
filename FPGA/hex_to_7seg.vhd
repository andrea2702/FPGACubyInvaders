LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY hex_to_7seg IS
	PORT(data: IN STD_LOGIC_VECTOR(7 downto 0);
			seg: OUT STD_LOGIC_VECTOR(7 downto 0)
			);
END hex_to_7seg;

ARCHITECTURE behaviour of hex_to_7seg IS
BEGIN
	PROCESS (data)
	BEGIN
		case data is
			when "00000000" => seg <= "11000000"; -- 0
			when "00000001" => seg <= "11111001"; -- 1
			when "00000010" => seg <= "10100100"; -- 2
			when "00000011" => seg <= "10110000"; -- 3
			when "00000100" => seg <= "10011001"; -- 4
			when "00000101" => seg <= "10010010"; -- 5
			when "00000110" => seg <= "10000010"; -- 6
			when "00000111" => seg <= "11111000"; -- 7
			when "00001000" => seg <= "10000000"; -- 8
			when "00001001" => seg <= "10011000"; -- 9
			when "00001010" => seg <= "10001000"; -- A
			when "00001011" => seg <= "10000011"; -- B
			when "00001100" => seg <= "11000110"; -- C
			when "00001101" => seg <= "10100001"; -- D
			when "00001110" => seg <= "10000110"; -- E
			when "00001111" => seg <= "10001110"; -- F
			when others => seg <= "10110000";
		end case;
	END PROCESS;
END behaviour;