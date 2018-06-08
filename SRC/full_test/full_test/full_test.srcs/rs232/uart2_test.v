`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    uart2_test 
// decription: test the RS232 
//////////////////////////////////////////////////////////////////////////////////
module uart2_test(
         input sys_clk,                      // �������ϲ������ʱ��P: 200Mhz
         input  rst_n,
         
 		 output SD_clk,					
         output SD_cs,
         output SD_datain,
         input  SD_dataout,        
         
         input uart2_rx,                       // �������ݽ���
         output uart2_tx);                     // �������ݷ���


wire clk;       //clock for 9600 uart port
wire SD_clk_i;
wire [7:0] txdata,rxdata;     //���ڷ������ݺʹ��ڽ�������



//����ʱ�ӵ�Ƶ��Ϊ16*9600
clkdiv u0 (
		.clk200                  (sys_clk),             //200Mhz�ľ�������                     
		.clkout1                 (SD_clk_i),            //25M SD clock
		.clkout2                 (clk)                  //16�������ʵ�ʱ��                        
 );

//���ڽ��ճ���
uartrx u1 (
		.clk                     (clk),                 //16�������ʵ�ʱ�� 
        .rx	                     (uart2_rx),  	        //���ڽ���
		.dataout                 (rxdata),              //uart ���յ�������,һ���ֽ�                     
        .rdsig                   (rdsig),               //uart ���յ�������Ч 
		.dataerror               (),
		.frameerror              ()
);

//���ڷ��ͳ���
uarttx u2 (
		.clk                     (clk),                  //16�������ʵ�ʱ��  
	    .tx                      (uart2_tx),			 //���ڷ���
		.datain                  (txdata),               //uart ���͵�����   
        .wrsig                   (wrsig),                //uart ���͵�������Ч  
        .idle                    () 	
	
 );

//�������ݷ��Ϳ��Ƴ���
uartctrl u3 (
		.SD_clk_i                (SD_clk_i),   
		.rst_n                   (rst_n),
		.SD_clk                  (SD_clk),		
		.SD_cs                   (SD_cs),
		.SD_datain               (SD_datain),		
		.SD_dataout              (SD_dataout),		
						
		.clk                     (clk),    
        .wrsig                   (wrsig),                //uart ���͵�������Ч  
        .dataout                 (txdata)	             //uart ���͵����ݣ�һ���ֽ� 
	
 );
   
  
  
endmodule

