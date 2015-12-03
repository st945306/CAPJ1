module mux1(
	Eq_i,	
	Branch_i,	
	Add_pc_i,	
	ADD_i,
	data_o
);

input   [31:0]		Add_pc_i;
input   [31:0]		ADD_i;
input				Eq_i;
input				Branch_i;
output reg [31:0]	data_o;

always@(Eq_i or Branch_i or Add_pc_i or ADD_i) begin
	if( (Eq_i&Branch_i) ==1'b1) begin
		data_o = ADD_i;
	end
	else begin
		data_o = Add_pc_i;
	end
end

endmodule