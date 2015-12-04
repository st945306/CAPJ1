module ID_EX(
	clk_i,
	rst_i,
	WB_i, 
	M_i, 
	EX_i, 
	
	data1_i, //what for?
	
	readData1_i, 
	readData2_i,
	sign_extend_i, 
	inst25_21_i,
	inst20_16_i, 
	inst15_11_i,

	WB_o, 
	M_o, 
	EX1_o,
	EX2_o,
	EX3_o,
	data1_o, 
	data2_o, 
	sign_extend_o, 
	inst25_21_o, 
	inst20_16_o, 
	inst15_11_o
);

	input rst_i, clk_i;
	input [1:0] WB_i,M_i;
	input [3:0] EX_i; 
	input [31:0] data1_i, readData1_i, readData2_i, sign_extend_i;
	input [4:0] inst25_21_i, inst20_16_i, inst15_11_i;
			   
	output reg[1:0] WB_o, M_o, EX2_o;
	output reg EX1_o, EX3_o;
	output reg[31:0] data1_o, data2_o, sign_extend_o; 
	output reg[4:0] inst25_21_o, inst20_16_o, inst15_11_o;

	
	always@(posedge clk_i)begin
			WB_o <= WB_i;
			M_o <= M_i;
			EX1_o <= EX_i[3:3];
			EX2_o <= EX_i[2:1];
			EX3_o  <=  EX_i[0:0];
			data1_o <= readData1_i;
			data2_o <= readData2_i;
			sign_extend_o <= sign_extend_i;
			inst25_21_o = inst25_21_i; 
			inst20_16_o = inst20_16_i; 
			inst15_11_o = inst15_11_i;
	end
endmodule