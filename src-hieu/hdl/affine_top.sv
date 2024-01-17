module affine_top (
input clk,    // Clock
input rst_n,  // Asynchronous reset active low
input start,
input load_ram,
input [20:0] rd_cost_me,
input [8:0] lamda_m,
input [2:0] mvBits,
// 3 control point vector
input signed [12:0] mvLT_x,
input signed [12:0] mvLT_y,
input signed [12:0] mvRT_x,
input signed [12:0] mvRT_y,
input signed [12:0] mvLB_x,
input signed [12:0] mvLB_y,
// 3 pre control point vector
input signed [12:0] pre_mvLT_x,
input signed [12:0] pre_mvLT_y,
input signed [12:0] pre_mvRT_x,
input signed [12:0] pre_mvRT_y,
input signed [12:0] pre_mvLB_x,
input signed [12:0] pre_mvLB_y, 
// toa do khoi du doan
input [11:0] Ipu_x,
input [11:0] Ipu_y,
// use for enableProf
input iref_scale,
// use for enableProf
input large_mv_grad_4,
// kich thuoc khoi du doan
input [8:0] Ipu_w,
input [8:0] Ipu_h,

// input [31:0] cur_line_0,
// input [31:0] cur_line_1,
// input [31:0] cur_line_2,
// input [31:0] cur_line_3,
// input [31:0] cur_line_4,
// input [31:0] cur_line_5,
// input [31:0] cur_line_6,
// input [31:0] cur_line_7,

// input [127:0] ref_line_0,
// input [127:0] ref_line_1,
// input [127:0] ref_line_2,
// input [127:0] ref_line_3,
// input [127:0] ref_line_4,
// input [127:0] ref_line_5,
// input [127:0] ref_line_6,
// input [127:0] ref_line_7,

output  logic [1:0] best_mode,
output  logic [20:0] rd_cost_min,
output  logic done
);
//control
logic export_data_init;
logic export_data_cal;
logic export_data_ref;
logic export_data_filter;
logic export_data_pdof;
logic export_data_cur;
logic export_data_had;
logic load_ref_ram;
logic load_cur_ram;
logic en;
logic [15:0] had_4x4;
logic [15:0] six_had_4x4;
//init4
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

//init6
logic signed [12:0] six_vect_4para_Int_x;
logic signed [12:0] six_vect_4para_Int_y;
// fraction vector value ouput
logic signed [4:0] six_vect_4para_Frac_x;
logic signed [4:0] six_vect_4para_Frac_y;
//ðo chênh lech toa ðo giua block du ðoán 4x4 voi khoi du ðoán hien tai 
logic signed [7:0] six_blk4x4_dif_coor_x;
logic signed [7:0] six_blk4x4_dif_coor_y;
//su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
//voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
logic signed [10:0] six_dMv_Scale_Prec_4_x0;
logic signed [10:0] six_dMv_Scale_Prec_4_y0;
logic signed [10:0] six_dMv_Scale_Prec_4_x1;
logic signed [10:0] six_dMv_Scale_Prec_4_y1;
logic signed [10:0] six_dMv_Scale_Prec_4_x2;
logic signed [10:0] six_dMv_Scale_Prec_4_y2;
logic signed [10:0] six_dMv_Scale_Prec_4_x3;
logic signed [10:0] six_dMv_Scale_Prec_4_y3;
logic signed [10:0] six_dMv_Scale_Prec_4_x4;
logic signed [10:0] six_dMv_Scale_Prec_4_y4;
logic signed [10:0] six_dMv_Scale_Prec_4_x5;
logic signed [10:0] six_dMv_Scale_Prec_4_y5;
logic signed [10:0] six_dMv_Scale_Prec_4_x6;
logic signed [10:0] six_dMv_Scale_Prec_4_y6;
logic signed [10:0] six_dMv_Scale_Prec_4_x7;
logic signed [10:0] six_dMv_Scale_Prec_4_y7;
logic signed [10:0] six_dMv_Scale_Prec_4_x8;
logic signed [10:0] six_dMv_Scale_Prec_4_y8;
logic signed [10:0] six_dMv_Scale_Prec_4_x9;
logic signed [10:0] six_dMv_Scale_Prec_4_y9;
logic signed [10:0] six_dMv_Scale_Prec_4_x10;
logic signed [10:0] six_dMv_Scale_Prec_4_y10;
logic signed [10:0] six_dMv_Scale_Prec_4_x11;
logic signed [10:0] six_dMv_Scale_Prec_4_y11;
logic signed [10:0] six_dMv_Scale_Prec_4_x12;
logic signed [10:0] six_dMv_Scale_Prec_4_y12;
logic signed [10:0] six_dMv_Scale_Prec_4_x13;
logic signed [10:0] six_dMv_Scale_Prec_4_y13;
logic signed [10:0] six_dMv_Scale_Prec_4_x14;
logic signed [10:0] six_dMv_Scale_Prec_4_y14;
logic signed [10:0] six_dMv_Scale_Prec_4_x15;
logic signed [10:0] six_dMv_Scale_Prec_4_y15;
// dMvScale for affine 
//so bit toi thieu dung de bieu dien vecto chuyen dong cua khoi du doan
logic [20:0] six_bits_4para;
//tín hieu cho biet che ðo PROF ðýoc su dung
logic six_enable_prof_4;

logic [12:0] cur_addr0;
logic [12:0] cur_addr1;
logic [12:0] cur_addr2;
logic [12:0] cur_addr3;
logic [12:0] addr_4;
logic [3:0] pos_4;
// fraction vector value ouput
logic signed [4:0] vect_4para_Frac_x_out1;
logic signed [4:0] vect_4para_Frac_y_out1;

//su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
//voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
logic signed [10:0] dMv_Scale_Prec_4_x0_out1;
logic signed [10:0] dMv_Scale_Prec_4_y0_out1;
logic signed [10:0] dMv_Scale_Prec_4_x1_out1;
logic signed [10:0] dMv_Scale_Prec_4_y1_out1;
logic signed [10:0] dMv_Scale_Prec_4_x2_out1;
logic signed [10:0] dMv_Scale_Prec_4_y2_out1;
logic signed [10:0] dMv_Scale_Prec_4_x3_out1;
logic signed [10:0] dMv_Scale_Prec_4_y3_out1;
logic signed [10:0] dMv_Scale_Prec_4_x4_out1;
logic signed [10:0] dMv_Scale_Prec_4_y4_out1;
logic signed [10:0] dMv_Scale_Prec_4_x5_out1;
logic signed [10:0] dMv_Scale_Prec_4_y5_out1;
logic signed [10:0] dMv_Scale_Prec_4_x6_out1;
logic signed [10:0] dMv_Scale_Prec_4_y6_out1;
logic signed [10:0] dMv_Scale_Prec_4_x7_out1;
logic signed [10:0] dMv_Scale_Prec_4_y7_out1;
logic signed [10:0] dMv_Scale_Prec_4_x8_out1;
logic signed [10:0] dMv_Scale_Prec_4_y8_out1;
logic signed [10:0] dMv_Scale_Prec_4_x9_out1;
logic signed [10:0] dMv_Scale_Prec_4_y9_out1;
logic signed [10:0] dMv_Scale_Prec_4_x10_out1;
logic signed [10:0] dMv_Scale_Prec_4_y10_out1;
logic signed [10:0] dMv_Scale_Prec_4_x11_out1;
logic signed [10:0] dMv_Scale_Prec_4_y11_out1;
logic signed [10:0] dMv_Scale_Prec_4_x12_out1;
logic signed [10:0] dMv_Scale_Prec_4_y12_out1;
logic signed [10:0] dMv_Scale_Prec_4_x13_out1;
logic signed [10:0] dMv_Scale_Prec_4_y13_out1;
logic signed [10:0] dMv_Scale_Prec_4_x14_out1;
logic signed [10:0] dMv_Scale_Prec_4_y14_out1;
logic signed [10:0] dMv_Scale_Prec_4_x15_out1;
logic signed [10:0] dMv_Scale_Prec_4_y15_out1;

logic enab_prof_out1;

logic [12:0] six_cur_addr0;
logic [12:0] six_cur_addr1;
logic [12:0] six_cur_addr2;
logic [12:0] six_cur_addr3;
logic [12:0] six_addr_4;
logic [3:0] six_pos_4;
// fraction vector value ouput
logic signed [4:0] six_vect_4para_Frac_x_out1;
logic signed [4:0] six_vect_4para_Frac_y_out1;

//su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
//voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
logic signed [10:0] six_dMv_Scale_Prec_4_x0_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y0_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x1_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y1_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x2_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y2_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x3_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y3_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x4_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y4_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x5_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y5_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x6_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y6_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x7_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y7_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x8_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y8_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x9_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y9_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x10_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y10_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x11_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y11_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x12_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y12_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x13_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y13_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x14_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y14_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_x15_out1;
logic signed [10:0] six_dMv_Scale_Prec_4_y15_out1;

logic six_enab_prof_out1;

logic signed [71:0] ref_Pel_4 [0:8];
logic [12:0] cur_addr0_out2;
logic [12:0] cur_addr1_out2;
logic [12:0] cur_addr2_out2;
logic [12:0] cur_addr3_out2;
// fraction vector value ouput
logic signed [4:0] vect_4para_Frac_x_out2;
logic signed [4:0] vect_4para_Frac_y_out2;

//su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
//voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
logic signed [10:0] dMv_Scale_Prec_4_x0_out2;
logic signed [10:0] dMv_Scale_Prec_4_y0_out2;
logic signed [10:0] dMv_Scale_Prec_4_x1_out2;
logic signed [10:0] dMv_Scale_Prec_4_y1_out2;
logic signed [10:0] dMv_Scale_Prec_4_x2_out2;
logic signed [10:0] dMv_Scale_Prec_4_y2_out2;
logic signed [10:0] dMv_Scale_Prec_4_x3_out2;
logic signed [10:0] dMv_Scale_Prec_4_y3_out2;
logic signed [10:0] dMv_Scale_Prec_4_x4_out2;
logic signed [10:0] dMv_Scale_Prec_4_y4_out2;
logic signed [10:0] dMv_Scale_Prec_4_x5_out2;
logic signed [10:0] dMv_Scale_Prec_4_y5_out2;
logic signed [10:0] dMv_Scale_Prec_4_x6_out2;
logic signed [10:0] dMv_Scale_Prec_4_y6_out2;
logic signed [10:0] dMv_Scale_Prec_4_x7_out2;
logic signed [10:0] dMv_Scale_Prec_4_y7_out2;
logic signed [10:0] dMv_Scale_Prec_4_x8_out2;
logic signed [10:0] dMv_Scale_Prec_4_y8_out2;
logic signed [10:0] dMv_Scale_Prec_4_x9_out2;
logic signed [10:0] dMv_Scale_Prec_4_y9_out2;
logic signed [10:0] dMv_Scale_Prec_4_x10_out2;
logic signed [10:0] dMv_Scale_Prec_4_y10_out2;
logic signed [10:0] dMv_Scale_Prec_4_x11_out2;
logic signed [10:0] dMv_Scale_Prec_4_y11_out2;
logic signed [10:0] dMv_Scale_Prec_4_x12_out2;
logic signed [10:0] dMv_Scale_Prec_4_y12_out2;
logic signed [10:0] dMv_Scale_Prec_4_x13_out2;
logic signed [10:0] dMv_Scale_Prec_4_y13_out2;
logic signed [10:0] dMv_Scale_Prec_4_x14_out2;
logic signed [10:0] dMv_Scale_Prec_4_y14_out2;
logic signed [10:0] dMv_Scale_Prec_4_x15_out2;
logic signed [10:0] dMv_Scale_Prec_4_y15_out2;

logic enab_prof_out2;

logic signed [71:0] six_ref_Pel_4 [0:8];
logic [12:0] six_cur_addr0_out2;
logic [12:0] six_cur_addr1_out2;
logic [12:0] six_cur_addr2_out2;
logic [12:0] six_cur_addr3_out2;
// fraction vector value ouput
logic signed [4:0] six_vect_4para_Frac_x_out2;
logic signed [4:0] six_vect_4para_Frac_y_out2;

//su khac biet toa do theo chieu ngang; doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
//voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
logic signed [10:0] six_dMv_Scale_Prec_4_x0_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y0_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x1_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y1_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x2_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y2_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x3_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y3_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x4_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y4_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x5_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y5_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x6_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y6_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x7_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y7_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x8_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y8_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x9_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y9_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x10_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y10_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x11_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y11_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x12_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y12_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x13_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y13_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x14_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y14_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_x15_out2;
logic signed [10:0] six_dMv_Scale_Prec_4_y15_out2;

logic six_enab_prof_out2;

logic [95:0] final_dst [0:5];
logic [12:0] cur_addr0_out3;
logic [12:0] cur_addr1_out3;
logic [12:0] cur_addr2_out3;
logic [12:0] cur_addr3_out3;
logic signed [10:0] dMv_Scale_Prec_4_x0_out3;
logic signed [10:0] dMv_Scale_Prec_4_y0_out3;
logic signed [10:0] dMv_Scale_Prec_4_x1_out3;
logic signed [10:0] dMv_Scale_Prec_4_y1_out3;
logic signed [10:0] dMv_Scale_Prec_4_x2_out3;
logic signed [10:0] dMv_Scale_Prec_4_y2_out3;
logic signed [10:0] dMv_Scale_Prec_4_x3_out3;
logic signed [10:0] dMv_Scale_Prec_4_y3_out3;
logic signed [10:0] dMv_Scale_Prec_4_x4_out3;
logic signed [10:0] dMv_Scale_Prec_4_y4_out3;
logic signed [10:0] dMv_Scale_Prec_4_x5_out3;
logic signed [10:0] dMv_Scale_Prec_4_y5_out3;
logic signed [10:0] dMv_Scale_Prec_4_x6_out3;
logic signed [10:0] dMv_Scale_Prec_4_y6_out3;
logic signed [10:0] dMv_Scale_Prec_4_x7_out3;
logic signed [10:0] dMv_Scale_Prec_4_y7_out3;
logic signed [10:0] dMv_Scale_Prec_4_x8_out3;
logic signed [10:0] dMv_Scale_Prec_4_y8_out3;
logic signed [10:0] dMv_Scale_Prec_4_x9_out3;
logic signed [10:0] dMv_Scale_Prec_4_y9_out3;
logic signed [10:0] dMv_Scale_Prec_4_x10_out3;
logic signed [10:0] dMv_Scale_Prec_4_y10_out3;
logic signed [10:0] dMv_Scale_Prec_4_x11_out3;
logic signed [10:0] dMv_Scale_Prec_4_y11_out3;
logic signed [10:0] dMv_Scale_Prec_4_x12_out3;
logic signed [10:0] dMv_Scale_Prec_4_y12_out3;
logic signed [10:0] dMv_Scale_Prec_4_x13_out3;
logic signed [10:0] dMv_Scale_Prec_4_y13_out3;
logic signed [10:0] dMv_Scale_Prec_4_x14_out3;
logic signed [10:0] dMv_Scale_Prec_4_y14_out3;
logic signed [10:0] dMv_Scale_Prec_4_x15_out3;
logic signed [10:0] dMv_Scale_Prec_4_y15_out3;

logic enab_prof_out3;

logic [95:0] six_final_dst [0:5];
logic [12:0] six_cur_addr0_out3;
logic [12:0] six_cur_addr1_out3;
logic [12:0] six_cur_addr2_out3;
logic [12:0] six_cur_addr3_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x0_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y0_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x1_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y1_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x2_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y2_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x3_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y3_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x4_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y4_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x5_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y5_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x6_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y6_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x7_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y7_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x8_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y8_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x9_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y9_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x10_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y10_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x11_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y11_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x12_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y12_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x13_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y13_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x14_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y14_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_x15_out3;
logic signed [10:0] six_dMv_Scale_Prec_4_y15_out3;

logic six_enab_prof_out3;

logic [31:0] ref_data0;
logic [31:0] ref_data1;
logic [31:0] ref_data2;
logic [31:0] ref_data3;

logic [31:0] six_ref_data0;
logic [31:0] six_ref_data1;
logic [31:0] six_ref_data2;
logic [31:0] six_ref_data3;

logic [31:0] cur_data0;
logic [31:0] cur_data1;
logic [31:0] cur_data2;
logic [31:0] cur_data3;

logic [31:0] six_cur_data0;
logic [31:0] six_cur_data1;
logic [31:0] six_cur_data2;
logic [31:0] six_cur_data3;

logic [15:0]num_of_sub_blk;
affine_control affine_control_inst (
.clk               (clk),
.rst_n             (rst_n),
.start             (start),
.load_ram          (load_ram),
.rd_cost_me        (rd_cost_me),
.had_4_param       (had_4x4),
.had_6_param       (six_had_4x4),
.lamda_m           (lamda_m),
.ctrl_point_bits   (six_bits_4para),
.en                (en),
.export_data_init  (export_data_init),
.export_data_cal   (export_data_cal),
.export_data_ref   (export_data_ref),
.export_data_filter(export_data_filter),
.export_data_pdof  (export_data_pdof),
.export_data_cur   (export_data_cur),
.export_data_had   (export_data_had),
.load_ref_ram      (load_ref_ram),
.load_cur_ram      (load_cur_ram),
.rd_cost_min    (rd_cost_min),
.num_of_sub_blk    (num_of_sub_blk),
.best_mode         (best_mode),
.done              (done)
);

init_4 init_4_inst (
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

init_6 init_6_inst (
.clk                 (clk),
.en                  (en),
.rst_n               (rst_n),
.export_data_init    (export_data_init),
.Ipu_x               (Ipu_x),
.Ipu_y               (Ipu_y),
.vect_4para_Int_x    (six_vect_4para_Int_x),
.vect_4para_Int_y    (six_vect_4para_Int_y),
.blk4x4_dif_coor_y   (six_blk4x4_dif_coor_y),
.blk4x4_dif_coor_x   (six_blk4x4_dif_coor_x),
.vect_4para_Frac_y   (six_vect_4para_Frac_y),
.vect_4para_Frac_x   (six_vect_4para_Frac_x),
.pre_mvLB_x          (pre_mvLB_x),
.pre_mvLB_y          (pre_mvLB_y),
.pre_mvRT_x          (pre_mvRT_x),
.pre_mvRT_y          (pre_mvRT_y),
.mvBits              (mvBits),
.bits_4para          (six_bits_4para),
.iref_scale          (iref_scale),
.large_mv_grad_4     (large_mv_grad_4),
.dMv_Scale_Prec_4_x0 (six_dMv_Scale_Prec_4_x0),
.dMv_Scale_Prec_4_x1 (six_dMv_Scale_Prec_4_x1),
.dMv_Scale_Prec_4_x2 (six_dMv_Scale_Prec_4_x2),
.dMv_Scale_Prec_4_x3 (six_dMv_Scale_Prec_4_x3),
.dMv_Scale_Prec_4_x4 (six_dMv_Scale_Prec_4_x4),
.dMv_Scale_Prec_4_x5 (six_dMv_Scale_Prec_4_x5),
.dMv_Scale_Prec_4_x6 (six_dMv_Scale_Prec_4_x6),
.dMv_Scale_Prec_4_x7 (six_dMv_Scale_Prec_4_x7),
.dMv_Scale_Prec_4_x8 (six_dMv_Scale_Prec_4_x8),
.dMv_Scale_Prec_4_x9 (six_dMv_Scale_Prec_4_x9),
.dMv_Scale_Prec_4_y0 (six_dMv_Scale_Prec_4_y0),
.dMv_Scale_Prec_4_y1 (six_dMv_Scale_Prec_4_y1),
.dMv_Scale_Prec_4_y2 (six_dMv_Scale_Prec_4_y2),
.dMv_Scale_Prec_4_y3 (six_dMv_Scale_Prec_4_y3),
.dMv_Scale_Prec_4_y4 (six_dMv_Scale_Prec_4_y4),
.dMv_Scale_Prec_4_y5 (six_dMv_Scale_Prec_4_y5),
.dMv_Scale_Prec_4_y6 (six_dMv_Scale_Prec_4_y6),
.dMv_Scale_Prec_4_y7 (six_dMv_Scale_Prec_4_y7),
.dMv_Scale_Prec_4_y8 (six_dMv_Scale_Prec_4_y8),
.dMv_Scale_Prec_4_y9 (six_dMv_Scale_Prec_4_y9),
.dMv_Scale_Prec_4_x10(six_dMv_Scale_Prec_4_x10),
.dMv_Scale_Prec_4_x11(six_dMv_Scale_Prec_4_x11),
.dMv_Scale_Prec_4_x12(six_dMv_Scale_Prec_4_x12),
.dMv_Scale_Prec_4_x13(six_dMv_Scale_Prec_4_x13),
.dMv_Scale_Prec_4_x14(six_dMv_Scale_Prec_4_x14),
.dMv_Scale_Prec_4_x15(six_dMv_Scale_Prec_4_x15),
.dMv_Scale_Prec_4_y10(six_dMv_Scale_Prec_4_y10),
.dMv_Scale_Prec_4_y11(six_dMv_Scale_Prec_4_y11),
.dMv_Scale_Prec_4_y12(six_dMv_Scale_Prec_4_y12),
.dMv_Scale_Prec_4_y13(six_dMv_Scale_Prec_4_y13),
.dMv_Scale_Prec_4_y14(six_dMv_Scale_Prec_4_y14),
.dMv_Scale_Prec_4_y15(six_dMv_Scale_Prec_4_y15),
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
.enable_prof_4       (six_enable_prof_4)
);



calc_addr calc_addr_4_inst (
.clk               (clk),
.rst_n             (rst_n),
.en             (en),
.export_data_cal  (export_data_cal),
.Ipu_x            (Ipu_x),
.Ipu_y            (Ipu_y),
.pos_4            (pos_4),
.addr_4           (addr_4),
.cur_addr0        (cur_addr0),
.cur_addr1        (cur_addr1),
.cur_addr2        (cur_addr2),
.cur_addr3        (cur_addr3),
.vect_4para_Int_x (vect_4para_Int_x),
.vect_4para_Int_y (vect_4para_Int_y),
.blk4x4_dif_coor_x(blk4x4_dif_coor_x),
.blk4x4_dif_coor_y(blk4x4_dif_coor_y),

//fw data
.dMv_Scale_Prec_4_x0_in (dMv_Scale_Prec_4_x0),
.dMv_Scale_Prec_4_x1_in (dMv_Scale_Prec_4_x1),
.dMv_Scale_Prec_4_x2_in (dMv_Scale_Prec_4_x2),
.dMv_Scale_Prec_4_x3_in (dMv_Scale_Prec_4_x3),
.dMv_Scale_Prec_4_x4_in (dMv_Scale_Prec_4_x4),
.dMv_Scale_Prec_4_x5_in (dMv_Scale_Prec_4_x5),
.dMv_Scale_Prec_4_x6_in (dMv_Scale_Prec_4_x6),
.dMv_Scale_Prec_4_x7_in (dMv_Scale_Prec_4_x7),
.dMv_Scale_Prec_4_x8_in (dMv_Scale_Prec_4_x8),
.dMv_Scale_Prec_4_x9_in (dMv_Scale_Prec_4_x9),
.dMv_Scale_Prec_4_y0_in (dMv_Scale_Prec_4_y0),
.dMv_Scale_Prec_4_y1_in (dMv_Scale_Prec_4_y1),
.dMv_Scale_Prec_4_y2_in (dMv_Scale_Prec_4_y2),
.dMv_Scale_Prec_4_y3_in (dMv_Scale_Prec_4_y3),
.dMv_Scale_Prec_4_y4_in (dMv_Scale_Prec_4_y4),
.dMv_Scale_Prec_4_y5_in (dMv_Scale_Prec_4_y5),
.dMv_Scale_Prec_4_y6_in (dMv_Scale_Prec_4_y6),
.dMv_Scale_Prec_4_y7_in (dMv_Scale_Prec_4_y7),
.dMv_Scale_Prec_4_y8_in (dMv_Scale_Prec_4_y8),
.dMv_Scale_Prec_4_y9_in (dMv_Scale_Prec_4_y9),
.dMv_Scale_Prec_4_x10_in(dMv_Scale_Prec_4_x10),
.dMv_Scale_Prec_4_x11_in(dMv_Scale_Prec_4_x11),
.dMv_Scale_Prec_4_x12_in(dMv_Scale_Prec_4_x12),
.dMv_Scale_Prec_4_x13_in(dMv_Scale_Prec_4_x13),
.dMv_Scale_Prec_4_x14_in(dMv_Scale_Prec_4_x14),
.dMv_Scale_Prec_4_x15_in(dMv_Scale_Prec_4_x15),
.dMv_Scale_Prec_4_y10_in(dMv_Scale_Prec_4_y10),
.dMv_Scale_Prec_4_y11_in(dMv_Scale_Prec_4_y11),
.dMv_Scale_Prec_4_y12_in(dMv_Scale_Prec_4_y12),
.dMv_Scale_Prec_4_y13_in(dMv_Scale_Prec_4_y13),
.dMv_Scale_Prec_4_y14_in(dMv_Scale_Prec_4_y14),
.dMv_Scale_Prec_4_y15_in(dMv_Scale_Prec_4_y15),


.dMv_Scale_Prec_4_x0_out (dMv_Scale_Prec_4_x0_out1),
.dMv_Scale_Prec_4_x1_out (dMv_Scale_Prec_4_x1_out1),
.dMv_Scale_Prec_4_x2_out (dMv_Scale_Prec_4_x2_out1),
.dMv_Scale_Prec_4_x3_out (dMv_Scale_Prec_4_x3_out1),
.dMv_Scale_Prec_4_x4_out (dMv_Scale_Prec_4_x4_out1),
.dMv_Scale_Prec_4_x5_out (dMv_Scale_Prec_4_x5_out1),
.dMv_Scale_Prec_4_x6_out (dMv_Scale_Prec_4_x6_out1),
.dMv_Scale_Prec_4_x7_out (dMv_Scale_Prec_4_x7_out1),
.dMv_Scale_Prec_4_x8_out (dMv_Scale_Prec_4_x8_out1),
.dMv_Scale_Prec_4_x9_out (dMv_Scale_Prec_4_x9_out1),
.dMv_Scale_Prec_4_y0_out (dMv_Scale_Prec_4_y0_out1),
.dMv_Scale_Prec_4_y1_out (dMv_Scale_Prec_4_y1_out1),
.dMv_Scale_Prec_4_y2_out (dMv_Scale_Prec_4_y2_out1),
.dMv_Scale_Prec_4_y3_out (dMv_Scale_Prec_4_y3_out1),
.dMv_Scale_Prec_4_y4_out (dMv_Scale_Prec_4_y4_out1),
.dMv_Scale_Prec_4_y5_out (dMv_Scale_Prec_4_y5_out1),
.dMv_Scale_Prec_4_y6_out (dMv_Scale_Prec_4_y6_out1),
.dMv_Scale_Prec_4_y7_out (dMv_Scale_Prec_4_y7_out1),
.dMv_Scale_Prec_4_y8_out (dMv_Scale_Prec_4_y8_out1),
.dMv_Scale_Prec_4_y9_out (dMv_Scale_Prec_4_y9_out1),
.dMv_Scale_Prec_4_x10_out(dMv_Scale_Prec_4_x10_out1),
.dMv_Scale_Prec_4_x11_out(dMv_Scale_Prec_4_x11_out1),
.dMv_Scale_Prec_4_x12_out(dMv_Scale_Prec_4_x12_out1),
.dMv_Scale_Prec_4_x13_out(dMv_Scale_Prec_4_x13_out1),
.dMv_Scale_Prec_4_x14_out(dMv_Scale_Prec_4_x14_out1),
.dMv_Scale_Prec_4_x15_out(dMv_Scale_Prec_4_x15_out1),
.dMv_Scale_Prec_4_y10_out(dMv_Scale_Prec_4_y10_out1),
.dMv_Scale_Prec_4_y11_out(dMv_Scale_Prec_4_y11_out1),
.dMv_Scale_Prec_4_y12_out(dMv_Scale_Prec_4_y12_out1),
.dMv_Scale_Prec_4_y13_out(dMv_Scale_Prec_4_y13_out1),
.dMv_Scale_Prec_4_y14_out(dMv_Scale_Prec_4_y14_out1),
.dMv_Scale_Prec_4_y15_out(dMv_Scale_Prec_4_y15_out1),

.vect_4para_Frac_x_in  (vect_4para_Frac_x),
.vect_4para_Frac_y_in  (vect_4para_Frac_y),
.vect_4para_Frac_x_out (vect_4para_Frac_x_out1),
.vect_4para_Frac_y_out (vect_4para_Frac_y_out1),
.enab_prof_out         (enab_prof_out1),
.enab_prof_in          (enable_prof_4)
);



calc_addr calc_addr_6_inst (
.clk               (clk),
.rst_n             (rst_n),
.en             (en),
.export_data_cal  (export_data_cal),
.Ipu_x            (Ipu_x),
.Ipu_y            (Ipu_y),
.pos_4            (six_pos_4),
.addr_4           (six_addr_4),
.cur_addr0        (six_cur_addr0),
.cur_addr1        (six_cur_addr1),
.cur_addr2        (six_cur_addr2),
.cur_addr3        (six_cur_addr3),
.vect_4para_Int_x (six_vect_4para_Int_x),
.vect_4para_Int_y (six_vect_4para_Int_y),
.blk4x4_dif_coor_x(six_blk4x4_dif_coor_x),
.blk4x4_dif_coor_y(six_blk4x4_dif_coor_y),

//fw data
.dMv_Scale_Prec_4_x0_in (six_dMv_Scale_Prec_4_x0),
.dMv_Scale_Prec_4_x1_in (six_dMv_Scale_Prec_4_x1),
.dMv_Scale_Prec_4_x2_in (six_dMv_Scale_Prec_4_x2),
.dMv_Scale_Prec_4_x3_in (six_dMv_Scale_Prec_4_x3),
.dMv_Scale_Prec_4_x4_in (six_dMv_Scale_Prec_4_x4),
.dMv_Scale_Prec_4_x5_in (six_dMv_Scale_Prec_4_x5),
.dMv_Scale_Prec_4_x6_in (six_dMv_Scale_Prec_4_x6),
.dMv_Scale_Prec_4_x7_in (six_dMv_Scale_Prec_4_x7),
.dMv_Scale_Prec_4_x8_in (six_dMv_Scale_Prec_4_x8),
.dMv_Scale_Prec_4_x9_in (six_dMv_Scale_Prec_4_x9),
.dMv_Scale_Prec_4_y0_in (six_dMv_Scale_Prec_4_y0),
.dMv_Scale_Prec_4_y1_in (six_dMv_Scale_Prec_4_y1),
.dMv_Scale_Prec_4_y2_in (six_dMv_Scale_Prec_4_y2),
.dMv_Scale_Prec_4_y3_in (six_dMv_Scale_Prec_4_y3),
.dMv_Scale_Prec_4_y4_in (six_dMv_Scale_Prec_4_y4),
.dMv_Scale_Prec_4_y5_in (six_dMv_Scale_Prec_4_y5),
.dMv_Scale_Prec_4_y6_in (six_dMv_Scale_Prec_4_y6),
.dMv_Scale_Prec_4_y7_in (six_dMv_Scale_Prec_4_y7),
.dMv_Scale_Prec_4_y8_in (six_dMv_Scale_Prec_4_y8),
.dMv_Scale_Prec_4_y9_in (six_dMv_Scale_Prec_4_y9),
.dMv_Scale_Prec_4_x10_in(six_dMv_Scale_Prec_4_x10),
.dMv_Scale_Prec_4_x11_in(six_dMv_Scale_Prec_4_x11),
.dMv_Scale_Prec_4_x12_in(six_dMv_Scale_Prec_4_x12),
.dMv_Scale_Prec_4_x13_in(six_dMv_Scale_Prec_4_x13),
.dMv_Scale_Prec_4_x14_in(six_dMv_Scale_Prec_4_x14),
.dMv_Scale_Prec_4_x15_in(six_dMv_Scale_Prec_4_x15),
.dMv_Scale_Prec_4_y10_in(six_dMv_Scale_Prec_4_y10),
.dMv_Scale_Prec_4_y11_in(six_dMv_Scale_Prec_4_y11),
.dMv_Scale_Prec_4_y12_in(six_dMv_Scale_Prec_4_y12),
.dMv_Scale_Prec_4_y13_in(six_dMv_Scale_Prec_4_y13),
.dMv_Scale_Prec_4_y14_in(six_dMv_Scale_Prec_4_y14),
.dMv_Scale_Prec_4_y15_in(six_dMv_Scale_Prec_4_y15),


.dMv_Scale_Prec_4_x0_out (six_dMv_Scale_Prec_4_x0_out1),
.dMv_Scale_Prec_4_x1_out (six_dMv_Scale_Prec_4_x1_out1),
.dMv_Scale_Prec_4_x2_out (six_dMv_Scale_Prec_4_x2_out1),
.dMv_Scale_Prec_4_x3_out (six_dMv_Scale_Prec_4_x3_out1),
.dMv_Scale_Prec_4_x4_out (six_dMv_Scale_Prec_4_x4_out1),
.dMv_Scale_Prec_4_x5_out (six_dMv_Scale_Prec_4_x5_out1),
.dMv_Scale_Prec_4_x6_out (six_dMv_Scale_Prec_4_x6_out1),
.dMv_Scale_Prec_4_x7_out (six_dMv_Scale_Prec_4_x7_out1),
.dMv_Scale_Prec_4_x8_out (six_dMv_Scale_Prec_4_x8_out1),
.dMv_Scale_Prec_4_x9_out (six_dMv_Scale_Prec_4_x9_out1),
.dMv_Scale_Prec_4_y0_out (six_dMv_Scale_Prec_4_y0_out1),
.dMv_Scale_Prec_4_y1_out (six_dMv_Scale_Prec_4_y1_out1),
.dMv_Scale_Prec_4_y2_out (six_dMv_Scale_Prec_4_y2_out1),
.dMv_Scale_Prec_4_y3_out (six_dMv_Scale_Prec_4_y3_out1),
.dMv_Scale_Prec_4_y4_out (six_dMv_Scale_Prec_4_y4_out1),
.dMv_Scale_Prec_4_y5_out (six_dMv_Scale_Prec_4_y5_out1),
.dMv_Scale_Prec_4_y6_out (six_dMv_Scale_Prec_4_y6_out1),
.dMv_Scale_Prec_4_y7_out (six_dMv_Scale_Prec_4_y7_out1),
.dMv_Scale_Prec_4_y8_out (six_dMv_Scale_Prec_4_y8_out1),
.dMv_Scale_Prec_4_y9_out (six_dMv_Scale_Prec_4_y9_out1),
.dMv_Scale_Prec_4_x10_out(six_dMv_Scale_Prec_4_x10_out1),
.dMv_Scale_Prec_4_x11_out(six_dMv_Scale_Prec_4_x11_out1),
.dMv_Scale_Prec_4_x12_out(six_dMv_Scale_Prec_4_x12_out1),
.dMv_Scale_Prec_4_x13_out(six_dMv_Scale_Prec_4_x13_out1),
.dMv_Scale_Prec_4_x14_out(six_dMv_Scale_Prec_4_x14_out1),
.dMv_Scale_Prec_4_x15_out(six_dMv_Scale_Prec_4_x15_out1),
.dMv_Scale_Prec_4_y10_out(six_dMv_Scale_Prec_4_y10_out1),
.dMv_Scale_Prec_4_y11_out(six_dMv_Scale_Prec_4_y11_out1),
.dMv_Scale_Prec_4_y12_out(six_dMv_Scale_Prec_4_y12_out1),
.dMv_Scale_Prec_4_y13_out(six_dMv_Scale_Prec_4_y13_out1),
.dMv_Scale_Prec_4_y14_out(six_dMv_Scale_Prec_4_y14_out1),
.dMv_Scale_Prec_4_y15_out(six_dMv_Scale_Prec_4_y15_out1),

.vect_4para_Frac_x_in  (six_vect_4para_Frac_x),
.vect_4para_Frac_y_in  (six_vect_4para_Frac_y),
.vect_4para_Frac_x_out (six_vect_4para_Frac_x_out1),
.vect_4para_Frac_y_out (six_vect_4para_Frac_y_out1),
.enab_prof_out         (six_enab_prof_out1),
.enab_prof_in          (six_enable_prof_4)
);



ref_data ref_data_4_inst (
.clk            (clk),
.en             (en),
.rst_n          (rst_n),
.load_ref_ram   (load_ref_ram),
.export_data_ref(export_data_ref),
.pos_4          (pos_4),
.ref_4para_addr (addr_4),
.ref_Pel_4      (ref_Pel_4),

//fw data
.dMv_Scale_Prec_4_x0_in (dMv_Scale_Prec_4_x0_out1),
.dMv_Scale_Prec_4_x1_in (dMv_Scale_Prec_4_x1_out1),
.dMv_Scale_Prec_4_x2_in (dMv_Scale_Prec_4_x2_out1),
.dMv_Scale_Prec_4_x3_in (dMv_Scale_Prec_4_x3_out1),
.dMv_Scale_Prec_4_x4_in (dMv_Scale_Prec_4_x4_out1),
.dMv_Scale_Prec_4_x5_in (dMv_Scale_Prec_4_x5_out1),
.dMv_Scale_Prec_4_x6_in (dMv_Scale_Prec_4_x6_out1),
.dMv_Scale_Prec_4_x7_in (dMv_Scale_Prec_4_x7_out1),
.dMv_Scale_Prec_4_x8_in (dMv_Scale_Prec_4_x8_out1),
.dMv_Scale_Prec_4_x9_in (dMv_Scale_Prec_4_x9_out1),
.dMv_Scale_Prec_4_y0_in (dMv_Scale_Prec_4_y0_out1),
.dMv_Scale_Prec_4_y1_in (dMv_Scale_Prec_4_y1_out1),
.dMv_Scale_Prec_4_y2_in (dMv_Scale_Prec_4_y2_out1),
.dMv_Scale_Prec_4_y3_in (dMv_Scale_Prec_4_y3_out1),
.dMv_Scale_Prec_4_y4_in (dMv_Scale_Prec_4_y4_out1),
.dMv_Scale_Prec_4_y5_in (dMv_Scale_Prec_4_y5_out1),
.dMv_Scale_Prec_4_y6_in (dMv_Scale_Prec_4_y6_out1),
.dMv_Scale_Prec_4_y7_in (dMv_Scale_Prec_4_y7_out1),
.dMv_Scale_Prec_4_y8_in (dMv_Scale_Prec_4_y8_out1),
.dMv_Scale_Prec_4_y9_in (dMv_Scale_Prec_4_y9_out1),
.dMv_Scale_Prec_4_x10_in(dMv_Scale_Prec_4_x10_out1),
.dMv_Scale_Prec_4_x11_in(dMv_Scale_Prec_4_x11_out1),
.dMv_Scale_Prec_4_x12_in(dMv_Scale_Prec_4_x12_out1),
.dMv_Scale_Prec_4_x13_in(dMv_Scale_Prec_4_x13_out1),
.dMv_Scale_Prec_4_x14_in(dMv_Scale_Prec_4_x14_out1),
.dMv_Scale_Prec_4_x15_in(dMv_Scale_Prec_4_x15_out1),
.dMv_Scale_Prec_4_y10_in(dMv_Scale_Prec_4_y10_out1),
.dMv_Scale_Prec_4_y11_in(dMv_Scale_Prec_4_y11_out1),
.dMv_Scale_Prec_4_y12_in(dMv_Scale_Prec_4_y12_out1),
.dMv_Scale_Prec_4_y13_in(dMv_Scale_Prec_4_y13_out1),
.dMv_Scale_Prec_4_y14_in(dMv_Scale_Prec_4_y14_out1),
.dMv_Scale_Prec_4_y15_in(dMv_Scale_Prec_4_y15_out1),


.dMv_Scale_Prec_4_x0_out (dMv_Scale_Prec_4_x0_out2),
.dMv_Scale_Prec_4_x1_out (dMv_Scale_Prec_4_x1_out2),
.dMv_Scale_Prec_4_x2_out (dMv_Scale_Prec_4_x2_out2),
.dMv_Scale_Prec_4_x3_out (dMv_Scale_Prec_4_x3_out2),
.dMv_Scale_Prec_4_x4_out (dMv_Scale_Prec_4_x4_out2),
.dMv_Scale_Prec_4_x5_out (dMv_Scale_Prec_4_x5_out2),
.dMv_Scale_Prec_4_x6_out (dMv_Scale_Prec_4_x6_out2),
.dMv_Scale_Prec_4_x7_out (dMv_Scale_Prec_4_x7_out2),
.dMv_Scale_Prec_4_x8_out (dMv_Scale_Prec_4_x8_out2),
.dMv_Scale_Prec_4_x9_out (dMv_Scale_Prec_4_x9_out2),
.dMv_Scale_Prec_4_y0_out (dMv_Scale_Prec_4_y0_out2),
.dMv_Scale_Prec_4_y1_out (dMv_Scale_Prec_4_y1_out2),
.dMv_Scale_Prec_4_y2_out (dMv_Scale_Prec_4_y2_out2),
.dMv_Scale_Prec_4_y3_out (dMv_Scale_Prec_4_y3_out2),
.dMv_Scale_Prec_4_y4_out (dMv_Scale_Prec_4_y4_out2),
.dMv_Scale_Prec_4_y5_out (dMv_Scale_Prec_4_y5_out2),
.dMv_Scale_Prec_4_y6_out (dMv_Scale_Prec_4_y6_out2),
.dMv_Scale_Prec_4_y7_out (dMv_Scale_Prec_4_y7_out2),
.dMv_Scale_Prec_4_y8_out (dMv_Scale_Prec_4_y8_out2),
.dMv_Scale_Prec_4_y9_out (dMv_Scale_Prec_4_y9_out2),
.dMv_Scale_Prec_4_x10_out(dMv_Scale_Prec_4_x10_out2),
.dMv_Scale_Prec_4_x11_out(dMv_Scale_Prec_4_x11_out2),
.dMv_Scale_Prec_4_x12_out(dMv_Scale_Prec_4_x12_out2),
.dMv_Scale_Prec_4_x13_out(dMv_Scale_Prec_4_x13_out2),
.dMv_Scale_Prec_4_x14_out(dMv_Scale_Prec_4_x14_out2),
.dMv_Scale_Prec_4_x15_out(dMv_Scale_Prec_4_x15_out2),
.dMv_Scale_Prec_4_y10_out(dMv_Scale_Prec_4_y10_out2),
.dMv_Scale_Prec_4_y11_out(dMv_Scale_Prec_4_y11_out2),
.dMv_Scale_Prec_4_y12_out(dMv_Scale_Prec_4_y12_out2),
.dMv_Scale_Prec_4_y13_out(dMv_Scale_Prec_4_y13_out2),
.dMv_Scale_Prec_4_y14_out(dMv_Scale_Prec_4_y14_out2),
.dMv_Scale_Prec_4_y15_out(dMv_Scale_Prec_4_y15_out2),

.vect_4para_Frac_x_in  (vect_4para_Frac_x_out1),
.vect_4para_Frac_y_in  (vect_4para_Frac_y_out1),
.vect_4para_Frac_x_out (vect_4para_Frac_x_out2),
.vect_4para_Frac_y_out (vect_4para_Frac_y_out2),
.enab_prof_out         (enab_prof_out2),
.enab_prof_in          (enab_prof_out1),
.cur_addr0_in          (cur_addr0),
.cur_addr1_in          (cur_addr1),
.cur_addr2_in          (cur_addr2),
.cur_addr3_in          (cur_addr3),
.cur_addr0_out         (cur_addr0_out2),
.cur_addr1_out         (cur_addr1_out2),
.cur_addr2_out         (cur_addr2_out2),
.cur_addr3_out         (cur_addr3_out2)
// .ref_line_0              (ref_line_0),
// .ref_line_1              (ref_line_1),
// .ref_line_2              (ref_line_2),
// .ref_line_3              (ref_line_3)
// .ref_line_4              (ref_line_4),
// .ref_line_5              (ref_line_5),
// .ref_line_6              (ref_line_6),
// .ref_line_7              (ref_line_7)
);



ref_data ref_data_6_inst (
.clk            (clk),
.en             (en),
.rst_n          (rst_n),
.load_ref_ram   (load_ref_ram),
.export_data_ref(export_data_ref),
.pos_4          (six_pos_4),
.ref_4para_addr (six_addr_4),
.ref_Pel_4      (six_ref_Pel_4),

//fw data
.dMv_Scale_Prec_4_x0_in (six_dMv_Scale_Prec_4_x0_out1),
.dMv_Scale_Prec_4_x1_in (six_dMv_Scale_Prec_4_x1_out1),
.dMv_Scale_Prec_4_x2_in (six_dMv_Scale_Prec_4_x2_out1),
.dMv_Scale_Prec_4_x3_in (six_dMv_Scale_Prec_4_x3_out1),
.dMv_Scale_Prec_4_x4_in (six_dMv_Scale_Prec_4_x4_out1),
.dMv_Scale_Prec_4_x5_in (six_dMv_Scale_Prec_4_x5_out1),
.dMv_Scale_Prec_4_x6_in (six_dMv_Scale_Prec_4_x6_out1),
.dMv_Scale_Prec_4_x7_in (six_dMv_Scale_Prec_4_x7_out1),
.dMv_Scale_Prec_4_x8_in (six_dMv_Scale_Prec_4_x8_out1),
.dMv_Scale_Prec_4_x9_in (six_dMv_Scale_Prec_4_x9_out1),
.dMv_Scale_Prec_4_y0_in (six_dMv_Scale_Prec_4_y0_out1),
.dMv_Scale_Prec_4_y1_in (six_dMv_Scale_Prec_4_y1_out1),
.dMv_Scale_Prec_4_y2_in (six_dMv_Scale_Prec_4_y2_out1),
.dMv_Scale_Prec_4_y3_in (six_dMv_Scale_Prec_4_y3_out1),
.dMv_Scale_Prec_4_y4_in (six_dMv_Scale_Prec_4_y4_out1),
.dMv_Scale_Prec_4_y5_in (six_dMv_Scale_Prec_4_y5_out1),
.dMv_Scale_Prec_4_y6_in (six_dMv_Scale_Prec_4_y6_out1),
.dMv_Scale_Prec_4_y7_in (six_dMv_Scale_Prec_4_y7_out1),
.dMv_Scale_Prec_4_y8_in (six_dMv_Scale_Prec_4_y8_out1),
.dMv_Scale_Prec_4_y9_in (six_dMv_Scale_Prec_4_y9_out1),
.dMv_Scale_Prec_4_x10_in(six_dMv_Scale_Prec_4_x10_out1),
.dMv_Scale_Prec_4_x11_in(six_dMv_Scale_Prec_4_x11_out1),
.dMv_Scale_Prec_4_x12_in(six_dMv_Scale_Prec_4_x12_out1),
.dMv_Scale_Prec_4_x13_in(six_dMv_Scale_Prec_4_x13_out1),
.dMv_Scale_Prec_4_x14_in(six_dMv_Scale_Prec_4_x14_out1),
.dMv_Scale_Prec_4_x15_in(six_dMv_Scale_Prec_4_x15_out1),
.dMv_Scale_Prec_4_y10_in(six_dMv_Scale_Prec_4_y10_out1),
.dMv_Scale_Prec_4_y11_in(six_dMv_Scale_Prec_4_y11_out1),
.dMv_Scale_Prec_4_y12_in(six_dMv_Scale_Prec_4_y12_out1),
.dMv_Scale_Prec_4_y13_in(six_dMv_Scale_Prec_4_y13_out1),
.dMv_Scale_Prec_4_y14_in(six_dMv_Scale_Prec_4_y14_out1),
.dMv_Scale_Prec_4_y15_in(six_dMv_Scale_Prec_4_y15_out1),


.dMv_Scale_Prec_4_x0_out (six_dMv_Scale_Prec_4_x0_out2),
.dMv_Scale_Prec_4_x1_out (six_dMv_Scale_Prec_4_x1_out2),
.dMv_Scale_Prec_4_x2_out (six_dMv_Scale_Prec_4_x2_out2),
.dMv_Scale_Prec_4_x3_out (six_dMv_Scale_Prec_4_x3_out2),
.dMv_Scale_Prec_4_x4_out (six_dMv_Scale_Prec_4_x4_out2),
.dMv_Scale_Prec_4_x5_out (six_dMv_Scale_Prec_4_x5_out2),
.dMv_Scale_Prec_4_x6_out (six_dMv_Scale_Prec_4_x6_out2),
.dMv_Scale_Prec_4_x7_out (six_dMv_Scale_Prec_4_x7_out2),
.dMv_Scale_Prec_4_x8_out (six_dMv_Scale_Prec_4_x8_out2),
.dMv_Scale_Prec_4_x9_out (six_dMv_Scale_Prec_4_x9_out2),
.dMv_Scale_Prec_4_y0_out (six_dMv_Scale_Prec_4_y0_out2),
.dMv_Scale_Prec_4_y1_out (six_dMv_Scale_Prec_4_y1_out2),
.dMv_Scale_Prec_4_y2_out (six_dMv_Scale_Prec_4_y2_out2),
.dMv_Scale_Prec_4_y3_out (six_dMv_Scale_Prec_4_y3_out2),
.dMv_Scale_Prec_4_y4_out (six_dMv_Scale_Prec_4_y4_out2),
.dMv_Scale_Prec_4_y5_out (six_dMv_Scale_Prec_4_y5_out2),
.dMv_Scale_Prec_4_y6_out (six_dMv_Scale_Prec_4_y6_out2),
.dMv_Scale_Prec_4_y7_out (six_dMv_Scale_Prec_4_y7_out2),
.dMv_Scale_Prec_4_y8_out (six_dMv_Scale_Prec_4_y8_out2),
.dMv_Scale_Prec_4_y9_out (six_dMv_Scale_Prec_4_y9_out2),
.dMv_Scale_Prec_4_x10_out(six_dMv_Scale_Prec_4_x10_out2),
.dMv_Scale_Prec_4_x11_out(six_dMv_Scale_Prec_4_x11_out2),
.dMv_Scale_Prec_4_x12_out(six_dMv_Scale_Prec_4_x12_out2),
.dMv_Scale_Prec_4_x13_out(six_dMv_Scale_Prec_4_x13_out2),
.dMv_Scale_Prec_4_x14_out(six_dMv_Scale_Prec_4_x14_out2),
.dMv_Scale_Prec_4_x15_out(six_dMv_Scale_Prec_4_x15_out2),
.dMv_Scale_Prec_4_y10_out(six_dMv_Scale_Prec_4_y10_out2),
.dMv_Scale_Prec_4_y11_out(six_dMv_Scale_Prec_4_y11_out2),
.dMv_Scale_Prec_4_y12_out(six_dMv_Scale_Prec_4_y12_out2),
.dMv_Scale_Prec_4_y13_out(six_dMv_Scale_Prec_4_y13_out2),
.dMv_Scale_Prec_4_y14_out(six_dMv_Scale_Prec_4_y14_out2),
.dMv_Scale_Prec_4_y15_out(six_dMv_Scale_Prec_4_y15_out2),

.vect_4para_Frac_x_in  (six_vect_4para_Frac_x_out1),
.vect_4para_Frac_y_in  (six_vect_4para_Frac_y_out1),
.vect_4para_Frac_x_out (six_vect_4para_Frac_x_out2),
.vect_4para_Frac_y_out (six_vect_4para_Frac_y_out2),
.enab_prof_out         (six_enab_prof_out2),
.enab_prof_in          (six_enab_prof_out1),
.cur_addr0_in          (six_cur_addr0),
.cur_addr1_in          (six_cur_addr1),
.cur_addr2_in          (six_cur_addr2),
.cur_addr3_in          (six_cur_addr3),
.cur_addr0_out         (six_cur_addr0_out2),
.cur_addr1_out         (six_cur_addr1_out2),
.cur_addr2_out         (six_cur_addr2_out2),
.cur_addr3_out         (six_cur_addr3_out2)
// .ref_line_0              (ref_line_0),
// .ref_line_1              (ref_line_1),
// .ref_line_2              (ref_line_2),
// .ref_line_3              (ref_line_3)
// .ref_line_4              (ref_line_4),
// .ref_line_5              (ref_line_5),
// .ref_line_6              (ref_line_6),
// .ref_line_7              (ref_line_7)
);



filter filter_4_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_filter(export_data_filter),
.ref_Pel_4         (ref_Pel_4),
.enab_prof_in         (enab_prof_out2),
.final_dst         (final_dst),
.vect_4para_Frac_y (vect_4para_Frac_y_out2),
.vect_4para_Frac_x (vect_4para_Frac_x_out2),

//fw data
.dMv_Scale_Prec_4_x0_in (dMv_Scale_Prec_4_x0_out2),
.dMv_Scale_Prec_4_x1_in (dMv_Scale_Prec_4_x1_out2),
.dMv_Scale_Prec_4_x2_in (dMv_Scale_Prec_4_x2_out2),
.dMv_Scale_Prec_4_x3_in (dMv_Scale_Prec_4_x3_out2),
.dMv_Scale_Prec_4_x4_in (dMv_Scale_Prec_4_x4_out2),
.dMv_Scale_Prec_4_x5_in (dMv_Scale_Prec_4_x5_out2),
.dMv_Scale_Prec_4_x6_in (dMv_Scale_Prec_4_x6_out2),
.dMv_Scale_Prec_4_x7_in (dMv_Scale_Prec_4_x7_out2),
.dMv_Scale_Prec_4_x8_in (dMv_Scale_Prec_4_x8_out2),
.dMv_Scale_Prec_4_x9_in (dMv_Scale_Prec_4_x9_out2),
.dMv_Scale_Prec_4_y0_in (dMv_Scale_Prec_4_y0_out2),
.dMv_Scale_Prec_4_y1_in (dMv_Scale_Prec_4_y1_out2),
.dMv_Scale_Prec_4_y2_in (dMv_Scale_Prec_4_y2_out2),
.dMv_Scale_Prec_4_y3_in (dMv_Scale_Prec_4_y3_out2),
.dMv_Scale_Prec_4_y4_in (dMv_Scale_Prec_4_y4_out2),
.dMv_Scale_Prec_4_y5_in (dMv_Scale_Prec_4_y5_out2),
.dMv_Scale_Prec_4_y6_in (dMv_Scale_Prec_4_y6_out2),
.dMv_Scale_Prec_4_y7_in (dMv_Scale_Prec_4_y7_out2),
.dMv_Scale_Prec_4_y8_in (dMv_Scale_Prec_4_y8_out2),
.dMv_Scale_Prec_4_y9_in (dMv_Scale_Prec_4_y9_out2),
.dMv_Scale_Prec_4_x10_in(dMv_Scale_Prec_4_x10_out2),
.dMv_Scale_Prec_4_x11_in(dMv_Scale_Prec_4_x11_out2),
.dMv_Scale_Prec_4_x12_in(dMv_Scale_Prec_4_x12_out2),
.dMv_Scale_Prec_4_x13_in(dMv_Scale_Prec_4_x13_out2),
.dMv_Scale_Prec_4_x14_in(dMv_Scale_Prec_4_x14_out2),
.dMv_Scale_Prec_4_x15_in(dMv_Scale_Prec_4_x15_out2),
.dMv_Scale_Prec_4_y10_in(dMv_Scale_Prec_4_y10_out2),
.dMv_Scale_Prec_4_y11_in(dMv_Scale_Prec_4_y11_out2),
.dMv_Scale_Prec_4_y12_in(dMv_Scale_Prec_4_y12_out2),
.dMv_Scale_Prec_4_y13_in(dMv_Scale_Prec_4_y13_out2),
.dMv_Scale_Prec_4_y14_in(dMv_Scale_Prec_4_y14_out2),
.dMv_Scale_Prec_4_y15_in(dMv_Scale_Prec_4_y15_out2),


.dMv_Scale_Prec_4_x0_out (dMv_Scale_Prec_4_x0_out3),
.dMv_Scale_Prec_4_x1_out (dMv_Scale_Prec_4_x1_out3),
.dMv_Scale_Prec_4_x2_out (dMv_Scale_Prec_4_x2_out3),
.dMv_Scale_Prec_4_x3_out (dMv_Scale_Prec_4_x3_out3),
.dMv_Scale_Prec_4_x4_out (dMv_Scale_Prec_4_x4_out3),
.dMv_Scale_Prec_4_x5_out (dMv_Scale_Prec_4_x5_out3),
.dMv_Scale_Prec_4_x6_out (dMv_Scale_Prec_4_x6_out3),
.dMv_Scale_Prec_4_x7_out (dMv_Scale_Prec_4_x7_out3),
.dMv_Scale_Prec_4_x8_out (dMv_Scale_Prec_4_x8_out3),
.dMv_Scale_Prec_4_x9_out (dMv_Scale_Prec_4_x9_out3),
.dMv_Scale_Prec_4_y0_out (dMv_Scale_Prec_4_y0_out3),
.dMv_Scale_Prec_4_y1_out (dMv_Scale_Prec_4_y1_out3),
.dMv_Scale_Prec_4_y2_out (dMv_Scale_Prec_4_y2_out3),
.dMv_Scale_Prec_4_y3_out (dMv_Scale_Prec_4_y3_out3),
.dMv_Scale_Prec_4_y4_out (dMv_Scale_Prec_4_y4_out3),
.dMv_Scale_Prec_4_y5_out (dMv_Scale_Prec_4_y5_out3),
.dMv_Scale_Prec_4_y6_out (dMv_Scale_Prec_4_y6_out3),
.dMv_Scale_Prec_4_y7_out (dMv_Scale_Prec_4_y7_out3),
.dMv_Scale_Prec_4_y8_out (dMv_Scale_Prec_4_y8_out3),
.dMv_Scale_Prec_4_y9_out (dMv_Scale_Prec_4_y9_out3),
.dMv_Scale_Prec_4_x10_out(dMv_Scale_Prec_4_x10_out3),
.dMv_Scale_Prec_4_x11_out(dMv_Scale_Prec_4_x11_out3),
.dMv_Scale_Prec_4_x12_out(dMv_Scale_Prec_4_x12_out3),
.dMv_Scale_Prec_4_x13_out(dMv_Scale_Prec_4_x13_out3),
.dMv_Scale_Prec_4_x14_out(dMv_Scale_Prec_4_x14_out3),
.dMv_Scale_Prec_4_x15_out(dMv_Scale_Prec_4_x15_out3),
.dMv_Scale_Prec_4_y10_out(dMv_Scale_Prec_4_y10_out3),
.dMv_Scale_Prec_4_y11_out(dMv_Scale_Prec_4_y11_out3),
.dMv_Scale_Prec_4_y12_out(dMv_Scale_Prec_4_y12_out3),
.dMv_Scale_Prec_4_y13_out(dMv_Scale_Prec_4_y13_out3),
.dMv_Scale_Prec_4_y14_out(dMv_Scale_Prec_4_y14_out3),
.dMv_Scale_Prec_4_y15_out(dMv_Scale_Prec_4_y15_out3),

.enab_prof_out         (enab_prof_out3),
.cur_addr0_in          (cur_addr0_out2),
.cur_addr1_in          (cur_addr1_out2),
.cur_addr2_in          (cur_addr2_out2),
.cur_addr3_in          (cur_addr3_out2),
.cur_addr0_out         (cur_addr0_out3),
.cur_addr1_out         (cur_addr1_out3),
.cur_addr2_out         (cur_addr2_out3),
.cur_addr3_out         (cur_addr3_out3)
);

filter filter_6_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_filter(export_data_filter),
.ref_Pel_4         (six_ref_Pel_4),
.enab_prof_in      (six_enab_prof_out2),
.final_dst         (six_final_dst),
.vect_4para_Frac_y (six_vect_4para_Frac_y_out2),
.vect_4para_Frac_x (six_vect_4para_Frac_x_out2),

//fw data
.dMv_Scale_Prec_4_x0_in (six_dMv_Scale_Prec_4_x0_out2),
.dMv_Scale_Prec_4_x1_in (six_dMv_Scale_Prec_4_x1_out2),
.dMv_Scale_Prec_4_x2_in (six_dMv_Scale_Prec_4_x2_out2),
.dMv_Scale_Prec_4_x3_in (six_dMv_Scale_Prec_4_x3_out2),
.dMv_Scale_Prec_4_x4_in (six_dMv_Scale_Prec_4_x4_out2),
.dMv_Scale_Prec_4_x5_in (six_dMv_Scale_Prec_4_x5_out2),
.dMv_Scale_Prec_4_x6_in (six_dMv_Scale_Prec_4_x6_out2),
.dMv_Scale_Prec_4_x7_in (six_dMv_Scale_Prec_4_x7_out2),
.dMv_Scale_Prec_4_x8_in (six_dMv_Scale_Prec_4_x8_out2),
.dMv_Scale_Prec_4_x9_in (six_dMv_Scale_Prec_4_x9_out2),
.dMv_Scale_Prec_4_y0_in (six_dMv_Scale_Prec_4_y0_out2),
.dMv_Scale_Prec_4_y1_in (six_dMv_Scale_Prec_4_y1_out2),
.dMv_Scale_Prec_4_y2_in (six_dMv_Scale_Prec_4_y2_out2),
.dMv_Scale_Prec_4_y3_in (six_dMv_Scale_Prec_4_y3_out2),
.dMv_Scale_Prec_4_y4_in (six_dMv_Scale_Prec_4_y4_out2),
.dMv_Scale_Prec_4_y5_in (six_dMv_Scale_Prec_4_y5_out2),
.dMv_Scale_Prec_4_y6_in (six_dMv_Scale_Prec_4_y6_out2),
.dMv_Scale_Prec_4_y7_in (six_dMv_Scale_Prec_4_y7_out2),
.dMv_Scale_Prec_4_y8_in (six_dMv_Scale_Prec_4_y8_out2),
.dMv_Scale_Prec_4_y9_in (six_dMv_Scale_Prec_4_y9_out2),
.dMv_Scale_Prec_4_x10_in(six_dMv_Scale_Prec_4_x10_out2),
.dMv_Scale_Prec_4_x11_in(six_dMv_Scale_Prec_4_x11_out2),
.dMv_Scale_Prec_4_x12_in(six_dMv_Scale_Prec_4_x12_out2),
.dMv_Scale_Prec_4_x13_in(six_dMv_Scale_Prec_4_x13_out2),
.dMv_Scale_Prec_4_x14_in(six_dMv_Scale_Prec_4_x14_out2),
.dMv_Scale_Prec_4_x15_in(six_dMv_Scale_Prec_4_x15_out2),
.dMv_Scale_Prec_4_y10_in(six_dMv_Scale_Prec_4_y10_out2),
.dMv_Scale_Prec_4_y11_in(six_dMv_Scale_Prec_4_y11_out2),
.dMv_Scale_Prec_4_y12_in(six_dMv_Scale_Prec_4_y12_out2),
.dMv_Scale_Prec_4_y13_in(six_dMv_Scale_Prec_4_y13_out2),
.dMv_Scale_Prec_4_y14_in(six_dMv_Scale_Prec_4_y14_out2),
.dMv_Scale_Prec_4_y15_in(six_dMv_Scale_Prec_4_y15_out2),


.dMv_Scale_Prec_4_x0_out (six_dMv_Scale_Prec_4_x0_out3),
.dMv_Scale_Prec_4_x1_out (six_dMv_Scale_Prec_4_x1_out3),
.dMv_Scale_Prec_4_x2_out (six_dMv_Scale_Prec_4_x2_out3),
.dMv_Scale_Prec_4_x3_out (six_dMv_Scale_Prec_4_x3_out3),
.dMv_Scale_Prec_4_x4_out (six_dMv_Scale_Prec_4_x4_out3),
.dMv_Scale_Prec_4_x5_out (six_dMv_Scale_Prec_4_x5_out3),
.dMv_Scale_Prec_4_x6_out (six_dMv_Scale_Prec_4_x6_out3),
.dMv_Scale_Prec_4_x7_out (six_dMv_Scale_Prec_4_x7_out3),
.dMv_Scale_Prec_4_x8_out (six_dMv_Scale_Prec_4_x8_out3),
.dMv_Scale_Prec_4_x9_out (six_dMv_Scale_Prec_4_x9_out3),
.dMv_Scale_Prec_4_y0_out (six_dMv_Scale_Prec_4_y0_out3),
.dMv_Scale_Prec_4_y1_out (six_dMv_Scale_Prec_4_y1_out3),
.dMv_Scale_Prec_4_y2_out (six_dMv_Scale_Prec_4_y2_out3),
.dMv_Scale_Prec_4_y3_out (six_dMv_Scale_Prec_4_y3_out3),
.dMv_Scale_Prec_4_y4_out (six_dMv_Scale_Prec_4_y4_out3),
.dMv_Scale_Prec_4_y5_out (six_dMv_Scale_Prec_4_y5_out3),
.dMv_Scale_Prec_4_y6_out (six_dMv_Scale_Prec_4_y6_out3),
.dMv_Scale_Prec_4_y7_out (six_dMv_Scale_Prec_4_y7_out3),
.dMv_Scale_Prec_4_y8_out (six_dMv_Scale_Prec_4_y8_out3),
.dMv_Scale_Prec_4_y9_out (six_dMv_Scale_Prec_4_y9_out3),
.dMv_Scale_Prec_4_x10_out(six_dMv_Scale_Prec_4_x10_out3),
.dMv_Scale_Prec_4_x11_out(six_dMv_Scale_Prec_4_x11_out3),
.dMv_Scale_Prec_4_x12_out(six_dMv_Scale_Prec_4_x12_out3),
.dMv_Scale_Prec_4_x13_out(six_dMv_Scale_Prec_4_x13_out3),
.dMv_Scale_Prec_4_x14_out(six_dMv_Scale_Prec_4_x14_out3),
.dMv_Scale_Prec_4_x15_out(six_dMv_Scale_Prec_4_x15_out3),
.dMv_Scale_Prec_4_y10_out(six_dMv_Scale_Prec_4_y10_out3),
.dMv_Scale_Prec_4_y11_out(six_dMv_Scale_Prec_4_y11_out3),
.dMv_Scale_Prec_4_y12_out(six_dMv_Scale_Prec_4_y12_out3),
.dMv_Scale_Prec_4_y13_out(six_dMv_Scale_Prec_4_y13_out3),
.dMv_Scale_Prec_4_y14_out(six_dMv_Scale_Prec_4_y14_out3),
.dMv_Scale_Prec_4_y15_out(six_dMv_Scale_Prec_4_y15_out3),

.enab_prof_out         (six_enab_prof_out3),
.cur_addr0_in          (six_cur_addr0_out2),
.cur_addr1_in          (six_cur_addr1_out2),
.cur_addr2_in          (six_cur_addr2_out2),
.cur_addr3_in          (six_cur_addr3_out2),
.cur_addr0_out         (six_cur_addr0_out3),
.cur_addr1_out         (six_cur_addr1_out3),
.cur_addr2_out         (six_cur_addr2_out3),
.cur_addr3_out         (six_cur_addr3_out3)
);



pdof pdof_4_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_pdof  (export_data_pdof),
.enab_prof         (enab_prof_out3),
.final_dst         (final_dst),
.dMv_Scale_Prec_4_x0 (dMv_Scale_Prec_4_x0_out3),
.dMv_Scale_Prec_4_x1 (dMv_Scale_Prec_4_x1_out3),
.dMv_Scale_Prec_4_x2 (dMv_Scale_Prec_4_x2_out3),
.dMv_Scale_Prec_4_x3 (dMv_Scale_Prec_4_x3_out3),
.dMv_Scale_Prec_4_x4 (dMv_Scale_Prec_4_x4_out3),
.dMv_Scale_Prec_4_x5 (dMv_Scale_Prec_4_x5_out3),
.dMv_Scale_Prec_4_x6 (dMv_Scale_Prec_4_x6_out3),
.dMv_Scale_Prec_4_x7 (dMv_Scale_Prec_4_x7_out3),
.dMv_Scale_Prec_4_x8 (dMv_Scale_Prec_4_x8_out3),
.dMv_Scale_Prec_4_x9 (dMv_Scale_Prec_4_x9_out3),
.dMv_Scale_Prec_4_y0 (dMv_Scale_Prec_4_y0_out3),
.dMv_Scale_Prec_4_y1 (dMv_Scale_Prec_4_y1_out3),
.dMv_Scale_Prec_4_y2 (dMv_Scale_Prec_4_y2_out3),
.dMv_Scale_Prec_4_y3 (dMv_Scale_Prec_4_y3_out3),
.dMv_Scale_Prec_4_y4 (dMv_Scale_Prec_4_y4_out3),
.dMv_Scale_Prec_4_y5 (dMv_Scale_Prec_4_y5_out3),
.dMv_Scale_Prec_4_y6 (dMv_Scale_Prec_4_y6_out3),
.dMv_Scale_Prec_4_y7 (dMv_Scale_Prec_4_y7_out3),
.dMv_Scale_Prec_4_y8 (dMv_Scale_Prec_4_y8_out3),
.dMv_Scale_Prec_4_y9 (dMv_Scale_Prec_4_y9_out3),
.dMv_Scale_Prec_4_x10(dMv_Scale_Prec_4_x10_out3),
.dMv_Scale_Prec_4_x11(dMv_Scale_Prec_4_x11_out3),
.dMv_Scale_Prec_4_x12(dMv_Scale_Prec_4_x12_out3),
.dMv_Scale_Prec_4_x13(dMv_Scale_Prec_4_x13_out3),
.dMv_Scale_Prec_4_x14(dMv_Scale_Prec_4_x14_out3),
.dMv_Scale_Prec_4_x15(dMv_Scale_Prec_4_x15_out3),
.dMv_Scale_Prec_4_y10(dMv_Scale_Prec_4_y10_out3),
.dMv_Scale_Prec_4_y11(dMv_Scale_Prec_4_y11_out3),
.dMv_Scale_Prec_4_y12(dMv_Scale_Prec_4_y12_out3),
.dMv_Scale_Prec_4_y13(dMv_Scale_Prec_4_y13_out3),
.dMv_Scale_Prec_4_y14(dMv_Scale_Prec_4_y14_out3),
.dMv_Scale_Prec_4_y15(dMv_Scale_Prec_4_y15_out3),
.ref_data0         (ref_data0),
.ref_data1         (ref_data1),
.ref_data2         (ref_data2),
.ref_data3         (ref_data3)

);



pdof pdof_6_inst (
.clk               (clk),
.en                (en),
.rst_n             (rst_n),
.export_data_pdof  (export_data_pdof),
.enab_prof         (six_enab_prof_out3),
.final_dst         (six_final_dst),
.dMv_Scale_Prec_4_x0 (six_dMv_Scale_Prec_4_x0_out3),
.dMv_Scale_Prec_4_x1 (six_dMv_Scale_Prec_4_x1_out3),
.dMv_Scale_Prec_4_x2 (six_dMv_Scale_Prec_4_x2_out3),
.dMv_Scale_Prec_4_x3 (six_dMv_Scale_Prec_4_x3_out3),
.dMv_Scale_Prec_4_x4 (six_dMv_Scale_Prec_4_x4_out3),
.dMv_Scale_Prec_4_x5 (six_dMv_Scale_Prec_4_x5_out3),
.dMv_Scale_Prec_4_x6 (six_dMv_Scale_Prec_4_x6_out3),
.dMv_Scale_Prec_4_x7 (six_dMv_Scale_Prec_4_x7_out3),
.dMv_Scale_Prec_4_x8 (six_dMv_Scale_Prec_4_x8_out3),
.dMv_Scale_Prec_4_x9 (six_dMv_Scale_Prec_4_x9_out3),
.dMv_Scale_Prec_4_y0 (six_dMv_Scale_Prec_4_y0_out3),
.dMv_Scale_Prec_4_y1 (six_dMv_Scale_Prec_4_y1_out3),
.dMv_Scale_Prec_4_y2 (six_dMv_Scale_Prec_4_y2_out3),
.dMv_Scale_Prec_4_y3 (six_dMv_Scale_Prec_4_y3_out3),
.dMv_Scale_Prec_4_y4 (six_dMv_Scale_Prec_4_y4_out3),
.dMv_Scale_Prec_4_y5 (six_dMv_Scale_Prec_4_y5_out3),
.dMv_Scale_Prec_4_y6 (six_dMv_Scale_Prec_4_y6_out3),
.dMv_Scale_Prec_4_y7 (six_dMv_Scale_Prec_4_y7_out3),
.dMv_Scale_Prec_4_y8 (six_dMv_Scale_Prec_4_y8_out3),
.dMv_Scale_Prec_4_y9 (six_dMv_Scale_Prec_4_y9_out3),
.dMv_Scale_Prec_4_x10(six_dMv_Scale_Prec_4_x10_out3),
.dMv_Scale_Prec_4_x11(six_dMv_Scale_Prec_4_x11_out3),
.dMv_Scale_Prec_4_x12(six_dMv_Scale_Prec_4_x12_out3),
.dMv_Scale_Prec_4_x13(six_dMv_Scale_Prec_4_x13_out3),
.dMv_Scale_Prec_4_x14(six_dMv_Scale_Prec_4_x14_out3),
.dMv_Scale_Prec_4_x15(six_dMv_Scale_Prec_4_x15_out3),
.dMv_Scale_Prec_4_y10(six_dMv_Scale_Prec_4_y10_out3),
.dMv_Scale_Prec_4_y11(six_dMv_Scale_Prec_4_y11_out3),
.dMv_Scale_Prec_4_y12(six_dMv_Scale_Prec_4_y12_out3),
.dMv_Scale_Prec_4_y13(six_dMv_Scale_Prec_4_y13_out3),
.dMv_Scale_Prec_4_y14(six_dMv_Scale_Prec_4_y14_out3),
.dMv_Scale_Prec_4_y15(six_dMv_Scale_Prec_4_y15_out3),
.ref_data0         (six_ref_data0),
.ref_data1         (six_ref_data1),
.ref_data2         (six_ref_data2),
.ref_data3         (six_ref_data3)


);



cur_data cur_data_4_inst (
.clk          (clk),
.rst_n        (rst_n),
.cur_addr0    (cur_addr0_out3),
.cur_addr1    (cur_addr1_out3),
.cur_addr2    (cur_addr2_out3),
.cur_addr3    (cur_addr3_out3),
.cur_data3    (cur_data3),
.cur_data2    (cur_data2),
.cur_data1    (cur_data1),
.cur_data0    (cur_data0),
.en             (en),
.load_cur_ram   (load_cur_ram),
.export_data_cur(export_data_cur)
// .cur_line_0     (cur_line_0),
// .cur_line_1     (cur_line_1),
// .cur_line_2     (cur_line_2),
// .cur_line_3     (cur_line_3),
// .cur_line_4     (cur_line_4),
// .cur_line_5     (cur_line_5),
// .cur_line_6     (cur_line_6),
// .cur_line_7     (cur_line_7)
);



cur_data cur_data_6_inst (
.clk          (clk),
.rst_n        (rst_n),
.cur_addr0    (six_cur_addr0_out3),
.cur_addr1    (six_cur_addr1_out3),
.cur_addr2    (six_cur_addr2_out3),
.cur_addr3    (six_cur_addr3_out3),
.cur_data3    (six_cur_data3),
.cur_data2    (six_cur_data2),
.cur_data1    (six_cur_data1),
.cur_data0    (six_cur_data0),
.en             (en),
.load_cur_ram   (load_cur_ram),
.export_data_cur(export_data_cur)
// .cur_line_0     (cur_line_0),
// .cur_line_1     (cur_line_1),
// .cur_line_2     (cur_line_2),
// .cur_line_3     (cur_line_3),
// .cur_line_4     (cur_line_4),
// .cur_line_5     (cur_line_5),
// .cur_line_6     (cur_line_6),
// .cur_line_7     (cur_line_7)
);


had had_4_inst (
.clk               (clk),
.rst_n             (rst_n),
.en             (en),
.export_data_had(export_data_had),
.a4x4_ref_blk1   (ref_data0),
.a4x4_ref_blk2   (ref_data1),
.a4x4_ref_blk3   (ref_data2),
.a4x4_ref_blk4   (ref_data3),
.a4x4_cur_blk1   (cur_data0),
.a4x4_cur_blk2   (cur_data1),
.a4x4_cur_blk3   (cur_data2),
.a4x4_cur_blk4   (cur_data3),
.had_4x4        (had_4x4)
);

had had_6_inst (
.clk               (clk),
.rst_n             (rst_n),
.en             (en),
.export_data_had(export_data_had),
.a4x4_ref_blk1   (six_ref_data0),
.a4x4_ref_blk2   (six_ref_data1),
.a4x4_ref_blk3   (six_ref_data2),
.a4x4_ref_blk4   (six_ref_data3),
.a4x4_cur_blk1   (six_cur_data0),
.a4x4_cur_blk2   (six_cur_data1),
.a4x4_cur_blk3   (six_cur_data2),
.a4x4_cur_blk4   (six_cur_data3),
.had_4x4        (six_had_4x4)
);
endmodule : affine_top