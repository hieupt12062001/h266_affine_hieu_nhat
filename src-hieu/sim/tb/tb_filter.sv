`timescale 1ns/1ps
module tb_filter();
  logic clk;
  logic rst_n;
  logic enab_prof_in;
  logic en;
  logic export_data_filter;
  logic signed [71:0] ref_Pel_4 [0:8];
  logic [4:0] vect_4para_Frac_x;
  logic [4:0] vect_4para_Frac_y;

  logic [95:0] final_dst [0:5];

      //fw_data
  logic enab_prof_out;

  logic signed [10:0] dMv_Scale_Prec_4_x0_in;
  logic signed [10:0] dMv_Scale_Prec_4_y0_in;
  logic signed [10:0] dMv_Scale_Prec_4_x1_in;
  logic signed [10:0] dMv_Scale_Prec_4_y1_in;
  logic signed [10:0] dMv_Scale_Prec_4_x2_in;
  logic signed [10:0] dMv_Scale_Prec_4_y2_in;
  logic signed [10:0] dMv_Scale_Prec_4_x3_in;
  logic signed [10:0] dMv_Scale_Prec_4_y3_in;
  logic signed [10:0] dMv_Scale_Prec_4_x4_in;
  logic signed [10:0] dMv_Scale_Prec_4_y4_in;
  logic signed [10:0] dMv_Scale_Prec_4_x5_in;
  logic signed [10:0] dMv_Scale_Prec_4_y5_in;
  logic signed [10:0] dMv_Scale_Prec_4_x6_in;
  logic signed [10:0] dMv_Scale_Prec_4_y6_in;
  logic signed [10:0] dMv_Scale_Prec_4_x7_in;
  logic signed [10:0] dMv_Scale_Prec_4_y7_in;
  logic signed [10:0] dMv_Scale_Prec_4_x8_in;
  logic signed [10:0] dMv_Scale_Prec_4_y8_in;
  logic signed [10:0] dMv_Scale_Prec_4_x9_in;
  logic signed [10:0] dMv_Scale_Prec_4_y9_in;
  logic signed [10:0] dMv_Scale_Prec_4_x10_in;
  logic signed [10:0] dMv_Scale_Prec_4_y10_in;
  logic signed [10:0] dMv_Scale_Prec_4_x11_in;
  logic signed [10:0] dMv_Scale_Prec_4_y11_in;
  logic signed [10:0] dMv_Scale_Prec_4_x12_in;
  logic signed [10:0] dMv_Scale_Prec_4_y12_in;
  logic signed [10:0] dMv_Scale_Prec_4_x13_in;
  logic signed [10:0] dMv_Scale_Prec_4_y13_in;
  logic signed [10:0] dMv_Scale_Prec_4_x14_in;
  logic signed [10:0] dMv_Scale_Prec_4_y14_in;
  logic signed [10:0] dMv_Scale_Prec_4_x15_in;
  logic signed [10:0] dMv_Scale_Prec_4_y15_in;

  logic signed [10:0] dMv_Scale_Prec_4_x0_out;
  logic signed [10:0] dMv_Scale_Prec_4_y0_out;
  logic signed [10:0] dMv_Scale_Prec_4_x1_out;
  logic signed [10:0] dMv_Scale_Prec_4_y1_out;
  logic signed [10:0] dMv_Scale_Prec_4_x2_out;
  logic signed [10:0] dMv_Scale_Prec_4_y2_out;
  logic signed [10:0] dMv_Scale_Prec_4_x3_out;
  logic signed [10:0] dMv_Scale_Prec_4_y3_out;
  logic signed [10:0] dMv_Scale_Prec_4_x4_out;
  logic signed [10:0] dMv_Scale_Prec_4_y4_out;
  logic signed [10:0] dMv_Scale_Prec_4_x5_out;
  logic signed [10:0] dMv_Scale_Prec_4_y5_out;
  logic signed [10:0] dMv_Scale_Prec_4_x6_out;
  logic signed [10:0] dMv_Scale_Prec_4_y6_out;
  logic signed [10:0] dMv_Scale_Prec_4_x7_out;
  logic signed [10:0] dMv_Scale_Prec_4_y7_out;
  logic signed [10:0] dMv_Scale_Prec_4_x8_out;
  logic signed [10:0] dMv_Scale_Prec_4_y8_out;
  logic signed [10:0] dMv_Scale_Prec_4_x9_out;
  logic signed [10:0] dMv_Scale_Prec_4_y9_out;
  logic signed [10:0] dMv_Scale_Prec_4_x10_out;
  logic signed [10:0] dMv_Scale_Prec_4_y10_out;
  logic signed [10:0] dMv_Scale_Prec_4_x11_out;
  logic signed [10:0] dMv_Scale_Prec_4_y11_out;
  logic signed [10:0] dMv_Scale_Prec_4_x12_out;
  logic signed [10:0] dMv_Scale_Prec_4_y12_out;
  logic signed [10:0] dMv_Scale_Prec_4_x13_out;
  logic signed [10:0] dMv_Scale_Prec_4_y13_out;
  logic signed [10:0] dMv_Scale_Prec_4_x14_out;
  logic signed [10:0] dMv_Scale_Prec_4_y14_out;
  logic signed [10:0] dMv_Scale_Prec_4_x15_out;
  logic signed [10:0] dMv_Scale_Prec_4_y15_out;

  logic [12:0] cur_addr0_in;
  logic [12:0] cur_addr1_in;
  logic [12:0] cur_addr2_in;
  logic [12:0] cur_addr3_in;

  logic [12:0] cur_addr0_out;
  logic [12:0] cur_addr1_out;
  logic [12:0] cur_addr2_out;
  logic [12:0] cur_addr3_out;

  int i;
  int j;
  int k;
always begin
  #1 clk = ~clk;
end
filter filter_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_filter(export_data_filter),
.ref_Pel_4         (ref_Pel_4),
.enab_prof_in         (enab_prof_in),
.final_dst         (final_dst),
.vect_4para_Frac_y (vect_4para_Frac_y),
.vect_4para_Frac_x (vect_4para_Frac_x),

//fw data
.dMv_Scale_Prec_4_x0_in (dMv_Scale_Prec_4_x0_in),
.dMv_Scale_Prec_4_x1_in (dMv_Scale_Prec_4_x1_in),
.dMv_Scale_Prec_4_x2_in (dMv_Scale_Prec_4_x2_in),
.dMv_Scale_Prec_4_x3_in (dMv_Scale_Prec_4_x3_in),
.dMv_Scale_Prec_4_x4_in (dMv_Scale_Prec_4_x4_in),
.dMv_Scale_Prec_4_x5_in (dMv_Scale_Prec_4_x5_in),
.dMv_Scale_Prec_4_x6_in (dMv_Scale_Prec_4_x6_in),
.dMv_Scale_Prec_4_x7_in (dMv_Scale_Prec_4_x7_in),
.dMv_Scale_Prec_4_x8_in (dMv_Scale_Prec_4_x8_in),
.dMv_Scale_Prec_4_x9_in (dMv_Scale_Prec_4_x9_in),
.dMv_Scale_Prec_4_y0_in (dMv_Scale_Prec_4_y0_in),
.dMv_Scale_Prec_4_y1_in (dMv_Scale_Prec_4_y1_in),
.dMv_Scale_Prec_4_y2_in (dMv_Scale_Prec_4_y2_in),
.dMv_Scale_Prec_4_y3_in (dMv_Scale_Prec_4_y3_in),
.dMv_Scale_Prec_4_y4_in (dMv_Scale_Prec_4_y4_in),
.dMv_Scale_Prec_4_y5_in (dMv_Scale_Prec_4_y5_in),
.dMv_Scale_Prec_4_y6_in (dMv_Scale_Prec_4_y6_in),
.dMv_Scale_Prec_4_y7_in (dMv_Scale_Prec_4_y7_in),
.dMv_Scale_Prec_4_y8_in (dMv_Scale_Prec_4_y8_in),
.dMv_Scale_Prec_4_y9_in (dMv_Scale_Prec_4_y9_in),
.dMv_Scale_Prec_4_x10_in(dMv_Scale_Prec_4_x10_in),
.dMv_Scale_Prec_4_x11_in(dMv_Scale_Prec_4_x11_in),
.dMv_Scale_Prec_4_x12_in(dMv_Scale_Prec_4_x12_in),
.dMv_Scale_Prec_4_x13_in(dMv_Scale_Prec_4_x13_in),
.dMv_Scale_Prec_4_x14_in(dMv_Scale_Prec_4_x14_in),
.dMv_Scale_Prec_4_x15_in(dMv_Scale_Prec_4_x15_in),
.dMv_Scale_Prec_4_y10_in(dMv_Scale_Prec_4_y10_in),
.dMv_Scale_Prec_4_y11_in(dMv_Scale_Prec_4_y11_in),
.dMv_Scale_Prec_4_y12_in(dMv_Scale_Prec_4_y12_in),
.dMv_Scale_Prec_4_y13_in(dMv_Scale_Prec_4_y13_in),
.dMv_Scale_Prec_4_y14_in(dMv_Scale_Prec_4_y14_in),
.dMv_Scale_Prec_4_y15_in(dMv_Scale_Prec_4_y15_in),


.dMv_Scale_Prec_4_x0_out (dMv_Scale_Prec_4_x0_out),
.dMv_Scale_Prec_4_x1_out (dMv_Scale_Prec_4_x1_out),
.dMv_Scale_Prec_4_x2_out (dMv_Scale_Prec_4_x2_out),
.dMv_Scale_Prec_4_x3_out (dMv_Scale_Prec_4_x3_out),
.dMv_Scale_Prec_4_x4_out (dMv_Scale_Prec_4_x4_out),
.dMv_Scale_Prec_4_x5_out (dMv_Scale_Prec_4_x5_out),
.dMv_Scale_Prec_4_x6_out (dMv_Scale_Prec_4_x6_out),
.dMv_Scale_Prec_4_x7_out (dMv_Scale_Prec_4_x7_out),
.dMv_Scale_Prec_4_x8_out (dMv_Scale_Prec_4_x8_out),
.dMv_Scale_Prec_4_x9_out (dMv_Scale_Prec_4_x9_out),
.dMv_Scale_Prec_4_y0_out (dMv_Scale_Prec_4_y0_out),
.dMv_Scale_Prec_4_y1_out (dMv_Scale_Prec_4_y1_out),
.dMv_Scale_Prec_4_y2_out (dMv_Scale_Prec_4_y2_out),
.dMv_Scale_Prec_4_y3_out (dMv_Scale_Prec_4_y3_out),
.dMv_Scale_Prec_4_y4_out (dMv_Scale_Prec_4_y4_out),
.dMv_Scale_Prec_4_y5_out (dMv_Scale_Prec_4_y5_out),
.dMv_Scale_Prec_4_y6_out (dMv_Scale_Prec_4_y6_out),
.dMv_Scale_Prec_4_y7_out (dMv_Scale_Prec_4_y7_out),
.dMv_Scale_Prec_4_y8_out (dMv_Scale_Prec_4_y8_out),
.dMv_Scale_Prec_4_y9_out (dMv_Scale_Prec_4_y9_out),
.dMv_Scale_Prec_4_x10_out(dMv_Scale_Prec_4_x10_out),
.dMv_Scale_Prec_4_x11_out(dMv_Scale_Prec_4_x11_out),
.dMv_Scale_Prec_4_x12_out(dMv_Scale_Prec_4_x12_out),
.dMv_Scale_Prec_4_x13_out(dMv_Scale_Prec_4_x13_out),
.dMv_Scale_Prec_4_x14_out(dMv_Scale_Prec_4_x14_out),
.dMv_Scale_Prec_4_x15_out(dMv_Scale_Prec_4_x15_out),
.dMv_Scale_Prec_4_y10_out(dMv_Scale_Prec_4_y10_out),
.dMv_Scale_Prec_4_y11_out(dMv_Scale_Prec_4_y11_out),
.dMv_Scale_Prec_4_y12_out(dMv_Scale_Prec_4_y12_out),
.dMv_Scale_Prec_4_y13_out(dMv_Scale_Prec_4_y13_out),
.dMv_Scale_Prec_4_y14_out(dMv_Scale_Prec_4_y14_out),
.dMv_Scale_Prec_4_y15_out(dMv_Scale_Prec_4_y15_out),

.enab_prof_out         (enab_prof_out),
.cur_addr0_in          (cur_addr0_in),
.cur_addr1_in          (cur_addr1_in),
.cur_addr2_in          (cur_addr2_in),
.cur_addr3_in          (cur_addr3_in),
.cur_addr0_out         (cur_addr0_out),
.cur_addr1_out         (cur_addr1_out),
.cur_addr2_out         (cur_addr2_out),
.cur_addr3_out         (cur_addr3_out)
);
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  export_data_filter= 0;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  en = 1;
  enab_prof_in = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_filter= 1;
    end
    else begin
      export_data_filter= 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

initial begin
  repeat(3) @(posedge clk);
  for(j = 0; j < 100; j++) begin
    if (j % 3 == 0 ) begin
        vect_4para_Frac_x= $urandom_range(0,15);
        vect_4para_Frac_y = $urandom_range(0,15);
        for(k=0;k<9;k++) begin
          ref_Pel_4[k] = $random();
        end
    end
    repeat(1) @(posedge clk);
  end
end

endmodule : tb_filter