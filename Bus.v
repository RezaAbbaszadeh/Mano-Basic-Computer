
module Bus(input[2:0] select , input[15:0] in1 , 
		input[15:0] in2 , input[15:0] in3 , input[15:0] in4 ,
		 input[15:0] in5 , input[15:0] in6 , input[15:0] in7 ,
		 output [15:0] out);

reg[15:0] tmp = 0;

always @*
begin

case(select)
		
	1: tmp<= in1; 
	2: tmp<= in2; 
	3: tmp<= in3; 
	4: tmp<= in4; 
	5: tmp<= in5; 
	6: tmp<= in6; 
	7: tmp<= in7; 
	default: tmp<= 16'hz;
	 		
endcase

end

assign out = tmp;



endmodule
