module mux2(
	branchAddr_i, 
	inst_i,	 	  
	jump_i,
	data_o   
);

input	[31:0]		branchAddr_i;
input	[31:0]		inst_i;
input			jump_i;
output reg [31:0]	data_o;

always@(*)begin
	if(jump_i)
		data_o = inst_i;
	else
		data_o = branchAddr_i;
end

endmodule