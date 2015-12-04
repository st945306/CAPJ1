module mux8(
	HD_i,		
	Control_i,		
	data_o
);

input 				HD_i;
input	[7:0]		Control_i;
output	reg [7:0]	data_o;

always@(HD_i or Control_i)begin
	if(HD_i==1'b1) begin
		data_o = 8'b0;
	end
	else begin 
		data_o = Control_i;
	end
end

endmodule
