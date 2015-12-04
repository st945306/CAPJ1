module MEM_WB(
	clk_i,
	rst_i,
	WB_i,
	ReadData_i,
	ALU_i,
	mux3_i,

	MemtoReg_o,
	RegWrite_o,
	mux5_1_o,
	mux5_2_o,
	FW_o
);

	input clk_i, rst_i;
	input [1:0] WB_i;
	input [31:0] ReadData_i, ALU_i;
	input [4:0] mux3_i;

	output reg MemtoReg_o, RegWrite_o;
	output reg[31:0] mux5_1_o, mux5_2_o;
	output reg[4:0] FW_o;

	
	
	always@(posedge clk_i)begin
			RegWrite_o <= WB_i[0];
			MemtoReg_o <= WB_i[1];
			mux5_1_o <= ReadData_i;
			mux5_2_o <= ALU_i;
			FW_o <= mux3_i;
	end
endmodule