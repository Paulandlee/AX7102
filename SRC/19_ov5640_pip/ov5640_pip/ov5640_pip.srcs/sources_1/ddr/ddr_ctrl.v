module ddr_ctrl
#(
	parameter DATA_WIDTH = 256,        //���ݿ��
	parameter ADDR_WIDTH = 29         //��ַ���
)
(
   // Differential system clocks
    input                    sys_clk_p,
    input                    sys_clk_n,
    input                    sys_rst,
	
	output                   clk,
	output                   rst,
    output                   init_calib_complete,     //ddr initial done
	///////////////CH0 read///////////////////
	input                    ch0_wr_burst_req,        //CH0 DDR Burstд����         	
	input  [9:0]             ch0_wr_burst_len,	          //CH0 DDR Burstд����
	input [ADDR_WIDTH - 1:0] ch0_wr_burst_addr,           //CH0 DDR Burstд��ַ
    output                   ch0_wr_burst_data_req,	      //CH0 д����������	
	input [DATA_WIDTH - 1:0] ch0_wr_burst_data,           //CH0 DDR Burstд����
    output                   ch0_wr_burst_finish,         //CH0 DDR Burstд����ź�
	
	input                    ch0_rd_burst_req,            //CH0 DDR Burst������ 
	input  [9:0]             ch0_rd_burst_len,	          //CH0 DDR Burst������
	input [ADDR_WIDTH - 1:0] ch0_rd_burst_addr,           //CH0 DDR Burst����ַ		
    output                   ch0_rd_burst_data_valid,     //CH0 DDR Burst��������Ч		
	output[DATA_WIDTH - 1:0] ch0_rd_burst_data,           //CH0 DDR Burst������
    output                   ch0_rd_burst_finish,         //CH0 DDR Burst������ź�

	///////////////CH1 read///////////////////
	input                    ch1_wr_burst_req,            //CH1 DDR Burstд����         	
	input  [9:0]             ch1_wr_burst_len,	          //CH1 DDR Burstд����
	input [ADDR_WIDTH - 1:0] ch1_wr_burst_addr,           //CH1 DDR Burstд��ַ
    output                   ch1_wr_burst_data_req,	      //CH1 д����������	
	input [DATA_WIDTH - 1:0] ch1_wr_burst_data,           //CH1 DDR Burstд����
    output                   ch1_wr_burst_finish,         //CH1 DDR Burstд����ź�
	
	input                    ch1_rd_burst_req,            //CH1 DDR Burst������ 
	input  [9:0]             ch1_rd_burst_len,	          //CH1 DDR Burst������
	input [ADDR_WIDTH - 1:0] ch1_rd_burst_addr,           //CH1 DDR Burst����ַ		
    output                   ch1_rd_burst_data_valid,     //CH1 DDR Burst��������Ч		
	output[DATA_WIDTH - 1:0] ch1_rd_burst_data,           //CH1 DDR Burst������
    output                   ch1_rd_burst_finish,         //CH1 DDR Burst������ź�
    
    	///////////////CH2 read///////////////////
    input                    ch2_wr_burst_req,            //CH2 DDR Burstд����             
    input  [9:0]             ch2_wr_burst_len,            //CH2 DDR Burstд����
    input [ADDR_WIDTH - 1:0] ch2_wr_burst_addr,           //CH2 DDR Burstд��ַ
    output                   ch2_wr_burst_data_req,       //CH2 д����������    
    input [DATA_WIDTH - 1:0] ch2_wr_burst_data,           //CH2 DDR Burstд����
    output                   ch2_wr_burst_finish,         //CH2 DDR Burstд����ź�
    
    input                    ch2_rd_burst_req,            //CH2 DDR Burst������ 
    input  [9:0]             ch2_rd_burst_len,            //CH2 DDR Burst������
    input [ADDR_WIDTH - 1:0] ch2_rd_burst_addr,           //CH2 DDR Burst����ַ        
    output                   ch2_rd_burst_data_valid,     //CH2 DDR Burst��������Ч        
    output[DATA_WIDTH - 1:0] ch2_rd_burst_data,           //CH2 DDR Burst������
    output                   ch2_rd_burst_finish,         //CH2 DDR Burst������ź�
    
    	///////////////CH3 read///////////////////
    input                    ch3_wr_burst_req,            //CH3 DDR Burstд����             
    input  [9:0]             ch3_wr_burst_len,            //CH3 DDR Burstд����
    input [ADDR_WIDTH - 1:0] ch3_wr_burst_addr,           //CH3 DDR Burstд��ַ
    output                   ch3_wr_burst_data_req,       //CH3 д����������    
    input [DATA_WIDTH - 1:0] ch3_wr_burst_data,           //CH3 DDR Burstд����
    output                   ch3_wr_burst_finish,         //CH3 DDR Burstд����ź�
    
    input                    ch3_rd_burst_req,            //CH3 DDR Burst������ 
    input  [9:0]             ch3_rd_burst_len,            //CH3 DDR Burst������
    input [ADDR_WIDTH - 1:0] ch3_rd_burst_addr,           //CH3 DDR Burst����ַ        
    output                   ch3_rd_burst_data_valid,     //CH3 DDR Burst��������Ч        
    output[DATA_WIDTH - 1:0] ch3_rd_burst_data,           //CH3 DDR Burst������
    output                   ch3_rd_burst_finish,         //CH3 DDR Burst������ź�
	
/*ddr3�ӿ��ź�*/	
    inout [31:0]             ddr3_dq,
    inout [3:0]              ddr3_dqs_n,
    inout [3:0]              ddr3_dqs_p,

    output [14:0]            ddr3_addr,
    output [2:0]             ddr3_ba,
    output                   ddr3_ras_n,
    output                   ddr3_cas_n,
    output                   ddr3_we_n,
    output                   ddr3_reset_n,
    output [0:0]             ddr3_ck_p,
    output [0:0]             ddr3_ck_n,
    output [0:0]             ddr3_cke,
    output [0:0]             ddr3_cs_n,
    output [3:0]             ddr3_dm,
    output [0:0]             ddr3_odt
);


  // Wire declarations
      
  wire [ADDR_WIDTH-1:0]                 app_addr;
  wire [2:0]                            app_cmd;
  wire                                  app_en;
  wire                                  app_rdy;
  wire [DATA_WIDTH-1:0]                 app_rd_data;
  wire                                  app_rd_data_end;
  wire                                  app_rd_data_valid;
  wire [DATA_WIDTH-1:0]                 app_wdf_data;
  wire                                  app_wdf_end;
  wire [DATA_WIDTH-1:0]                 app_wdf_mask;
  wire                                  app_wdf_rdy;
  wire                                  app_sr_active;
  wire                                  app_ref_ack;
  wire                                  app_zq_ack;
  wire                                  app_wdf_wren;


wire rd_burst_finish;
wire wr_burst_finish;
wire[ADDR_WIDTH - 1:0] wr_burst_addr;
wire[ADDR_WIDTH - 1:0] rd_burst_addr;
wire wr_burst_data_req;
wire rd_burst_data_valid;
wire[9:0] wr_burst_len;
wire[9:0] rd_burst_len;
wire wr_burst_req;
wire rd_burst_req;
wire[DATA_WIDTH - 1:0] wr_burst_data;
wire[DATA_WIDTH - 1:0] rd_burst_data;

//���port�Ķ������ٲ�
mem_read_arbi 
#(
	.MEM_DATA_BITS(DATA_WIDTH)
)
mem_read_arbi_m0
(
	.rst_n(~rst),
	.mem_clk(clk),
	.ch0_rd_burst_req(ch0_rd_burst_req),
	.ch0_rd_burst_len(ch0_rd_burst_len),
	.ch0_rd_burst_addr(ch0_rd_burst_addr),
	.ch0_rd_burst_data_valid(ch0_rd_burst_data_valid),
	.ch0_rd_burst_data(ch0_rd_burst_data),
	.ch0_rd_burst_finish(ch0_rd_burst_finish),
	
	.ch1_rd_burst_req(ch1_rd_burst_req),
	.ch1_rd_burst_len(ch1_rd_burst_len),
	.ch1_rd_burst_addr(ch1_rd_burst_addr),
	.ch1_rd_burst_data_valid(ch1_rd_burst_data_valid),
	.ch1_rd_burst_data(ch1_rd_burst_data),
	.ch1_rd_burst_finish(ch1_rd_burst_finish),
	
	.ch2_rd_burst_req(ch2_rd_burst_req),
	.ch2_rd_burst_len(ch2_rd_burst_len),
	.ch2_rd_burst_addr(ch2_rd_burst_addr),
	.ch2_rd_burst_data_valid(ch2_rd_burst_data_valid),
	.ch2_rd_burst_data(ch2_rd_burst_data),
	.ch2_rd_burst_finish(ch2_rd_burst_finish),
	
	.ch3_rd_burst_req(ch3_rd_burst_req),
	.ch3_rd_burst_len(ch3_rd_burst_len),
	.ch3_rd_burst_addr(ch3_rd_burst_addr),
	.ch3_rd_burst_data_valid(ch3_rd_burst_data_valid),
	.ch3_rd_burst_data(ch3_rd_burst_data),
	.ch3_rd_burst_finish(ch3_rd_burst_finish),
	
	///////////////////////////////////////////
	.rd_burst_req(rd_burst_req),
	.rd_burst_len(rd_burst_len),
	.rd_burst_addr(rd_burst_addr),
	.rd_burst_data_valid(rd_burst_data_valid),
	.rd_burst_data(rd_burst_data),
	.rd_burst_finish(rd_burst_finish)	
);

//���port��д�����ٲ�
mem_write_arbi
#(
	.MEM_DATA_BITS(DATA_WIDTH)
)
mem_write_arbi_m0(
	.rst_n(~rst),
	.mem_clk(clk),
	
	.ch0_wr_burst_req(ch0_wr_burst_req),
	.ch0_wr_burst_len(ch0_wr_burst_len),
	.ch0_wr_burst_addr(ch0_wr_burst_addr),
	.ch0_wr_burst_data_req(ch0_wr_burst_data_req),
	.ch0_wr_burst_data(ch0_wr_burst_data),
	.ch0_wr_burst_finish(ch0_wr_burst_finish),
	
	.ch1_wr_burst_req(ch1_wr_burst_req),
	.ch1_wr_burst_len(ch1_wr_burst_len),
	.ch1_wr_burst_addr(ch1_wr_burst_addr),
	.ch1_wr_burst_data_req(ch1_wr_burst_data_req),
	.ch1_wr_burst_data(ch1_wr_burst_data),
	.ch1_wr_burst_finish(ch1_wr_burst_finish),
	
	.ch2_wr_burst_req(ch2_wr_burst_req),
	.ch2_wr_burst_len(ch2_wr_burst_len),
	.ch2_wr_burst_addr(ch2_wr_burst_addr),
	.ch2_wr_burst_data_req(ch2_wr_burst_data_req),
	.ch2_wr_burst_data(ch2_wr_burst_data),
	.ch2_wr_burst_finish(ch2_wr_burst_finish),
	
	.ch3_wr_burst_req(ch3_wr_burst_req),
	.ch3_wr_burst_len(ch3_wr_burst_len),
	.ch3_wr_burst_addr(ch3_wr_burst_addr),
	.ch3_wr_burst_data_req(ch3_wr_burst_data_req),
	.ch3_wr_burst_data(ch3_wr_burst_data),
	.ch3_wr_burst_finish(ch3_wr_burst_finish),
	
	.wr_burst_req(wr_burst_req),
	.wr_burst_len(wr_burst_len),
	.wr_burst_addr(wr_burst_addr),
	.wr_burst_data_req(wr_burst_data_req),
	.wr_burst_data(wr_burst_data),
	.wr_burst_finish(wr_burst_finish)	
);

//ʵ����mem_burst
mem_burst
#(
	.MEM_DATA_BITS(DATA_WIDTH),
	.ADDR_BITS(ADDR_WIDTH)
)
 mem_burst_m0
(
   .rst(rst),                                  /*��λ*/
   .mem_clk(clk),                              /*�ӿ�ʱ��*/
   .rd_burst_req(rd_burst_req),                /*DDR Burst������*/
   .wr_burst_req(wr_burst_req),                /*DDR Burstд����*/
   .rd_burst_len(rd_burst_len),                /*DDR Burst�����ݳ���*/
   .wr_burst_len(wr_burst_len),                 /*DDR Burstд���ݳ���*/
   .rd_burst_addr(rd_burst_addr),               /*DDR Burst���׵�ַ*/
   .wr_burst_addr(wr_burst_addr),               /*DDR Burstд�׵�ַ*/
   .rd_burst_data_valid(rd_burst_data_valid),   /*DDR Burst����������Ч*/
   .wr_burst_data_req(wr_burst_data_req),       /*DDR Burstд�����ź�*/
   .rd_burst_data(rd_burst_data),               /*DDR Burst����������*/
   .wr_burst_data(wr_burst_data),               /*DDR Burstд�������*/
   .rd_burst_finish(rd_burst_finish),           /*DDR Burst�����*/
   .wr_burst_finish(wr_burst_finish),           /*DDR Burstд���*/
   .burst_finish(),                             /*����д���*/
   
   ///////////////////
  .app_addr(app_addr),
  .app_cmd(app_cmd),
  .app_en(app_en),
  .app_wdf_data(app_wdf_data),
  .app_wdf_end(app_wdf_end),
  .app_wdf_mask(app_wdf_mask),
  .app_wdf_wren(app_wdf_wren),
  .app_rd_data(app_rd_data),
  .app_rd_data_end(app_rd_data_end),
  .app_rd_data_valid(app_rd_data_valid),
  .app_rdy(app_rdy),
  .app_wdf_rdy(app_wdf_rdy),
  .ui_clk_sync_rst(),  
  .init_calib_complete(init_calib_complete)
);

//ʵ����ddr3.v IP
  ddr3 ddr_m0
      ( 
       
// Memory interface ports
       .ddr3_addr                      (ddr3_addr),
       .ddr3_ba                        (ddr3_ba),
       .ddr3_cas_n                     (ddr3_cas_n),
       .ddr3_ck_n                      (ddr3_ck_n),
       .ddr3_ck_p                      (ddr3_ck_p),
       .ddr3_cke                       (ddr3_cke),
       .ddr3_ras_n                     (ddr3_ras_n),
       .ddr3_we_n                      (ddr3_we_n),
       .ddr3_dq                        (ddr3_dq),
       .ddr3_dqs_n                     (ddr3_dqs_n),
       .ddr3_dqs_p                     (ddr3_dqs_p),
       .ddr3_reset_n                   (ddr3_reset_n),
       .init_calib_complete            (init_calib_complete),
      
       .ddr3_cs_n                      (ddr3_cs_n),
       .ddr3_dm                        (ddr3_dm),
       .ddr3_odt                       (ddr3_odt),
// Application interface ports
       .app_addr                       (app_addr),
       .app_cmd                        (app_cmd),
       .app_en                         (app_en),
       .app_wdf_data                   (app_wdf_data),
       .app_wdf_end                    (app_wdf_end),
       .app_wdf_wren                   (app_wdf_wren),
       .app_rd_data                    (app_rd_data),
       .app_rd_data_end                (app_rd_data_end),
       .app_rd_data_valid              (app_rd_data_valid),
       .app_rdy                        (app_rdy),
       .app_wdf_rdy                    (app_wdf_rdy),
       .app_sr_req                     (1'b0),
       .app_ref_req                    (1'b0),
       .app_zq_req                     (1'b0),
       .app_sr_active                  (app_sr_active),
       .app_ref_ack                    (app_ref_ack),
       .app_zq_ack                     (app_zq_ack),
       .ui_clk                         (clk),
       .ui_clk_sync_rst                (rst),
      
       .app_wdf_mask                   (app_wdf_mask),
      
       
// System Clock Ports
       .sys_clk_p                       (sys_clk_p),
       .sys_clk_n                       (sys_clk_n),
      
       .sys_rst                         (sys_rst)
       );
	
endmodule 

