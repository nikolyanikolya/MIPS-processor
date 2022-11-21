module control_unit(opcode, funct, memtoreg, memwrite, branch, alusrc, regdst, regwrite, alucontrol);
  input [5:0] opcode, funct;
  wire [1:0] aluop;
  wire Rformat, lw, sw, beq, addi;
  output memtoreg, memwrite, branch, alusrc, regdst, regwrite;
  output reg [2:0] alucontrol; 
  
  parameter LW = 6'b100011;
  parameter SW = 6'b101011;
  parameter BEQ = 6'b000100;
  parameter ADDI = 6'b001000;
  
  parameter ADD = 6'b100000;
  parameter SUB = 6'b100010;
  parameter AND = 6'b100100;
  parameter OR = 6'b100101;
  parameter SLT = 6'b101010;

  parameter RFORMAT = 6'b000000;
  
  assign Rformat = (opcode == RFORMAT);
  assign lw = (opcode == LW);
  assign sw = (opcode == SW);
  assign beq = (opcode == BEQ);
  assign addi = (opcode == ADDI);
  
  assign regdst = Rformat;
  assign alusrc = lw | sw | addi;
  
  assign memtoreg = lw;
  assign regwrite = Rformat | lw | addi;
  assign memwrite = sw;
  assign branch = beq;
  
  assign aluop[0] = Rformat;
  assign aluop[1] = beq;
  
  always @(*)
	case (aluop)
		2'b00: alucontrol <= 3'b010; // LW | SW | ADDI -> ADD
	    2'b10: alucontrol <= 3'b110; // BEQ -> SUB
      	2'b01: case (funct) // RType -> func
			   	ADD: alucontrol <= 3'b010; // add
				SUB: alucontrol <= 3'b110; // sub
				AND: alucontrol <= 3'b000; // and
				OR: alucontrol <= 3'b001; //  or
				SLT: alucontrol <= 3'b111; // slt
			   endcase
// aluop=11 is never given
	endcase
endmodule