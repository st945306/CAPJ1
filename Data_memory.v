module Data_memory(
	clk_i,
	Address_i,
	WriteData_i,
	MemWrite_i,
	MemRead_i,
	data_o
);
	input clk_i, MemWrite_i, MemRead_i;
	input [31:0] Address_i, WriteData_i;
	output reg	[31:0] data_o;
	
	reg [7:0] memory [0:31];

always @(posedge clk_i) begin
	if(MemWrite_i)begin
		memory[Address_i] = WriteData_i[7:0];
		memory[Address_i + 1] = WriteData_i[15:8];
		memory[Address_i + 2] = WriteData_i[23:16];
		memory[Address_i + 3] = WriteData_i[31:24];		
	end
end

always@(*)begin
	if(MemRead_i)begin
		data_o = {
		    memory[Address_i + 3],
        	memory[Address_i + 2],
        	memory[Address_i + 1],
        	memory[Address_i]
    	};
	end
end

endmodule