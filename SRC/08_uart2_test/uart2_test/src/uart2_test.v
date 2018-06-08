`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    uart2_test 
// decription: test the RS232 
//////////////////////////////////////////////////////////////////////////////////
module uart2_test(
         input sys_clk_p,                      // �������ϲ������ʱ��P: 200Mhz
         input sys_clk_n,                      // �������ϲ������ʱ��N: 200Mhz
         input uart2_rx,                       // �������ݽ���
         output uart2_tx);                     // �������ݷ���

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

wire clk;       //clock for 9600 uart port
wire [7:0] txdata,rxdata;     //���ڷ������ݺʹ��ڽ�������



//����ʱ�ӵ�Ƶ��Ϊ16*9600
clkdiv u0 (
		.clk200                  (sys_clk_ibufg),       //200Mhz�ľ�������                     
		.clkout                  (clk)                  //16�������ʵ�ʱ��                        
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
		.clk                     (clk),                           
		.rdsig                   (rdsig),                //uart ���յ�������Ч   
        .rxdata                  (rxdata), 		         //uart ���յ������� 
        .wrsig                   (wrsig),                //uart ���͵�������Ч  
        .dataout                 (txdata)	             //uart ���͵����ݣ�һ���ֽ� 
	
 );
 

endmodule

