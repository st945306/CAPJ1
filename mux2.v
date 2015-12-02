module mux2(
	branchAddr_i, 
	inst_i,
	pc_4_i,		 	  
	jump_i,
	data_o   
);

input	[31:0]		pc_4_i;
input	[31:0]		branchAddr_i;
input	[25:0]		inst_i;
input				jump_i;
output reg [31:0]	data_o;
reg		[31:0]		tmp;

tmp={pc_4_i[31:28],inst_i,2'b00};

always@(*)begin
	if(jump_i)
		data_o = tmp;
	else
		data_o = branchAddr_i;
end

endmodule