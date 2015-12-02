module mux8(
	.HD_i		
	.Control_i		
	.data_o
);

input 				HD_i;
input	[7:0]		.Control_i;
output	reg [7:0]	data_o;

always@(*)begin
	if(HD_i)begin
		data_o = 7'b0;
	end
	else begin 
		data_o = Control_i;
	end
end

endmodule