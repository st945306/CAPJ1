module  mux3(
	.RegDst_i,
	.data1_i,
	.data2_i,
	.data_o
);

input   [4:0]  data1_i, data2_i;
input	RegDst_i;

output  [4:0]  data_o;

always@(data1_i or data2_i or RegDst_i) begin
	if(select_i == 1'b1) begin
		data_o = data1_i;
	end
	else begin
		data_o = data2_i;
	end
end

endmodule