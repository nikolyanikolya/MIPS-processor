`timescale 1ns / 1ps
 
module cpu(
    input clk, // сигнал фронта тактового сигнала
         input rst, // сигнал сброса
         output [31: 0] pcdata, // адрес кода инструкции pc
         input [31: 0] inst, // код команды ввода
         input [31: 0] rdata, // данные читаются из оперативной памяти
         output [31: 0] addr, // Записываем адрес оперативной памяти
         output [31: 0] wdata, // данные, записанные в RAM
         output im_r, // сигнал чтения регистра инструкции
    output dm_cs,			//
         output dm_r, // сигнал чтения регистра данных
         output dm_w, // сигнал записи регистра данных
         output [5: 0] op_out, // Для вывода отладки ...
         output Z // Для вывода отладки ...
    );
     
     wire [31:0] npc_out;
     wire [31:0] npc_in;
         
           ADDU NPC (// модуль NPC
           .a (npc_in), // Функция: каждый раз, когда pc + 4 указывает на адрес следующей инструкции
     .b(32'd4),
     .c(npc_out)
     );
     
     wire [31:0] mux1_in1;
     wire [31:0] mux1_in2;
     wire [31:0] mux1_out;
     wire mux1_m;
           MUX MUX1 (// Селектор данных
           .m (mux1_m), // Функция: выбрать неиспользуемый вход как выход в соответствии с разными сигналами
     .data_in1(mux1_in1),
     .data_in2(mux1_in2),
     .data_out(mux1_out)
     );
     
     wire [31:0] mux3_in1;
     wire [31:0] mux3_in2;
     wire [31:0] mux3_out;
           wire mux3_m; // Селектор данных
     MUX MUX3(
     .m(mux3_m),
     .data_in1(mux3_in1),
     .data_in2(mux3_in2),
     .data_out(mux3_out)
     );
     
     wire [31:0] mux4_in1;
     wire [31:0] mux4_in2;
     wire [31:0] mux4_out;
           wire mux4_m; // Селектор данных
     MUX MUX4(
     .m(mux4_m),
     .data_in1(mux4_in1),
     .data_in2(mux4_in2),
     .data_out(mux4_out)
     );
     
     wire [31:0] mux5_in1;
     wire [31:0] mux5_in2;
     wire [31:0] mux5_out;
     wire mux5_m;
           MUX MUX5 (// Селектор данных
     .m(mux5_m),
     .data_in1(mux5_in1),
     .data_in2(mux5_in2),
     .data_out(mux5_out)
     );
     
     wire [31:0] mux6_in1;
     wire [31:0] mux6_in2;
     wire [31:0] mux6_out;
     wire mux6_m;
           MUX MUX6 (// Селектор данных
     .m(mux6_m),
     .data_in1(mux6_in1),
     .data_in2(mux6_in2),
     .data_out(mux6_out)
     );
     
     wire [31:0] mux7_in1;
     wire [31:0] mux7_in2;
     wire [31:0] mux7_out;
     wire mux7_m;
           MUX MUX7 (// Селектор данных
     .m(mux7_m),
     .data_in1(mux7_in1),
     .data_in2(mux7_in2),
     .data_out(mux7_out)
     );
     
     wire [31:0] mux8_in1;
     wire [31:0] mux8_in2;
     wire [31:0] mux8_out;
     wire mux8_m;
           MUX MUX8 (// Селектор данных
     .m(mux8_m),
     .data_in1(mux8_in1),
     .data_in2(mux8_in2),
     .data_out(mux8_out)
     );
     
     wire [31:0] mux2_in1;
     wire [31:0] mux2_in2;
     wire [31:0] mux2_in3;
     wire [31:0] mux2_out;
     wire [1:0] mux2_m;
           MUXS MUX2 (// Селектор данных
     .m(mux2_m),
     .data_in1(mux2_in1),
     .data_in2(mux2_in2),
     .data_in3(mux2_in3),
     .data_out(mux2_out)
     );
     
     wire [4:0] ext5_in;
     wire [31:0] ext5_out;
     wire ext5_c;
           Ext_imm5 ext5 (// Расширитель данных
           .idata (ext5_in), // Расширяем данные до 32 бит
     .odata(ext5_out),
     .ca(ext5_c)
     );
     
     wire [15:0] ext16_in;
     wire [31:0] ext16_out;
     wire ext16_c;
           Ext_imm16 ext16 (// расширитель данных
     .idata(ext16_in),
     .odata(ext16_out),
     .ca(ext16_c)
     );
     
     wire [15:0] ext18_in;
     wire [31:0] ext18_out;
     wire ext18_c;
           Ext_imm18 ext18 (// расширитель данных
     .idata(ext18_in),
     .odata(ext18_out),
     .ca(ext18_c)
     );
     
 //    wire pc_ena;
     wire pc_clk;
     wire pc_rst;
     assign pc_rst=rst;
     wire [31:0] pc_data_in;
     wire [31:0] pc_data_out;
     wire [3:0] pc_data31_28;
           PC_Reg PC (// регистр ПК
           .clk (pc_clk), // Функция: сохранить адрес следующей инструкции
     .rst(pc_rst),
     .ena(1'b1),
     .data_in(pc_data_in),
     .data_out(pc_data_out),
     .pc31_28(pc_data31_28)
     );
     
//     wire imem_wena;
 //    assign imem_wena=0;
//     wire [31:0] imem_addr;
 //    wire [31:0] imem_data_in;
//     assign imem_data_in=32'b0;
     wire [31:0] imem_data_out;
     wire [25:0] target=imem_data_out[25:0];
     wire [4:0] sa=imem_data_out[10:6];
     wire [4:0] Rsc=imem_data_out[25:21];
     wire [4:0] Rtc=imem_data_out[20:16];
     wire [4:0] Rdc=imem_data_out[15:11];
     wire [5:0] op=imem_data_out[31:26];
     wire [5:0] func=imem_data_out[5:0];
     wire [15:0] imm16=imem_data_out[15:0];
/*     IMEM imem(
     .clk(clk),
     .wena(imem_wena),
     .addr(imem_addr),
     .data_in(imem_data_in),
     .data_out(imem_data_out)
     );*/
     
     
     wire rf_clk;
     wire rf_rst;
     assign rf_rst=rst;
     wire rf_we;
     wire [4:0]rf_rsc;
     wire [4:0]rf_rtc;
     wire [4:0]rf_rdc;
     wire [31:0]rf_rd;
     wire [31:0]rf_rs;
     wire [31:0]rf_rt;
           RegFiles cpu_ref (// Модуль общего реестра
     .clk(rf_clk),
     .rst(rf_rst),
     .we(rf_we),
     .raddr1(rf_rsc),
     .rdata1(rf_rs),
     .raddr2(rf_rtc),
     .rdata2(rf_rt),
     .waddr(rf_rdc),
     .wdata(rf_rd)
     );
     
     wire [31:0] alu_a;
     wire [31:0] alu_b;
     wire [31:0] alu_r;
     wire [3:0] aluc;
     wire z;
     wire c;
     wire n;
     wire o;
           alu ALU (// модуль ALU
     .a(alu_a),
     .b(alu_b),
     .r(alu_r),
     .aluc(aluc),
     .zero(z),
     .carry(c),
     .negative(n),
     .overflow(o)
     );
     
     wire [31:0] add_a;
     wire [31:0] add_b;
     wire [31:0] add_c;
     ADD add(
     .a(add_a),
     .b(add_b),
     .c(add_c)
     );
     
     
     wire dmem_cs;
     wire dmem_we;
     wire dmem_re;
     wire [31:0] dmem_addr;
     wire [31:0] dmem_data_in;
     wire [31:0] dmem_data_out;
 //    wire [31:0] dmem_data;
/*     DMEM dmem(
     .clk(clk),
     .cs(dmem_cs),
     .we(dmem_we),
     .re(dmem_re),
     .addr(dmem_addr),
     .data_in(dmem_data_in),
     .data_out(dmem_data_out)
     );  */
     wire [31:0] j_jal={npc_out[31:28],imem_data_out[25:0],2'b0};
     
     assign npc_in=pc_data_out;
     assign mux1_in1=j_jal;
     assign mux1_in2=mux5_out;
     assign add_b=npc_out;
     assign mux5_in1=npc_out;
     assign mux5_in2=add_c;
     assign add_a=ext18_out;
     assign ext18_in=imm16;
     assign ext16_in=imm16;
     assign ext5_in=sa;
 //    assign imem_addr=pc_data_out;
     assign mux7_in1=rf_rs;
     assign mux7_in2=mux1_out;
     assign pc_data_in=mux7_out;
     assign mux6_in1=rf_rtc;
     assign mux6_in2=Rdc;//assign mux6_in2=rf_rdc;//
     assign mux8_in1=mux6_out;
     assign mux8_in2=32'd31;
     assign rf_rdc=mux8_out;
     assign rf_rsc=Rsc;
     assign rf_rtc=Rtc;
     assign rf_rd=mux2_out;
     assign mux3_in1=ext5_out;
     assign mux3_in2=rf_rs;
     assign mux4_in1=rf_rt;
     assign mux4_in2=ext16_out;
     assign alu_a=mux3_out;
     assign alu_b=mux4_out;
     assign dmem_addr=alu_r;
     assign mux2_in1=dmem_data_out;
     assign dmem_data_in=rf_rt;
     assign mux2_in2=npc_out;
     assign mux2_in3=alu_r;
     
 /*    wire [5:0] op;
     wire [5:0] func;
     wire z;*/
 
 
     wire PC_CLK;
     wire IM_R;
     wire M3;
     wire M4;
     wire [3:0] ALUC;
     wire M2_0;
     wire M2_1;
     wire M6;
     wire RF_W;
     wire RF_CLK;
     wire M5;
     wire M1;
     wire DM_CS;
     wire DM_R;
     wire DM_W;
     wire M7;
     wire M8;
     wire Ext5_C;
     wire Ext16_C;
     wire Ext18_C;
     
           control cpucon (// модуль контроллера
     .op(op),
     .func(func),
     .z(z),
     .clk(clk),
     .PC_CLK(PC_CLK),
     .IM_R(IM_R),
     .M3(M3),
     .M4(M4),
     .ALUC(ALUC),
     .M2_0(M2_0),
     .M2_1(M2_1),
     .M6(M6),
     .RF_W(RF_W),
     .RF_CLK(RF_CLK),
     .M5(M5),
     .M1(M1),
     .DM_CS(DM_CS),
     .DM_R(DM_R),
     .DM_W(DM_W),
     .M7(M7),
     .M8(M8),
     .Ext5_C(Ext5_C),
     .Ext16_C(Ext16_C),
     .Ext18_C(Ext18_C)    
     );
     
     assign pc_clk=PC_CLK;
  //   assign =IM_R;
     assign mux3_m=M3;
     assign mux4_m=M4;
     assign aluc=ALUC;
     assign mux2_m={M2_0,M2_1};
     assign mux6_m=M6;
     assign rf_we=RF_W;
     assign rf_clk=RF_CLK;
     assign mux5_m=M5;
     assign mux1_m=M1;
     assign dmem_cs=DM_CS;
     assign dmem_we=DM_W;
     assign dmem_re=DM_R;
     assign mux7_m=M7;
     assign mux8_m=M8;
     assign ext5_c=Ext5_C;
     assign ext16_c=Ext16_C;
     assign ext18_c=Ext18_C;
    
    
    assign imem_data_out=inst;
    assign pcdata=pc_data_out;
    assign addr=dmem_addr;
    assign wdata=dmem_data_in;
    assign dmem_data_out=rdata;
    assign dm_cs=DM_CS;
    assign dm_w=DM_W;
    assign dm_r=DM_R;
    assign op_out=op;
    assign Z=z;
 endmodule
