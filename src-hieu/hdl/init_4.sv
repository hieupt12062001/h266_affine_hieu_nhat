
module init_4(
    input clk,
    input rst_n,
    // dau vao bat dau tinh toan affine cho khoi du doan
    input en,
    input export_data_init,
    // mvbits
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
    // integer vector value output
    output logic signed [12:0] vect_4para_Int_x,
    output logic signed [12:0] vect_4para_Int_y,
    // fraction vector value ouput
    output logic signed [4:0] vect_4para_Frac_x,
    output logic signed [4:0] vect_4para_Frac_y,
    //ðo chênh lech toa ðo giua block du ðoán 4x4 voi khoi du ðoán hien tai 
    output logic signed [7:0] blk4x4_dif_coor_x,
    output logic signed [7:0] blk4x4_dif_coor_y,
    //su khac biet toa do theo chieu ngang, doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
    //voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
    output logic signed [10:0] dMv_Scale_Prec_4_x0,
    output logic signed [10:0] dMv_Scale_Prec_4_y0,
    output logic signed [10:0] dMv_Scale_Prec_4_x1,
    output logic signed [10:0] dMv_Scale_Prec_4_y1,
    output logic signed [10:0] dMv_Scale_Prec_4_x2,
    output logic signed [10:0] dMv_Scale_Prec_4_y2,
    output logic signed [10:0] dMv_Scale_Prec_4_x3,
    output logic signed [10:0] dMv_Scale_Prec_4_y3,
    output logic signed [10:0] dMv_Scale_Prec_4_x4,
    output logic signed [10:0] dMv_Scale_Prec_4_y4,
    output logic signed [10:0] dMv_Scale_Prec_4_x5,
    output logic signed [10:0] dMv_Scale_Prec_4_y5,
    output logic signed [10:0] dMv_Scale_Prec_4_x6,
    output logic signed [10:0] dMv_Scale_Prec_4_y6,
    output logic signed [10:0] dMv_Scale_Prec_4_x7,
    output logic signed [10:0] dMv_Scale_Prec_4_y7,
    output logic signed [10:0] dMv_Scale_Prec_4_x8,
    output logic signed [10:0] dMv_Scale_Prec_4_y8,
    output logic signed [10:0] dMv_Scale_Prec_4_x9,
    output logic signed [10:0] dMv_Scale_Prec_4_y9,
    output logic signed [10:0] dMv_Scale_Prec_4_x10,
    output logic signed [10:0] dMv_Scale_Prec_4_y10,
    output logic signed [10:0] dMv_Scale_Prec_4_x11,
    output logic signed [10:0] dMv_Scale_Prec_4_y11,
    output logic signed [10:0] dMv_Scale_Prec_4_x12,
    output logic signed [10:0] dMv_Scale_Prec_4_y12,
    output logic signed [10:0] dMv_Scale_Prec_4_x13,
    output logic signed [10:0] dMv_Scale_Prec_4_y13,
    output logic signed [10:0] dMv_Scale_Prec_4_x14,
    output logic signed [10:0] dMv_Scale_Prec_4_y14,
    output logic signed [10:0] dMv_Scale_Prec_4_x15,
    output logic signed [10:0] dMv_Scale_Prec_4_y15,
    // dMvScale for affine 6
    
    //so bit toi thieu dung de bieu dien vecto chuyen dong cua khoi du doan
    output logic [20:0] bits_4para,
    //tín hieu cho biet che ðo PROF ðýoc su dung
    output logic enable_prof_4
    );

localparam sbW = 4'd4;
localparam sbH = 4'd4;
localparam offset_calc_mv = 1 << 7 >> 1;
localparam MV_FRAC_BITS_LUMA = 4'd4;
localparam MV_FRAC_MASK_LUMA = 4'd15;
localparam right_shift0 = 2;
localparam nOffset0 = 1 << (right_shift0 - 1);
localparam right_shift1 = 4;
localparam nOffset1 = 1 << (right_shift1 - 1);
localparam  uiLength2_init = 1'd1;


logic [3:0] result1_1;
logic [3:0] result1_2;
logic [3:0] result1;
//logic [3:0] result2_1;
//logic [3:0] result2_2;
//logic [3:0] result2;

logic [3:0] result_LT_1_1;
logic [3:0] result_LT_1_2;
logic [3:0] result_LT_1;
logic [3:0] result_LT_2_1;
logic [3:0] result_LT_2_2;
logic [3:0] result_LT_2;

logic [3:0] result_RT_1_1;
logic [3:0] result_RT_1_2;
logic [3:0] result_RT_1;
logic [3:0] result_RT_2_1;
logic [3:0] result_RT_2_2;
logic [3:0] result_RT_2;

logic [3:0] result_LB_1_1;
logic [3:0] result_LB_1_2;
logic [3:0] result_LB_1;
logic [3:0] result_LB_2_1;
logic [3:0] result_LB_2_2;
logic [3:0] result_LB_2;

logic signed [19:0] dmHorX;
logic signed [19:0] dmHorY;
logic signed [19:0] dmVerX_4;
logic signed [19:0] dmVerY_4;
logic signed [19:0] baseHor;
logic signed [19:0] baseVer;
logic signed [7:0] weightHor_4;
logic signed [7:0] weightVer_4;

logic signed [28:0] mv4_4param_x;
logic signed [28:0] mv4_4param_y;

logic signed [23:0] mv4_4para_x;
logic signed [23:0] mv4_4para_y;

logic enable_prof_4para_tmp_1;

logic signed [2:0] w_4_x0;
logic signed [2:0] h_4_y0;
logic signed [2:0] w_4_x1;
logic signed [2:0] h_4_y1;
logic signed [2:0] w_4_x2;
logic signed [2:0] h_4_y2;
logic signed [2:0] w_4_x3;
logic signed [2:0] h_4_y3;
logic signed [2:0] w_4_x4;
logic signed [2:0] h_4_y4;
logic signed [2:0] w_4_x5;
logic signed [2:0] h_4_y5;
logic signed [2:0] w_4_x6;
logic signed [2:0] h_4_y6;
logic signed [2:0] w_4_x7;
logic signed [2:0] h_4_y7;
logic signed [2:0] w_4_x8;
logic signed [2:0] h_4_y8;
logic signed [2:0] w_4_x9;
logic signed [2:0] h_4_y9;
logic signed [2:0] w_4_x10;
logic signed [2:0] h_4_y10;
logic signed [2:0] w_4_x11;
logic signed [2:0] h_4_y11;
logic signed [2:0] w_4_x12;
logic signed [2:0] h_4_y12;
logic signed [2:0] w_4_x13;
logic signed [2:0] h_4_y13;
logic signed [2:0] w_4_x14;
logic signed [2:0] h_4_y14;
logic signed [2:0] w_4_x15;
logic signed [2:0] h_4_y15;

logic signed [16:0] dMv_Scale_4_x0;
logic signed [16:0] dMv_Scale_4_y0;
logic signed [16:0] dMv_Scale_4_x1;
logic signed [16:0] dMv_Scale_4_y1;
logic signed [16:0] dMv_Scale_4_x2;
logic signed [16:0] dMv_Scale_4_y2;
logic signed [16:0] dMv_Scale_4_x3;
logic signed [16:0] dMv_Scale_4_y3;
logic signed [16:0] dMv_Scale_4_x4;
logic signed [16:0] dMv_Scale_4_y4;
logic signed [16:0] dMv_Scale_4_x5;
logic signed [16:0] dMv_Scale_4_y5;
logic signed [16:0] dMv_Scale_4_x6;
logic signed [16:0] dMv_Scale_4_y6;
logic signed [16:0] dMv_Scale_4_x7;
logic signed [16:0] dMv_Scale_4_y7;
logic signed [16:0] dMv_Scale_4_x8;
logic signed [16:0] dMv_Scale_4_y8;
logic signed [16:0] dMv_Scale_4_x9;
logic signed [16:0] dMv_Scale_4_y9;
logic signed [16:0] dMv_Scale_4_x10;
logic signed [16:0] dMv_Scale_4_y10;
logic signed [16:0] dMv_Scale_4_x11;
logic signed [16:0] dMv_Scale_4_y11;
logic signed [16:0] dMv_Scale_4_x12;
logic signed [16:0] dMv_Scale_4_y12;
logic signed [16:0] dMv_Scale_4_x13;
logic signed [16:0] dMv_Scale_4_y13;
logic signed [16:0] dMv_Scale_4_x14;
logic signed [16:0] dMv_Scale_4_y14;
logic signed [16:0] dMv_Scale_4_x15;
logic signed [16:0] dMv_Scale_4_y15;
    // dMvScale for affine 6

logic signed [10:0] pred_mvLT_x;
logic signed [10:0] pred_mvLT_y;
logic signed [10:0] new_mvLT_x;
logic signed [10:0] new_mvLT_y;
logic signed [10:0] ival_LT_x;
logic signed [10:0] ival_LT_y;
logic signed [12:0] temp2_LT_x;
logic signed [12:0] temp2_LT_y;
logic [4:0] uiLength2_LT_x;
logic [4:0] uiLength2_LT_y;
logic [5:0] bits_LT;
logic [12:0] temp2_LT_x1;
logic [12:0] temp2_LT_y1;
logic [12:0] temp1_LT_x1;
logic [12:0] temp1_LT_y1;
logic [12:0] temp0_LT_x1;
logic [12:0] temp0_LT_y1;

logic signed [13:0] pred_tmp_mvRT_x;
logic signed [13:0] pred_tmp_mvRT_y;
logic signed [10:0] pred_mvRT_x;
logic signed [10:0] pred_mvRT_y;
logic signed [10:0] new_mvRT_x;
logic signed [10:0] new_mvRT_y;
logic signed [10:0] ival_RT_x;
logic signed [10:0] ival_RT_y;
logic signed [12:0] temp2_RT_x;
logic signed [12:0] temp2_RT_y;
logic [4:0] uiLength2_RT_x;
logic [4:0] uiLength2_RT_y;
logic [5:0] bits_RT;
logic [12:0] temp2_RT_x1;
logic [12:0] temp2_RT_y1;
logic [12:0] temp1_RT_x1;
logic [12:0] temp1_RT_y1;
logic [12:0] temp0_RT_x1;
logic [12:0] temp0_RT_y1;

logic signed [13:0] pred_tmp_mvLB_x;
logic signed [13:0] pred_tmp_mvLB_y;
logic signed [10:0] pred_mvLB_x;
logic signed [10:0] pred_mvLB_y;
logic signed [10:0] new_mvLB_x;
logic signed [10:0] new_mvLB_y;
logic signed [10:0] ival_LB_x;
logic signed [10:0] ival_LB_y;
logic signed [12:0] temp2_LB_x;
logic signed [12:0] temp2_LB_y;
logic [4:0] uiLength2_LB_x;
logic [4:0] uiLength2_LB_y;
logic [5:0] bits_LB;
logic [12:0] temp2_LB_x1;
logic [12:0] temp2_LB_y1;
logic [12:0] temp1_LB_x1;
logic [12:0] temp1_LB_y1;
logic [12:0] temp0_LB_x1;
logic [12:0] temp0_LB_y1;

logic [8:0] Ipu_w1;
logic [8:0] Ipu_w2;

////////////////////////////////tinh toan logarit co so 2 do rong, do cao cua khoi du doan
///phan nay phuc vu cho tinh toan phan nguyen và phan thap phan cua khoi anh
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

//////////////////////Left top 
//chuyen vecto sang dang AMVR
always_comb
begin    
    if(pre_mvLT_x >= 0)
    begin
        pred_mvLT_x = (pre_mvLT_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvLT_x = (pre_mvLT_x + nOffset0) >> right_shift0;
    end
    
    if(pre_mvLT_y >= 0)
    begin
        pred_mvLT_y = (pre_mvLT_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvLT_y = (pre_mvLT_y + nOffset0) >> right_shift0;
    end
    
    if(mvLT_x >= 0)
    begin
        new_mvLT_x = (mvLT_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvLT_x = (mvLT_x + nOffset0) >> right_shift0;
    end
    
    if(mvLT_y >= 0)
    begin
        new_mvLT_y = (mvLT_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvLT_y = (mvLT_y + nOffset0) >> right_shift0;
    end
    
 // tinh su khac nhau ve do dai toa do giua cac ung cu vien AMVP mõi va cac CPMV
    ival_LT_x = new_mvLT_x - pred_mvLT_x;
    ival_LT_y = new_mvLT_y - pred_mvLT_y;
    
    //tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 1
    if (ival_LT_x <= 0)
    begin
        temp2_LT_x = (-ival_LT_x << 1) + 1;
//        temp2_LT_x = shift_ival + 1
    end
    else
    begin
        temp2_LT_x = ival_LT_x << 1;
    end
    
    if (ival_LT_y <= 0)
    begin
        temp2_LT_y = (-ival_LT_y << 1) + 1;
    end
    else
    begin
        temp2_LT_y = ival_LT_y << 1;
    end

end

// L?nh always ?? x? lý theo c?nh
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 2
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    uiLength2_LT_x <= 0;
    uiLength2_LT_y <= 0;
    /*temp2_LT_x <= 0;
    temp2_LT_y <= 0;*/
  end else begin
    if(temp2_LT_x > 128)
    begin
        uiLength2_LT_x <= uiLength2_init + (7 << 1);
        temp2_LT_x1 <= temp2_LT_x >> 7;
    end
    else
    begin
        uiLength2_LT_x <= uiLength2_init;
        temp2_LT_x1 <= temp2_LT_x;
    end
    
    if(temp2_LT_y > 128)
    begin
        uiLength2_LT_y <= uiLength2_init + (7 << 1);
        temp2_LT_y1 <= temp2_LT_y >> 7;
    end
    else
    begin
        uiLength2_LT_y <= uiLength2_init;
        temp2_LT_y1 <= temp2_LT_y;
    end
  end
end
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 3
always_comb 
begin
    if(temp2_LT_x1 & 8'hf0)
    begin
        temp1_LT_x1 = temp2_LT_x1 >> 4;
        result_LT_1_1 = 4;
    end
    else
    begin
        temp1_LT_x1 = temp2_LT_x1;
        result_LT_1_1 = 0;
    end
    if(temp1_LT_x1 & 4'hc)
    begin
        temp0_LT_x1 = temp1_LT_x1 >> 2;
        result_LT_1_2 = result_LT_1_1 + 2;
    end
    else
    begin
        temp0_LT_x1 = temp1_LT_x1;
        result_LT_1_2 = result_LT_1_1;
    end
    if(temp0_LT_x1 & 2'h2)
        result_LT_1 = result_LT_1_2 + 1;
    else
        result_LT_1 = result_LT_1_2;
end

always_comb 
begin
    if(temp2_LT_y1 & 8'hf0)
    begin
        temp1_LT_y1 = temp2_LT_y1 >> 4;
        result_LT_2_1 = 4;
    end
    else
    begin
        temp1_LT_y1 = temp2_LT_y1;
        result_LT_2_1 = 0;
    end
    if(temp1_LT_y1 & 4'hc)
    begin
        temp0_LT_y1 = temp1_LT_y1 >> 2;
        result_LT_2_2 = result_LT_2_1 + 2;
    end
    else
    begin
        temp0_LT_y1 = temp1_LT_y1;
        result_LT_2_2 = result_LT_2_1;
    end
    if(temp0_LT_y1 & 2'h2)
        result_LT_2 = result_LT_2_2 + 1;
    else
        result_LT_2 = result_LT_2_2;
end

/////////////////Right Top 
/// tinh toan AMVP moi
always_comb
begin 
    
    pred_tmp_mvRT_x = pre_mvRT_x + mvLT_x - pre_mvLT_x;
    pred_tmp_mvRT_y = pre_mvRT_y + mvLT_y - pre_mvLT_y;
end
//////chuyen doi sang dang AMVR 
always_comb
begin  
    if(pred_tmp_mvRT_x >= 0)
    begin
        pred_mvRT_x = (pred_tmp_mvRT_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvRT_x = (pred_tmp_mvRT_x + nOffset0) >> right_shift0;
    end
    
    if(pred_tmp_mvRT_y >= 0)
    begin
        pred_mvRT_y = (pred_tmp_mvRT_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvRT_y = (pred_tmp_mvRT_y + nOffset0) >> right_shift0;
    end
    
    if(mvRT_x >= 0)
    begin
        new_mvRT_x = (mvRT_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvRT_x = (mvRT_x + nOffset0) >> right_shift0;
    end
    
    if(mvRT_y >= 0)
    begin
        new_mvRT_y = (mvRT_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvRT_y = (mvRT_y + nOffset0) >> right_shift0;
    end
    
    // tinh su khac nhau ve do dai toa do giua cac ung cu vien AMVP mõi va cac CPMV
    ival_RT_x = new_mvRT_x - pred_mvRT_x;
    ival_RT_y = new_mvRT_y - pred_mvRT_y;
    ////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 1
    if (ival_RT_x <= 0)
    begin
        temp2_RT_x = (-ival_RT_x << 1) + 1;
    end
    else
    begin
        temp2_RT_x = ival_RT_x << 1;
    end
    
    if (ival_RT_y <= 0)
    begin
        temp2_RT_y = (-ival_RT_y << 1) + 1;
    end
    else
    begin
        temp2_RT_y = ival_RT_y << 1;
    end
end

// L?nh always ?? x? lý theo c?nh
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 2
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    uiLength2_RT_x <= 0;
    uiLength2_RT_y <= 0;
  end else begin
    if(temp2_RT_x > 128)
    begin
        uiLength2_RT_x <= uiLength2_init + (7 << 1);
        temp2_RT_x1 <= temp2_RT_x >> 7;
    end
    else
    begin
        uiLength2_RT_x <= uiLength2_init;
        temp2_RT_x1 <= temp2_RT_x;
    end
 
    if(temp2_RT_y > 128)
    begin
        uiLength2_RT_y <= uiLength2_init + (7 << 1);
        temp2_RT_y1 <= temp2_RT_x >> 7;
    end
    else
    begin
        uiLength2_RT_y <= uiLength2_init;
        temp2_RT_y1 <= temp2_RT_y;
    end
  end
end
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 3
always_comb 
begin
    if(temp2_RT_x1 & 8'hf0)
    begin
        temp1_RT_x1 = temp2_RT_x1 >> 4;
        result_RT_1_1 = 4;
    end
    else
    begin
        temp1_RT_x1 = temp2_RT_x1;
        result_RT_1_1 = 0;
    end
    if(temp1_RT_x1 & 4'hc)
    begin
        temp0_RT_x1 = temp1_RT_x1 >> 2;
        result_RT_1_2 = result_RT_1_1 + 2;
    end
    else
    begin
        temp0_RT_x1 = temp1_RT_x1;
        result_RT_1_2 = result_RT_1_1;
    end
    if(temp0_RT_x1 & 2'h2)
        result_RT_1 = result_RT_1_2 + 1;
    else
        result_RT_1 = result_RT_1_2;
end

always_comb 
begin
    if(temp2_RT_y1 & 8'hf0)
    begin
        temp1_RT_y1 = temp2_RT_y1 >> 4;
        result_RT_2_1 = 4;
    end
    else
    begin
        temp1_RT_y1 = temp2_RT_y1;
        result_RT_2_1 = 0;
    end
    if(temp1_RT_y1 & 4'hc)
    begin
        temp0_RT_y1 = temp1_RT_y1 >> 2;
        result_RT_2_2 = result_RT_2_1 + 2;
    end
    else
    begin
        temp0_RT_y1 = temp1_RT_y1;
        result_RT_2_2 = result_RT_2_1;
    end
    if(temp0_RT_y1 & 2'h2)
        result_RT_2 = result_RT_2_2 + 1;
    else
        result_RT_2 = result_RT_2_2;
end

////////////////Left Bottom

//tinh AMVP moi
always_comb
begin 
    pred_tmp_mvLB_x = pre_mvLB_x + mvLT_x - pre_mvLT_x;
    pred_tmp_mvLB_y = pre_mvLB_y + mvLT_y - pre_mvLT_y;
end
//chuyen doi sang dang AMVR
always_comb
begin 
    if(pred_tmp_mvLB_x >= 0)
    begin
        pred_mvLB_x = (pred_tmp_mvLB_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvLB_x = (pred_tmp_mvLB_x + nOffset0) >> right_shift0;
    end
    
    if(pred_tmp_mvLB_y >= 0)
    begin
        pred_mvLB_y = (pred_tmp_mvLB_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        pred_mvLB_y = (pred_tmp_mvLB_y + nOffset0) >> right_shift0;
    end
    
    if(mvLB_x >= 0)
    begin
        new_mvLB_x = (mvLB_x + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvLB_x = (mvLB_x + nOffset0) >> right_shift0;
    end
    
    if(mvLB_y >= 0)
    begin
        new_mvLB_y = (mvLB_y + nOffset0 - 1) >> right_shift0;
    end
    else
    begin
        new_mvLB_y = (mvLB_y + nOffset0) >> right_shift0;
    end
    //// tinh su khac nhau ve do dai toa do giua cac ung cu vien AMVP mõi va cac CPMV
    ival_LB_x = new_mvLB_x - pred_mvLB_x;
    ival_LB_y = new_mvLB_y - pred_mvLB_y;
    ////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 1
    if (ival_LB_x <= 0)
    begin
        temp2_LB_x = (-ival_LB_x << 1) + 1;
    end
    else
    begin
        temp2_LB_x = ival_LB_x << 1;
    end
    
    if (ival_LB_y <= 0)
    begin
        temp2_LB_y = (-ival_LB_y << 1) + 1;
    end
    else
    begin
        temp2_LB_y = ival_LB_y << 1;
    end
end

// L?nh always ?? x? lý theo c?nh
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 2
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    uiLength2_LB_x <= 1;
    uiLength2_LB_y <= 1;
    /*temp2_LB_x <= 0;
    temp2_LB_y <= 0;*/
  end else begin
    
    if(temp2_LB_x > 128)
    begin
        uiLength2_LB_x <= uiLength2_init + (7 << 1);
        temp2_LB_x1 <= temp2_LB_x >> 7;
    end
    else
    begin
        uiLength2_LB_x <= uiLength2_init;
        temp2_LB_x1 <= temp2_LB_x;
    end
    
    /*while (temp2_LB_y > 128) begin
      uiLength2_LB_y <= uiLength2_LB_y + (7 << 1);
      temp2_LB_y <= temp2_LB_y >> 7;
    end*/
    
    if(temp2_LB_y > 128)
    begin
        uiLength2_LB_y <= uiLength2_init + (7 << 1);
        temp2_LB_y1 <= temp2_LB_y >> 7;
    end
    else
    begin
        uiLength2_LB_y <= uiLength2_init;
        temp2_LB_y1 <= temp2_LB_y;
    end
  end
end
////tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step 3
always_comb 
begin
    if(temp2_LB_x1 & 8'hf0)
    begin
        temp1_LB_x1 = temp2_LB_x1 >> 4;
        result_LB_1_1 = 4;
    end
    else
    begin
        temp1_LB_x1 = temp2_LB_x1;
        result_LB_1_1 = 0;
    end
    if(temp1_LB_x1 & 4'hc)
    begin
        temp0_LB_x1 = temp1_LB_x1 >> 2;
        result_LB_1_2 = result_LB_1_1 + 2;
    end
    else
    begin
        temp0_LB_x1 = temp1_LB_x1;
        result_LB_1_2 = result_LB_1_1;
    end
    if(temp0_LB_x1 & 2'h2)
        result_LB_1 = result_LB_1_2 + 1;
    else
        result_LB_1 = result_LB_1_2;
end

always_comb 
begin
    if(temp2_LB_y1 & 8'hf0)
    begin
        temp1_LB_y1 = temp2_LB_y1 >> 4;
        result_LB_2_1 = 4;
    end
    else
    begin
        temp1_LB_y1 = temp2_LB_y1;
        result_LB_2_1 = 0;
    end
    if(temp1_LB_y1 & 4'hc)
    begin
        temp0_LB_y1 = temp1_LB_y1 >> 2;
        result_LB_2_2 = result_LB_2_1 + 2;
    end
    else
    begin
        temp0_LB_y1 = temp1_LB_y1;
        result_LB_2_2 = result_LB_2_1;
    end
    if(temp0_LB_y1 & 2'h2)
        result_LB_2 = result_LB_2_2 + 1;
    else
        result_LB_2 = result_LB_2_2;
end

//tinh so bit ma hoa Entropy theo phuong phap Exponential Golomb : step cuoi cung
always_comb
begin
    bits_LT = uiLength2_LT_x + (result_LT_1 << 1) + uiLength2_LT_y + (result_LT_2 << 1);
    bits_RT = uiLength2_RT_x + (result_RT_1 << 1) + uiLength2_RT_y + (result_RT_2 << 1);
    bits_LB = uiLength2_LB_x + (result_LB_1 << 1) + uiLength2_LB_y + (result_LB_2 << 1);
end
//so bit can thiet de ma hoa cac CPMV theo tung che do Affine
always_ff @(posedge clk or negedge rst_n) 
begin 
  if(~rst_n) begin
     bits_4para <= 0;
  end else begin
    if (export_data_init) begin
      bits_4para <= bits_LT + bits_RT + mvBits; 
    end else begin
       bits_4para <= bits_4para;
    end
  end
end



///////////////////////////////tinh toan phan nguyen, phan thap phan cuya khoi anh 4x4
//tinh toan phan xoay, phong to thu nho theo chieu ngang
always_comb
begin
    dmHorX = (mvRT_x - mvLT_x)  << (7- result1);
    dmHorY = (mvRT_y - mvLT_y)  << (7- result1);
    dmVerX_4 = -dmHorY;
    dmVerY_4 = dmHorX;
    
    //thanh phan dich theo chieu ngang va chieu cao
    baseHor = mvLT_x << 7;
    baseVer = mvLT_y << 7;
end
//kiem tra khi nao dung che do tinh chinh
always_comb
begin
    if(dmHorX == 0 && dmHorY == 0 && dmVerX_4 == 0 && dmVerY_4 == 0)
    begin
        enable_prof_4para_tmp_1 = 0;
    end
    else
    begin
        enable_prof_4para_tmp_1 = 1;
    end
    
    /*enable_4para_tmp = large_mv_grad_4 && ~iref_scale && enable_prof_4para_tmp_1;
    enable_6para_tmp = large_mv_grad_6 && ~iref_scale && enable_prof_6para_tmp_1;
    if(enable_4para_tmp && abs(dmHorX) <= profthres && abs(dmHorY) <= profthres && abs(dmVerX_4) <= profthres && abs(dmVerY_4) <= profthres)
    begin
        enable_prof_4para_tmp_2 = 0;
    end
    else
    begin
        enable_prof_4para_tmp_2 = 1;
    end
    
    if(abs(dmHorX) <= profthres && abs(dmHorY) <= profthres && abs(dmVerX_6) <= profthres && abs(dmVerY_6) <= profthres)
    begin
        enable_prof_6para_tmp_2 = 0;
    end
    else
    begin
        enable_prof_6para_tmp_2 = 1;
    end*/
end
//che do tinh chinh duoc bat khi
always_ff @(posedge clk)
begin
    enable_prof_4 <= ~large_mv_grad_4 && ~iref_scale && enable_prof_4para_tmp_1;
end
//tinh toan do lech theo chieu ngang va chieu cao cua tung diem anh nãm trong khoi 4x4 so voi tam cua khoi
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x0 <= 0;
        h_4_y0 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x0 <= 2 * 0 - (sbW - 1);
            h_4_y0 <= 2 * 0 - (sbH - 1);
        end
        else
        begin
            w_4_x0 <= 0;
            h_4_y0 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x1 <= 0;
        h_4_y1 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x1 <= 2 * 1 - (sbW - 1);
            h_4_y1 <= 2 * 0 - (sbH - 1);
        end
        else
        begin
            w_4_x1 <= 0;
            h_4_y1 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x2 <= 0;
        h_4_y2 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x2 <= 2 * 2 - (sbW - 1);
            h_4_y2 <= 2 * 0 - (sbH - 1);
        end
        else
        begin
            w_4_x2 <= 0;
            h_4_y2 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x3 <= 0;
        h_4_y3 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x3 <= 2 * 3 - (sbW - 1);
            h_4_y3 <= 2 * 0 - (sbH - 1);
        end
        else
        begin
            w_4_x3 <= 0;
            h_4_y3 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x4 <= 0;
        h_4_y4 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x4 <= 2 * 0 - (sbW - 1);
            h_4_y4 <= 2 * 1 - (sbH - 1);
        end
        else
        begin
            w_4_x4 <= 0;
            h_4_y4 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x5 <= 0;
        h_4_y5 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x5 <= 2 * 1 - (sbW - 1);
            h_4_y5 <= 2 * 1 - (sbH - 1);
        end
        else
        begin
            w_4_x5 <= 0;
            h_4_y5 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x6 <= 0;
        h_4_y6 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x6 <= 2 * 2 - (sbW - 1);
            h_4_y6 <= 2 * 1 - (sbH - 1);
        end
        else
        begin
            w_4_x6 <= 0;
            h_4_y6 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x7 <= 0;
        h_4_y7 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x7 <= 2 * 3 - (sbW - 1);
            h_4_y7 <= 2 * 1 - (sbH - 1);
        end
        else
        begin
            w_4_x7 <= 0;
            h_4_y7 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x8 <= 0;
        h_4_y8 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x8 <= 2 * 0 - (sbW - 1);
            h_4_y8 <= 2 * 2 - (sbH - 1);
        end
        else
        begin
            w_4_x8 <= 0;
            h_4_y8 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x9 <= 0;
        h_4_y9 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x9 <= 2 * 1 - (sbW - 1);
            h_4_y9 <= 2 * 2 - (sbH - 1);
        end
        else
        begin
            w_4_x9 <= 0;
            h_4_y9 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x10 <= 0;
        h_4_y10 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x10 <= 2 * 2 - (sbW - 1);
            h_4_y10 <= 2 * 2 - (sbH - 1);
        end
        else
        begin
            w_4_x10 <= 0;
            h_4_y10 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x11 <= 0;
        h_4_y11 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x11 <= 2 * 3 - (sbW - 1);
            h_4_y11 <= 2 * 2 - (sbH - 1);
        end
        else
        begin
            w_4_x11 <= 0;
            h_4_y11 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x12 <= 0;
        h_4_y12 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x12 <= 2 * 0 - (sbW - 1);
            h_4_y12 <= 2 * 3 - (sbH - 1);
        end
        else
        begin
            w_4_x12 <= 0;
            h_4_y12 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x13 <= 0;
        h_4_y13 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x13 <= 2 * 1 - (sbW - 1);
            h_4_y13 <= 2 * 3 - (sbH - 1);
        end
        else
        begin
            w_4_x13 <= 0;
            h_4_y13 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x14 <= 0;
        h_4_y14 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x14 <= 2 * 2 - (sbW - 1);
            h_4_y14 <= 2 * 3 - (sbH - 1);
        end
        else
        begin
            w_4_x14 <= 0;
            h_4_y14 <= 0;
        end
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        w_4_x15 <= 0;
        h_4_y15 <= 0;
    end
    else
    begin
        if(enable_prof_4 )
        begin
            w_4_x15 <= 2 * 3 - (sbW - 1);
            h_4_y15 <= 2 * 3 - (sbH - 1);
        end
        else
        begin
            w_4_x15 <= 0;
            h_4_y15 <= 0;
        end
    end
end

//tinh toan su chenh lech giua khoi du doan 4x4 dang duoc tinh toan va khoi du doan hien tai
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        // blk4x4_dif_coor_x <= -8'd4;
        // blk4x4_dif_coor_y <= -8'd4;
        blk4x4_dif_coor_x <= -8'd4;
        blk4x4_dif_coor_y <= -8'd4;
    end
    else
    begin
    
        if(en & export_data_init)
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
        end
        else
        begin
            blk4x4_dif_coor_x <=  blk4x4_dif_coor_x ;
            blk4x4_dif_coor_y <=  blk4x4_dif_coor_y ;
        end
    end
end
//
always_comb
begin
    if(large_mv_grad_4)
    begin
         weightHor_4 = Ipu_w >> 1;
         weightVer_4 = Ipu_h >> 1;
    end
    else
    begin
         weightHor_4 = (sbW >> 1) + blk4x4_dif_coor_x;
         weightVer_4 = (sbH >> 1) + blk4x4_dif_coor_y;
    end
end
//tinh toan scale vecto du doan
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      mv4_4param_x <= 0;     
      mv4_4param_y <= 0;
    end
    else
    begin
      mv4_4param_x <= baseHor + dmHorX * weightHor_4 + dmVerX_4 * weightVer_4;     
      mv4_4param_y <= baseVer + dmHorY * weightHor_4 + dmVerY_4 * weightVer_4;
    end
end

always_comb
begin
    //lam tron den 1/16 luma
    mv4_4para_x = (mv4_4param_x + offset_calc_mv + (~mv4_4param_x >> 31)) >> 7;
    mv4_4para_y = (mv4_4param_y + offset_calc_mv + (~mv4_4param_y >> 31)) >> 7;
end
always_ff @(posedge clk or negedge rst_n) begin : proc_
  if(~rst_n) begin
    vect_4para_Int_x <= 0;
    vect_4para_Frac_x <= 0;
    vect_4para_Int_y <= 0;
    vect_4para_Frac_y <= 0;
  end else begin
    if (export_data_init) begin
      //tinh toan phan nguyen va phan thap phan cho vecto du doan
      vect_4para_Int_x <= mv4_4para_x >> MV_FRAC_BITS_LUMA;
      vect_4para_Frac_x <= mv4_4para_x & MV_FRAC_MASK_LUMA;
      vect_4para_Int_y <= mv4_4para_y >> MV_FRAC_BITS_LUMA;
      vect_4para_Frac_y <= mv4_4para_y & MV_FRAC_MASK_LUMA;
    end
    else begin
      vect_4para_Int_x <= vect_4para_Int_x;
      vect_4para_Frac_x <= vect_4para_Frac_x;
      vect_4para_Int_y <= vect_4para_Int_y;
      vect_4para_Frac_y <= vect_4para_Frac_y;
    end
  end
end



//tinh toan su khac biet toa do dai giýa vecto chuyen dong cua khoi du doan 4x4 hien tai voi vecto chuyen dong cua tung diem anh 
//nam trong khoi du doan 4x4 do
always_ff @(posedge clk)
begin
    dMv_Scale_4_x0 <= dmHorX * w_4_x0 + dmVerX_4 * h_4_y0;
    dMv_Scale_4_y0 <= dmHorY * w_4_x0 + dmVerY_4 * h_4_y0;
    dMv_Scale_4_x1 <= dmHorX * w_4_x1 + dmVerX_4 * h_4_y1;
    dMv_Scale_4_y1 <= dmHorY * w_4_x1 + dmVerY_4 * h_4_y1;
    dMv_Scale_4_x2 <= dmHorX * w_4_x2 + dmVerX_4 * h_4_y2;
    dMv_Scale_4_y2 <= dmHorY * w_4_x2 + dmVerY_4 * h_4_y2;
    dMv_Scale_4_x3 <= dmHorX * w_4_x3 + dmVerX_4 * h_4_y3;
    dMv_Scale_4_y3 <= dmHorY * w_4_x3 + dmVerY_4 * h_4_y3;
    dMv_Scale_4_x4 <= dmHorX * w_4_x4 + dmVerX_4 * h_4_y4;
    dMv_Scale_4_y4 <= dmHorY * w_4_x4 + dmVerY_4 * h_4_y4;
    dMv_Scale_4_x5 <= dmHorX * w_4_x5 + dmVerX_4 * h_4_y5;
    dMv_Scale_4_y5 <= dmHorY * w_4_x5 + dmVerY_4 * h_4_y5;
    dMv_Scale_4_x6 <= dmHorX * w_4_x6 + dmVerX_4 * h_4_y6;
    dMv_Scale_4_y6 <= dmHorY * w_4_x6 + dmVerY_4 * h_4_y6;
    dMv_Scale_4_x7 <= dmHorX * w_4_x7 + dmVerX_4 * h_4_y7;
    dMv_Scale_4_y7 <= dmHorY * w_4_x7 + dmVerY_4 * h_4_y7;
    dMv_Scale_4_x8 <= dmHorX * w_4_x8 + dmVerX_4 * h_4_y8;
    dMv_Scale_4_y8 <= dmHorY * w_4_x8 + dmVerY_4 * h_4_y8;
    dMv_Scale_4_x9 <= dmHorX * w_4_x9 + dmVerX_4 * h_4_y9;
    dMv_Scale_4_y9 <= dmHorY * w_4_x9 + dmVerY_4 * h_4_y9;
    dMv_Scale_4_x10 <= dmHorX * w_4_x10 + dmVerX_4 * h_4_y10;
    dMv_Scale_4_y10 <= dmHorY * w_4_x10 + dmVerY_4 * h_4_y10;
    dMv_Scale_4_x11 <= dmHorX * w_4_x11 + dmVerX_4 * h_4_y11;
    dMv_Scale_4_y11 <= dmHorY * w_4_x11 + dmVerY_4 * h_4_y11;
    dMv_Scale_4_x12 <= dmHorX * w_4_x12 + dmVerX_4 * h_4_y12;
    dMv_Scale_4_y12 <= dmHorY * w_4_x12 + dmVerY_4 * h_4_y12;
    dMv_Scale_4_x13 <= dmHorX * w_4_x13 + dmVerX_4 * h_4_y13;
    dMv_Scale_4_y13 <= dmHorY * w_4_x13 + dmVerY_4 * h_4_y13;
    dMv_Scale_4_x14 <= dmHorX * w_4_x14 + dmVerX_4 * h_4_y14;
    dMv_Scale_4_y14 <= dmHorY * w_4_x14 + dmVerY_4 * h_4_y14;
    dMv_Scale_4_x15 <= dmHorX * w_4_x15 + dmVerX_4 * h_4_y15;
    dMv_Scale_4_y15 <= dmHorY * w_4_x15 + dmVerY_4 * h_4_y15;
end
always_ff @(posedge clk or negedge rst_n)
if(~rst_n) begin
  dMv_Scale_Prec_4_x0 <= 0;
  dMv_Scale_Prec_4_y0 <= 0;
  dMv_Scale_Prec_4_x1 <= 0;
  dMv_Scale_Prec_4_y1 <= 0;
  dMv_Scale_Prec_4_x2 <= 0;
  dMv_Scale_Prec_4_y2 <= 0;
  dMv_Scale_Prec_4_x3 <= 0;
  dMv_Scale_Prec_4_y3 <= 0;
  dMv_Scale_Prec_4_x4 <= 0;
  dMv_Scale_Prec_4_y4 <= 0;
  dMv_Scale_Prec_4_x5 <= 0;
  dMv_Scale_Prec_4_y5 <= 0;
  dMv_Scale_Prec_4_x6 <= 0;
  dMv_Scale_Prec_4_y6 <= 0;
  dMv_Scale_Prec_4_x7 <= 0;
  dMv_Scale_Prec_4_y7 <= 0;
  dMv_Scale_Prec_4_x8 <= 0;
  dMv_Scale_Prec_4_y8 <= 0;
  dMv_Scale_Prec_4_x9 <= 0;
  dMv_Scale_Prec_4_y9 <= 0;
  dMv_Scale_Prec_4_x10 <= 0;
  dMv_Scale_Prec_4_y10 <= 0;
  dMv_Scale_Prec_4_x11 <= 0;
  dMv_Scale_Prec_4_y11 <= 0;
  dMv_Scale_Prec_4_x12 <= 0;
  dMv_Scale_Prec_4_y12 <= 0;
  dMv_Scale_Prec_4_x13 <= 0;
  dMv_Scale_Prec_4_y13 <= 0;
  dMv_Scale_Prec_4_x14 <= 0;
  dMv_Scale_Prec_4_y14 <= 0;
  dMv_Scale_Prec_4_x15 <= 0;
  dMv_Scale_Prec_4_y15 <= 0;
end
else begin
  if(export_data_init) begin
    dMv_Scale_Prec_4_x0 <= (dMv_Scale_4_x0 + offset_calc_mv + (~dMv_Scale_4_x0 >> 31)) >> 7;
    dMv_Scale_Prec_4_y0 <= (dMv_Scale_4_y0 + offset_calc_mv + (~dMv_Scale_4_y0 >> 31)) >> 7;
    dMv_Scale_Prec_4_x1 <= (dMv_Scale_4_x1 + offset_calc_mv + (~dMv_Scale_4_x1 >> 31)) >> 7;
    dMv_Scale_Prec_4_y1 <= (dMv_Scale_4_y1 + offset_calc_mv + (~dMv_Scale_4_y1 >> 31)) >> 7;
    dMv_Scale_Prec_4_x2 <= (dMv_Scale_4_x2 + offset_calc_mv + (~dMv_Scale_4_x2 >> 31)) >> 7;
    dMv_Scale_Prec_4_y2 <= (dMv_Scale_4_y2 + offset_calc_mv + (~dMv_Scale_4_y2 >> 31)) >> 7;
    dMv_Scale_Prec_4_x3 <= (dMv_Scale_4_x3 + offset_calc_mv + (~dMv_Scale_4_x3 >> 31)) >> 7;
    dMv_Scale_Prec_4_y3 <= (dMv_Scale_4_y3 + offset_calc_mv + (~dMv_Scale_4_y3 >> 31)) >> 7;
    dMv_Scale_Prec_4_x4 <= (dMv_Scale_4_x4 + offset_calc_mv + (~dMv_Scale_4_x4 >> 31)) >> 7;
    dMv_Scale_Prec_4_y4 <= (dMv_Scale_4_y4 + offset_calc_mv + (~dMv_Scale_4_y4 >> 31)) >> 7;
    dMv_Scale_Prec_4_x5 <= (dMv_Scale_4_x5 + offset_calc_mv + (~dMv_Scale_4_x5 >> 31)) >> 7;
    dMv_Scale_Prec_4_y5 <= (dMv_Scale_4_y5 + offset_calc_mv + (~dMv_Scale_4_y5 >> 31)) >> 7;
    dMv_Scale_Prec_4_x6 <= (dMv_Scale_4_x6 + offset_calc_mv + (~dMv_Scale_4_x6 >> 31)) >> 7;
    dMv_Scale_Prec_4_y6 <= (dMv_Scale_4_y6 + offset_calc_mv + (~dMv_Scale_4_y6 >> 31)) >> 7;
    dMv_Scale_Prec_4_x7 <= (dMv_Scale_4_x7 + offset_calc_mv + (~dMv_Scale_4_x7 >> 31)) >> 7;
    dMv_Scale_Prec_4_y7 <= (dMv_Scale_4_y7 + offset_calc_mv + (~dMv_Scale_4_y7 >> 31)) >> 7;
    dMv_Scale_Prec_4_x8 <= (dMv_Scale_4_x8 + offset_calc_mv + (~dMv_Scale_4_x8 >> 31)) >> 7;
    dMv_Scale_Prec_4_y8 <= (dMv_Scale_4_y8 + offset_calc_mv + (~dMv_Scale_4_y8 >> 31)) >> 7;
    dMv_Scale_Prec_4_x9 <= (dMv_Scale_4_x9 + offset_calc_mv + (~dMv_Scale_4_x9 >> 31)) >> 7;
    dMv_Scale_Prec_4_y9 <= (dMv_Scale_4_y9 + offset_calc_mv + (~dMv_Scale_4_y9 >> 31)) >> 7;
    dMv_Scale_Prec_4_x10 <= (dMv_Scale_4_x10 + offset_calc_mv + (~dMv_Scale_4_x10 >> 31)) >> 7;
    dMv_Scale_Prec_4_y10 <= (dMv_Scale_4_y10 + offset_calc_mv + (~dMv_Scale_4_y10 >> 31)) >> 7;
    dMv_Scale_Prec_4_x11 <= (dMv_Scale_4_x11 + offset_calc_mv + (~dMv_Scale_4_x11 >> 31)) >> 7;
    dMv_Scale_Prec_4_y11 <= (dMv_Scale_4_y11 + offset_calc_mv + (~dMv_Scale_4_y11 >> 31)) >> 7;
    dMv_Scale_Prec_4_x12 <= (dMv_Scale_4_x12 + offset_calc_mv + (~dMv_Scale_4_x12 >> 31)) >> 7;
    dMv_Scale_Prec_4_y12 <= (dMv_Scale_4_y12 + offset_calc_mv + (~dMv_Scale_4_y12 >> 31)) >> 7;
    dMv_Scale_Prec_4_x13 <= (dMv_Scale_4_x13 + offset_calc_mv + (~dMv_Scale_4_x13 >> 31)) >> 7;
    dMv_Scale_Prec_4_y13 <= (dMv_Scale_4_y13 + offset_calc_mv + (~dMv_Scale_4_y13 >> 31)) >> 7;
    dMv_Scale_Prec_4_x14 <= (dMv_Scale_4_x14 + offset_calc_mv + (~dMv_Scale_4_x14 >> 31)) >> 7;
    dMv_Scale_Prec_4_y14 <= (dMv_Scale_4_y14 + offset_calc_mv + (~dMv_Scale_4_y14 >> 31)) >> 7;
    dMv_Scale_Prec_4_x15 <= (dMv_Scale_4_x15 + offset_calc_mv + (~dMv_Scale_4_x15 >> 31)) >> 7;
    dMv_Scale_Prec_4_y15 <= (dMv_Scale_4_y15 + offset_calc_mv + (~dMv_Scale_4_y15 >> 31)) >> 7;
  end else begin
    dMv_Scale_Prec_4_x0 <= dMv_Scale_Prec_4_x0;
    dMv_Scale_Prec_4_y0 <= dMv_Scale_Prec_4_y0;
    dMv_Scale_Prec_4_x1 <= dMv_Scale_Prec_4_x1;
    dMv_Scale_Prec_4_y1 <= dMv_Scale_Prec_4_y1;
    dMv_Scale_Prec_4_x2 <= dMv_Scale_Prec_4_x2;
    dMv_Scale_Prec_4_y2 <= dMv_Scale_Prec_4_y2;
    dMv_Scale_Prec_4_x3 <= dMv_Scale_Prec_4_x3;
    dMv_Scale_Prec_4_y3 <= dMv_Scale_Prec_4_y3;
    dMv_Scale_Prec_4_x4 <= dMv_Scale_Prec_4_x4;
    dMv_Scale_Prec_4_y4 <= dMv_Scale_Prec_4_y4;
    dMv_Scale_Prec_4_x5 <= dMv_Scale_Prec_4_x5;
    dMv_Scale_Prec_4_y5 <= dMv_Scale_Prec_4_y5;
    dMv_Scale_Prec_4_x6 <= dMv_Scale_Prec_4_x6;
    dMv_Scale_Prec_4_y6 <= dMv_Scale_Prec_4_y6;
    dMv_Scale_Prec_4_x7 <= dMv_Scale_Prec_4_x7;
    dMv_Scale_Prec_4_y7 <= dMv_Scale_Prec_4_y7;
    dMv_Scale_Prec_4_x8 <= dMv_Scale_Prec_4_x8;
    dMv_Scale_Prec_4_y8 <= dMv_Scale_Prec_4_y8;
    dMv_Scale_Prec_4_x9 <= dMv_Scale_Prec_4_x9;
    dMv_Scale_Prec_4_y9 <= dMv_Scale_Prec_4_y9;
    dMv_Scale_Prec_4_x10 <= dMv_Scale_Prec_4_x10; 
    dMv_Scale_Prec_4_y10 <= dMv_Scale_Prec_4_y10;
    dMv_Scale_Prec_4_x11 <= dMv_Scale_Prec_4_x11;
    dMv_Scale_Prec_4_y11 <= dMv_Scale_Prec_4_y11;
    dMv_Scale_Prec_4_x12 <= dMv_Scale_Prec_4_x12;
    dMv_Scale_Prec_4_y12 <= dMv_Scale_Prec_4_y12;
    dMv_Scale_Prec_4_x13 <= dMv_Scale_Prec_4_x13;
    dMv_Scale_Prec_4_y13 <= dMv_Scale_Prec_4_y13;
    dMv_Scale_Prec_4_x14 <= dMv_Scale_Prec_4_x14;
    dMv_Scale_Prec_4_y14 <= dMv_Scale_Prec_4_y14;
    dMv_Scale_Prec_4_x15 <= dMv_Scale_Prec_4_x15;
    dMv_Scale_Prec_4_y15 <= dMv_Scale_Prec_4_y15;
  end
end


endmodule
