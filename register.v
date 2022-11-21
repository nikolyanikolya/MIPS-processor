module register(input clk, input rst, output reg [31:0] instruction_memory_a);
  always @(posedge clk) begin
    if (rst == 1) 
      instruction_memory_a <= 0;
    else 
      instruction_memory_a <= instruction_memory_a + 4;
  end
  
endmodule