`timescale 1ns/1ps
module tb_init();
    logic clk;
    logic rst_n;
    // dau vao bat dau tinh toan affine cho khoi du doan
    logic en;
    logic export_data_init;
    // mvbits
    logic [2:0] mvBits;
    // 3 control point vector
    logic signed [12:0] mvLT_x;
    logic signed [12:0] mvLT_y;
    logic signed [12:0] mvRT_x;
    logic signed [12:0] mvRT_y;
    logic signed [12:0] mvLB_x;
    logic signed [12:0] mvLB_y;
    // 3 pre control point vector
    logic signed [12:0] pre_mvLT_x;
    logic signed [12:0] pre_mvLT_y;
    logic signed [12:0] pre_mvRT_x;
    logic signed [12:0] pre_mvRT_y;
    logic signed [12:0] pre_mvLB_x;
    logic signed [12:0] pre_mvLB_y; 
    // toa do khoi du doan
    logic [11:0] Ipu_x;
    logic [11:0] Ipu_y;
    // use for enableProf
    logic iref_scale;
    // use for enableProf
    logic large_mv_grad_4;
    // kich thuoc khoi du doan
    logic [8:0] Ipu_w;
    logic [8:0] Ipu_h;
    // integer vector value output
    logic signed [12:0] vect_4para_Int_x;
    logic signed [12:0] vect_4para_Int_y;
    // fraction vector value ouput
    logic signed [4:0] vect_4para_Frac_x;
    logic signed [4:0] vect_4para_Frac_y;
    //ðo chênh lech toa ðo giua block du ðoán 4x4 voi khoi du ðoán hien tai 
    logic signed [7:0] blk4x4_dif_coor_x;
    logic signed [7:0] blk4x4_dif_coor_y;
    //su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
    //voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
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
    // dMvScale for affine 6
    
    //so bit toi thieu dung de bieu dien vecto chuyen dong cua khoi du doan
    logic [20:0] bits_4para;
    //tín hieu cho biet che ðo PROF ðýoc su dung
    logic enable_prof_4;

  int i;
  int j;
  int k;
always begin
  #1 clk = ~clk;
end
init_6 init_4_inst (
.clk                 (clk),
.en                  (en),
.rst_n               (rst_n),
.export_data_init    (export_data_init),
.Ipu_x               (Ipu_x),
.Ipu_y               (Ipu_y),
.vect_4para_Int_x    (vect_4para_Int_x),
.vect_4para_Int_y    (vect_4para_Int_y),
.blk4x4_dif_coor_y   (blk4x4_dif_coor_y),
.blk4x4_dif_coor_x   (blk4x4_dif_coor_x),
.vect_4para_Frac_y   (vect_4para_Frac_y),
.vect_4para_Frac_x   (vect_4para_Frac_x),
.pre_mvLB_x          (pre_mvLB_x),
.pre_mvLB_y          (pre_mvLB_y),
.pre_mvRT_x          (pre_mvRT_x),
.pre_mvRT_y          (pre_mvRT_y),
.mvBits              (mvBits),
.bits_4para          (bits_4para),
.iref_scale          (iref_scale),
.large_mv_grad_4     (large_mv_grad_4),
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
.mvLB_x              (mvLB_x),
.mvLB_y              (mvLB_y),
.mvRT_x              (mvRT_x),
.mvRT_y              (mvRT_y),
.pre_mvLT_x          (pre_mvLT_x),
.pre_mvLT_y          (pre_mvLT_y),
.Ipu_h               (Ipu_h),
.mvLT_x              (mvLT_x),
.mvLT_y              (mvLT_y),
.Ipu_w               (Ipu_w),
.enable_prof_4       (enable_prof_4)
);
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  export_data_init= 0;
  Ipu_x = 0;
  Ipu_y = 0;
  iref_scale = 0;
  large_mv_grad_4 = 0;
  Ipu_w = 6'b100000;
  Ipu_h = 6'b100000;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  mvLT_x = $random();
  mvLT_y = $random();
  mvRT_x = $random();
  mvRT_y = $random();
  mvLB_x = $random();
  mvLB_y = $random();

  pre_mvLT_x = $random();
  pre_mvLT_y = $random();
  pre_mvRT_x = $random();
  pre_mvRT_y = $random();
  pre_mvLB_x = $random();
  pre_mvLB_y = $random();
  mvBits = $random(); 
  en = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_init= 1;
    end
    else begin
      export_data_init= 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

endmodule : tb_init