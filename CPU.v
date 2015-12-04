module CPU
(
    rst_i,
    clk_i, 
    start_i
);

// Ports
input               clk_i;
input               start_i;
input		    rst_i;
wire [31:0] inst_addr, inst;

mux1 mux1(
    .Eq_i        (Eq.data_o),
    .Branch_i    (Control.Branch_o),    
    .Add_pc_i    (Add_pc.data_o),
    .ADD_i       (ADD.data_o),
    .data_o      ()
);

mux2 mux2(
    .branchAddr_i    (mux1.data_o),
    .jump_i    	     (Control.Jump_o),
    .inst_i          ({mux1.data_o[31:28], inst[25:0], 2'b00}),
    .data_o          ()
);

mux3 mux3(
    .RegDst_i    (ID_EX.EX3_o),
    .data1_i     (ID_EX.inst20_16_o),
    .data2_i     (ID_EX.inst15_11_o),
    .data_o      ()
);

mux4 mux4(
    .data1_i	(mux7.data_o),
    .data2_i    (ID_EX.sign_extend_o),
    .ALUSrc_i	(ID_EX.EX1_o),
    .data_o     ()
);

mux5 mux5(
    .MemtoReg_i (MEM_WB.MemtoReg_o),
    .data1_i   	(MEM_WB.mux5_1_o),
    .data2_i    (MEM_WB.mux5_2_o),
    .data_o    	()
);

mux6 mux6 (
    .data1_i    (ID_EX.data1_o),
    .data2_i    (mux5.data_o),
    .data3_i    (EX_MEM.Address_o),
    .fw_i       (FW.mux6_o),
    .data_o    	()
);

mux7 mux7(
    .data1_i    (ID_EX.data2_o),
    .data2_i    (mux5.data_o),
    .data3_i    (EX_MEM.Address_o),
    .fw_i       (FW.mux7_o),
    .data_o 	()
);

mux8 mux8(
    .HD_i	(HD.mux8_o),
    .Control_i  (Control.Mux8_o),
    .data_o    	()
);

Data_memory Data_memory(
    .Address_i    	(EX_MEM.Address_o),
    .WriteData_i    	(EX_MEM.Write_data_o),
    .MemWrite_i    	(EX_MEM.MemWrite_o),
    .MemRead_i   	(EX_MEM.MemRead_o),
    .data_o    		()
);

Control Control(
        .Op_i		(inst[31:26]),
        .Branch_o     	(),
        .Jump_o        	(),
        .Mux8_o       	()
);

Add_pc Add_pc(
        .data1_in       (inst_addr),
        .data2_in       (32'd4),
        .data_o         ()
);

ADD ADD(
         .data1_in       (Sign_extend.data_o << 2),
         .data2_in       (IF_ID.pc_o),
         .data_o         ()
);

PC PC(
        .clk_i          (clk_i),
	.rst_i          (rst_i),
        .start_i        (start_i),
        .HD_i        	(HD.PC_o),
        .pc_i           (mux2.data_o),
        .pc_o           (inst_addr)
);

Eq Eq(
        .data1_i     (Registers.ReadData1_o),
        .data2_i     (Registers.ReadData2_o),
        .data_o      ()
);

Registers Registers(
        .clk_i         		(clk_i),
        .ReadRegister1_i        (inst[25:21]),
        .ReadRegister2_i        (inst[20:16]),
        .WriteRegister_i        (MEM_WB.FW_o), 
        .WriteData_i       	(mux5.data_o),
        .RegWrite_i    		(MEM_WB.RegWrite_o), 
        .ReadData1_o   		(), 
        .ReadData2_o   		() 
);


Sign_extend Sign_extend(
        .data_i         (inst[15:0]),
        .data_o         ()
);

Instruction_Memory Instruction_Memory(
        .addr_i         (inst_addr), 
        .instr_o        ()
);

ALU ALU(
        .data1_i        (mux6.data_o),
        .data2_i        (mux4.data_o),
        .ALUCtrl_i      (ALU_Control.ALUCtrl_o),
        .data_o         ()
);

ALU_Control ALU_Control(
        .funct_i        (ID_EX.sign_extend_o[5:0]),
        .ALUOp_i        (ID_EX.EX2_o),
        .ALUCtrl_o      ()
);

HD HD(
    	.inst20_16_i    (ID_EX.inst20_16_o),
 	.inst_i    	(inst),
	.MemRead_i	(ID_EX.M_o[0]),
    	.IF_ID_o    	(),
    	.PC_o        	(),
    	.mux8_o    	()
);

FW FW(
    .ID_EX_inst25_21_i  (ID_EX.inst25_21_o),
    .ID_EX_inst20_16_i  (ID_EX.inst20_16_o),
    .EX_MEM_mux3_i	(EX_MEM.mux3_result_o),
    .EX_MEM_WB_i    	(EX_MEM.WB_o[0]),
    .MEM_WB_mux3_i    	(MEM_WB.FW_o),
    .MEM_WB_WB_i    	(MEM_WB.RegWrite_o),
    .mux6_o        	(),
    .mux7_o        	()
);

IF_ID IF_ID(
    .clk_i		(clk_i),
    .rst_i		(rst_i),
    .pc_i        	(Add_pc.data_o),
    .read_data_i    	(Instruction_Memory.instr_o),
    .flush_i        	(Control.Jump_o | (Eq.data_o & Control.Branch_o)),
    .Hz_i        	(HD.IF_ID_o),
    .pc_o        	(),
    .inst_o        	(inst)
);

ID_EX ID_EX(
 	.clk_i    	(clk_i),
	.rst_i		(),
   	.WB_i		(mux8.data_o[1:0]),    //2 bits, 0 is MemtoReg, 1 is RegWrite
    	.M_i        	(mux8.data_o[3:2]),     //2 bits, 0 is MemRead, 1 is MemWrite
    	.EX_i      	(mux8.data_o[7:4]),	//4 bits
	.data1_i    	(IF_ID.pc_o),
	.readData1_i    (Registers.ReadData1_o),
	.readData2_i    (Registers.ReadData2_o),
	.sign_extend_i	(Sign_extend.data_o),
	.inst25_21_i    (inst[25:21]),
	.inst20_16_i    (inst[20:16]),
	.inst15_11_i    (inst[15:11]),
	.WB_o        	(EX_MEM.WB_i),
	.M_o      	(),
	.EX1_o    	(mux4.ALUSrc_i),
	.EX2_o    	(ALU_Control.ALUOp_i),
	.EX3_o   	(mux3.RegDst_i),
	.data1_o 	(mux6.data1_i),
	.data2_o    	(mux7.data1_i),
	.sign_extend_o	(),
	.inst25_21_o    (),
	.inst20_16_o    (),
	.inst15_11_o    ()
);


EX_MEM EX_MEM(
    .clk_i		(clk_i),
    .rst_i		(),
    .WB_i     	  	(ID_EX.WB_o),
    .M_i        	(ID_EX.M_o),
    .ALUResult_i	(ALU.data_o),
    .mux3_i    		(mux3.data_o),
    .mux7_i    		(mux7.data_o),
    .WB_o        	(),
    .MemRead_o    	(),
    .MemWrite_o    	(),
    .Address_o    	(),
    .Write_data_o  	(),
    .mux3_result_o	()
);

MEM_WB MEM_WB(
    .clk_i	(clk_i),
    .rst_i	(rst_i),
    .WB_i	(EX_MEM.WB_o),
    .ReadData_i (Data_memory.data_o),
    .ALU_i      (EX_MEM.Address_o),
    .mux3_i    	(EX_MEM.mux3_result_o),
    .MemtoReg_o (),
    .RegWrite_o (),
    .mux5_1_o  	(),
    .mux5_2_o   (),
    .FW_o       ()
);

endmodule
