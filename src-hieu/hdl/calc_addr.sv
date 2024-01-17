module calc_addr (
  input clk,
  input en,
  input rst_n,
  input export_data_cal,

    //toa ðo cua khoi du ðoán
  input [11:0] Ipu_x,
  input [11:0] Ipu_y,
    //ðo chênh lech toa ðo giua block du ðoán 4x4 voi khoi du ðoán hien tai 
  input signed [7:0] blk4x4_dif_coor_x,
  input signed [7:0] blk4x4_dif_coor_y,
    //phan nguyên theo chieu ngang, chieu cao cua vector du ðoán cho khoi du ðoán 4x4 ðiem anh cua khoi du ðoán hien tai
  input signed [12:0] vect_4para_Int_x,
  input signed [12:0] vect_4para_Int_y,
    //du lieu ve ðia chi ðiem anh ðau tiên cua reference block 4x4
  output logic [12:0] addr_4,
    //du lieu ve vi trí ðiem anh ðau tiên cua reference block 4x4 
  output logic [3:0] pos_4,
    //ðia chi các ðiem anh nam o hàng thu 1,2,3,4 cua khoi du ðoán 4x4
  output logic [12:0] cur_addr0,
  output logic [12:0] cur_addr1,
  output logic [12:0] cur_addr2,
  output logic [12:0] cur_addr3,


  //fw_data
  input enab_prof_in,
  output logic enab_prof_out,

  input signed [10:0] dMv_Scale_Prec_4_x0_in,
  input signed [10:0] dMv_Scale_Prec_4_y0_in,
  input signed [10:0] dMv_Scale_Prec_4_x1_in,
  input signed [10:0] dMv_Scale_Prec_4_y1_in,
  input signed [10:0] dMv_Scale_Prec_4_x2_in,
  input signed [10:0] dMv_Scale_Prec_4_y2_in,
  input signed [10:0] dMv_Scale_Prec_4_x3_in,
  input signed [10:0] dMv_Scale_Prec_4_y3_in,
  input signed [10:0] dMv_Scale_Prec_4_x4_in,
  input signed [10:0] dMv_Scale_Prec_4_y4_in,
  input signed [10:0] dMv_Scale_Prec_4_x5_in,
  input signed [10:0] dMv_Scale_Prec_4_y5_in,
  input signed [10:0] dMv_Scale_Prec_4_x6_in,
  input signed [10:0] dMv_Scale_Prec_4_y6_in,
  input signed [10:0] dMv_Scale_Prec_4_x7_in,
  input signed [10:0] dMv_Scale_Prec_4_y7_in,
  input signed [10:0] dMv_Scale_Prec_4_x8_in,
  input signed [10:0] dMv_Scale_Prec_4_y8_in,
  input signed [10:0] dMv_Scale_Prec_4_x9_in,
  input signed [10:0] dMv_Scale_Prec_4_y9_in,
  input signed [10:0] dMv_Scale_Prec_4_x10_in,
  input signed [10:0] dMv_Scale_Prec_4_y10_in,
  input signed [10:0] dMv_Scale_Prec_4_x11_in,
  input signed [10:0] dMv_Scale_Prec_4_y11_in,
  input signed [10:0] dMv_Scale_Prec_4_x12_in,
  input signed [10:0] dMv_Scale_Prec_4_y12_in,
  input signed [10:0] dMv_Scale_Prec_4_x13_in,
  input signed [10:0] dMv_Scale_Prec_4_y13_in,
  input signed [10:0] dMv_Scale_Prec_4_x14_in,
  input signed [10:0] dMv_Scale_Prec_4_y14_in,
  input signed [10:0] dMv_Scale_Prec_4_x15_in,
  input signed [10:0] dMv_Scale_Prec_4_y15_in,

  output logic signed [10:0] dMv_Scale_Prec_4_x0_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y0_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x1_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y1_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x2_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y2_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x3_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y3_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x4_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y4_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x5_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y5_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x6_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y6_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x7_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y7_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x8_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y8_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x9_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y9_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x10_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y10_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x11_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y11_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x12_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y12_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x13_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y13_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x14_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y14_out,
  output logic signed [10:0] dMv_Scale_Prec_4_x15_out,
  output logic signed [10:0] dMv_Scale_Prec_4_y15_out,

  input [4:0] vect_4para_Frac_x_in,
  input [4:0] vect_4para_Frac_y_in,

  output logic [4:0] vect_4para_Frac_x_out,
  output logic [4:0] vect_4para_Frac_y_out
);
//fw data

always_ff @(posedge clk) begin
if (export_data_cal) begin
  dMv_Scale_Prec_4_x0_out<= dMv_Scale_Prec_4_x0_in;
  dMv_Scale_Prec_4_y0_out<= dMv_Scale_Prec_4_y0_in;
  dMv_Scale_Prec_4_x1_out<= dMv_Scale_Prec_4_x1_in;
  dMv_Scale_Prec_4_y1_out<= dMv_Scale_Prec_4_y1_in;
  dMv_Scale_Prec_4_x2_out<= dMv_Scale_Prec_4_x2_in;
  dMv_Scale_Prec_4_y2_out<= dMv_Scale_Prec_4_y2_in;
  dMv_Scale_Prec_4_x3_out<= dMv_Scale_Prec_4_x3_in;
  dMv_Scale_Prec_4_y3_out<= dMv_Scale_Prec_4_y3_in;
  dMv_Scale_Prec_4_x4_out<= dMv_Scale_Prec_4_x4_in;
  dMv_Scale_Prec_4_y4_out<= dMv_Scale_Prec_4_y4_in;
  dMv_Scale_Prec_4_x5_out<= dMv_Scale_Prec_4_x5_in;
  dMv_Scale_Prec_4_y5_out<= dMv_Scale_Prec_4_y5_in;
  dMv_Scale_Prec_4_x6_out<= dMv_Scale_Prec_4_x6_in;
  dMv_Scale_Prec_4_y6_out<= dMv_Scale_Prec_4_y6_in;
  dMv_Scale_Prec_4_x7_out<= dMv_Scale_Prec_4_x7_in;
  dMv_Scale_Prec_4_y7_out<= dMv_Scale_Prec_4_y7_in;
  dMv_Scale_Prec_4_x8_out<= dMv_Scale_Prec_4_x8_in;
  dMv_Scale_Prec_4_y8_out<= dMv_Scale_Prec_4_y8_in;
  dMv_Scale_Prec_4_x9_out<= dMv_Scale_Prec_4_x9_in;
  dMv_Scale_Prec_4_y9_out<= dMv_Scale_Prec_4_y9_in;
  dMv_Scale_Prec_4_x10_out <= dMv_Scale_Prec_4_x10_in; 
  dMv_Scale_Prec_4_y10_out <= dMv_Scale_Prec_4_y10_in;
  dMv_Scale_Prec_4_x11_out <= dMv_Scale_Prec_4_x11_in;
  dMv_Scale_Prec_4_y11_out <= dMv_Scale_Prec_4_y11_in;
  dMv_Scale_Prec_4_x12_out <= dMv_Scale_Prec_4_x12_in;
  dMv_Scale_Prec_4_y12_out <= dMv_Scale_Prec_4_y12_in;
  dMv_Scale_Prec_4_x13_out <= dMv_Scale_Prec_4_x13_in;
  dMv_Scale_Prec_4_y13_out <= dMv_Scale_Prec_4_y13_in;
  dMv_Scale_Prec_4_x14_out <= dMv_Scale_Prec_4_x14_in;
  dMv_Scale_Prec_4_y14_out <= dMv_Scale_Prec_4_y14_in;
  dMv_Scale_Prec_4_x15_out <= dMv_Scale_Prec_4_x15_in;
  dMv_Scale_Prec_4_y15_out <= dMv_Scale_Prec_4_y15_in;

  vect_4para_Frac_x_out <= vect_4para_Frac_x_in;
  vect_4para_Frac_y_out <= vect_4para_Frac_y_in;

  enab_prof_out <= enab_prof_in;
end
end

logic signed [12:0] ref4_x;
logic signed [12:0] ref4_y;
//toa ðo vùng anh search
logic signed [12:0] search_x;
logic signed [12:0] search_y;


logic [12:0] c_addr_4;
integer i;
integer j;


//ref
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    ref4_x <= 0;
    ref4_y <= 0;
    search_x <= 0;
    search_y <= 0;
  end
  else begin
    if (en) begin
      ref4_x <= blk4x4_dif_coor_x + Ipu_x + vect_4para_Int_x;
      ref4_y <= blk4x4_dif_coor_y + Ipu_y + vect_4para_Int_y;
      search_x <= Ipu_x - 64;
      search_y <= Ipu_y - 64;
    end
    else begin
      ref4_x <= ref4_x;
      ref4_y <= ref4_y;
      search_x <= search_x;
      search_y <= search_y;
    end
  end 
end

//??????
always_ff @(posedge clk)
begin
    for(i = 0; i < 256; i++)
    begin
        if(ref4_y == search_y + i)
        begin
              c_addr_4 <= i << 4'd4;
        end 
    end
end


always_ff @(posedge clk)
begin
  if(export_data_cal) begin
    for(j = 0; j < 16; j++)
    begin
        if(ref4_x - (search_x + (j << 4)) >= 0 &&  ref4_x - (search_x + ((j + 1) << 4) - 1))
        begin
            addr_4 <= c_addr_4 + j;
        end
    end 
    pos_4 <= 5'd15 - (ref4_x & 5'd15);
  end
  else begin
    addr_4 <= addr_4;
    pos_4 <= pos_4;
  end
end

// cur
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    cur_addr0 <= 0; 
    cur_addr1 <= 0;
    cur_addr2 <= 0;
    cur_addr3 <= 0; 
  end
  else begin
    if (en & export_data_cal) begin
      cur_addr0 <=  (128 >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2);
      cur_addr1 <= (128 >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (128 >> 2);
      cur_addr2 <= (128 >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (128 >> 2) * 2;
      cur_addr3 <= (128 >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (128 >> 2) * 3;
    end
    else begin
      cur_addr0 <= cur_addr0;
      cur_addr1 <= cur_addr1;
      cur_addr2 <= cur_addr2;
      cur_addr3 <= cur_addr3;
    end
  end
end
endmodule : calc_addr