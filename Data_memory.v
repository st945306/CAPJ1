module Data_memory(
	Address_i,
	WriteData_i,
	MemWrite_i,
	MemRead_i,
	data_o
);
	input MemWrite_i, MemRead_i;
	input [31:0] Address_i, WriteData_i;
	output reg	[31:0] data_o;
	
	reg [7:0] memory [0:31];


always@(Address_i or WriteData_i or MemWrite_i or MemRead_i)begin
	if(MemRead_i)begin
		data_o <= {
		    memory[Address_i + 3],
        	memory[Address_i + 2],
        	memory[Address_i + 1],
        	memory[Address_i]
    	};
	end
	else if(MemWrite_i)begin
		memory[Address_i + 3] <= WriteData_i[31:24];
		memory[Address_i + 2] <= WriteData_i[23:16];
		memory[Address_i + 1] <= WriteData_i[15:8];
		memory[Address_i] <= WriteData_i[7:0];				
	end
	else begin
		data_o <= 32'bx;
	end
end

endmodule