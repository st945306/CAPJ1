module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input [5:0] funct_i;
input [1:0] ALUOp_i;
output [2:0] ALUCtrl_o;

reg [2:0] temp;
assign ALUCtrl_o = temp;

always@(funct_i or ALUOp_i) begin
    if (ALUOp_i == 2'b11) begin		//R-type
	if (funct_i == 6'b100000)	//add
	    temp = 3'b010;
	else if (funct_i == 6'b100010)	//sub
	    temp = 3'b110;
	else if (funct_i == 6'b100100)	//and
	    temp = 3'b000;
	else if (funct_i == 6'b100101)	//or
	    temp = 3'b001;
	else if (funct_i == 6'b101010)	//set on less than
	    temp = 3'b111;
	else if (funct_i == 6'b011000)	//mul self def
	    temp = 3'b011;
    end
    else if (ALUOp_i == 2'b00) begin	//lw, sw
	temp = 3'b010;
    end
    else if (ALUOp_i == 2'b01) begin	//beq
	temp = 3'b110;
    end
    else if (ALUOp_i == 2'b10) begin	//ori
	temp = 3'b001;
    end
end


endmodule 