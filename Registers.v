//not modify
module Registers
(
    clk_i,
    ReadRegister1_i,
    ReadRegister2_i,
    WriteRegister_i, 
    WriteData_i,
    RegWrite_i, 
    ReadData1_o, 
    ReadData2_o 
);

// Ports
input               clk_i, RegWrite_i;
input   [4:0]       ReadRegister1_i, ReadRegister2_i, WriteRegister_i;
input   [31:0]      WriteData_i;

output  [31:0]      ReadData1_o, ReadData2_o; 

// Register File
reg     [31:0]      register        [0:31];

// Read Data      
assign  ReadData1_o = register[ReadRegister1_i];
assign  ReadData2_o = register[ReadRegister2_i];

// Write Data   
always@(negedge clk_i) begin
    if(RegWrite_i)
        register[WriteRegister_i] <= WriteData_i;
end
   
endmodule 
