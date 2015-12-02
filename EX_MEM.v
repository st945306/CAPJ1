module EX_MEM(
	clk,
    //reset,
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

	input clk;
    input rst;
    input [1:0] WB_i, M_i;
    input [31:0] ALUResult_i, mux7_i; 
    input [4:0] mux3_i; 
    
    output reg[1:0] WB_o;
    output reg MemRead, MemWrite;
    output reg[31:0] Address_o, Write_data_o; 
    output reg[4:0] mux3_result_o; 
	
	always@(posedge rst)begin
		WB_o = 0;
		MemRead = 0;
		MemWrite = 0;		
		Address_o = 0;
		Write_data_o = 0;
		mux3_result_o = 0;
	end
	
	always@(posedge clk)begin
			WB_o <= WB_i;
			MemRead <= M_i[0];
			MemWrite <= M_i[1];			
			Address_o <= ALUResult_i;
			Write_data_o <= mux7_i;
			mux3_result_o <= mux3_i;
	end
endmodule