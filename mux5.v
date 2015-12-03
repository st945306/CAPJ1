module mux5(
	MemtoReg_i,
	data1_i,
	data2_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input				MemtoReg_i;
output reg [31:0]	data_o;

always@(MemtoReg_i or data1_i or data2_i)begin
	if(MemtoReg_i == 1'b1) begin
		data_o = data1_i;
	end
	else begin
		data_o = data2_i;
	end
end

endmodule
