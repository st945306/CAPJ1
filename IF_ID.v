module IF_ID(
	clk_i,
	rst_i,
	pc_i,
	read_data_i,
	Hz_i,
	flush_i,

	pc_o,
	inst_o
);

	input clk_i, rst_i, Hz_i, flush_i; 
	input [31:0] pc_i, read_data_i;	

	output reg[31:0] pc_o, inst_o;

			


always@(posedge clk_i)begin
	pc_o <= pc_i;
 	
 	if(flush_i)begin
    	inst_o <= 32'b0;
 	end
	else begin
		if(Hz_i)
			inst_o <= inst_o;
		else
    		inst_o <= read_data_i;
	end  
	
end
endmodule