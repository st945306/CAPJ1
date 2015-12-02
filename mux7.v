module mux7(
	data1_i,	// ID/EX's read data2
	data2_i,	// from mux5's result 
	data3_i,	// from EX's result
	fw_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[31:0]		data3_i;
input	[1:0]		fw_i;
output reg [31:0]	data_o;

always@(*)begin
	if(fw_i == 2'b00) begin
		data_o = data1_i;
	end
	else if(fw_i == 2'b01) begin 
		data_o = data2_i;
	end
	else if(fw_i == 2'b10) begin
		data_o = data3_i;
	end
	//special
	else begin
		data_o = data1_i;
	end
end

endmodule
