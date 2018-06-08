`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ov5640_ethernet_800600 
//////////////////////////////////////////////////////////////////////////////////
module ov5640_ethernet_800600(
    input               sys_clk_p,
    input               sys_clk_n,
	input               sys_rst,
    output    [3:0]      led,               //led��ָʾ

	//Camera�ӿ��ź�
	output              cmos1_reset,
	input               cmos1_pclk,              //cmos pxiel clock
    input               cmos1_href,              //cmos hsync refrence
	input               cmos1_vsync,             //cmos vsync
	input     [7:0]     cmos1_d,              //cmos data
	output              cmos1_scl,                 //cmos i2c clock
	inout               cmos1_sda,  	              //cmos i2c data

	//ǧ����̫���ӿ��ź�	
	output               e_reset,	
    output               e_mdc,                      //MDIO��ʱ���źţ����ڶ�дPHY�ļĴ���
	inout                e_mdio,                     //MDIO�������źţ����ڶ�дPHY�ļĴ���	
            
	input	             e_rxc,                      //125Mhz ethernet gmii rx clock
	input	             e_rxdv,	                   //GMII ����������Ч�ź�
	input	             e_rxer,	                   //GMII �������ݴ����ź�					
	input      [7:0]     e_rxd,                      //GMII ��������	      

	input	             e_txc,                      //25Mhz ethernet mii tx clock         
	output               e_gtxc,                     //25Mhz ethernet gmii tx clock  
	output               e_txen,                     //GMII ����������Ч�ź�	
	output               e_txer,                     //GMII �������ݴ����ź�					
	output     [7:0]     e_txd	                      //GMII �������� 	
		
    );


wire reg_conf_done;
wire initial_en;

wire clk_out1;

assign e_gtxc=e_rxc;	 
assign e_reset = 1'b1; 


////////////////���ʱ��ת���ɵ���ʱ��////////////////////////
wire sys_clk_ibufg;
     IBUFGDS #
           (
            .DIFF_TERM    ("FALSE"),
            .IBUF_LOW_PWR ("FALSE")
            )
           u_ibufg_sys_clk
             (
              .I  (sys_clk_p),
              .IB (sys_clk_n),
              .O  (sys_clk_ibufg)
              );

//////////////////////PLLʱ��//////////////////////////////
  pll pll_inst
   (// Clock in ports
    .clk_in1(sys_clk_ibufg),         // IN
    // Clock out ports
    .clk_out1(clk_out1),       // 24Mhz
    .clk_out2(camera_clk),     // 24Mhz
    // Status and control signals
    .reset(~sys_rst),// IN
    .locked());      // OUT
    

////////////////�ϵ��ӳٲ���////////////////////
power_on_delay	power_on_delay_inst(
	.clk_50M                 (camera_clk),
	.reset_n                 (sys_rst),	
	.camera_rstn             (cmos1_reset),
	.camera_pwnd             (cmos1_pwnd),
	.initial_en              (initial_en)            //initial ov5640 register is allow		
);

//Camera��ʼ������,Camera LED FLASH control//////////
reg_config	reg_config_inst(
	.clk_25M                 (camera_clk),
	.camera_rstn             (cmos1_reset),
	.initial_en              (initial_en),		
	.i2c_sclk                (cmos1_scl),
	.i2c_sdat                (cmos1_sda),
	.reg_conf_done           (reg_conf_done)        //ov5640 register configure is done

);


///////////////// /Camera��������////////////////
wire [11:0] camera_h_count;
wire [10:0] camera_v_count;
wire fifo_wr_en; 
wire fifo_rst;
camera_capture	camera_capture_inst(
	.reg_conf_done           (reg_conf_done),	
	.camera_pclk             (cmos1_pclk),
	.camera_href             (cmos1_href),
	.camera_vsync            (cmos1_vsync),
	.camera_data             (cmos1_d),
	.camera_h_count          (camera_h_count),	
	.camera_v_count          (camera_v_count),
	
	.fifo_rst                (fifo_rst)
	
);


//////////////////// CMOS FIFO/////////////////// 
wire fifo_prog_full;
wire [7:0] fifo_data;
wire fifo_rd_en;
wire fifo_full;
wire fifo_empty;
cmos1_fifo cmos1_fifo_inst (
  .rst                      (fifo_rst),   // input rst
  .wr_clk                   (cmos1_pclk),                   // input wr_clk
  .din                      (cmos1_d),                   // input [7 : 0] din
  .wr_en                    (cmos1_href),                    // input wr_en
  
  .rd_clk                   (e_rxc),                         // input rd_clk
  .rd_en                    (fifo_rd_en),                    // input rd_en
  .dout                     (fifo_data),                     // output [7 : 0] dout
  .full                     (fifo_full),                     // output full
  .empty                    (fifo_empty),                    // output empty
  .prog_full                (fifo_prog_full)                // output [10 : 0] rd_data_count
);


/////////////////udp���ͺͽ��ճ���/////////////////// 
udp udp_inst(
	.reset_n                 (cmos1_reset),
	.e_rxc                   (e_rxc),
	.e_rxd                   (e_rxd),
    .e_rxdv                  (e_rxdv),
	.e_txen                  (e_txen),
	.e_txd                   (e_txd),
	.e_txer                  (e_txer),		
	
	.fifo_data               (fifo_data),           //FIFO������8bit����/
	.fifo_prog_full          (fifo_prog_full),     //FIFO�еĿɱ�����ź�
    .fifo_rd_en              (fifo_rd_en),          //FIFO��ʹ�� 

	.frame_index             (camera_v_count), 

	.tx_total_length         (16'd1052),            //����IP�����ܳ���/
	.tx_data_length          (16'd1032)             //����IP�������ݳ���/		


	);
	
endmodule
