module Ctrl_unit(input clk , input[15:0] ir , input[15:0] dr , input[15:0] ac , input e ,

output wire[2:0] bus_select,
output wire ar_load , ar_inc , ar_clr,
output wire pc_load , pc_inc , pc_clr,
output wire dr_load , dr_inc , dr_clr,
output wire ac_load , ac_inc , ac_clr,
output wire[2:0] alu_opcode,
output wire ir_load,
output wire tr_load , tr_inc , tr_clr,
output wire outr_load,
output wire mem_read,mem_write
);

wire I = ir[15];
wire[2:0] opcode = ir[14:12];
wire[11:0]address = ir[11:0];
wire D[7:0];
wire T[7:0];
wire[2:0] counter ;
wire reset_sc;
reg R;
reg fgi,fgo,ien;
reg S;

assign D[0] = (opcode==0)? 1 : 0;
assign D[1] = (opcode==1)? 1 : 0;
assign D[2] = (opcode==2)? 1 : 0;
assign D[3] = (opcode==3)? 1 : 0;
assign D[4] = (opcode==4)? 1 : 0;
assign D[5] = (opcode==5)? 1 : 0;
assign D[6] = (opcode==6)? 1 : 0;
assign D[7] = (opcode==7)? 1 : 0;

sc sc(clk , reset_sc , counter);
assign T[0] = (counter==0)? 1 : 0;
assign T[1] = (counter==1)? 1 : 0;
assign T[2] = (counter==2)? 1 : 0;
assign T[3] = (counter==3)? 1 : 0;
assign T[4] = (counter==4)? 1 : 0;
assign T[5] = (counter==5)? 1 : 0;
assign T[6] = (counter==6)? 1 : 0;
assign T[7] = (counter==7)? 1 : 0;



wire r = D[7]& (~I) & T[3];
wire p = D[7]& I & T[3];

assign bus_select = ((~R)&T[0] |D[5]&T[4] | R&T[0])? 3'h2:
	(mem_read)? 3'h7:
	((~R)&T[2])? 3'h5:
	((D[3]&T[4]) |(p & address[10]))? 3'h4:
	((D[4]&T[4]) | (D[5]&T[5]))? 3'h1:
	(R&T[1])? 3'h6:
	(D[6]&T[6])? 3'h3:
	3'h0;


assign ar_load = (~R)&T[0] | (~R)&T[2] | ((~D[7])&I& T[3]) ;
assign ar_inc = (D[5]&T[4]) ;
assign ar_clr = R&T[0];

assign pc_load = D[4]&T[4] | D[5]&T[5];
assign pc_inc = (~R)&T[1] | D[6]&T[6]&(dr==0) | r&address[4]&(~ac[15]) |
		r&address[3]&ac[15] | r&address[2]&(ac==0) |
		r&address[1]&(~e) | p&address[9]&fgi | p&address[8]&fgo |
		R&T[2];
assign pc_clr = R&T[1];

assign dr_load = (D[0]|D[1]|D[2])&T[4] | D[6]&T[4];
assign dr_inc = D[6]&T[5];
assign dr_clr = 1'b0;

assign ac_load = (alu_opcode!=0);
assign ac_inc = (r&address[5]);
assign ac_clr = r&address[11];

assign alu_opcode = (D[0]&T[5])? 3'h1 : (D[1]&T[5])? 3'h2 : (D[2]&T[5])? 3'h3:
		(p&address[11])? 3'h4 : (r&address[9])? 3'h5 : (r&address[7])? 3'h6:
		(r&address[6])? 3'h7 : 0;

assign ir_load = T[1] ;

assign tr_load = R&T[0];
assign tr_inc = 1'b0;
assign tr_clr = 1'b0;

assign outr_load = p&address[10];

assign mem_read = ((D[0]|D[1]|D[2]|D[6])&T[4]) | (~R)&T[1] | (~D[7])&I&T[3];
assign mem_write = (D[3]|D[5])&T[4] | D[6]&T[6] | R&T[1];

assign reset_sc = T[4]&(D[3]|D[4]) | T[5]&(D[0]|D[1]|D[2]|D[5]) | D[6]&T[6] | r | p | R&T[2];


always @(posedge clk)
begin

	if(R&T[2] | p&address[6])
		ien = 0;
	if(p&address[7])
		ien =1;
	if(p&address[11])
		fgi =0;
	if(p&address[10])
		fgo =0;
	if((~T[0])&(~T[1])&(~T[2])&ien&(fgo|fgi))
		R = 1;
	if(R&T[2])
		R=0;
	if(r & address[0])
		S=0;

end

endmodule
