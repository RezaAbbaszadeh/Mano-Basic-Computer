module testbench();

reg clk;
BC bs(clk);



initial 
 begin

	force bs.cu.reset_sc = 1;
	bs.cu.ien = 1;
	bs.cu.R = 0;
	bs.cu.S = 1;

	//This lines compute 4*5 and save in mem_array[62]
	bs.dp.mem.mem_array[12'd50] = 16'h203C;//LDA 60
	bs.dp.mem.mem_array[12'd51] = 16'h5046;//BSA 70 (Call subroutine)
	bs.dp.mem.mem_array[12'd52] = 16'h7800;//CLA
	bs.dp.mem.mem_array[12'd53] = 16'h103D;//ADD 61
	bs.dp.mem.mem_array[12'd54] = 16'h603C;//ISZ 60
	bs.dp.mem.mem_array[12'd55] = 16'h4035;//BUN 53
	bs.dp.mem.mem_array[12'd56] = 16'h303E;//STA RES
	bs.dp.mem.mem_array[12'd57] = 16'h7001;//HLT
	bs.dp.mem.mem_array[12'd60] = 16'D5;
	bs.dp.mem.mem_array[12'd61] = 16'D4;
	bs.dp.mem.mem_array[12'd62] = 16'hZ;

	//Subroutine to calculate 2's complement of AC
	bs.dp.mem.mem_array[12'd71] = 16'h7200;//CMA
	bs.dp.mem.mem_array[12'd72] = 16'h7020;//INC
	bs.dp.mem.mem_array[12'd73] = 16'h303C;//STA 60
	bs.dp.mem.mem_array[12'd74] = 16'hC046;//BUN 70 Indirect
	

	//Interrupt Service(Puts INPR to OUTR)
	bs.dp.mem.mem_array[1] = 16'hf200; //SKI
	bs.dp.mem.mem_array[2] = 16'h4005; //BUN
	bs.dp.mem.mem_array[3] = 16'h3015; //STA h'15
	bs.dp.mem.mem_array[4] = 16'hf800; //INP
	bs.dp.mem.mem_array[5] = 16'hf400; //OUT
	bs.dp.mem.mem_array[6] = 16'h2015; //LDA h'15
	bs.dp.mem.mem_array[7] = 16'hf080; //ION
	bs.dp.mem.mem_array[8] = 16'hc000; //BUN I

 end
  
  
  
always @(posedge clk)
 begin

	if(bs.cu.S==0)
		$stop;
 end

  
  
initial 
 begin

	#80
	force bs.cu.reset_sc = 0;
	bs.dp.pc.tmp = 12'D50;
	force bs.dp.pc_out = bs.dp.pc.tmp;

	#20
	release bs.cu.reset_sc;

	//Interrupt
	#980
	bs.cu.fgi = 1'b1;
	force bs.dp.inpr_out = 8'h44;

 end
  

  

initial 
 begin 
    clk = 0;
    forever 
	 begin
		#50 clk = ~clk;
	 end 
 end

endmodule