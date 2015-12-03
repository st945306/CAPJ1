module mux2(
	branchAddr_i, 
	inst_i,	 	  
	jump_i,
	data_o   
);

input	[31:0]		branchAddr_i;
input	[31:0]		inst_i;
input				jump_i;
output reg [31:0]	data_o;

always@(branchAddr_i or inst_i or jump_i)begin
	if(jump_i==1'b1) begin
		data_o = inst_i;
	end
	else begin
		data_o = branchAddr_i;
	end
end

endmodule