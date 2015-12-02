module HD(
	inst20_16_i,
 	inst_i,
	MemRead_i,
    	IF_ID_o,
    	PC_o,
    	mux8_o
);

input [4:0] inst20_16_i; 
input [31:0] inst_i;
input MemRead_i;
output reg IF_ID_o, PC_o, mux8_o;

always @(*) begin
	IF_ID_o = 1'b0;
	PC_o = 1'b0;
	mux8_o = 1'b0;
	if ((inst_i[25:21] == inst20_16_i
		|| inst_i[20:16] == inst20_16_i) && MemRead_i) begin
		IF_ID_o = 1'b1;
		PC_o = 1'b1;
		mux8_o = 1'b1;
	end
end
endmodule
