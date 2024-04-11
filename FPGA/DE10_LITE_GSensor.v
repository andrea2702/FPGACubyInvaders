// ============================================================================
// Copyright (c) 2016 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Wed May 11 09:51:57 2016
// ============================================================================

module DE10_LITE_GSensor(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,
	
	output 					[7:0] HEX0,
	output					[7:0] HEX1,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,

	//////////// Arduino //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
	
	
	//////////// SEÑALES //////////
	output							LEFT_SIGNAL,
	output							RIGHT_SIGNAL,
	output							SHOOT_SIGNAL,
	output			 [7:0]		DATA_MOVEMENT,
	output							SHOOT_SIGNAL_OUT,
	output			 [7:0]		DEAD_ALIENS
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire	        dly_rst;
wire	        spi_clk, spi_clk_out;
wire	[15:0]  data_x;
wire gumnut_rst;
//=======================================================
//  Structural coding
//=======================================================

//	Reset
reset_delay	u_reset_delay	(	
            .iRSTN(KEY[0]),
            .iCLK(MAX10_CLK1_50),
            .oRST(dly_rst));

//  PLL            
spi_pll     u_spi_pll	(
            .areset(dly_rst),
            .inclk0(MAX10_CLK1_50),
            .c0(spi_clk),      // 2MHz
            .c1(spi_clk_out)); // 2MHz phase shift 

//  Initial Setting and Data Read Back
spi_ee_config u_spi_ee_config (			
						.iRSTN(!dly_rst),															
						.iSPI_CLK(spi_clk),								
						.iSPI_CLK_OUT(spi_clk_out),								
						.iG_INT2(GSENSOR_INT[1]),            
						.oDATA_L(data_x[7:0]),
						.oDATA_H(data_x[15:8]),
						.SPI_SDIO(GSENSOR_SDI),
						.oSPI_CSN(GSENSOR_CS_N),
						.oSPI_CLK(GSENSOR_SCLK));
			
//
//display display_1 (
//							.clk(MAX10_CLK1_50),
//							.entrada(data_x [9:5]),
//							.disp1 (HEX0),
//							.disp2(HEX1));
							
							
vga_interface VGA (
							.clk(MAX10_CLK1_50),
							.H_sync(VGA_HS),
							.V_sync(VGA_VS),
							.BLANKn(blank),
							.SYNCn(sync),
							.R(VGA_R),
							.G(VGA_G),
							.B(VGA_B),
							.moveLeft(LEFT_SIGNAL),
							.moveRight(RIGHT_SIGNAL),
							.shootKey(SHOOT_SIGNAL_OUT),
							.aliens_killed(DEAD_ALIENS),
							.resetGame(!KEY[0])
//							.HEX_0(HEX0),
//							.HEX_1(HEX1)
							);
							

// PLAYER CONTROLLER
player_controller u_player_controller(
						.clk(MAX10_CLK1_50),
						.dataIn(DATA_MOVEMENT),
						.LEDS(LEDR),
						.btn_disparo(SHOOT_SIGNAL),
						.left_move(LEFT_SIGNAL),
						.right_move(RIGHT_SIGNAL),
						.shoot_en(SHOOT_SIGNAL_OUT));
						
// GUMNUT CONTROLLER
gumnut_controller u_gumnut_controller(
						.CLOCK_50(MAX10_CLK1_50),
						.DATA_ACC(data_x[12:5]),
						.KEY_IN(KEY[1:0]),
						.cont_acc(DATA_MOVEMENT),
						.cont_k(SHOOT_SIGNAL),
						.HEX_0(HEX0),
						.HEX_1(HEX1),
						.SCORE_DATA_IN(DEAD_ALIENS)
						);
						
gumnut_with_mem gumnut (
	.clk_i(MAX10_CLK1_50),
	.rst_i(gumnut_rst));
	
endmodule
