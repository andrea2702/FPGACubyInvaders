LIBRARY 	ieee;
USE 		ieee.std_logic_1164.all;
USE 		ieee.std_logic_arith.all;

ENTITY vga_interface IS
	GENERIC(
		H_LOW:	natural	:= 96; --Hpulse
		HBP: 		natural 	:= 48; --HBP
		H_HIGH:	natural 	:= 640; --Hactive
		HFP: 		natural  := 16; --HFP
		V_LOW: 	natural  := 2; --Vpulse
		VBP: 		natural	:= 33; --VBP
		V_HIGH: 	natural  := 480; --Vactive
		VFP: 		natural	:= 10 --VFP
	); 
	PORT(
		clk: 					INOUT 	std_logic; --50MHz in our board
		H_sync, V_sync: 	OUT	std_logic;
		BLANKn, SYNCn : 	OUT 	std_logic;
		R, G, B: 			OUT 	std_logic_vector(3 DOWNTO 0);
		aliens_killed : OUT std_logic_vector(7 downto 0);
		moveLeft, moveRight : IN std_logic;
		resetGame : IN std_logic;
		endGame : IN std_logic;
		shootKey : in std_logic;
		debug_led : BUFFER std_logic_vector(3 downto 0)
	);
END vga_interface;

ARCHITECTURE rtl OF vga_interface IS
	SIGNAL Hsync, Vsync, Hactive, Vactive, dena, clk_vga:	std_logic;
	
	type shape is record
		x,y : natural;
		x_size,y_size : integer;
		draw_shape : std_logic;
		r,g,b : std_logic;
		is_enemy : std_logic;
	end record shape;
	
	constant empty_shape : shape := (x => 0,
												y => 0,
												x_size => 0,
												y_size => 0,
												draw_shape => '0',
												r => '0',
												g => '0',
												b => '0',
												is_enemy => '0');
												
	constant player_default_shape : shape := (x => 500,
												y => 410,
												x_size => 40,
												y_size => 20,
												draw_shape => '1',
												r => '0',
												g => '1',
												b => '1',
												is_enemy => '0');
	constant player_sombrerito_shape : shape := (x => 510,
												y => 401,
												x_size => 20,
												y_size => 10,
												draw_shape => '1',
												r => '0',
												g => '1',
												b => '1',
												is_enemy => '0');
												
	constant bala_default_shape : shape := (x => 800,
												y => 800,
												x_size => 4,
												y_size => 10,
												draw_shape => '0',
												r => '0',
												g => '0',
												b => '1',
												is_enemy => '0');
												
	constant enemy_default_shape : shape := (x => 0,
												y => 0,
												x_size => 50,
												y_size => 50,
												draw_shape => '1',
												r => '1',
												g => '0',
												b => '0',
												is_enemy => '1');
												
	type shape_array_type is array(0 to 100) of shape;
	signal shape_array : shape_array_type := (others => empty_shape);
	signal draw_clk, GameOver, PlayerWin : std_logic;
	signal ready, reset, playing : std_logic := '0';
	type Status is (Start_st, Playing_st, GameOver_st, Winner_st, Delay_st);
	signal Game_st, nx_Game_st : Status;

	
BEGIN
-------------------------------------------------------
--Part 1: CONTROL GENERATOR
-------------------------------------------------------		
		--Static signals for DACs:
		BLANKn 	<= '1'; --no direct blanking
		SYNCn 	<= '0'; --no sync on green
		
		--Create pixel clock (50MHz->25MHz):
		PROCESS( clk )
		BEGIN
			IF rising_edge( clk ) THEN 
				clk_vga <= not clk_vga;
			END IF;
		END PROCESS;
	
		--Horizontal signals generation:
		PROCESS( clk_vga )
			VARIABLE Hcount:	natural RANGE 0 to H_LOW + HBP + H_HIGH + HFP;
		BEGIN
			IF rising_edge( clk_vga ) THEN 
				Hcount := Hcount + 1;
				IF Hcount = H_LOW THEN 
					Hsync 	<= '1';
				ELSIF Hcount = H_LOW + HBP THEN 
					Hactive 	<= '1';
				ELSIF Hcount = H_LOW + HBP + H_HIGH THEN 
					Hactive 	<= '0';
				ELSIF Hcount = H_LOW + HBP + H_HIGH + HFP THEN 
					Hsync 	<= '0'; 
					Hcount 	:=  0;
				END IF;
			END IF;
		END PROCESS;
		
		--Vertical signals generation:
		PROCESS( Hsync )
			VARIABLE Vcount:	natural RANGE 0 TO V_LOW + VBP + V_HIGH + VFP;
		BEGIN
			IF rising_edge( Hsync ) THEN 
				Vcount := Vcount + 1;
				IF Vcount = V_LOW THEN 
					Vsync 	<= '1';
				ELSIF Vcount = V_LOW + VBP THEN 
					Vactive 	<= '1';
				ELSIF Vcount = V_LOW + VBP + V_HIGH THEN 
					Vactive 	<= '0';
				ELSIF Vcount = V_LOW + VBP + V_HIGH + VFP THEN 
					Vsync 	<= '0'; 
					Vcount 	:=  0;
				END IF;
			END IF;
		END PROCESS;
	
		H_sync <= Hsync;
		V_sync <= Vsync;
	
		---Display enable generation:
		dena <= Hactive and Vactive;
		
	clock_div : process(clk_vga, dena)
		variable count : integer := 0;
	begin
		if(rising_edge(clk_vga)) then
			count := count + 1;
			if count > 100000 and dena = '0' then
				draw_clk <= not draw_clk;
				count := 0;
			end if;
		end if;
	end process;
	
	
-------------------------------------------------------
--Part 2: IMAGE GENERATOR
-------------------------------------------------------	
	--- Actualizar la posicion de los cuadrados que se dibujan en pantalla
	update_shapes : process(draw_clk, moveLeft, moveRight, shootKey, dena, shape_array)
		variable bala : shape;
		variable ready_var : std_logic := '0';
		variable player : shape;
		variable player_sombrerito : shape;
		variable enemy : shape;
		variable has_collision : std_logic := '0';
		variable aliens_killed_var : integer := 0;
		variable shape_array_var : shape_array_type := (others => empty_shape);
		variable avance : std_logic := '0';
		variable count : integer := 0;
		variable game_over : std_logic := '0';
		variable win : std_logic := '0';
	
	begin	
		if(rising_edge(draw_clk)) then
			
			ready_var := '0';
			
			if reset = '1' then
				shape_array_var(0) := player_default_shape;
				shape_array_var(1) := bala_default_shape;
				shape_array_var(2) := player_sombrerito_shape;
				
				win := '0';
				game_over := '0';
				
				for I in 0 to 7 loop
					for J in 0 to 4 loop
						shape_array_var(3 + I + (J * 8)) := enemy_default_shape;
						shape_array_var(3 + I + (J * 8)).x := ((I) * (50 + 30));
						shape_array_var(3 + I + (J * 8)).y := 60 * J;
					end loop;
				end loop;
				

				player := player_default_shape;
				bala := bala_default_shape;
				player_sombrerito := player_sombrerito_shape;
				aliens_killed <= x"00";
				aliens_killed_var := 0;
				
				ready_var := '1';
			end if;
			
			if(playing = '1') then
			
				if (count > 400) then
					count := 0;
					avance := '1';
				else
					avance := '0';
				end if;
				
				count := count  + 1;
				
				for I in 0 to 100 loop
					enemy := shape_array_var(I);
					if (enemy.draw_shape = '1' and enemy.is_enemy = '1' and avance = '1') then
						shape_array_var(I).y := shape_array_var(I).y + 25;
						if(shape_array_var(I).y >= 365) then
							game_over := '1';
						end if;
					end if;
				end loop;
			
				--bala := shape_array(1);
				--player := shape_array(0);
				has_collision := '0';
				if (bala.draw_shape = '1') then
					for I in 0 to 100 loop
						enemy := shape_array(I);
						if (enemy.draw_shape = '1' and enemy.is_enemy = '1') then
							if((abs(bala.x - enemy.x) <= enemy.x_size) and (abs(bala.y - enemy.y) <= enemy.y_size)) then
								has_collision := '1';
								aliens_killed_var := aliens_killed_var + 1;
								shape_array_var(I).draw_shape := '0';
								exit;
							end if;
						end if;
					end loop;
				end if;
				
				if (has_collision = '1' and bala.draw_shape = '1') then
					--- Dejar de dibujar la bala y de actualizar su posicion
					bala.draw_shape := '0';
				end if;
				
				if(bala.draw_shape = '1') then
					--- Actualizar la posicion de la bala
					bala.y := bala.y - 6;
					if(bala.y > 500) then -- Checar si la bala salio de la pantalla
						bala.draw_shape := '0';
					end if;
				end if;
				
				if(shootKey = '1' and bala.draw_shape = '0') then --- Volver a dibujar bala
					bala := bala_default_shape;
					bala.x := player.x + 18;
					bala.y := player.y;
					bala.draw_shape := '1';
				end if;
				
				--- Actualizar posicion del jugador
				if(moveLeft = '1' and player.x > 1) then
					player.x := player.x - 1;
					player_sombrerito.x := player_sombrerito.x - 1;
				elsif(moveRight = '1' and player.x < 600) then
					player.x := player.x + 1;
					player_sombrerito.x := player_sombrerito.x + 1;
				end if;
				
				if(aliens_killed_var = 40) then
					win := '1';
				end if;
			
			end if;
			
			debug_led(0) <= moveLeft;
			debug_led(1) <= shootKey;
			debug_led(2) <= bala.draw_shape;
			debug_led(3) <= not debug_led(3);
			
			shape_array_var(0) := player;
			shape_array_var(1) := bala;
			shape_array_var(2) := player_sombrerito;
			
			shape_array <= shape_array_var;
			GameOver <= game_over; 
			PlayerWin <= win;
			
			ready <= ready_var;
		end if;
		aliens_killed <= conv_std_logic_vector(aliens_killed_var, aliens_killed'length);
		--aliens_killed <= aliens_killed_var;
	end process;
			
-- Dibujar la pantalla
		PROCESS( Hsync, clk_vga, Vactive, Hactive, dena, shape_array)
		VARIABLE v_line_count:	natural RANGE 0 TO 480;
		VARIABLE h_line_count:	natural RANGE 0 TO 640;
		VARIABLE R_var, G_var, B_var : std_logic_vector(3 downto 0);
		VARIABLE is_drawing : std_logic;
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
			
			case Game_st is
			
				when Start_st =>
					R_var := (OTHERS => '0');
					G_var := (OTHERS => '0');
					B_var := (OTHERS => '1');
					
				when Playing_st =>
				
						for I in 0 to 100 loop
							if(shape_array(I).draw_shape = '1') then
								if (h_line_count > shape_array(I).x and h_line_count < shape_array(I).x + shape_array(I).x_size) and (v_line_count > shape_array(I).y and v_line_count < shape_array(I).y + shape_array(I).y_size) then
									R_var := (OTHERS => shape_array(I).r);
									G_var := (OTHERS => shape_array(I).g);
									B_var := (OTHERS => shape_array(I).b);
									exit;
								end if;
							end if;
						end loop;
							
				when GameOver_st =>
					R_var := (OTHERS => '1');
					G_var := (OTHERS => '0');
					B_var := (OTHERS => '0');
					
				when Winner_st =>
					R_var := (OTHERS => '0');
					G_var := (OTHERS => '1');
					B_var := (OTHERS => '0');
					
				when Delay_st =>
					
					R_var := (OTHERS => '0');
					G_var := (OTHERS => '0');
					B_var := (OTHERS => '0');
					
			end case;
		else
			R_var := (OTHERS => '0');
			G_var := (OTHERS => '0');
			B_var := (OTHERS => '0');
		end if;
		
		R <= R_var;
		G <= G_var;
		B <= B_var;
	END PROCESS;

-- Maquina de estados
		process (clk)
			variable count : integer := 0;
		begin
			if rising_edge(clk) then
			
				if (resetGame = '1' and Game_st /= Start_st) then
					Game_st <= Start_st;
				else
					case Game_st is
						when Start_st =>
						
							reset <= '1';
							Playing <= '0';
							if(ready = '1') then
								Game_st <= Delay_st;
								nx_Game_st <= Playing_st;
							end if;
							
						when Playing_st =>
							reset <= '0';
							Playing <= '1';
							if( GameOver = '1') then
								Game_st <= Delay_st;
								nx_Game_st <= GameOver_st;
							elsif (PlayerWin = '1') then
								Game_st <= Delay_st;
								nx_Game_st <= Winner_st;
							end if;
							
						when GameOver_st =>
							reset <= '0';
							Playing <= '0';
							Game_st <= GameOver_st;
							
						when Winner_st =>
							reset <= '0';
							Playing <= '0';
							Game_st <= Winner_st;
							
						when Delay_st =>
							count := count + 1;
							if(count > 100000) then
								count := 0;
								Game_st <= nx_Game_st;
							end if;
					end case;
				end if;
			end if;
		end process;
	
END ARCHITECTURE;