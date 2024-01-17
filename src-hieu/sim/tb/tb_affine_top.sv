`timescale 1ns / 1ps
module tb_affine_top ();
logic clk;
logic rst_n;
// dau vao bat dau tinh toan affine cho khoi du doan
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
logic start;
logic load_ram;
logic [20:0] rd_cost_me;
logic [8:0] lamda_m;
logic [1:0] best_mode;
logic [20:0] rd_cost_min;
logic done;

// logic [31:0] cur_line_0;
// logic [31:0] cur_line_1;
// logic [31:0] cur_line_2;
// logic [31:0] cur_line_3;
// logic [31:0] cur_line_4;
// logic [31:0] cur_line_5;
// logic [31:0] cur_line_6;
// logic [31:0] cur_line_7;

// logic [127:0] ref_line_0;
// logic [127:0] ref_line_1;
// logic [127:0] ref_line_2;
// logic [127:0] ref_line_3;
// logic [127:0] ref_line_4;
// logic [127:0] ref_line_5;
// logic [127:0] ref_line_6;
// logic [127:0] ref_line_7;

// logic[15:0] k;
// logic [15:0]n;
logic [31:0] cur_data_tb [0:4095]; 
logic[127:0] ref_data_tb [0:4095];
always begin
  #1 clk = ~clk;
end

affine_top affine_top_inst(
.rd_cost_min    (rd_cost_min),
.clk            (clk),
.rst_n          (rst_n),
.best_mode      (best_mode),
.done           (done),
.lamda_m        (lamda_m),
.Ipu_x          (Ipu_x),
.Ipu_y          (Ipu_y),
.load_ram       (load_ram),
.rd_cost_me     (rd_cost_me),
.pre_mvLB_x     (pre_mvLB_x),
.pre_mvLB_y     (pre_mvLB_y),
.pre_mvRT_x     (pre_mvRT_x),
.pre_mvRT_y     (pre_mvRT_y),
.mvBits         (mvBits),
.start          (start),
.iref_scale     (iref_scale),
.large_mv_grad_4(large_mv_grad_4),
.mvLB_x         (mvLB_x),
.mvLB_y         (mvLB_y),
.mvRT_x         (mvRT_x),
.mvRT_y         (mvRT_y),
.pre_mvLT_x     (pre_mvLT_x),
.pre_mvLT_y     (pre_mvLT_y),
.Ipu_h          (Ipu_h),
.mvLT_x         (mvLT_x),
.mvLT_y         (mvLT_y),
.Ipu_w          (Ipu_w)
// .ref_line_0              (ref_line_0),
// .ref_line_1              (ref_line_1),
// .ref_line_2              (ref_line_2),
// .ref_line_3              (ref_line_3),
// // .ref_line_4              (ref_line_4),
// // .ref_line_5              (ref_line_5),
// // .ref_line_6              (ref_line_6),
// // .ref_line_7              (ref_line_7),
// .cur_line_0     (cur_line_0),
// .cur_line_1     (cur_line_1),
// .cur_line_2     (cur_line_2),
// .cur_line_3     (cur_line_3),
// .cur_line_4     (cur_line_4),
// .cur_line_5     (cur_line_5),
// .cur_line_6     (cur_line_6),
// .cur_line_7     (cur_line_7)
);

initial begin 
  clk = 1;
  rst_n = 1;
  lamda_m = 20'd0;
  rd_cost_me = 20'd9999999;
  // mvLT_x = -23;
  // mvLT_y = -5;
  // mvRT_x = -23;
  // mvRT_y = -5;
  // mvLB_x = -23;
  // mvLB_y = -5;
  
  mvLT_x = -92;
  mvLT_y = -20;
  mvRT_x = -92;
  mvRT_y = -20;
  mvLB_x = -92;
  mvLB_y = -20;
  pre_mvLT_x = 0;
  pre_mvLT_y = 0;
  pre_mvRT_x = 0;
  pre_mvRT_y = 0;
  pre_mvLB_x = 0;
  pre_mvLB_y = 0;
  mvBits = 2;
  Ipu_x = 0;
  Ipu_y = 0;
  iref_scale = 0;
  large_mv_grad_4 = 0;
  Ipu_w = 8'd128;
  Ipu_h = 8'd128;
  repeat(1) @(posedge clk);
  rst_n = 0;
  start = 0;
  load_ram = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  load_ram = 1;
  // $readmemh("/data6/workspace/hieupt1/H266_128/data/ref_ram.txt", ref_data_tb);
  // for (k = 0; k < 4095; k = k+4) begin
  //   repeat(1) @(negedge clk);
  //   ref_line_0 = ref_data_tb[k+0];
  //   ref_line_1 = ref_data_tb[k+1];
  //   ref_line_2 = ref_data_tb[k+2];
  //   ref_line_3 = ref_data_tb[k+3];
  //   // ref_line_4 = ref_data_tb[k+4];
  //   // ref_line_5 = ref_data_tb[k+5];
  //   // ref_line_6 = ref_data_tb[k+6];
  //   // ref_line_7 = ref_data_tb[k+7];
  // end
  repeat(1) @(posedge clk);
  load_ram = 0;
  start = 1;

  #7000;
  $finish;
end

// initial begin
//   repeat(2) @(posedge clk);
//   $readmemh("/data6/workspace/hieupt1/H266_128/data/cur_ram.txt", cur_data_tb);
//   for (n = 0; n < 4090; n = n+8) begin
//     repeat(1) @(negedge clk);
//     cur_line_0 = cur_data_tb[n+0];
//     cur_line_1 = cur_data_tb[n+1];
//     cur_line_2 = cur_data_tb[n+2];
//     cur_line_3 = cur_data_tb[n+3];
//     cur_line_4 = cur_data_tb[n+4];
//     cur_line_5 = cur_data_tb[n+5];
//     cur_line_6 = cur_data_tb[n+6];
//     cur_line_7 = cur_data_tb[n+7];
//     // cur_line_8 = cur_data_tb[n+8];
//     // cur_line_9 = cur_data_tb[n+9];
//     // cur_line_10 = cur_data_tb[n+10];
//     // cur_line_11 = cur_data_tb[n+11];
//     // cur_line_12 = cur_data_tb[n+12];
//     // cur_line_13 = cur_data_tb[n+13];
//     // cur_line_14 = cur_data_tb[n+14];
//     // cur_line_15 = cur_data_tb[n+15];
//   end
// end
endmodule : tb_affine_top