`timescale 1ns/1ps
module tb_pdof();
  logic clk;
  logic rst_n;
  logic enab_prof;
  logic en;
  logic export_data_pdof;
  logic [95:0] final_dst [0:5];
  logic signed [10:0] dMv_Scale_Prec_4_x0;
  logic signed [10:0] dMv_Scale_Prec_4_y0;
  logic signed [10:0] dMv_Scale_Prec_4_x1;
  logic signed [10:0] dMv_Scale_Prec_4_y1;
  logic signed [10:0] dMv_Scale_Prec_4_x2;
  logic signed [10:0] dMv_Scale_Prec_4_y2;
  logic signed [10:0] dMv_Scale_Prec_4_x3;
  logic signed [10:0] dMv_Scale_Prec_4_y3;
  logic signed [10:0] dMv_Scale_Prec_4_x4;
  logic signed [10:0] dMv_Scale_Prec_4_y4;
  logic signed [10:0] dMv_Scale_Prec_4_x5;
  logic signed [10:0] dMv_Scale_Prec_4_y5;
  logic signed [10:0] dMv_Scale_Prec_4_x6;
  logic signed [10:0] dMv_Scale_Prec_4_y6;
  logic signed [10:0] dMv_Scale_Prec_4_x7;
  logic signed [10:0] dMv_Scale_Prec_4_y7;
  logic signed [10:0] dMv_Scale_Prec_4_x8;
  logic signed [10:0] dMv_Scale_Prec_4_y8;
  logic signed [10:0] dMv_Scale_Prec_4_x9;
  logic signed [10:0] dMv_Scale_Prec_4_y9;
  logic signed [10:0] dMv_Scale_Prec_4_x10;
  logic signed [10:0] dMv_Scale_Prec_4_y10;
  logic signed [10:0] dMv_Scale_Prec_4_x11;
  logic signed [10:0] dMv_Scale_Prec_4_y11;
  logic signed [10:0] dMv_Scale_Prec_4_x12;
  logic signed [10:0] dMv_Scale_Prec_4_y12;
  logic signed [10:0] dMv_Scale_Prec_4_x13;
  logic signed [10:0] dMv_Scale_Prec_4_y13;
  logic signed [10:0] dMv_Scale_Prec_4_x14;
  logic signed [10:0] dMv_Scale_Prec_4_y14;
  logic signed [10:0] dMv_Scale_Prec_4_x15;
  logic signed [10:0] dMv_Scale_Prec_4_y15;
  logic [31:0] ref_data0;
  logic [31:0] ref_data1;
  logic [31:0] ref_data2;
  logic [31:0] ref_data3;

  int i;
  int j;
  int k;
always begin
  #1 clk = ~clk;
end
pdof pdof_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_pdof  (export_data_pdof),
.enab_prof         (enab_prof),
.final_dst         (final_dst),
.dMv_Scale_Prec_4_x0 (dMv_Scale_Prec_4_x0),
.dMv_Scale_Prec_4_x1 (dMv_Scale_Prec_4_x1),
.dMv_Scale_Prec_4_x2 (dMv_Scale_Prec_4_x2),
.dMv_Scale_Prec_4_x3 (dMv_Scale_Prec_4_x3),
.dMv_Scale_Prec_4_x4 (dMv_Scale_Prec_4_x4),
.dMv_Scale_Prec_4_x5 (dMv_Scale_Prec_4_x5),
.dMv_Scale_Prec_4_x6 (dMv_Scale_Prec_4_x6),
.dMv_Scale_Prec_4_x7 (dMv_Scale_Prec_4_x7),
.dMv_Scale_Prec_4_x8 (dMv_Scale_Prec_4_x8),
.dMv_Scale_Prec_4_x9 (dMv_Scale_Prec_4_x9),
.dMv_Scale_Prec_4_y0 (dMv_Scale_Prec_4_y0),
.dMv_Scale_Prec_4_y1 (dMv_Scale_Prec_4_y1),
.dMv_Scale_Prec_4_y2 (dMv_Scale_Prec_4_y2),
.dMv_Scale_Prec_4_y3 (dMv_Scale_Prec_4_y3),
.dMv_Scale_Prec_4_y4 (dMv_Scale_Prec_4_y4),
.dMv_Scale_Prec_4_y5 (dMv_Scale_Prec_4_y5),
.dMv_Scale_Prec_4_y6 (dMv_Scale_Prec_4_y6),
.dMv_Scale_Prec_4_y7 (dMv_Scale_Prec_4_y7),
.dMv_Scale_Prec_4_y8 (dMv_Scale_Prec_4_y8),
.dMv_Scale_Prec_4_y9 (dMv_Scale_Prec_4_y9),
.dMv_Scale_Prec_4_x10(dMv_Scale_Prec_4_x10),
.dMv_Scale_Prec_4_x11(dMv_Scale_Prec_4_x11),
.dMv_Scale_Prec_4_x12(dMv_Scale_Prec_4_x12),
.dMv_Scale_Prec_4_x13(dMv_Scale_Prec_4_x13),
.dMv_Scale_Prec_4_x14(dMv_Scale_Prec_4_x14),
.dMv_Scale_Prec_4_x15(dMv_Scale_Prec_4_x15),
.dMv_Scale_Prec_4_y10(dMv_Scale_Prec_4_y10),
.dMv_Scale_Prec_4_y11(dMv_Scale_Prec_4_y11),
.dMv_Scale_Prec_4_y12(dMv_Scale_Prec_4_y12),
.dMv_Scale_Prec_4_y13(dMv_Scale_Prec_4_y13),
.dMv_Scale_Prec_4_y14(dMv_Scale_Prec_4_y14),
.dMv_Scale_Prec_4_y15(dMv_Scale_Prec_4_y15),
.ref_data0         (ref_data0),
.ref_data1         (ref_data1),
.ref_data2         (ref_data2),
.ref_data3         (ref_data3)

);
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  export_data_pdof= 0;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  en = 1;
  enab_prof = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_pdof= 1;
    end
    else begin
      export_data_pdof= 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

initial begin
  repeat(3) @(posedge clk);
  for(j = 0; j < 100; j++) begin
    if (j % 3 == 0 ) begin
        dMv_Scale_Prec_4_x0  = $random();
        dMv_Scale_Prec_4_y0 = $random();
        dMv_Scale_Prec_4_x1 = $random();
        dMv_Scale_Prec_4_y1 = $random();
        dMv_Scale_Prec_4_x2 = $random();
        dMv_Scale_Prec_4_y2 = $random();
        dMv_Scale_Prec_4_x3 = $random();
        dMv_Scale_Prec_4_y3 = $random();
        dMv_Scale_Prec_4_x4 = $random();
        dMv_Scale_Prec_4_y4 = $random();
        dMv_Scale_Prec_4_x5 = $random();
        dMv_Scale_Prec_4_y5 = $random();
        dMv_Scale_Prec_4_x6 = $random();
        dMv_Scale_Prec_4_y6 = $random();
        dMv_Scale_Prec_4_x7 = $random();
        dMv_Scale_Prec_4_y7 = $random();
        dMv_Scale_Prec_4_x8 = $random();
        dMv_Scale_Prec_4_y8 = $random();
        dMv_Scale_Prec_4_x9 = $random();
        dMv_Scale_Prec_4_y9 = $random();
        dMv_Scale_Prec_4_x10 = $random();
        dMv_Scale_Prec_4_y10 = $random();
        dMv_Scale_Prec_4_x11 = $random();
        dMv_Scale_Prec_4_y11 = $random();
        dMv_Scale_Prec_4_x12 = $random();
        dMv_Scale_Prec_4_y12 = $random();
        dMv_Scale_Prec_4_x13 = $random();
        dMv_Scale_Prec_4_y13 = $random();
        dMv_Scale_Prec_4_x14 = $random();
        dMv_Scale_Prec_4_y14 = $random();
        dMv_Scale_Prec_4_x15 = $random();
        dMv_Scale_Prec_4_y15 = $random();
        for(k=0;k<6;k++) begin
          final_dst[k] = $random();
        end
    end
    repeat(1) @(posedge clk);
  end
end

endmodule : tb_pdof