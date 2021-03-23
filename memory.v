
module memory(input read , input write ,input[11:0] address, input[15:0] in , output[15:0] out);

reg[15:0] mem_array [0:4095];



assign out = (read==1 && write==0)? mem_array[address] : 16'hz;


always @(posedge write  or  negedge read  or  address  or  in)
begin
    if (write && !read)
        mem_array[address] = in;
end


endmodule
