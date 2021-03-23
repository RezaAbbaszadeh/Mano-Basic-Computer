
module Data_path(
	input clk , input[2:0] bus_select ,
	input ar_load , ar_inc , ar_clr,
	input pc_load , pc_inc , pc_clr,
	input dr_load , dr_inc , dr_clr,
	input ac_load , ac_inc , ac_clr,
	input[2:0] alu_opcode,
	input ir_load,
	input tr_load , tr_inc , tr_clr,
	input outr_load,
	input mem_read,mem_write,

output wire[15:0] ir_out,
output wire[15:0] dr_out,
output wire[15:0] ac_out,
output wire E_out
	
	);
	
	wire[15:0] bus_out;
	wire[11:0] ar_out;
	wire[11:0] pc_out = 12'h0;
	
	

	wire[15:0] alu_out;
	wire alu_out_e;

	
	wire[7:0] inpr_out;
	
	wire[15:0] tr_out;
	wire[7:0] outr_out;
	wire[15:0] mem_out;


	Bus bus(bus_select,ar_out , pc_out,dr_out,ac_out,ir_out,tr_out,mem_out, bus_out);
	
	register #(.n(12)) ar(.load(ar_load) , .inc(ar_inc) , .clr(ar_clr) , .clk(clk) , .in_data(bus_out) , .out_data(ar_out));
	register #(.n(12)) pc(.load(pc_load) , .inc(pc_inc) , .clr(pc_clr) , .clk(clk) , .in_data(bus_out) , .out_data(pc_out));
	register #(.n(16)) dr(.load(dr_load) , .inc(dr_inc) , .clr(dr_clr) , .clk(clk) , .in_data(bus_out) , .out_data(dr_out));
	register #(.n(16)) ac(.load(ac_load) , .inc(ac_inc) , .clr(ac_clr) , .clk(clk) , .in_data(alu_out) , .out_data(ac_out));
	register #(.n(1)) E(.load(E_load), .clk(clk) , .in_data(alu_out_e) , .out_data(E_out));	
	alu alu(alu_opcode, ac_out, dr_out, inpr_out, E_out,alu_out , alu_out_e);
	register #(.n(16)) ir(.load(ir_load) , .clk(clk) , .in_data(bus_out) , .out_data(ir_out));
	register #(.n(16)) tr(.load(tr_load) , .inc(tr_inc) , .clr(tr_clr) , .clk(clk) , .in_data(bus_out) , .out_data(tr_out));
	register #(.n(8)) outr(.load(outr_load) , .clk(clk) , .in_data(bus_out) , .out_data(outr_out));

	memory mem (mem_read, mem_write, ar_out, bus_out, mem_out);
	
endmodule