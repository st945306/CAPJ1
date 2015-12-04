module Control(
	Op_i,
	Branch_o,
	Jump_o,
	Mux8_o
);

input		[5:0]    Op_i;
output reg	         Branch_o,Jump_o;
output reg 	[7:0]    Mux8_o;

//WB
// Mux8_o[0] is RegWrite
// Mux8_o[1] is MemtoReg
//M
// Mux8_o[2] is MemRead
// Mux8_o[3] is MemWrite
//EX
// Mux8_o[4] is ALUSrc
// Mux8_o[5][6] is ALUOp 2 bit
// Mux8_o[7] is RegDst

always@(*) begin
	Branch_o = 0;
	Jump_o = 0;
	//r-type
	if(Op_i == 6'b000000) begin
		Mux8_o[0] = 1;
		Mux8_o[1] = 0;
		Mux8_o[2] = 0;
		Mux8_o[3] = 0;
		Mux8_o[4] = 1;
		Mux8_o[6:5] = 2'b10;
		Mux8_o[7] = 0;
	end
	// addi
	else if(Op_i == 6'b001000) begin
		Mux8_o[0] = 1;
		Mux8_o[1] = 0;
		Mux8_o[2] = 0;
		Mux8_o[3] = 0;
		Mux8_o[4] = 0;
		Mux8_o[6:5] = 2'b00;
		Mux8_o[7] = 1;
	end
	// sw
	else if(Op_i == 6'b101011) begin 
		Mux8_o[0] = 0;
		Mux8_o[1] = 0;
		Mux8_o[2] = 0;
		Mux8_o[3] = 1;
		Mux8_o[4] = 0;
		Mux8_o[6:5] = 2'b00;
		Mux8_o[7] = 1; 
	end
	// lw
	else if(Op_i == 6'b100011) begin 
		Mux8_o[0] = 1;
		Mux8_o[1] = 1;
		Mux8_o[2] = 1;
		Mux8_o[3] = 0;
		Mux8_o[4] = 0;
		Mux8_o[6:5] = 2'b00;
		Mux8_o[7] = 1; 
	end
	// jump
	else if(Op_i == 6'b000010) begin 
		Jump_o = 1;
		Mux8_o[0] = 0;
		Mux8_o[1] = 0;
		Mux8_o[2] = 0;
		Mux8_o[3] = 0;
		Mux8_o[4] = 0;
		Mux8_o[6:5] = 2'b00;
		Mux8_o[7] = 0; 
	end
	// beq
	else if(Op_i == 6'b000100) begin 
		Branch_o = 1;
		Mux8_o[0] = 0;
		Mux8_o[1] = 0;
		Mux8_o[2] = 0;
		Mux8_o[3] = 0;
		Mux8_o[4] = 0;
		Mux8_o[6:5] = 2'b00;
		Mux8_o[7] = 0; 
	end
end

endmodule