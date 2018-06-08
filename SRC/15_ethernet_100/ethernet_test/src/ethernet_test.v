`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    100M ethernet port  
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test(
					input       reset_n,                           
                    input       sys_clk_p,
                    input       sys_clk_n,  
					output      e_reset , 					
            
				//signal connect to PHY//
                    output       e_mdc,                      //MDIO��ʱ���źţ����ڶ�дPHY�ļĴ���
                    inout        e_mdio,                     //MDIO�������źţ����ڶ�дPHY�ļĴ���  				
					input	     e_rxc, 
					input        e_rxdv,				           
					input  [3:0] e_rxd, 
					input        e_rxer,      
               
					input        e_txc,  
					output       e_txen,
					output       e_txer,  					
					output [3:0] e_txd  	 
	  
    );

assign  e_mdc=1'bz;
assign  e_mdio=1'bz;

wire [31:0] ram_wr_data;
wire [31:0] ram_rd_data;
wire [8:0] ram_wr_addr;
wire [8:0] ram_rd_addr;

wire [15:0] tx_data_counter;


wire [31:0] datain_reg;
         
wire [3:0] tx_state;
wire [3:0] rx_state;
wire [15:0] rx_total_length;          //rx ��IP���ĳ���
wire [15:0] tx_total_length;          //tx ��IP���ĳ���
wire [15:0] rx_data_length;           //rx ��UDP�����ݰ�����
wire [15:0] tx_data_length;           //rx ��UDP�����ݰ�����

wire data_receive;
reg ram_wr_finish;

reg [31:0] udp_data [4:0];                        //�洢�����ַ�
reg ram_wren_i;
reg [8:0] ram_addr_i;
reg [31:0] ram_data_i;
reg [4:0] i;

wire data_o_valid;
wire wea;
wire [8:0] addra;
wire [31:0] dina;

assign e_reset = 1'b1; 

assign wea=ram_wr_finish?data_o_valid:ram_wren_i;
assign addra=ram_wr_finish?ram_wr_addr:ram_addr_i;
assign dina=ram_wr_finish?ram_wr_data:ram_data_i;


assign tx_data_length=data_receive?rx_data_length:16'd28;
assign tx_total_length=data_receive?rx_total_length:16'd48;

//���ʱ��ת���ɵ���ʱ��
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

////////udp���ͺͽ��ճ���/////////////////// 
udp udp_inst(
	.reset_n(reset_n),
	.e_rxc(e_rxc),
	.e_rxd(e_rxd),
   .e_rxdv(e_rxdv),
	.data_o_valid(data_o_valid),                    //���ݽ�����Ч�ź�,д��RAM/
	.ram_wr_data(ram_wr_data),                      //���յ���32bit����д��RAM/	
	.rx_total_length(rx_total_length),              //����IP�����ܳ���/
	.mydata_num(mydata_num),                        //for debug
	.rx_state(rx_state),                            //for debug
	.rx_data_length(rx_data_length),                //����IP�������ݳ���/	
	.ram_wr_addr(ram_wr_addr),
	.data_receive(data_receive),

	.e_txc(e_txc),	
	.e_txen(e_txen),
	.e_txd(e_txd),
	.e_txer(e_txer),	
	.ram_rd_data(ram_rd_data),                      //RAM������32bit����/
	.tx_state(tx_state),                            //for debug
	.tx_data_length(tx_data_length),                //����IP�������ݳ���/	
	.tx_total_length(tx_total_length),              //�ӷ���IP�����ܳ���/
	.ram_rd_addr(ram_rd_addr),
	.tx_data_counter(tx_data_counter)	
	

	);
		


//////////ram���ڴ洢��̫�����յ������ݻ��������///////////////////
ram ram_inst (
  .clka(e_rxc),           // input clka
  .wea(wea),     // input [0 : 0] wea
  .addra(addra),    // input [8 : 0] addra
  .dina(dina),     // input [31 : 0] dina
  
  .clkb(e_txc),           // input clkb
  .addrb(ram_rd_addr),    // input [8 : 0] addrb
  .doutb(ram_rd_data)     // output [31 : 0] doutb
);

/********************************************/
//�洢�����͵��ַ�
/********************************************/
always @(*)
begin     //���巢�͵��ַ�
	 udp_data[0]<={8'd72,8'd69,8'd76,8'd76};   //�洢�ַ�HELL 
	 udp_data[1]<={8'd79,8'd32,8'd65,8'd76};   //�洢�ַ�O�ո�AL 
     udp_data[2]<={8'd73,8'd78,8'd88,8'd32};   //�洢�ַ�INX�ո�
	 udp_data[3]<={8'd65,8'd88,8'd55,8'd49};   //�洢�ַ�AX71 	 
	 udp_data[4]<={8'd48,8'd49,8'd10,8'd13};   //�洢�ַ�01���з��س���                            

end 


//////////д��Ĭ�Ϸ��͵�����//////////////////
always@(posedge e_rxc)
begin	
  if(reset_n==1'b0) begin
     ram_wr_finish<=1'b0;
	  ram_addr_i<=0;
	  ram_data_i<=0;
	  i<=0;
  end
  else begin
     if(i==5) begin
        ram_wr_finish<=1'b1;
        ram_wren_i<=1'b0;		  
     end
     else begin
        ram_wren_i<=1'b1;
		  ram_addr_i<=ram_addr_i+1'b1;
		  ram_data_i<=udp_data[i];
		  i<=i+1'b1;
	  end
  end 
end  




endmodule
