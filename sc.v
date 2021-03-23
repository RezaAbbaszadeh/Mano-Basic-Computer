// sequence counter
module sc(input clk, reset, output reg[2:0] counter);
	 
	always@(posedge clk)
	begin
		if(reset)
			counter <= 0;
		else 
			counter <= counter+1;
	end	
			
endmodule

