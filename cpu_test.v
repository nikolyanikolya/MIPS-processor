`include "mips_cpu.v"
`include "memory.v"
`include "register.v"

module cpu_test();
  reg clk;
  reg rst;
  wire [31:0] instruction_memory_a;
  wire [31:0] instruction_memory_rd;

  register register(
    .clk(clk),
    .rst(rst),
    //output
    .instruction_memory_a(instruction_memory_a)
  );
  
  instruction_memory cpu_instruction_memory(
    .a(instruction_memory_a),
    //output
    .rd(instruction_memory_rd)
  );

  wire data_memory_we;
  wire [31:0] data_memory_a, data_memory_rd, data_memory_wd;

  data_memory cpu_data_memory(
    .a(data_memory_a),
    .we(data_memory_we),
    .clk(clk),
    .wd(data_memory_wd),
    //output
    .rd(data_memory_rd)
  );

  wire register_we3;
  wire [4:0] register_a1, register_a2, register_a3;
  wire [31:0] register_rd1, register_rd2, register_wd3;
  
  mips_cpu cpu(.clk(clk),
               //output
               .instruction_memory_a(instruction_memory_a),
               .instruction_memory_rd(instruction_memory_rd), //inout
               .data_memory_a(data_memory_a),
               .data_memory_rd(data_memory_rd), // inout
               .data_memory_we(data_memory_we),
               .data_memory_wd(data_memory_wd),
               .register_a1(register_a1),
               .register_a2(register_a2),
               .register_a3(register_a3),
               .register_we3(register_we3),
               .register_wd3(register_wd3),
               .register_rd1(register_rd1), //inout
               .register_rd2(register_rd2) //inout
              );
  
  initial begin
    clk = 1;
    repeat(12) begin
      #50 clk= ~clk;
    end
  end
  
  initial begin 
    rst = 1;
    #100 rst = 0;
  end  
  
  always @(register_wd3 or register_a3) begin
    $monitor("register_a3 : %5b, register_wd3 : %32b, ", register_a3, register_wd3);
  end

endmodule