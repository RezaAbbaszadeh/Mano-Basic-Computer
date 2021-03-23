
module BC(input clk);

wire[2:0] bus_select;
wire ar_load , ar_inc , ar_clr;
wire pc_load , pc_inc , pc_clr;
wire dr_load , dr_inc , dr_clr;
wire ac_load , ac_inc , ac_clr;
wire[2:0] alu_opcode;
wire ir_load;
wire tr_load , tr_inc , tr_clr;
wire outr_load;
wire mem_read,mem_write;


wire[15:0] ir_out;
wire[15:0] dr_out;
wire[15:0] ac_out;
wire E_out;

wire fgi , fgo , ien;


Data_path dp(clk,bus_select ,ar_load , ar_inc , ar_clr,
pc_load , pc_inc , pc_clr,
dr_load , dr_inc , dr_clr,
ac_load , ac_inc , ac_clr,
alu_opcode,
ir_load,
tr_load , tr_inc , tr_clr,
outr_load,
mem_read,mem_write,


ir_out,
dr_out,
ac_out,
E_out 
);


Ctrl_unit cu(clk,ir_out,
dr_out,
ac_out,
E_out ,


bus_select ,ar_load , ar_inc , ar_clr,
pc_load , pc_inc , pc_clr,
dr_load , dr_inc , dr_clr,
ac_load , ac_inc , ac_clr,
alu_opcode,
ir_load,
tr_load , tr_inc , tr_clr,
outr_load,
mem_read,mem_write
);




endmodule