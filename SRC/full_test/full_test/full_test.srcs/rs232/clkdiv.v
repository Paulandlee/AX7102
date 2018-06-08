`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    clkdiv
// ����һ��������9600��16��Ƶ��ʱ�ӣ�9600*16= 153600
// �൱��200MHz��326��Ƶ��200000000/153600=1302
//////////////////////////////////////////////////////////////////////////////////
module clkdiv(clk200, clkout1,clkout2);
input clk200;              //ϵͳʱ��
output clkout1;          //����ʱ�����
output clkout2;
reg clkout2;
reg [15:0] cnt;

//��Ƶ����,��200Mhz��ʱ��1302��Ƶ
always @(posedge clk200)   
begin
  if(cnt == 16'd560)
  begin
    clkout2 <= 1'b1;
    cnt <= cnt + 16'd1;
  end
  else if(cnt == 16'd1301)
  begin
    clkout2 <= 1'b0;
    cnt <= 16'd0;
  end
  else
  begin
    cnt <= cnt + 16'd1;
  end
end

pll_sd pll_sd_inst
(
	.clk_in1	    (clk200),
	.reset	        (1'b0),
	.locked	        (),
			
	.clk_out1		(clkout1)          //65Mhz	


);

endmodule
