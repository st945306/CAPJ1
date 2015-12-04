module FW 
(
    EX_MEM_WB_i,          //EX_MEM_RegWrite,
    MEM_WB_WB_i,          //MEM_WB_RegWrite,
    EX_MEM_mux3_i,        //EX_MEM_RegisterRd,
    MEM_WB_mux3_i,        //MEM_WB_RegisterRd,
    ID_EX_inst25_21_i,    //ID_EX_RegisterRs,
    ID_EX_inst20_16_i,    //ID_Ex_RegisterRt,
    mux6_o,               //FA
    mux7_o                //FB
);

input               EX_MEM_WB_i;
input               MEM_WB_WB_i;
input       [4:0]   EX_MEM_mux3_i;
input       [4:0]   MEM_WB_mux3_i;
input       [4:0]   ID_EX_inst25_21_i;
input       [4:0]   ID_EX_inst20_16_i;
output reg  [1:0]   mux6_o;
output reg  [1:0]   mux7_o;

always @(EX_MEM_WB_i or MEM_WB_WB_i or EX_MEM_mux3_i or MEM_WB_mux3_i or ID_EX_inst25_21_i or ID_EX_inst20_16_i) begin
    mux6_o = 2'b00;    
    mux7_o = 2'b00 ;     
    //  EX Hazard
    if (EX_MEM_WB_i && 
        EX_MEM_mux3_i != 5'b00000 &&
        EX_MEM_mux3_i == ID_EX_inst25_21_i) begin
        mux6_o = 2'b10;
    end
    if (EX_MEM_WB_i &&
        EX_MEM_mux3_i != 5'b00000 &&
        EX_MEM_mux3_i == ID_EX_inst20_16_i) begin
        mux7_o = 2'b10;
    end
    //  Mem Hazard
    if (MEM_WB_WB_i &&
        MEM_WB_mux3_i != 5'b00000 &&
        MEM_WB_mux3_i == ID_EX_inst25_21_i) begin
        mux6_o = 2'b01;
    end
    if (MEM_WB_WB_i &&
        MEM_WB_mux3_i != 5'b00000 &&
        MEM_WB_mux3_i == ID_EX_inst20_16_i) begin
        mux7_o = 2'b01;
    end
end

endmodule