`include "alu.v"
module testSwitch;
  reg [31:0] srca, srcb;
  reg [2:0] alucontrol;
  reg [31:0] aluresult;
  reg zero;
 
  alu alu_(srca, srcb, alucontrol, aluresult, zero);
  
  initial begin 
    #5 srca = 250; srcb = 239; alucontrol = 3'b110; // sub 11 expected
    #5 srca = 239; srcb = 250; alucontrol = 3'b010;  // add 489 expected
    #5 srca = 5; srcb = 6; alucontrol = 3'b001; // or 7 expected 
    #5 srca = 5; srcb = 6; alucontrol = 3'b000; // and 4 expected   
    #5 srca = 5; srcb = 6; alucontrol = 3'b100; // nand 1 expected
    #5 srca = 5; srcb = 6; alucontrol = 3'b101; // nor -3 expected
    #5 srca = 5; srcb = 6; alucontrol = 3'b111; // and 1 expected
    #5 srca = 6; srcb = 5; alucontrol = 3'b111; // and 0 expected
    $finish(0);
  end  
  
  always @(srca or srcb or alucontrol) begin
    $monitor("ALU result: %32b. Cout: %b", aluresult, zero);
  end    
  
  
endmodule