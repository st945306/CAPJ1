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

wire [31:0] inst_addr, inst, Add_pc_w, IF_ID_w, mux1_w;
wire [31:0] read_data1_w, read_data2_w, eq_w, mux5_w;
wire [31:0] mux7_w;ID_EX_sign_w, ID_EX_inst20_w;

wire control_jmp_w, control_br_w;

wire [7:0] mux8_w;

mux1 mux1(
    .Eq_i        (eq_w),
    .Branch_i    (control_br_w),    
    .Add_pc_i    (Add_pc_w),
    .ADD_i       (ADD.data_o),
    .data_o      (mux1_w)
);

mux2 mux2(
    .branchAddr_i    (mux1_w),
    .jump_i    	     (control_jmp_w),
    .inst_i          ({mux1_w[31:28], inst[25:0], 2'b00}),
    .data_o          (PC.pc_i)
);

mux3 mux3(
    .RegDst_i    (ID_EX.EX3_o),
    .data1_i     (ID_EX_inst20_w),
    .data2_i     (ID_EX.inst15_11_o),
    .data_o      (EX_MEM.mux3_i)
);

mux4 mux4(
    .data1_i	(mux7_w),
    .data2_i    (ID_EX_sign_w),
    .ALUSrc_i	(ID_EX.EX1_o),
    .data_o     (ALU.data2_i)
);

mux5 mux5(
    .MemtoReg_i (MEM_WB.MemtoReg_o),
    .data1_i   	(MEM_WB.mux5_1_o),
    .data2_i    (MEM_WB.mux5_2_o),
    .data_o    	(mux5_w)
);

mux6 mux6 (
    .data1_i    (ID_EX.data1_o),
    .data2_i    (mux5_w),
    .data3_i    (EX_MEM.Address_o),
    .fw_i       (FW.mux6_o),
    .data_o    	(ALU.data1_i)
);

mux7 mux7(
    .data1_i    (ID_EX.data2_o),
    .data2_i    (mux5_w),
    .data3_i    (EX_MEM.Address_o),
    .fw_i       (FW.mux7_o),
    .data_o 	(mux7_w)
);

mux8 mux8(
    .HD_i	(HD.mux8_o),
    .Control_i  (Control.Mux8_o),
    .data_o    	(mux8_w)
);

Data_memory Data_memory(
    .Address_i    	(EX_MEM.Address_o),
    .WriteData_i    	(EX_MEM.Write_data_o),
    .MemWrite_i    	(EX_MEM.MemWrite_o),
    .MemRead_i   	(EX_MEM.MemRead_o),
    .data_o    		(MEM_WB.ReadData_i)
);

Control Control(
        .Op_i		(inst[31:26]),
        .Branch_o     	(control_br_w),
        .Jump_o        	(control_jmp_w),
        .Mux8_o       	(mux8.Control_i)
);

Add_pc Add_pc(
        .data1_in       (inst_addr),
        .data2_in       (32'd4),
        .data_o         (Add_pc_w)
);

ADD ADD(
         .data1_in       (sign_extend_w << 2),
         .data2_in       (IF_ID_w),
         .data_o         (mux1.ADD_i)
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
        .data1_i     (read_data1_w),
        .data2_i     (read_data2_w),
        .data_o      (eq_w)
);

Registers Registers(
        .clk_i         		(clk_i),
        .ReadRegister1_i        (inst[25:21]),
        .ReadRegister2_i        (inst[20:16]),
        .WriteRegister_i        (MEM_WB.FW_o), 
        .WriteData_i       	(mux5_w),
        .RegWrite_i    		(MEM_WB.RegWrite_o), 
        .ReadData1_o   		(read_data1_w), 
        .ReadData2_o   		(read_data2_w) 
);


Sign_extend Sign_extend(
        .data_i         (inst[15:0]),
        .data_o         (sign_extend_w)
);

Instruction_Memory Instruction_Memory(
        .addr_i         (inst_addr), 
        .instr_o        (IF_ID.read_data_i)
);

ALU ALU(
        .data1_i        (mux6.data_o),
        .data2_i        (mux4.data_o),
        .ALUCtrl_i      (ALU_Control.ALUCtrl_o),
        .data_o         (EX_MEM.ALUResult_i)
);

ALU_Control ALU_Control(
        .funct_i        (ID_EX_sign_w[5:0]),
        .ALUOp_i        (ID_EX.EX2_o),
        .ALUCtrl_o      (ALU.ALUCtrl_i)
);

HD HD(
    	.inst20_16_i    (ID_EX_inst20_w),
 	.inst_i    	(inst),
	.MemRead_i	(ID_EX.M_o[0]),
    	.IF_ID_o    	(IF_ID.Hz_i),
    	.PC_o        	(PC.HD_i),
    	.mux8_o    	(mux8.HD_i)
);

FW FW(
    .ID_EX_inst25_21_i  (ID_EX.inst25_21_o),
    .ID_EX_inst20_16_i  (ID_EX_inst20_w),
    .EX_MEM_mux3_i	(EX_MEM.mux3_result_o),
    .EX_MEM_WB_i    	(EX_MEM.WB_o[1]),
    .MEM_WB_mux3_i    	(MEM_WB.FW_o),
    .MEM_WB_WB_i    	(MEM_WB.RegWrite_o),
    .mux6_o        	(mux6.fw_i),
    .mux7_o        	(mux7.fw_i)
);

IF_ID IF_ID(
    .clk_i		(clk_i),
    .rst_i		(rst_i),
    .pc_i        	(Add_pc_w),
    .read_data_i    	(Instruction_Memory.instr_o),
    .flush_i        	(control_jmp_w| (eq_w & control_br_w)),
    .Hz_i        	(HD.IF_ID_o),
    .pc_o        	(IF_ID_w),
    .inst_o        	(inst)
);

ID_EX ID_EX(
 	.clk_i    	(clk_i),
	.rst_i		(rst_i),
   	.WB_i		(mux8_w[1:0]),    //2 bits, 0 is MemtoReg, 1 is RegWrite
    	.M_i        	(mux8_w[3:2]),     //2 bits, 0 is MemRead, 1 is MemWrite
    	.EX_i      	(mux8_w[7:4]),	//4 bits
	.data1_i    	(IF_ID_w),
	.readData1_i    (read_data1_w),
	.readData2_i    (read_data2_w),
	.sign_extend_i	(sign_extend_w),
	.inst25_21_i    (inst[25:21]),
	.inst20_16_i    (inst[20:16]),
	.inst15_11_i    (inst[15:11]),
	.WB_o        	(EX_MEM.WB_i),
	.M_o      	(EX_MEM.M_i),
	.EX1_o    	(mux4.ALUSrc_i),
	.EX2_o    	(ALU_Control.ALUOp_i),
	.EX3_o   	(mux3.RegDst_i),
	.data1_o 	(mux6.data1_i),
	.data2_o    	(mux7.data1_i),
	.sign_extend_o	(ID_EX_sign_w),
	.inst25_21_o    (FW.ID_EX_inst25_21_i),
	.inst20_16_o    (ID_EX_inst20_w),
	.inst15_11_o    (mux3.data2_i)
);


EX_MEM EX_MEM(
    .clk_i		(clk_i),
    .rst_i		(rst_i),
    .WB_i     	  	(ID_EX.WB_o),
    .M_i        	(ID_EX.M_o),
    .ALUResult_i	(ALU.data_o),
    .mux3_i    		(mux3.data_o),
    .mux7_i    		(mux7_w),
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
