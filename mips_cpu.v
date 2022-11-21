`include "alu.v"
`include "control_unit.v"
`include "register_file.v"
`include "util.v"

module mips_cpu(clk, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  input clk;
  output data_memory_we;
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  inout [31:0] instruction_memory_rd, data_memory_rd;
  output register_we3; 
  output [4:0] register_a1, register_a2, register_a3;
  output [31:0] register_wd3; 
  inout [31:0] register_rd1, register_rd2;

  wire memtoreg, memwrite, branch, alusrc, regdst, regwrite;
  wire [2:0] alucontrol;
  wire [31:0] aluresult;
  wire zero;
  wire [31:0] extended_imm;
  wire [5:0] opcode;
  wire [5:0] funct; 
  wire [15:0] imm;
  wire [31:0] alu_b;
  wire [4:0] write_reg;
  wire [31:0] next_instruction;
  wire [31:0] skip;
  wire [31:0] skip_in_bytes;
  
 
 control_unit control_unit(
    .opcode(opcode),
    .funct(funct),
    .memtoreg(memtoreg), 
    .memwrite(memwrite), 
    .branch(branch), 
    .alusrc(alusrc), 
    .regdst(regdst), 
    .regwrite(regwrite), 
    .alucontrol(alucontrol)
  );

  mux2_5 rt_or_rd(
    .d0(register_a2),
    .d1(dest), 
    .a(regdst),
    .out(write_reg)
  );

  sign_extend extend_imm(
    .in(imm),
    .out(extended_imm)
  );

  mux2_32 constant_or_register(
    .d0(register_rd2),
    .d1(extended_imm),
    .a(alusrc),
    .out(alu_b)
  );

  register_file cpu_register(
    .clk(clk),
    .we3(register_we3),
    .a1(register_a1),
    .a2(register_a2),
    .a3(register_a3),
    .wd3(register_wd3),
    //output
    .rd1(register_rd1),
    .rd2(register_rd2)
  );

  alu alu(
    //input
    .srca(register_rd1), 
    .srcb(alu_b),
    .alucontrol(alucontrol),
    //output
    .aluresult(aluresult),
    .zero(zero)
  );

  // mux2_32 jump_or_continue(
  //   .d0(32'b0),
  //   .d1(extended_imm),
  //   .a(zero & branch),
  //   .out(skip)
  // );

  // shl_2 shl_2(  Вот так можно было бы обрабатывать условный переход (но я не смог написать PC)
  //   .in(skip),
  //   .out(skip_in_bytes)
  // );

  // adder adder(
  //   .a(skip_in_bytes),
  //   .b(32'h00000004),
  //   .out(next_instruction)
  // )

  mux2_32 from_mem_or_alu(
    .d0(aluresult),
    .d1(data_memory_rd),
    .a(memtoreg),
    .out(register_wd3)
  );

  assign opcode = instruction_memory_rd[31:26];
  assign dest = instruction_memory_rd[15:11];
  assign funct = instruction_memory_rd[5:0];
  assign imm = instruction_memory_rd[15:0];
  assign register_a1 = instruction_memory_rd[25:21];
  assign register_a2 = instruction_memory_rd[20:16];
  assign register_a3 = write_reg;
  assign data_memory_a = aluresult;
  assign data_memory_we = memwrite;
  assign data_memory_wd = register_rd2;
  assign register_we3 = regwrite;                       

endmodule