LIBRARY 	ieee;
USE 		ieee.std_logic_1164.all;
USE 		ieee.std_logic_arith.all;

entity draw_aliens is
	port(
		Hsync, Vsync, Hactive, Vactive, dena, clk_vga: in std_logic;
		aliens_vivos : in std_logic_vector(53 downto 0);
		aliens_color : in std_logic_vector(17 downto 0);
		R, G, B : OUT 	std_logic_vector(3 DOWNTO 0));
end draw_aliens;

architecture aliens_behavior of draw_aliens is
	begin
	PROCESS( Hsync, clk_vga, Vactive, Hactive, dena )
		VARIABLE v_line_count:	natural RANGE 0 TO 480;
		VARIABLE h_line_count:	natural RANGE 0 TO 640;

	BEGIN
	
		IF rising_edge( Hsync ) THEN
			IF Vactive = '1' THEN
				v_line_count := v_line_count + 1;
			ELSE
				v_line_count := 0;
			END IF;
		END IF;
		IF rising_edge( clk_vga ) THEN 
			h_line_count := h_line_count + 1;
			IF(Hactive = '0') then
				h_line_count := 0;
			END IF;
		END IF;
		
		IF dena = '1' THEN
--			case numero_linea is
--				when "100000" =>
					if(v_line_count > 0 and v_line_count < 65) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(53) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(52) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(51) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(50) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(49) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(48) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(47) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(46) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(45) = '1') then
							R <= ( OTHERS => aliens_color(17) );
							G <= ( OTHERS => aliens_color(18) );
							B <= ( OTHERS => aliens_color(16) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 65 and v_line_count < 69) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when "010000" =>
					if(v_line_count > 69 and v_line_count < 134) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(44) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(43) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(42) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(41) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(40) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(39) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(38) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(37) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(36) = '1') then
							R <= ( OTHERS => aliens_color(15) );
							G <= ( OTHERS => aliens_color(14) );
							B <= ( OTHERS => aliens_color(13) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 134 and v_line_count < 138) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when "001000" =>
					if(v_line_count > 138 and v_line_count < 203) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(35) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(34) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(33) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(32) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(31) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(30) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(29) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(28) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(27) = '1') then
							R <= ( OTHERS => aliens_color(12) );
							G <= ( OTHERS => aliens_color(11) );
							B <= ( OTHERS => aliens_color(10) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 203 and v_line_count < 207) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when "000100" =>
					if(v_line_count > 207 and v_line_count < 272) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(26) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(25) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(24) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(23) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(22) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(21) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(20) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(19) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(18) = '1') then
							R <= ( OTHERS => aliens_color(9) );
							G <= ( OTHERS => aliens_color(8) );
							B <= ( OTHERS => aliens_color(7) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 272 and v_line_count < 276) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when "000010" =>
					if(v_line_count > 276	and v_line_count < 341) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(17) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(16) = '1') then
							R <= ( OTHERS => aliens_color(6) ); 
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(15) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(14) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(13) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(12) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(11) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(10) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(9) = '1') then
							R <= ( OTHERS => aliens_color(6) );
							G <= ( OTHERS => aliens_color(5) );
							B <= ( OTHERS => aliens_color(4) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 341 and v_line_count < 345) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when "000001" =>
					if(v_line_count > 345 and v_line_count < 410) then
						if(h_line_count > 7 and h_line_count < 73 and aliens_vivos(8) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 77 and h_line_count < 143 and aliens_vivos(7) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 147 and h_line_count < 213 and aliens_vivos(6) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );	
						elsif(h_line_count > 217 and h_line_count < 283 and aliens_vivos(5) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 287 and h_line_count < 353 and aliens_vivos(4) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 357 and h_line_count < 423 and aliens_vivos(3) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 427 and h_line_count < 493 and aliens_vivos(2) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 497 and h_line_count < 563 and aliens_vivos(1) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						elsif(h_line_count > 567 and h_line_count < 633 and aliens_vivos(0) = '1') then
							R <= ( OTHERS => aliens_color(3) );
							G <= ( OTHERS => aliens_color(2) );
							B <= ( OTHERS => aliens_color(1) );
						else
							R <= ( OTHERS => '0');
							G <= ( OTHERS => '0');
							B <= ( OTHERS => '0');
						end if;
					end if;
					if(v_line_count > 410 and v_line_count < 414) then
						R <= ( OTHERS => '0');
						G <= ( OTHERS => '0');
						B <= ( OTHERS => '0');
					end if;
--				when others =>
--					R <= ( OTHERS => '0');
--					G <= ( OTHERS => '0');
--					B <= ( OTHERS => '0');
--			end case;
		END IF;
	END PROCESS;	
end aliens_behavior;