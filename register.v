module register #(parameter n=16)
	(
    input inc,load,clr,clk,
    input [n-1:0] in_data,
    output [n-1:0] out_data
    );
	
	reg [n-1:0] tmp;
	assign out_data = tmp;

	always@(posedge clk)
		if(clr)
			tmp <= 0;
		else if(inc)
			tmp <= tmp + 1;
		else if(load)
			tmp <= in_data;
			
	


endmodule

/*
module register #(parameter n=16)
	(
    input inc,load,clr,clk,
    input [n-1:0] in_data,
    output reg[n-1:0] out_data
    );
	
	//reg [n-1:0] tmp;
	//assign out_data = tmp;

	always@(posedge clk)
		if(clr)
			out_data <= 0;
		else if(inc)
			out_data <= out_data + 1;
		else if(load)
			out_data <= in_data;
			
	


endmodule*/


