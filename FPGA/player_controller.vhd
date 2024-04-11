LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity player_controller is
	PORT(
		clk			:	IN		std_logic;
		dataIn		:	IN		std_logic_vector(7 downto 0):=x"FF";
		LEDS			:	OUT	std_logic_vector(9 downto 0);
		btn_disparo	:	IN		std_logic;
		left_move	:	OUT	std_logic;  -- BIT PARA GUMNUT
		right_move	:	OUT	std_logic;  -- BIT PARA GUMNUT
		shoot_en		:	OUT 	std_logic);	-- BIT PARA GUMNUT
end player_controller;

architecture behavioral of player_controller is
	
	begin
	
		PROCESS (dataIn)
			variable data_sign : std_logic;
			variable data_acc : std_logic_vector(3 downto 0);
			
			BEGIN
			
			data_sign 	:= dataIn(4);
			data_acc 	:= dataIn(3 downto 0);
			
--			LEDS(9 downto 0) <= "000000" & dataIn(3 downto 0);

--			LEDS(7 downto 0) <= dataIn;
			if(data_acc > "0001" and data_acc < "0111") then -- DIRECCION A LA IZQUIERDA
				LEDS(9 downto 8) <= (others => '1'); -- LEDS IZQ = 1
				LEDS(1 downto 0) <= (others => '0'); -- LEDS DER = 0
				
				-- LEDS CENTRALES = 0
				LEDS(6) <= '0';
				LEDS(3) <= '0';
				-- DIRECTION=0 PARA MANDAR AL GUMNUT -> VGA.
				left_move <= '1';
				right_move <= '0';
			elsif (data_acc < "1110" and data_acc > "1000") then -- DIRECCION A LA DERECHA
				LEDS(9 downto 8) <= (others => '0'); -- LEDS IZQ = 0
				LEDS(1 downto 0) <= (others => '1'); -- LEDS DER = 1
				
				-- LEDS CENTRALES = 0 
				LEDS(6) <= '0';
				LEDS(3) <= '0';
				left_move <= '0';
				right_move <= '1';
			else
				LEDS(9 downto 8) <= (others => '0'); -- LEDS IZQ = 0
				LEDS(1 downto 0) <= (others => '0'); -- LEDS DER = 0
				-- LEDS CENTRALES = 1
				LEDS(6) <= '1';
				LEDS(3) <= '1';
				
				left_move <= '0';
				right_move <= '0';
			end if;
				
			
		END PROCESS;
--		
--		
		PROCESS (btn_disparo)
			variable shoot_var: std_logic := '0';
		BEGIN
			if(btn_disparo ='0') then  --btn esta siendo presionando
				LEDS(5 downto 4) <= (others => '1');
				shoot_var := '1'; -- manda la orden para disparar
			else -- btn no esta presionado
				LEDS(5 downto 4) <= (others => '0');
				shoot_var := '0'; -- no dispara
			end if;
			
			shoot_en <= shoot_var;
		END PROCESS;

end behavioral;