`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 03:49:27 PM
// Design Name: 
// Module Name: affine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module affine(
    input clk,
    input rst_n,
    input start_load,
    // bat dau tinh toan
    input start_calc,
    // 3 control point vector
    input signed [12:0] mvLT_x,
    input signed [12:0] mvLT_y,
    input signed [12:0] mvRT_x,
    input signed [12:0] mvRT_y,
    input signed [12:0] mvLB_x,
    input signed [12:0] mvLB_y,
    // Ipu_coor
    input [11:0] Ipu_x,
    input [11:0] Ipu_y,
    // use for enableProf
    input iref_scale,
    // use for enableProf
    input large_mv_grad,
    // Ipu size
    input [8:0] Ipu_w,
    input [8:0] Ipu_h,
    //gia tri lam da
    input [8:0] lamb,
    //gia tri hevc
    input [20:0] rdcost_HEVC,
    //so bit toi thieu ma hoa vecto control point
    input [20:0] bits, 
    output logic [20:0] cost_min,
    output logic [2:0] mode,
    output logic done
    );
wire signed [12:0] vect_Int_x;
wire signed [12:0] vect_Int_y;
    // fraction vector value ouput
wire [4:0] vect_Frac_x;
wire [4:0] vect_Frac_y;
    // calculate done flag
wire calc_done;
    // the difference of the coor subblock 4x4 and the coor prediction block
wire signed [7:0] blk4x4_dif_coor_x;
wire signed [7:0] blk4x4_dif_coor_y;
    // dMvScale for affine 
wire signed [10:0] dMv_Scale_Prec_x0;
wire signed [10:0] dMv_Scale_Prec_y0;
wire signed [10:0] dMv_Scale_Prec_x1;
wire signed [10:0] dMv_Scale_Prec_y1;
wire signed [10:0] dMv_Scale_Prec_x2;
wire signed [10:0] dMv_Scale_Prec_y2;
wire signed [10:0] dMv_Scale_Prec_x3;
wire signed [10:0] dMv_Scale_Prec_y3;
wire signed [10:0] dMv_Scale_Prec_x4;
wire signed [10:0] dMv_Scale_Prec_y4;
wire signed [10:0] dMv_Scale_Prec_x5;
wire signed [10:0] dMv_Scale_Prec_y5;
wire signed [10:0] dMv_Scale_Prec_x6;
wire signed [10:0] dMv_Scale_Prec_y6;
wire signed [10:0] dMv_Scale_Prec_x7;
wire signed [10:0] dMv_Scale_Prec_y7;
wire signed [10:0] dMv_Scale_Prec_x8;
wire signed [10:0] dMv_Scale_Prec_y8;
wire signed [10:0] dMv_Scale_Prec_x9;
wire signed [10:0] dMv_Scale_Prec_y9;
wire signed [10:0] dMv_Scale_Prec_x10;
wire signed [10:0] dMv_Scale_Prec_y10;
wire signed [10:0] dMv_Scale_Prec_x11;
wire signed [10:0] dMv_Scale_Prec_y11;
wire signed [10:0] dMv_Scale_Prec_x12;
wire signed [10:0] dMv_Scale_Prec_y12;
wire signed [10:0] dMv_Scale_Prec_x13;
wire signed [10:0] dMv_Scale_Prec_y13;
wire signed [10:0] dMv_Scale_Prec_x14;
wire signed [10:0] dMv_Scale_Prec_y14;
wire signed [10:0] dMv_Scale_Prec_x15;
wire signed [10:0] dMv_Scale_Prec_y15;

wire enable_prof;

wire [31:0] ref_data40;
wire [31:0] ref_data41;
wire [31:0] ref_data42;
wire [31:0] ref_data43;

wire comb_done;
wire [31:0] cur_data0;
wire [31:0] cur_data1;
wire [31:0] cur_data2;
wire [31:0] cur_data3;
wire start_cost;
wire start_blk;
wire [20:0] rdcost;
wire rdcost_done;
wire start_comb;

wire last;
wire first;

wire start_aff6;

mv_blk_calc sblk1(.clk(clk), .rst_n(rst_n), .start_aff6(start_aff6), .start_load(start_load), .Ipu_w(Ipu_w), .Ipu_h(Ipu_h), .start_calc(start_calc), .start_blk(start_blk), .mvLT_x(mvLT_x), .mvLT_y(mvLT_y), .mvRT_x(mvRT_x), .mvRT_y(mvRT_y), .mvLB_x(mvLB_x), .mvLB_y(mvLB_y), 
    .iref_scale(iref_scale), 
    .large_mv_grad(large_mv_grad), .vect_Int_x(vect_Int_x), .vect_Int_y(vect_Int_y),
    .vect_Frac_x(vect_Frac_x), .vect_Frac_y(vect_Frac_y), .calc_done(calc_done), .blk4x4_dif_coor_x(blk4x4_dif_coor_x), .blk4x4_dif_coor_y(blk4x4_dif_coor_y),
    .enable_prof(enable_prof), .dMv_Scale_Prec_x0(dMv_Scale_Prec_x0), .dMv_Scale_Prec_y0(dMv_Scale_Prec_y0), .dMv_Scale_Prec_x1(dMv_Scale_Prec_x1), .dMv_Scale_Prec_y1(dMv_Scale_Prec_y1),
    .dMv_Scale_Prec_x2(dMv_Scale_Prec_x2), .dMv_Scale_Prec_y2(dMv_Scale_Prec_y2), .dMv_Scale_Prec_x3(dMv_Scale_Prec_x3), .dMv_Scale_Prec_y3(dMv_Scale_Prec_y3), .dMv_Scale_Prec_x4(dMv_Scale_Prec_x4), .dMv_Scale_Prec_y4(dMv_Scale_Prec_y4), .dMv_Scale_Prec_x5(dMv_Scale_Prec_x5),
    .dMv_Scale_Prec_y5(dMv_Scale_Prec_y5), .dMv_Scale_Prec_x6(dMv_Scale_Prec_x6), .dMv_Scale_Prec_y6(dMv_Scale_Prec_y6), .dMv_Scale_Prec_x7(dMv_Scale_Prec_x7), .dMv_Scale_Prec_y7(dMv_Scale_Prec_y7), .dMv_Scale_Prec_x8(dMv_Scale_Prec_x8), .dMv_Scale_Prec_y8(dMv_Scale_Prec_y8),
    .dMv_Scale_Prec_x9(dMv_Scale_Prec_x9), .dMv_Scale_Prec_y9(dMv_Scale_Prec_y9), .dMv_Scale_Prec_x10(dMv_Scale_Prec_x10), .dMv_Scale_Prec_y10(dMv_Scale_Prec_y10), .dMv_Scale_Prec_x11(dMv_Scale_Prec_x11), .dMv_Scale_Prec_y11(dMv_Scale_Prec_y11), .dMv_Scale_Prec_x12(dMv_Scale_Prec_x12),
    .dMv_Scale_Prec_y12(dMv_Scale_Prec_y12), .dMv_Scale_Prec_x13(dMv_Scale_Prec_x13), .dMv_Scale_Prec_y13(dMv_Scale_Prec_y13), .dMv_Scale_Prec_x14(dMv_Scale_Prec_x14), .dMv_Scale_Prec_y14(dMv_Scale_Prec_y14), .dMv_Scale_Prec_x15(dMv_Scale_Prec_x15), .dMv_Scale_Prec_y15(dMv_Scale_Prec_y15));

ref_comb comb_4(.clk(clk), .rst_n(rst_n), .start_load(start_load), .enable_prof(enable_prof), .calc_done(calc_done),.Ipu_w(Ipu_w), .Ipu_h(Ipu_h),.blk4x4_dif_coor_x(blk4x4_dif_coor_x), .blk4x4_dif_coor_y(blk4x4_dif_coor_y),  
.Ipu_x(Ipu_x), .Ipu_y(Ipu_y), .vect_Int_x(vect_Int_x), .vect_Int_y(vect_Int_y),
.dMv_Scale_Prec_x0(dMv_Scale_Prec_x0), .dMv_Scale_Prec_y0(dMv_Scale_Prec_y0), .dMv_Scale_Prec_x1(dMv_Scale_Prec_x1), .dMv_Scale_Prec_y1(dMv_Scale_Prec_y1),
.dMv_Scale_Prec_x2(dMv_Scale_Prec_x2), .dMv_Scale_Prec_y2(dMv_Scale_Prec_y2), .dMv_Scale_Prec_x3(dMv_Scale_Prec_x3), .dMv_Scale_Prec_y3(dMv_Scale_Prec_y3), 
.dMv_Scale_Prec_x4(dMv_Scale_Prec_x4), .dMv_Scale_Prec_y4(dMv_Scale_Prec_y4), .dMv_Scale_Prec_x5(dMv_Scale_Prec_x5),
.dMv_Scale_Prec_y5(dMv_Scale_Prec_y5), .dMv_Scale_Prec_x6(dMv_Scale_Prec_x6), .dMv_Scale_Prec_y6(dMv_Scale_Prec_y6), 
.dMv_Scale_Prec_x7(dMv_Scale_Prec_x7), .dMv_Scale_Prec_y7(dMv_Scale_Prec_y7), .dMv_Scale_Prec_x8(dMv_Scale_Prec_x8), .dMv_Scale_Prec_y8(dMv_Scale_Prec_y8),
.dMv_Scale_Prec_x9(dMv_Scale_Prec_x9), .dMv_Scale_Prec_y9(dMv_Scale_Prec_y9), .dMv_Scale_Prec_x10(dMv_Scale_Prec_x10), 
.dMv_Scale_Prec_y10(dMv_Scale_Prec_y10), .dMv_Scale_Prec_x11(dMv_Scale_Prec_x11), .dMv_Scale_Prec_y11(dMv_Scale_Prec_y11), .dMv_Scale_Prec_x12(dMv_Scale_Prec_x12),
.dMv_Scale_Prec_y12(dMv_Scale_Prec_y12), .dMv_Scale_Prec_x13(dMv_Scale_Prec_x13), .dMv_Scale_Prec_y13(dMv_Scale_Prec_y13), 
.dMv_Scale_Prec_x14(dMv_Scale_Prec_x14), .dMv_Scale_Prec_y14(dMv_Scale_Prec_y14), .dMv_Scale_Prec_x15(dMv_Scale_Prec_x15), .dMv_Scale_Prec_y15(dMv_Scale_Prec_y15),
.vect_Frac_x(vect_Frac_x), .vect_Frac_y(vect_Frac_y), .ref_data0(ref_data40), .ref_data1(ref_data41), .ref_data2(ref_data42), .ref_data3(ref_data43), .comb_done(comb_done));
    //, .ref_line_0(ref_line_0), .ref_line_1(ref_line_1), .ref_line_2(ref_line_2), .ref_line_3(ref_line_3), .ref_line_4(ref_line_4), .ref_line_5(ref_line_5), .ref_line_6(ref_line_6), .ref_line_7(ref_line_7));

cur_comb cur(.clk(clk), .rst_n(rst_n),.Ipu_w(Ipu_w), .Ipu_h(Ipu_h), .blk4x4_dif_coor_x(blk4x4_dif_coor_x), .blk4x4_dif_coor_y(blk4x4_dif_coor_y), .last(last), .first(first), .comb_done(comb_done), .start_load(start_load), .cur_data0(cur_data0), .cur_data1(cur_data1), .cur_data2(cur_data2), .cur_data3(cur_data3), .start_cost(start_cost),
.start_blk(start_blk));
//,.cur_line_0(cur_line_0), .cur_line_1(cur_line_1), .cur_line_2(cur_line_2), .cur_line_3(cur_line_3), .cur_line_4(cur_line_4), .cur_line_5(cur_line_5), .cur_line_6(cur_line_6), .cur_line_7(cur_line_7));

rdcost rd_4(.clk(clk), .first(first), .last(last), .start_cost(start_cost), .cur_data0(cur_data0), .cur_data1(cur_data1), .cur_data2(cur_data2), .cur_data3(cur_data3), .ref_data0(ref_data40), .ref_data1(ref_data41), .ref_data2(ref_data42),
.ref_data3(ref_data43), .lamb(lamb), .bits(bits), .rdcost(rdcost), .rdcost_done(rdcost_done));


compare comp(.clk(clk), .rst_n(rst_n), .start_load(start_load), .rdcost_done(rdcost_done), .rdcost_HEVC(rdcost_HEVC), .rdcost(rdcost), .cost_min(cost_min), .mode(mode), .done(done), .start_aff6(start_aff6));
endmodule
