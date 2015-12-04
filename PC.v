module PC
(
  clk_i,
  rst_i,
  start_i,
  HD_i,
  pc_i,
  pc_o
);

// Ports
input               clk_i, rst_i, start_i, HD_i;
input   [31:0]      pc_i;
output  reg [31:0]  pc_o;

// Wires & Registers

always@(posedge clk_i or negedge rst_i) begin
  if(~rst_i) begin
        pc_o <= 32'b0;
  end
  else if(start_i)begin
    if(HD_i) begin
      pc_o <= pc_i-4;
    end
    else begin
      pc_o <= pc_i;
    end
  end
  else begin
      pc_o <= 32'b0;
  end
end

endmodule