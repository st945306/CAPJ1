module ALU(
    data1_i, 
    data2_i,
    ALUCtrl_i,
    data_o
);

input   [31:0]      data1_i;
input   [31:0]      data2_i;
input   [2:0]       ALUCtrl_i;
output  reg[31:0]   data_o;

always@(data1_i or data2_i or ALUCtrl_i)begin
    if(ALUCtrl_i==3'b000)begin
        data_o = data1_i & data2_i;
    end
    else if(ALUCtrl_i==3'b001)begin
        data_o = data1_i | data2_i;
    end
    else if(ALUCtrl_i==3'b010)begin
        data_o = data1_i + data2_i;
    end
    else if(ALUCtrl_i==3'b011)begin
        data_o = data1_i - data2_i;
    end
    else if(ALUCtrl_i==3'b110)begin
        data_o = data1_i * data2_i;
    end
    //special case
    else begin
        data_o = data1_i;
    end
end

endmodule