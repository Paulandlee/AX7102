`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////
// Module Name:    sd_test
///////////////////////////////////////////////////////////////////
module sd_test(
                    input sys_clk,
					input rst_n,
					
					output SD_clk,					
					output SD_cs,
					output SD_datain,
					input  SD_dataout
					
    );

wire CLKFB;
wire CLK0;
wire CLKDV;
wire CLKFX;
wire CLK2X;
wire clock100M;

wire SD_datain_i;
wire SD_datain_w;
wire SD_datain_r;
reg SD_datain_o;

wire SD_cs_i;
wire SD_cs_w;
wire SD_cs_r;
reg SD_cs_o;


reg [31:0]read_sec;
reg read_req;

reg [31:0]write_sec;
reg write_req;

wire [7:0]mydata_o;
wire myvalid_o;

wire init_o;             //SD ��ʼ����ɱ�ʶ
wire write_o;            //SD blcokд��ɱ�ʶ
wire read_o;             //SD blcok����ɱ�ʶ

reg [3:0] sd_state;

wire [3:0] initial_state;
wire [3:0] write_state;
wire [3:0] read_state;

wire rx_valid;

parameter STATUS_INITIAL=4'd0;
parameter STATUS_WRITE=4'd1;
parameter STATUS_READ=4'd2;
parameter STATUS_IDLE=4'd3;

assign SD_cs=SD_cs_o;
assign SD_datain=SD_datain_o;

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
 ////////////////����25Mhz��SD����дʱ��////////////////////////    
 wire locked;        

   pll_sd pll_sd_inst
             (// Clock in ports
              .clk_in1(sys_clk),      // IN
              .clk_out1(SD_clk),     // 25MHz) 
              .reset(0),               // reset input 
              .locked(locked));        // OUT
/*******************************/
//SD����ʼ��,blockд,block��	
/*******************************/
always @ ( posedge SD_clk or negedge rst_n )
    if( !rst_n ) begin
			sd_state <= STATUS_INITIAL;
			read_req <= 1'b0;
			read_sec <= 32'd0;
			write_req <= 1'b0;
			write_sec <= 32'd0;			
	 end
	 else 
	     case( sd_state )

	      STATUS_INITIAL:      // �ȴ�sd����ʼ������
			if( init_o ) begin sd_state <= STATUS_WRITE; write_sec <= 32'd0; write_req<=1'b1; end
			else begin sd_state <= STATUS_INITIAL; end	
		  
	      STATUS_WRITE:        //�ȴ�sd��blockд����
			if( write_o ) begin sd_state <= STATUS_READ; read_sec <= 32'd0; read_req<=1'b1; end
			else begin write_req<=1'b0; sd_state <= STATUS_WRITE; end
	
		  STATUS_READ:        //�ȴ�sd��block������
			if( read_o ) begin sd_state <= STATUS_IDLE; end
			else begin read_req<=1'b0; sd_state <= STATUS_READ;  end
			
	      STATUS_IDLE:        //����״̬
			sd_state <= STATUS_IDLE;
			
			default: sd_state <= STATUS_IDLE;
	      endcase

//SD����ʼ������				
sd_initial	sd_initial_inst(					
						.rst_n(rst_n),
						.SD_clk(SD_clk),
						.SD_cs(SD_cs_i),
						.SD_datain(SD_datain_i),
						.SD_dataout(SD_dataout),
						.rx(),
						.init_o(init_o),
						.state(initial_state)

);


//SD��block������, д512��0~255,0~255������			 
sd_write	sd_write_inst(   
						.SD_clk(SD_clk),
						.SD_cs(SD_cs_w),
						.SD_datain(SD_datain_w),
						.SD_dataout(SD_dataout),
						
						.init(init_o),
						.sec(write_sec),
						.write_req(write_req),
						.mystate(write_state),
						.rx_valid(rx_valid),

						.write_o(write_o)			
						
    );

//SD��block������, ��512������			 
sd_read	sd_read_inst(   
						.SD_clk(SD_clk),
						.SD_cs(SD_cs_r),
						.SD_datain(SD_datain_r),
						.SD_dataout(SD_dataout),
						
						.init(init_o),
						.sec(read_sec),
						.read_req(read_req),
						
						.mydata_o(mydata_o),
						.myvalid_o(myvalid_o),
		
						.data_come(data_come),
						.mystate(read_state),
						
						.read_o(read_o)
						
    );

always @(*)
begin
	 case( sd_state )
	 STATUS_INITIAL: begin SD_cs_o<=SD_cs_i;SD_datain_o<=SD_datain_i; end
	 STATUS_WRITE: begin SD_cs_o<=SD_cs_w;SD_datain_o<=SD_datain_w; end
	 STATUS_READ: begin SD_cs_o<=SD_cs_r;SD_datain_o<=SD_datain_r; end
	 default: begin SD_cs_o<=1'b1;SD_datain_o<=1'b1; end	 
	 endcase
end



endmodule
