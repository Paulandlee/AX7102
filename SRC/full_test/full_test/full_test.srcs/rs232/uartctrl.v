`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module name    uartctrl.v
// ˵����          ������ڽ��յ����ݣ����ͽ��յ������ݵ����ڣ����û�н��յ����ݣ�Ĭ�ϲ��ϵķ���
//                �洢���ַ���
//////////////////////////////////////////////////////////////////////////////////
module uartctrl(

      input                    SD_clk_i,                //25M 
 	  input                    rst_n,
      
      output                   SD_clk,                    
      output                   SD_cs,
      output                   SD_datain,
      input                    SD_dataout,     
      
      input                   clk,
	  output                  wrsig,                //���ڷ���ָʾ�ź�
	  output     [7:0]        dataout               //���ڷ�������

);

reg [17:0] uart_wait;
reg [15:0] uart_cnt;
reg rx_data_valid;
reg [2:0] uart_stat;                           //uart״̬��
reg [8:0] k;                                   //����ָʾ���͵ĵڼ�������
reg [7:0] dataout_reg;
reg data_sel;
reg wrsig_reg;

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

reg [8:0] ram_wr_addr;
reg [8:0] ram_rd_addr;

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

assign SD_clk=SD_clk_i;
assign SD_cs=SD_cs_o;
assign SD_datain=SD_datain_o;

assign dataout = dataout_reg;            //��������ѡ��data_sel�ߣ�ѡ��洢���ַ�����data_sel���ͣ�ѡ����յ�����
assign wrsig = wrsig_reg;                  //��������ѡ��data_sel�ߣ����ʹ洢���ַ�����data_sel���ͣ����ͽ��յ�����


/*******************************/
//SD����ʼ��,blockд,block��	
/*******************************/
always @ ( posedge SD_clk_i or negedge rst_n )
    if( !rst_n ) begin
			sd_state <= STATUS_INITIAL;
			read_req <= 1'b0;
			read_sec <= 32'd0;
			write_req <= 1'b0;
			write_sec <= 32'd0;		
			ram_wr_addr <=0;	
	 end
	 else 
	     case( sd_state )

	      STATUS_INITIAL:      // �ȴ�sd����ʼ������
			//if( init_o ) begin sd_state <= STATUS_WRITE; write_sec <= 32'd0; write_req<=1'b1; end
			if( init_o ) begin sd_state <= STATUS_READ; read_sec <= 32'd0; read_req<=1'b1; end			
			else begin sd_state <= STATUS_INITIAL; end	
		  
	      STATUS_WRITE:        //�ȴ�sd��blockд����
			if( write_o ) begin sd_state <= STATUS_READ; read_sec <= 32'd0; read_req<=1'b1; end
			else begin write_req<=1'b0; sd_state <= STATUS_WRITE; end
	
		  STATUS_READ:        //�ȴ�sd��block������
			if( read_o ) begin sd_state <= STATUS_IDLE; end
			else begin
			     read_req<=1'b0; 			     
			     sd_state <= STATUS_READ; 
			    if (myvalid_o==1'b1) ram_wr_addr <= ram_wr_addr +1'b1; 
			end
			
	      STATUS_IDLE:        //����״̬
			sd_state <= STATUS_IDLE;
			
			default: sd_state <= STATUS_IDLE;
	      endcase

//SD����ʼ������				
sd_initial	sd_initial_inst(					
						.rst_n(rst_n),
						.SD_clk(SD_clk_i),
						.SD_cs(SD_cs_i),
						.SD_datain(SD_datain_i),
						.SD_dataout(SD_dataout),
						.rx(),
						.init_o(init_o),
						.state(initial_state)

);


//SD��block������, д512��0~255,0~255������			 
sd_write	sd_write_inst(   
						.SD_clk(SD_clk_i),
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
						.SD_clk(SD_clk_i),
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

//////////ram���ڴ洢SD���յ������ݻ��������///////////////////
wire [7:0] ram_rd_data;
sd_ram sd_ram_inst (
  .clka(SD_clk_i),           // input clka
  .wea(myvalid_o),     // input [0 : 0] wea
  .addra(ram_wr_addr),
  .dina(mydata_o),     // input [7 : 0] dina
  .clkb(clk),           // input clkb
  .addrb(k),    // input [8 : 0] addrb
  .doutb(ram_rd_data)     // output [7 : 0] doutb
);

 
//���ڷ��Ϳ��ƣ�ÿ��һ��ʱ�����һ�������ַ���������  
always @(negedge clk)
begin
    if (uart_wait ==18'h3ffff) begin                //�ȴ�һ��ʱ��(ÿ��һ��ʱ�䷢���ַ�����,������������Ըı䷢���ַ���֮���ʱ������
		uart_wait <= 0;
		rx_data_valid <=1'b1;	                      //�ȴ�ʱ�����������һ�������ַ�����Ч�ź�����
    end		
	 else begin
		uart_wait <= uart_wait+1'b1;
		rx_data_valid <=1'b0;
	 end
end 
 
//////////////////////////////////////// 
//���ڷ����ַ������Ƴ������η��ʹ洢���ַ���//
////////////////////////////////////////	
always @(posedge clk)
begin
  if(rst_n == 1'b0) begin   
		uart_cnt <= 0;
		uart_stat <= 3'b000; 
		data_sel<=1'b0;
		k<=0;
  end
  else begin
  	 case(uart_stat)
	 3'b000: begin               
       if (rx_data_valid == 1'b1) begin  //�����ַ�����Ч�ź�Ϊ�ߣ���ʼ�����ַ���
		     uart_stat <= 3'b001; 
			 data_sel<=1'b1; 
		 end
	 end	
	 3'b001: begin                      //����512���ַ�   
         if (k == 511 ) begin           //���͵�512���ַ�      		 
				 if(uart_cnt ==0) begin
					dataout_reg <= ram_rd_data; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;      //�����ַ�ʹ������             			
				 end	
				 else if(uart_cnt ==254) begin    //�ȴ�һ���ַ�������ɣ�����һ���ַ���ʱ��Ϊ168��ʱ�ӣ���������ȴ���ʱ����Ҫ����168
					uart_cnt <= 0;
					wrsig_reg <= 1'b0; 				
					uart_stat <= 3'b010; 
					k <= 0;
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig_reg <= 1'b0;  
				 end
		  end
	     else begin                      //����ǰ511���ַ�   
				 if(uart_cnt ==0) begin      
					dataout_reg <= ram_rd_data; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;           //����ʹ��           			
				 end	
				 else if(uart_cnt ==254) begin    //�ȴ�һ�����ݷ�����ɣ�����һ���ַ���ʱ��Ϊ168��ʱ�ӣ���������ȴ���ʱ����Ҫ����168
					uart_cnt <= 0;
					wrsig_reg <= 1'b0; 
					k <= k + 1'b1;	               //k��1��������һ���ַ�        			
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig_reg <= 1'b0;  
				 end
		 end	 
	 end
	 3'b010: begin       //����finish	 
		 	uart_stat <= 3'b000;
	 end
	 default:uart_stat <= 3'b000;
    endcase 
  end
end
 
endmodule
