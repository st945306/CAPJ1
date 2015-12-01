module Control
(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);
input [5:0] Op_i;
output RegDst_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output RegWrite_o;

reg [4:0] out;
assign RegDst_o = out[0];
assign ALUOp_o = out[2:1];
assign ALUSrc_o = out[3];
assign RegWrite_o = out[4];

always @(Op_i) begin
    if (Op_i == 6'b000000) begin	//R-type
	out = 5'b10111;
    end
    else if (Op_i == 6'b001101) begin	//ori

    end
    else if (Op_i == 6'b001000) begin	//addi
	out = 5'b11000;
    end

    else if (Op_i == 6'b101011) begin	//sw
 
    end

    else if (Op_i == 6'b000100) begin	//beq

    end

    else if (Op_i == 6'b000010) begin	//jump

    end
end
endmodule 