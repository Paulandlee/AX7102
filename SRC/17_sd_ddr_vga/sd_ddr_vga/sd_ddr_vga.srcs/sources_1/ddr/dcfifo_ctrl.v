`timescale 1 ns / 1 ns
module dcfifo_ctrl
(
	//global clock
	input				    clk_ref,		      //ȫ��ʱ��
	input 			        clk_write,		      //fifoд����ʱ��
	input				    clk_read,		      //fifo������ʱ��
	input 			        rst_n,			      //ȫ�ָ�λ
	
	//burst length
	input		[9:0]	 	wr_length,		      //ddr��ͻ������
	input		[9:0]	 	rd_length,		      //ddrдͻ������
	input		[28:0]   	wr_addr,		      //ddrд��ַ
	input		[28:0]   	wr_max_addr,	      //ddr���д��ַ
	input		[28:0]   	rd_addr,		      //ddr����ַ
	input		[28:0] 	    rd_max_addr,	      //ddr������ַ	
	input				 	rd_load,		      //ddr����ַ������λ
   input				 	wr_load,		      //ddrд��ַ������λ
	
	//wrfifo:  fifo 2 ddr
	input 			 	   wrf_wrreq,		      //д��ddr���ݻ���fifo��������,��Ϊfifoд�ź�
	input		[255:0]    wrf_din,		         //д��ddr���ݻ���fifoд�����ߣ�д��sdram���ݣ�
	output 	reg	 	       ddr_wr_req,	         //д��ddr�����ź�
	input 			 	   ddr_wr_ack,	         //д��ddr��Ӧ�ź�,��Ϊfifo���ź�
	output	    [255:0]    ddr_din,		         //д��ddr���ݻ���fifo�����������
	output	reg	[28:0] 	   ddr_wraddr,	        //д��ddrʱ��ַ�ݴ���
    input                  ddr_wr_finish,       //д��ddr�������
	
	//rdfifo: sdram 2 fifo
	input 				   rdf_rdreq,		      //��ȡddr���ݻ���fifo�������
	output	    [255:0]    rdf_dout,		      //��ȡddr���ݻ���fifo������ߣ���ȡsdram���ݣ�
	output 	reg			   ddr_rd_req,	          //��ȡddr�����ź�
	input 				   ddr_rd_ack,	          //��ȡddr��Ӧ�ź�,��Ϊfifo����д��Ч�ź�
	input		[255:0]    ddr_dout,		      //��ȡddr���ݻ���fifo��������
	output	reg	[28:0] 	   ddr_rdaddr,	          //��ȡddrʱ��ַ�ݴ�����{bank[1:0],row[11:0],column[7:0]} 
   input                   ddr_rd_finish,         //��ddr�������
	
	//sdram address control	
	input				   ddr_init_done,	       //ddr��ʼ������ź�
	output	reg		       frame_write_done,	   //ddr write one frame
	output	reg		       frame_read_done,	       //ddr read one frame
	input 				   data_valid,			   //ʹ��sdram�����ݵ�Ԫ����Ѱַ���ַ����
	input                  pic_read_done
	
);


//------------------------------------------------
//?ͬ��sdram��д��ַ��ʼֵ��λ�ź�
reg	wr_load_r1, wr_load_r2;	
reg	rd_load_r1, rd_load_r2;	
always@(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		wr_load_r1 <= 1'b0;
		wr_load_r2 <= 1'b0;
		rd_load_r1 <= 1'b0;
		rd_load_r2 <= 1'b0;
		end
	else
		begin
		wr_load_r1 <= wr_load;
		wr_load_r2 <= wr_load_r1;
		rd_load_r1 <= rd_load;
		rd_load_r2 <= rd_load_r1;
		end
end
wire	wr_load_flag = ~wr_load_r2 & wr_load_r1;	//��ַ���������ر�־λ
wire	rd_load_flag = ~rd_load_r2 & rd_load_r1;	//��ַ���������ر�־λ

//------------------------------------------------
//ͬ�� ��дddr��Ч�ź�
reg	data_valid_r;
always@(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n) 
		data_valid_r <= 1'b0;
	else 
		data_valid_r <= data_valid;
end

//------------------------------------------------
//ddrд��ַ����ģ�飨���ȣ�
always @(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		ddr_wraddr <= 29'd0;	
		frame_write_done <= 1'b0;
		end			
	else if(wr_load_flag)						//����ddrд�����ַ
		begin
		ddr_wraddr <= wr_addr;	
		frame_write_done <= 1'b0;	
		end
	else if(ddr_wr_finish)						//ͻ��д�����
		begin
		if(ddr_wraddr < wr_max_addr - wr_length)
			begin
			ddr_wraddr <= ddr_wraddr + wr_length;   //ddr�ĵ�ַ����
			frame_write_done <= 1'b0;
			end
		else
			begin
			ddr_wraddr <= ddr_wraddr;		//��ֹ����������ַ
			frame_write_done <= 1'b1;
			end
		end
	else
		begin
		ddr_wraddr <= ddr_wraddr;			//�����ַ
		frame_write_done <= frame_write_done;
		end
end

//------------------------------------------------
//ddr����ַ����ģ��(���)
always @(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		ddr_rdaddr <= 29'd0;
		frame_read_done <= 0;
		end
	else if(rd_load_flag)						//����ddr��ȡ����ַ
		begin
		ddr_rdaddr <= rd_addr;
		frame_read_done <= 0;
		end
	else if(~data_valid_r)						//��ʾ��Ч��
		begin
		ddr_rdaddr <= rd_addr;
		frame_read_done <= 0;
		end
	else if(ddr_rd_finish)						//ͻ��д�����
		begin
		if(ddr_rdaddr < rd_max_addr - rd_length)
			begin
			ddr_rdaddr <= ddr_rdaddr + rd_length;
			frame_read_done <= 0;
			end
		else
			begin
			ddr_rdaddr <= ddr_rdaddr;		//��ֹ����������ַ
			frame_read_done <= 1;
			end
		end
	else
		begin
		ddr_rdaddr <= ddr_rdaddr;			//�����ַ
		frame_read_done <= frame_read_done;
		end
end


//-------------------------------------
//ddr ��д�źŲ���ģ��
wire	[9:0] 	wrf_use;
wire	[9:0] 	rdf_use;
always@(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)	
		begin
		ddr_wr_req <= 0;
		ddr_rd_req <= 0;
		end
	else if(ddr_init_done == 1'b1)
		begin						      //д�����ȣ������ڷ�ֹ���ݶ�ʧ
		if(wrf_use >= wr_length)	//д��FIFO��������������burst����,дDDR��ʼ	       
			begin					      //wrfifo��ͻ������
			ddr_wr_req <= 1;		//дddrʹ��
			ddr_rd_req <= 0;		//��ddr����
			end
		else if(rdf_use < rd_length && data_valid_r == 1'b1 && pic_read_done ==1'b1)//��FIFO�����������С��burst����,��DDR��ʼ	
			begin					//rdfifo��ͻ������
			ddr_wr_req <= 0;		//дddr����
			ddr_rd_req <= 1;		//��ddrmʹ��
			end
		else
			begin
			ddr_wr_req <= 0;		//дddr����
			ddr_rd_req <= 0;		//��ddr����
			end
		end
	else
		begin
		ddr_wr_req <= 0;			//дddr����
		ddr_rd_req <= 0;			//��ddr����
		end
end

//------------------------------------------------
//����ddrд�����ݻ���fifoģ��
wrfifo	u_wrfifo
(
	.rst		    (~rst_n ),			//wrfifo�첽�����źţ�����Ҫ��| wr_load_flag
	//input 2 fifo
	.wr_clk		    (clk_write),		//wrfifoдʱ��
	.wr_en		    (wrf_wrreq),		//wrfifoдʹ���ź�
	.din		    (wrf_din),			//wrfifo������������
	//fifo 2sdram
	.rd_clk		    (clk_ref),			//wrfifo��ʱ��100MHz
	.rd_en		    (ddr_wr_ack),		//wrfifo��ʹ���ź�
	.dout			(ddr_din),		//wrfifo�����������
	//user port
   .full            (), // output full
   .empty           (), // output empty
   .rd_data_count	(wrf_use),			//wrfifo�洢��������
   .wr_data_count	()			
);	


//------------------------------------------------
//����ddr�������ݻ���fifoģ��
rdfifo	u_rdfifo
(
	.rst		    (~rst_n | ~data_valid_r | rd_load_flag),		//rdfifo�첽�����ź�   
	//sdram 2 fifo
	.wr_clk		    (clk_ref),       	//rdfifoдʱ��
	.wr_en		    (ddr_rd_ack),  	//rdfifoдʹ���ź�
	.din		    (ddr_dout),  		//rdfifo������������
	//fifo 2 output 
	.rd_clk		    (clk_read),         //rdfifo��ʱ��50MHz
	.rd_en		    (rdf_rdreq),     	//rdfifo��ʹ���ź�
	.dout			(rdf_dout),			//rdfifo�����������
	//user port
	.full           (), // output full
    .empty(), // output empty
	.rd_data_count	(),                //rdfifo�洢��������
	.wr_data_count	(rdf_use)          //rdfifo�洢��������
);


endmodule
