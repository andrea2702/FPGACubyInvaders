LIBRARY 	ieee;
USE		ieee.std_logic_1164.all, ieee.numeric_std.all;

ENTITY gumnut_controller IS
	PORT(	
		CLOCK_50			: 	IN			std_logic;
		KEY_IN			: 	IN 		std_logic_vector( 1 DOWNTO 0 );
		HEX_0				:	OUT		std_logic_vector( 7 DOWNTO 0 );
		HEX_1				:	OUT		std_logic_vector( 7 DOWNTO 0 );
		DATA_ACC			:	IN			std_logic_vector( 7 downto 0 );
		cont_acc			:	OUT		std_logic_vector( 7 downto 0 );
		cont_k			:	OUT		std_logic;
		SCORE_DATA_IN	:	IN			std_logic_vector(7 downto 0);
		SCORE_OUT		:	BUFFER	std_logic_vector(7 downto 0)
	);
END gumnut_controller;

ARCHITECTURE behavior OF gumnut_controller IS	
	
	component gumnut_with_mem IS
		generic ( 
			IMem_file_name : string := "gasm_text.dat";
			DMem_file_name : string := "gasm_data.dat";
         debug : boolean := false );
		port ( clk_i : in std_logic;
         rst_i : in std_logic;
         -- I/O port bus
         port_cyc_o : out std_logic;
         port_stb_o : out std_logic;
         port_we_o : out std_logic;
         port_ack_i : in std_logic;
         port_adr_o : out unsigned(7 downto 0);
         port_dat_o : out std_logic_vector(7 downto 0);
         port_dat_i : in std_logic_vector(7 downto 0);
         -- Interrupts
         int_req : in std_logic;
         int_ack : out std_logic );
	end COMPONENT gumnut_with_mem;
	
	
	COMPONENT decoder IS
		PORT(
			DATA_IN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	
	
	SIGNAL 	clk_i, rst_i, 
				port_cyc_o, port_stb_o, 
				port_we_o, port_ack_i, 
				int_req, int_ack			: 	std_logic;
	SIGNAL 	port_dat_o, port_dat_i	:	std_logic_vector( 7 downto 0 );
	SIGNAL   port_adr_o					:	unsigned( 7 DOWNTO 0 );
	
	SIGNAL hex_out	:	STD_LOGIC_VECTOR(7 downto 0);
	
	signal acc_data_temp : 	STD_LOGIC_VECTOR(7 downto 0);
	signal btn_temp		: 	STD_LOGIC_VECTOR(7 downto 0);
	signal score_temp		:	STD_LOGIC_VECTOR(7 downto 0);
	
	signal unidades : STD_LOGIC_VECTOR(7 downto 0);
	signal decenas  : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

	display:	decoder PORT MAP(SCORE_OUT, HEX_0, HEX_1);
	
	
	clk_i 		<= CLOCK_50;
	rst_i 		<= not KEY_IN( 0 );
	port_ack_i 	<= '1';
	
	gumnut	:	COMPONENT gumnut_with_mem 
						PORT MAP(
							clk_i, -- port_dat_o debe depender de esta señal
							rst_i,
							port_cyc_o,
							port_stb_o,
							port_we_o,
							port_ack_i,
							port_adr_o( 7 DOWNTO 0 ),
							port_dat_o( 7 DOWNTO 0 ), -- Recibe datos del gumnut, se debe sincronizar con el reloj
							port_dat_i( 7 DOWNTO 0 ), -- Envia datos a gumnut
							int_req,
							int_ack
						);

	accel_in		:	PROCESS(clk_i)
							BEGIN
								IF rising_edge(clk_i) THEN
									IF port_adr_o = "00000000" and port_cyc_o='1' and port_stb_o ='1' and port_we_o = '0' THEN
										acc_data_temp <= DATA_ACC;
									END IF;
								END IF; 
						END PROCESS;
						
	accel_out	:	PROCESS(clk_i)
							BEGIN
								IF rising_edge(clk_i) THEN
									IF port_adr_o = "00000001" and port_cyc_o='1' and port_stb_o ='1' and port_we_o = '1' THEN
										cont_acc <= port_dat_o;
									END IF;
								END IF;
						END PROCESS;

	btn_in		:	PROCESS(clk_i)
							BEGIN
								if rising_edge(clk_i) THEN
									IF port_adr_o = x"02" and port_cyc_o='1' and port_stb_o='1' and port_we_o = '0' THEN
										btn_temp <= "0000000" & KEY_IN(1);
									END IF;
								END IF;
						END PROCESS;
						
	btn_shot		:	PROCESS(clk_i)
							BEGIN
								IF rising_edge(clk_i) THEN
									IF port_adr_o = x"03" and port_cyc_o='1' and port_stb_o='1' and port_we_o = '1' THEN
										cont_k <= port_dat_o(0);
									END IF; 
								END IF;
						END PROCESS;
				
	score_in		:	PROCESS(clk_i)
							BEGIN
								IF rising_edge(clk_i) THEN
									IF port_adr_o = x"04" and port_cyc_o='1' and port_stb_o='1' and port_we_o = '0' THEN
										score_temp <= SCORE_DATA_IN;
									END IF; 
								END IF;
						END PROCESS;
	
	score_disp	:	PROCESS(clk_i)
							variable num:	std_logic_vector(7 downto 0);
							variable decenas_var: unsigned(7 downto 0);
							variable unidades_var: unsigned(7 downto 0); 
							BEGIN
								IF rising_edge(clk_i) THEN
									IF port_adr_o = x"05" and port_cyc_o='1' and port_stb_o='1' and port_we_o = '1' THEN
										SCORE_OUT <= port_dat_o;
									END IF; 
								END IF;
								
						END PROCESS;
	
-- MULTIPLEXER PARA LAS ENTRADAS A GUMNUT		
	with port_adr_o select
		port_dat_i <= 	acc_data_temp when x"00",
							btn_temp when x"02",
							score_temp when x"04",
							x"00" when others;
	
	
END behavior;