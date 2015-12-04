module Eq(
 	data1_i,
	data2_i,
	data_o 
);

input [31:0]   data1_i;
input [31:0]   data2_i;
output reg     data_o ;

always@(data1_i or data2_i) begin
	if(data1_i == data2_i) begin
		data_o  = 1'b1;
	end
	else begin
		data_o  = 1'b0;
	end
end

endmodule
