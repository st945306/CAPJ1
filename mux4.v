module mux4(
	data1_i,
	data2_i,
	ALUSrc_i,
	data_o
);

input	[31:0]		data1_i;			
input	[31:0]		data2_i;
input				ALUSrc_i;
output reg	[31:0]	data_o;		

always@(*)begin
	if(ALUSrc_i)
		data_o = data1_i;
	else
		data_o = data2_i;
end	

endmodule