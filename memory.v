module data_memory(a, we, clk, wd, rd);
  input we, clk;
  input [31:0] a;
  input [31:0] wd;
  output [31:0] rd;

  reg [7:0] dataMem [0:1023];
  wire [31:0] base_address;
  integer i;
  
  initial begin 
    for (i=1; i<32; i=i+1) begin
      dataMem[i] <= 0;
    end
  end
  
  always @ (posedge clk) begin
    if (we)
       {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]} <= wd;
  end

  assign base_address = ((a & 32'b11111111111111111111101111111111) >> 2) << 2;
  assign rd = (a >= 1024) ? 0 : {dataMem[base_address], dataMem[base_address + 1], dataMem[base_address + 2], dataMem[base_address + 3]};
  
endmodule

module instruction_memory(a, rd);
  input [31:0] a;
  output reg [31:0] rd;
  integer addr;
  // Note that at this point our programs cannot be larger then 64 subsequent commands.
  // Increase constant below if larger programs are going to be executed.
  reg [31:0] ram[0:63];

  initial
    begin
      $readmemb("instructions.dat", ram);
    end
    
  assign rd = ram[a / 4];
 
  
endmodule
