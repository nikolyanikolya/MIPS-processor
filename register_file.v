module register_file(clk, we3, a1, a2, a3, wd3, rd1, rd2);
  input clk, we3;
  input [4:0] a1, a2, a3;
  input [31:0] wd3;
  output [31:0] rd1, rd2;

  reg [31:0] regMem [31:0];
  integer i;
  
  initial begin
    for (i=1; i<32; i=i+1) begin
      regMem[i] <= 0;
    end
  end

  always @ (posedge clk) begin
    if (we3) 
      regMem[a3] <= wd3;
    regMem[0] <= 0;
  end

  assign rd1 = (regMem[a1]);
  assign rd2 = (regMem[a2]);
endmodule 