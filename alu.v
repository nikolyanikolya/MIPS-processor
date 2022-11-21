module subMultiplexer(a0, d0, d1, out);
  input a0;
  input [31:0] d0, d1; 
  output reg [31:0] out;
  
  always @* begin
    case (a0)
      2'b0 : out <= d0;
      2'b1 : out <= d1;   
	  endcase
  end
  
endmodule

module operationMultiplexer(a0, a1, d0, d1, d2, d3, out);
  input a0, a1;
  input [31:0] d0, d1, d2, d3;
  output reg [31:0] out;
  
  always @* begin
    case ({a1, a0})
      2'b00 : out <= d0;
      2'b01 : out <= d1;        
      2'b10 : out <= d2;   
      2'b11 : out <= d3;   
	  endcase
  end
  
endmodule

module fullAdder32(a, b, cin, sum, cout);
  input [31:0] a, b;
  input cin;
  output reg cout;
  output reg [31:0] sum;
    
  always @ (a or b or cin) begin
    {cout, sum} = a + b + cin;
  end
  
endmodule

module alu(srca, srcb, alucontrol, aluresult, zero);
  input [31:0] srca, srcb;
  input [2:0] alucontrol;
  wire cout;
  wire [31:0] inv_b, result_b, sum, or_res, and_res;
  wire overflow;
  output [31:0] aluresult;
  output zero;
  
  assign inv_b = ~srcb;
  
  subMultiplexer subOrAddChoice(alucontrol[2], srcb, inv_b, result_b);
  fullAdder32 adder(srca, result_b, alucontrol[2], sum, overflow);
  
  assign or_res = srca | result_b;
  assign and_res = srca & result_b;
  
  operationMultiplexer operationChoice(
    alucontrol[0], 
    alucontrol[1], 
    and_res, 
    or_res, 
    sum, 
    32'(sum[31]), 
    aluresult
  );

  assign zero = (aluresult == 0);
  
endmodule