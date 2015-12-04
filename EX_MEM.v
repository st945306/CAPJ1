module EX_MEM(
	clk_i,
	rst_i,
    WB_i, 
    M_i,
    ALUResult_i, 
    mux7_i,
   	mux3_i, 
    
    WB_o,
    MemRead_o,
    MemWrite_o,
    Address_o,
	Write_data_o,
	mux3_result_o
);

	input clk_i, rst_i;
	input [1:0] WB_i, M_i;
	input [31:0] ALUResult_i, mux7_i; 
	input [4:0] mux3_i; 
    
	output reg[1:0] WB_o;
	output reg MemRead_o, MemWrite_o;
	output reg[31:0] Address_o, Write_data_o; 
	output reg[4:0] mux3_result_o; 
	
	
	always@(posedge clk_i)begin
			WB_o <= WB_i;
			MemRead_o <= M_i[0:0];
			MemWrite_o <= M_i[1:1];			
			Address_o <= ALUResult_i;
			Write_data_o <= mux7_i;
			mux3_result_o <= mux3_i;
	end
endmodule