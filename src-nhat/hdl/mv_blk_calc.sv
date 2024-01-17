`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 09:57:28 AM
// Design Name: 
// Module Name: mv_blk_calc
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
module mv_blk_calc(
    input clk,
    input rst_n,
    // dau vao bat dau tinh toan khoi tiep theo
    input start_blk,
    //bat dau tai du lieu
    input start_load,
    //tin hieu bat dau tinh toan cho khoi 6 tham so
    input start_aff6,
    // bat dau tinh toan
    input start_calc,
     // use for enableProf
    input iref_scale,
    // use for enableProf
    input large_mv_grad,
    // 3 control point vector
    input signed [12:0] mvLT_x,
    input signed [12:0] mvLT_y,
    input signed [12:0] mvRT_x,
    input signed [12:0] mvRT_y,
    input signed [12:0] mvLB_x,
    input signed [12:0] mvLB_y,
    // kich thuoc khoi du doan
    input [8:0] Ipu_w,
    input [8:0] Ipu_h,
    // integer vector value output
    output logic signed [12:0] vect_Int_x,
    output logic signed [12:0] vect_Int_y,
    // fraction vector value ouput
    output logic signed [4:0] vect_Frac_x,
    output logic signed [4:0] vect_Frac_y,
    // calculate done flag
    output logic calc_done,
    //?o chênh lech toa ?o giua block du ?oán 4x4 voi khoi du ?oán hien tai 
    output logic signed [7:0] blk4x4_dif_coor_x,
    output logic signed [7:0] blk4x4_dif_coor_y,
    //su khac biet toa do theo chieu ngang, doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
    //voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
    output logic signed [10:0] dMv_Scale_Prec_x0,
    output logic signed [10:0] dMv_Scale_Prec_y0,
    output logic signed [10:0] dMv_Scale_Prec_x1,
    output logic signed [10:0] dMv_Scale_Prec_y1,
    output logic signed [10:0] dMv_Scale_Prec_x2,
    output logic signed [10:0] dMv_Scale_Prec_y2,
    output logic signed [10:0] dMv_Scale_Prec_x3,
    output logic signed [10:0] dMv_Scale_Prec_y3,
    output logic signed [10:0] dMv_Scale_Prec_x4,
    output logic signed [10:0] dMv_Scale_Prec_y4,
    output logic signed [10:0] dMv_Scale_Prec_x5,
    output logic signed [10:0] dMv_Scale_Prec_y5,
    output logic signed [10:0] dMv_Scale_Prec_x6,
    output logic signed [10:0] dMv_Scale_Prec_y6,
    output logic signed [10:0] dMv_Scale_Prec_x7,
    output logic signed [10:0] dMv_Scale_Prec_y7,
    output logic signed [10:0] dMv_Scale_Prec_x8,
    output logic signed [10:0] dMv_Scale_Prec_y8,
    output logic signed [10:0] dMv_Scale_Prec_x9,
    output logic signed [10:0] dMv_Scale_Prec_y9,
    output logic signed [10:0] dMv_Scale_Prec_x10,
    output logic signed [10:0] dMv_Scale_Prec_y10,
    output logic signed [10:0] dMv_Scale_Prec_x11,
    output logic signed [10:0] dMv_Scale_Prec_y11,
    output logic signed [10:0] dMv_Scale_Prec_x12,
    output logic signed [10:0] dMv_Scale_Prec_y12,
    output logic signed [10:0] dMv_Scale_Prec_x13,
    output logic signed [10:0] dMv_Scale_Prec_y13,
    output logic signed [10:0] dMv_Scale_Prec_x14,
    output logic signed [10:0] dMv_Scale_Prec_y14,
    output logic signed [10:0] dMv_Scale_Prec_x15,
    output logic signed [10:0] dMv_Scale_Prec_y15,
    //tín hieu cho biet che ?o PROF ??oc su dung
    output logic enable_prof
    );
localparam sbW = 4'd4;
localparam sbH = 4'd4;
logic signed [16:0] dMv_Scale_x0;
logic signed [16:0] dMv_Scale_y0;
logic signed [16:0] dMv_Scale_x1;
logic signed [16:0] dMv_Scale_y1;
logic signed [16:0] dMv_Scale_x2;
logic signed [16:0] dMv_Scale_y2;
logic signed [16:0] dMv_Scale_x3;
logic signed [16:0] dMv_Scale_y3;
logic signed [16:0] dMv_Scale_x4;
logic signed [16:0] dMv_Scale_y4;
logic signed [16:0] dMv_Scale_x5;
logic signed [16:0] dMv_Scale_y5;
logic signed [16:0] dMv_Scale_x6;
logic signed [16:0] dMv_Scale_y6;
logic signed [16:0] dMv_Scale_x7;
logic signed [16:0] dMv_Scale_y7;
logic signed [16:0] dMv_Scale_x8;
logic signed [16:0] dMv_Scale_y8;
logic signed [16:0] dMv_Scale_x9;
logic signed [16:0] dMv_Scale_y9;
logic signed [16:0] dMv_Scale_x10;
logic signed [16:0] dMv_Scale_y10;
logic signed [16:0] dMv_Scale_x11;
logic signed [16:0] dMv_Scale_y11;
logic signed [16:0] dMv_Scale_x12;
logic signed [16:0] dMv_Scale_y12;
logic signed [16:0] dMv_Scale_x13;
logic signed [16:0] dMv_Scale_y13;
logic signed [16:0] dMv_Scale_x14;
logic signed [16:0] dMv_Scale_y14;
logic signed [16:0] dMv_Scale_x15;
logic signed [16:0] dMv_Scale_y15;
localparam w_4_x0 = -4'd3;
localparam w_4_x1 = -4'd1;
localparam w_4_x2 = 4'd1;
localparam w_4_x3 = 4'd3;
localparam w_4_x4 = -4'd3;
localparam w_4_x5 = -4'd1;
localparam w_4_x6 = 4'd1;
localparam w_4_x7 = 4'd3;
localparam w_4_x8 = -4'd3;
localparam w_4_x9 = -4'd1;
localparam w_4_x10 = 4'd1;
localparam w_4_x11 = 4'd3;
localparam w_4_x12 = -4'd3;
localparam w_4_x13 = -4'd1;
localparam w_4_x14 = 4'd1;
localparam w_4_x15 = 4'd3;

localparam h_4_y0 = -4'd3;
localparam h_4_y1 = -4'd3;
localparam h_4_y2 = -4'd3;
localparam h_4_y3 = -4'd3;
localparam h_4_y4 = -4'd1;
localparam h_4_y5 = -4'd1;
localparam h_4_y6 = -4'd1;
localparam h_4_y7 = -4'd1;
localparam h_4_y8 =  4'd1;
localparam h_4_y9 =  4'd1;
localparam h_4_y10 = 4'd1;
localparam h_4_y11 = 4'd1;
localparam h_4_y12 = 4'd3;
localparam h_4_y13 = 4'd3;
localparam h_4_y14 = 4'd3;
localparam h_4_y15 = 4'd3;

logic [8:0] Ipu_w1;
logic [8:0] Ipu_w2;

logic [3:0] result1_1;
logic [3:0] result1_2;
logic [3:0] result1;

logic signed [19:0] dmHorX;
logic signed [19:0] dmHorY;
logic signed [19:0] dmVerX;
logic signed [19:0] dmVerY;
logic signed [19:0] baseHor;
logic signed [19:0] baseVer;
logic signed [7:0] weightHor;
logic signed [7:0] weightVer;

logic signed enable_prof_tmp;
logic signed calc_done_tmp1;

logic signed [28:0] mv_param_x;
logic signed [28:0] mv_param_y;
logic signed [23:0] mv_para_x;
logic signed [23:0] mv_para_y;

logic a6para;

always_ff @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        a6para <= 0;
    end
    else
    begin
        if(start_load)
            a6para <= 0;
        else
        begin
            if (start_aff6)
            begin
                a6para <= 1;
            end
            else
            begin
                a6para <= a6para;
            end
        end
    end
end

//tinh toan logarit co so 2 do rong, do cao cua khoi du doan
always_comb 
begin
    if(Ipu_w & 8'hf0)
    begin
        Ipu_w1 = Ipu_w >> 4;
        result1_1 = 4;
    end
    else
    begin
        Ipu_w1 = Ipu_w;
        result1_1 = 0;
    end
    if(Ipu_w1 & 4'hc)
    begin
        Ipu_w2 = Ipu_w1 >> 2;
        result1_2 = result1_1 + 2;
    end
    else
    begin
        Ipu_w2 = Ipu_w1;
        result1_2 = result1_1;
    end
    if(Ipu_w2 & 2'h2)
        result1 = result1_2 + 1;
    else
        result1 = result1_2;
end

//tinh toan phan xoay, phong to thu nho theo chieu ngang
always_comb
begin
    dmHorX = (mvRT_x - mvLT_x)  << (7- result1);
    dmHorY = (mvRT_y - mvLT_y)  << (7- result1);
    if(~a6para)
    begin
        dmVerX = -dmHorY;
        dmVerY = dmHorX;
    end
    else
    begin
        dmVerX = (mvLB_x - mvLT_x)  << (7 - result1);
        dmVerY = (mvLB_y - mvLT_y)  << (7 - result1);
    end
    //thanh phan dich theo chieu ngang va chieu cao
    baseHor = mvLT_x << 7;
    baseVer = mvLT_y << 7;
end

//kiem tra khi nao dung che do tinh chinh
always_comb
begin
    if(~(&dmHorX) && ~(&dmHorY) && ~(&dmVerX) && ~(&dmVerY))
    begin
        enable_prof_tmp = 0;
    end
    else
    begin
        enable_prof_tmp = 1;
    end
end

//tinh toan su chenh lech giua khoi du doan 4x4 dang duoc tinh toan va khoi du doan hien tai
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        blk4x4_dif_coor_x <= -8'd4;
        blk4x4_dif_coor_y <= -8'd4;
        calc_done_tmp1 <= 0;
    end
    else
    begin
    
        if(start_blk || start_calc || start_aff6)
        begin
            if(blk4x4_dif_coor_y < Ipu_h - sbH)
            begin
                if(blk4x4_dif_coor_x < Ipu_w - sbW)
                begin
                   blk4x4_dif_coor_x <= blk4x4_dif_coor_x + sbW;
                end
                else
                begin
                    blk4x4_dif_coor_x <= 0;
                    blk4x4_dif_coor_y <= blk4x4_dif_coor_y + sbH;   
                end
            end
            else
            begin
                if(blk4x4_dif_coor_x < Ipu_w - sbW)
                begin
                    blk4x4_dif_coor_x <= blk4x4_dif_coor_x + sbW;
                end
                else
                begin
                    blk4x4_dif_coor_x <= 0;
                    blk4x4_dif_coor_y <= 0;
                end
            end
            calc_done_tmp1 <= 1;
        end
        else
        begin
            calc_done_tmp1 <= 0;
        end
    end
end
//che do tinh chinh duoc bat khi
always_ff @(posedge clk)
begin
    enable_prof <= ~large_mv_grad && ~iref_scale && enable_prof_tmp;
end

//
always_comb
begin
    if(large_mv_grad)
    begin
         weightHor = Ipu_w >> 1;
         weightVer = Ipu_h >> 1;
    end
    else
    begin
         weightHor = (sbW >> 1) + blk4x4_dif_coor_x;
         weightVer = (sbH >> 1) + blk4x4_dif_coor_y;
    end
end
//tinh toan scale vecto du doan
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        mv_param_x <= 0;     
        mv_param_y <= 0;
        calc_done <= 0;
        
    end
    else
    begin
        mv_param_x <= baseHor + dmHorX * weightHor + dmVerX * weightVer;     
        mv_param_y <= baseVer + dmHorY * weightHor + dmVerY * weightVer;
        calc_done <= calc_done_tmp1;
    end
end

always_comb
begin
    mv_para_x = (mv_param_x + 64 + (~mv_param_x >> 31)) >> 7;
    mv_para_y = (mv_param_y + 64 + (~mv_param_y >> 31)) >> 7;
    //lam tron den 1/16 luma
    //tinh toan phan nguyen va phan thap phan cho vecto du doan
    vect_Int_x = mv_para_x >> 4;
    vect_Frac_x = mv_para_x & 15;
    vect_Int_y = mv_para_y >> 4;
    vect_Frac_y = mv_para_y & 15;
end

//tinh toan su khac biet toa do dai gi?a vecto chuyen dong cua khoi du doan 4x4 hien tai voi vecto chuyen dong cua tung diem anh 
//nam trong khoi du doan 4x4 do

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
    dMv_Scale_x0 = 0;
    dMv_Scale_y0 = 0;
    dMv_Scale_x1 = 0;
    dMv_Scale_y1 = 0;
    dMv_Scale_x2 = 0;
    dMv_Scale_y2 = 0;
    dMv_Scale_x3 = 0;
    dMv_Scale_y3 = 0;
    dMv_Scale_x4 = 0;
    dMv_Scale_y4 = 0;
    dMv_Scale_x5 = 0;
    dMv_Scale_y5 = 0;
    dMv_Scale_x6 = 0;
    dMv_Scale_y6 = 0;
    dMv_Scale_x7 = 0;
    dMv_Scale_y7 = 0;
    dMv_Scale_x8 = 0;
    dMv_Scale_y8 = 0;
    dMv_Scale_x9 = 0;
    dMv_Scale_y9 = 0;
    dMv_Scale_x10 = 0;
    dMv_Scale_y10 = 0;
    dMv_Scale_x11 = 0;
    dMv_Scale_y11 = 0;
    dMv_Scale_x12 = 0;
    dMv_Scale_y12 = 0;
    dMv_Scale_x13 = 0;
    dMv_Scale_y13 = 0;
    dMv_Scale_x14 = 0;
    dMv_Scale_y14 = 0;
    dMv_Scale_x15 = 0;
    dMv_Scale_y15 = 0;
    end
    else begin
        if(enable_prof)
        begin  
        dMv_Scale_x0 = dmHorX * w_4_x0 + dmVerX * h_4_y0;
        dMv_Scale_y0 = dmHorY * w_4_x0 + dmVerY * h_4_y0;
        dMv_Scale_x1 = dmHorX * w_4_x1 + dmVerX * h_4_y1;
        dMv_Scale_y1 = dmHorY * w_4_x1 + dmVerY * h_4_y1;
        dMv_Scale_x2 = dmHorX * w_4_x2 + dmVerX * h_4_y2;
        dMv_Scale_y2 = dmHorY * w_4_x2 + dmVerY * h_4_y2;
        dMv_Scale_x3 = dmHorX * w_4_x3 + dmVerX * h_4_y3;
        dMv_Scale_y3 = dmHorY * w_4_x3 + dmVerY * h_4_y3;
        dMv_Scale_x4 = dmHorX * w_4_x4 + dmVerX * h_4_y4;
        dMv_Scale_y4 = dmHorY * w_4_x4 + dmVerY * h_4_y4;
        dMv_Scale_x5 = dmHorX * w_4_x5 + dmVerX * h_4_y5;
        dMv_Scale_y5 = dmHorY * w_4_x5 + dmVerY * h_4_y5;
        dMv_Scale_x6 = dmHorX * w_4_x6 + dmVerX * h_4_y6;
        dMv_Scale_y6 = dmHorY * w_4_x6 + dmVerX * h_4_y6;
        dMv_Scale_x7 = dmHorX * w_4_x7 + dmVerX * h_4_y7;
        dMv_Scale_y7 = dmHorY * w_4_x7 + dmVerY * h_4_y7;
        dMv_Scale_x8 = dmHorX * w_4_x8 + dmVerX * h_4_y8;
        dMv_Scale_y8 = dmHorY * w_4_x8 + dmVerY * h_4_y8;
        dMv_Scale_x9 = dmHorX * w_4_x9 + dmVerX * h_4_y9;
        dMv_Scale_y9 = dmHorY * w_4_x9 + dmVerY * h_4_y9;
        dMv_Scale_x10 = dmHorX * w_4_x10 + dmVerX * h_4_y10;
        dMv_Scale_y10 = dmHorY * w_4_x10 + dmVerY * h_4_y10;
        dMv_Scale_x11 = dmHorX * w_4_x11 + dmVerX * h_4_y11;
        dMv_Scale_y11 = dmHorY * w_4_x11 + dmVerY * h_4_y11;
        dMv_Scale_x12 = dmHorX * w_4_x12 + dmVerX * h_4_y12;
        dMv_Scale_y12 = dmHorY * w_4_x12 + dmVerY * h_4_y12;
        dMv_Scale_x13 = dmHorX * w_4_x13 + dmVerX * h_4_y13;
        dMv_Scale_y13 = dmHorY * w_4_x13 + dmVerY * h_4_y13;
        dMv_Scale_x14 = dmHorX * w_4_x14 + dmVerX * h_4_y14;
        dMv_Scale_y14 = dmHorY * w_4_x14 + dmVerY * h_4_y14;
        dMv_Scale_x15 = dmHorX * w_4_x15 + dmVerX * h_4_y15;
        dMv_Scale_y15 = dmHorY * w_4_x15 + dmVerY * h_4_y15;
        end
        else 
        begin
        dMv_Scale_x0 = 0;
        dMv_Scale_y0 = 0;
        dMv_Scale_x1 = 0;
        dMv_Scale_y1 = 0;
        dMv_Scale_x2 = 0;
        dMv_Scale_y2 = 0;
        dMv_Scale_x3 = 0;
        dMv_Scale_y3 = 0;
        dMv_Scale_x4 = 0;
        dMv_Scale_y4 = 0;
        dMv_Scale_x5 = 0;
        dMv_Scale_y5 = 0;
        dMv_Scale_x6 = 0;
        dMv_Scale_y6 = 0;
        dMv_Scale_x7 = 0;
        dMv_Scale_y7 = 0;
        dMv_Scale_x8 = 0;
        dMv_Scale_y8 = 0;
        dMv_Scale_x9 = 0;
        dMv_Scale_y9 = 0;
        dMv_Scale_x10 = 0;
        dMv_Scale_y10 = 0;
        dMv_Scale_x11 = 0;
        dMv_Scale_y11 = 0;
        dMv_Scale_x12 = 0;
        dMv_Scale_y12 = 0;
        dMv_Scale_x13 = 0;
        dMv_Scale_y13 = 0;
        dMv_Scale_x14 = 0;
        dMv_Scale_y14 = 0;
        dMv_Scale_x15 = 0;
        dMv_Scale_y15 = 0;
        end
    end
end

always_comb
begin
    dMv_Scale_Prec_x0 = (dMv_Scale_x0 + 64 + (~dMv_Scale_x0 >> 31)) >> 7;
    dMv_Scale_Prec_y0 = (dMv_Scale_y0 + 64 + (~dMv_Scale_y0 >> 31)) >> 7;
    dMv_Scale_Prec_x1 = (dMv_Scale_x1 + 64 + (~dMv_Scale_x1 >> 31)) >> 7;
    dMv_Scale_Prec_y1 = (dMv_Scale_y1 + 64 + (~dMv_Scale_y1 >> 31)) >> 7;
    dMv_Scale_Prec_x2 = (dMv_Scale_x2 + 64 + (~dMv_Scale_x2 >> 31)) >> 7;
    dMv_Scale_Prec_y2 = (dMv_Scale_y2 + 64 + (~dMv_Scale_y2 >> 31)) >> 7;
    dMv_Scale_Prec_x3 = (dMv_Scale_x3 + 64 + (~dMv_Scale_x3 >> 31)) >> 7;
    dMv_Scale_Prec_y3 = (dMv_Scale_y3 + 64 + (~dMv_Scale_y3 >> 31)) >> 7;
    dMv_Scale_Prec_x4 = (dMv_Scale_x4 + 64 + (~dMv_Scale_x4 >> 31)) >> 7;
    dMv_Scale_Prec_y4 = (dMv_Scale_y4 + 64 + (~dMv_Scale_y4 >> 31)) >> 7;
    dMv_Scale_Prec_x5 = (dMv_Scale_x5 + 64 + (~dMv_Scale_x5 >> 31)) >> 7;
    dMv_Scale_Prec_y5 = (dMv_Scale_y5 + 64 + (~dMv_Scale_y5 >> 31)) >> 7;
    dMv_Scale_Prec_x6 = (dMv_Scale_x6 + 64 + (~dMv_Scale_x6 >> 31)) >> 7;
    dMv_Scale_Prec_y6 = (dMv_Scale_y6 + 64 + (~dMv_Scale_y6 >> 31)) >> 7;
    dMv_Scale_Prec_x7 = (dMv_Scale_x7 + 64 + (~dMv_Scale_x7 >> 31)) >> 7;
    dMv_Scale_Prec_y7 = (dMv_Scale_y7 + 64 + (~dMv_Scale_y7 >> 31)) >> 7;
    dMv_Scale_Prec_x8 = (dMv_Scale_x8 + 64 + (~dMv_Scale_x8 >> 31)) >> 7;
    dMv_Scale_Prec_y8 = (dMv_Scale_y8 + 64 + (~dMv_Scale_y8 >> 31)) >> 7;
    dMv_Scale_Prec_x9 = (dMv_Scale_x9 + 64 + (~dMv_Scale_x9 >> 31)) >> 7;
    dMv_Scale_Prec_y9 = (dMv_Scale_y9 + 64 + (~dMv_Scale_y9 >> 31)) >> 7;
    dMv_Scale_Prec_x10 = (dMv_Scale_x10 + 64 + (~dMv_Scale_x10 >> 31)) >> 7;
    dMv_Scale_Prec_y10 = (dMv_Scale_y10 + 64 + (~dMv_Scale_y10 >> 31)) >> 7;
    dMv_Scale_Prec_x11 = (dMv_Scale_x11 + 64 + (~dMv_Scale_x11 >> 31)) >> 7;
    dMv_Scale_Prec_y11 = (dMv_Scale_y11 + 64 + (~dMv_Scale_y11 >> 31)) >> 7;
    dMv_Scale_Prec_x12 = (dMv_Scale_x12 + 64 + (~dMv_Scale_x12 >> 31)) >> 7;
    dMv_Scale_Prec_y12 = (dMv_Scale_y12 + 64 + (~dMv_Scale_y12 >> 31)) >> 7;
    dMv_Scale_Prec_x13 = (dMv_Scale_x13 + 64 + (~dMv_Scale_x13 >> 31)) >> 7;
    dMv_Scale_Prec_y13 = (dMv_Scale_y13 + 64 + (~dMv_Scale_y13 >> 31)) >> 7;
    dMv_Scale_Prec_x14 = (dMv_Scale_x14 + 64 + (~dMv_Scale_x14 >> 31)) >> 7;
    dMv_Scale_Prec_y14 = (dMv_Scale_y14 + 64 + (~dMv_Scale_y14 >> 31)) >> 7;
    dMv_Scale_Prec_x15 = (dMv_Scale_x15 + 64 + (~dMv_Scale_x15 >> 31)) >> 7;
    dMv_Scale_Prec_y15 = (dMv_Scale_y15 + 64 + (~dMv_Scale_y15 >> 31)) >> 7;
end

endmodule
