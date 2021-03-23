
module alu(
		input [2:0] opcode,
		input [15:0] ac,dr,
		input [7:0] inpr,
		input ei,
		output [15:0] res,
		output eo
    );
	 
	 reg [16:0] dat = 0;
	 assign eo = (opcode==3'b110) ? ac[0] : 
					 (opcode==3'b111) ? ac[15] :
					 dat[16];
					 
	 
	 always@*
		case(opcode)
		
		1 : dat <= ac & dr;
		2 : dat <= ac + dr;
		3 : dat <= dr;
		4 : dat <= inpr;
		5 : dat <= ~ac;
		6 : dat <= {{ei},{ac[15:1]}};	//shr
		7 : dat <= {{ac[14:0]},{ei}};	//shl
		default : dat <= 17'bz;
					 		
		endcase

	 assign res = dat[15:0];

endmodule



