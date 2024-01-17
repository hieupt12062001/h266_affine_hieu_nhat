`timescale 1ns / 1ps
module filter(
  input clk,
  input rst_n,
  input enab_prof_in,
  input en,
  input export_data_filter,
  input signed [71:0] ref_Pel_4 [0:8],
  input [4:0] vect_4para_Frac_x,
  input [4:0] vect_4para_Frac_y,

  output logic [95:0] final_dst [0:5],


  //fw data
  input [12:0] cur_addr0_in,
  input [12:0] cur_addr1_in,
  input [12:0] cur_addr2_in,
  input [12:0] cur_addr3_in,

  output logic [12:0] cur_addr0_out,
  output logic [12:0] cur_addr1_out,
  output logic [12:0] cur_addr2_out,
  output logic [12:0] cur_addr3_out,

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
  output logic signed [10:0] dMv_Scale_Prec_4_y15_out
 );

//fw data
always_ff @(posedge clk) begin
  if(export_data_filter) begin
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

  enab_prof_out <= enab_prof_in;

  cur_addr0_out <= cur_addr0_in;
  cur_addr1_out <= cur_addr1_in;
  cur_addr2_out <= cur_addr2_in;
  cur_addr3_out <= cur_addr3_in;
  end 
end

localparam ref_stride = 5'd4;
localparam shift1 = 0;
localparam nOffset1 = -21'd8192;

logic [12:0] i;
//logic [12:0] j;
logic [12:0] k;
logic [12:0] m;
//logic [12:0] n;
logic [12:0] q;

(* rom_style = "block" *)logic signed [63:0] tmp_Pel_4 [0:8]; 
logic [95:0] dst [0:5];
logic signed [63:0] affineLumaFilter [0:15];

logic [3:0] shift0;


logic signed [23:0] sum0;
logic signed [23:0] sum1;
logic signed [23:0] sum2;
logic signed [23:0] sum3;

logic signed [23:0] sum01;
logic signed [23:0] sum11;
logic signed [23:0] sum21;
logic signed [23:0] sum31;
logic signed [23:0] sum41;
logic signed [23:0] sum51;
logic signed [23:0] sum61;
logic signed [23:0] sum71;
logic signed [23:0] sum81;

logic signed [15:0] buf01;
logic signed [15:0] buf11;
logic signed [15:0] buf21;
logic signed [15:0] buf31;
logic signed [15:0] buf41;
logic signed [15:0] buf51;

logic signed [15:0] buf02;
logic signed [15:0] buf12;
logic signed [15:0] buf22;
logic signed [15:0] buf32;
logic signed [15:0] buf42;
logic signed [15:0] buf52;

logic signed [15:0] buf03;
logic signed [15:0] buf13;
logic signed [15:0] buf23;
logic signed [15:0] buf33;
logic signed [15:0] buf43;
logic signed [15:0] buf53;

logic signed [15:0] buf04;
logic signed [15:0] buf14;
logic signed [15:0] buf24;
logic signed [15:0] buf34;
logic signed [15:0] buf44;
logic signed [15:0] buf54;

logic signed [7:0] abuf0;
logic signed [7:0] abuf1;
logic signed [7:0] abuf2;
logic signed [7:0] abuf3;
logic signed [7:0] abuf4;
logic signed [7:0] abuf5;


logic signed [20:0] nOffset0;
// logic [12:0] a;
// logic [12:0] b;
// logic [12:0] s;

always_comb
begin
    //duoi day la cac trong so loc noi suy
  affineLumaFilter[0] = {8'd0, 8'd0, 8'd64, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
  affineLumaFilter[1] = {8'd1, 8'd3, 8'd63, 8'd4, 8'd2, 8'd1, 8'd0, 8'd0};
  affineLumaFilter[2] = {8'd1, 8'd5, 8'd62, 8'd8, 8'd3, 8'd1, 8'd0, 8'd0};
  affineLumaFilter[3] = {8'd2, 8'd8, 8'd60, 8'd13, 8'd4, 8'd1, 8'd0, 8'd0};
  affineLumaFilter[4] = {8'd3, 8'd10, 8'd58, 8'd17, 8'd5, 8'd1, 8'd0, 8'd0 };
  affineLumaFilter[5] = {8'd3, 8'd11, 8'd52, 8'd26, 8'd8, 8'd2, 8'd0, 8'd0 };
  affineLumaFilter[6] = {8'd2, 8'd9, 8'd47, 8'd31, 8'd10, 8'd3, 8'd0, 8'd0};
  affineLumaFilter[7] = {8'd3, 8'd11, 8'd45, 8'd34, 8'd10, 8'd3, 8'd0, 8'd0 };
  affineLumaFilter[8] = {8'd3, 8'd11, 8'd40, 8'd40, 8'd11, 8'd3, 8'd0, 8'd0 };
  affineLumaFilter[9] = {8'd3, 8'd10, 8'd34, 8'd45, 8'd11, 8'd3, 8'd0, 8'd0 };
  affineLumaFilter[10] = {8'd3, 8'd10, 8'd31, 8'd47, 8'd9, 8'd2, 8'd0, 8'd0 };
  affineLumaFilter[11] = {8'd2, 8'd8, 8'd26, 8'd52, 8'd11, 8'd3, 8'd0, 8'd0 };
  affineLumaFilter[12] = {8'd1, 8'd5, 8'd17, 8'd58, 8'd10, 8'd3, 8'd0, 8'd0 };
  affineLumaFilter[13] = {8'd1, 8'd4, 8'd13, 8'd60, 8'd8, 8'd2, 8'd0, 8'd0 };
  affineLumaFilter[14] = {8'd1, 8'd3, 8'd8, 8'd62, 8'd5, 8'd1, 8'd0, 8'd0 };
  affineLumaFilter[15] = {8'd1, 8'd2, 8'd4, 8'd63, 8'd3, 8'd1, 8'd0, 8'd0 };
end


// always_comb
// begin
//   dst[0][95:80] = 0;
//   dst[0][15:0] = 0;
//   dst[5][95:80] = 0;
//   dst[5][15:0] = 0;
// end

//tính toán giá tr? d?ch bit và giá tr? ph?n bù c?a quá tr?nh l?c n?i suy
always_comb
begin
  if(vect_4para_Frac_y == 0 && vect_4para_Frac_x == 0)
  begin
    if(!enab_prof_in)
    begin
        shift0 = 0;
    end
    else
    begin
        shift0 = 4'd6;
    end
  end
  else if(vect_4para_Frac_y == 0 && vect_4para_Frac_x != 0)
  begin
    if(!enab_prof_in)
    begin
        shift0 = 4'd6;
        nOffset0 = 1 << 5;
    end
    else
    begin
        shift0 = 0;
        nOffset0 = -21'd8192;
    end
  end
  else if(vect_4para_Frac_y != 0 && vect_4para_Frac_x == 0)
  begin
    if(!enab_prof_in)
    begin
        shift0 = 4'd6;
        nOffset0 = 1 << 5;
    end
    else
    begin
        shift0 = 0;
        nOffset0 = -21'd8192;
    end
  end
  else
  begin
    if(!enab_prof_in)
    begin
        shift0 = 4'd12;
        nOffset0 = (1 << 11) + (21'd8192 << 6);
    end
    else
    begin
        shift0 = 4'd6;
        nOffset0 = 0;
    end
  end
end

//tinh toan ... phuc vu cho qua trinh l?c noi suy theo ca hang ngang va hang doc o duoi
always_comb
begin
  for(q = 0; q < 4; q++)
  begin
    sum01 = ref_Pel_4[0][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] -
             ref_Pel_4[0][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[0][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[0][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[0][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[0][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum11 = ref_Pel_4[1][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[1][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[1][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[1][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[1][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[1][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum21 = ref_Pel_4[2][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[2][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[2][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[2][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[2][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[2][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum31 = ref_Pel_4[3][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[3][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[3][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[3][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[3][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[3][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum41 = ref_Pel_4[4][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[4][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[4][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[4][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[4][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[4][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum51 = ref_Pel_4[5][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[5][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[5][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[5][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[5][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[5][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum61 = ref_Pel_4[6][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[6][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[6][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[6][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[6][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[6][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum71 = ref_Pel_4[7][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[7][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[7][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[7][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[7][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[7][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    sum81 = ref_Pel_4[8][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
             ref_Pel_4[8][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
             ref_Pel_4[8][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
             ref_Pel_4[8][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
             ref_Pel_4[8][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
             ref_Pel_4[8][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
    tmp_Pel_4[0][((3-q) << 4) +15 -: 16] = (sum01 + nOffset1) >> shift1;
    tmp_Pel_4[1][((3-q) << 4) +15 -: 16] = (sum11 + nOffset1) >> shift1;
    tmp_Pel_4[2][((3-q) << 4) +15 -: 16] = (sum21 + nOffset1) >> shift1;
    tmp_Pel_4[3][((3-q) << 4) +15 -: 16] = (sum31 + nOffset1) >> shift1;
    tmp_Pel_4[4][((3-q) << 4) +15 -: 16] = (sum41 + nOffset1) >> shift1;
    tmp_Pel_4[5][((3-q) << 4) +15 -: 16] = (sum51 + nOffset1) >> shift1;
    tmp_Pel_4[6][((3-q) << 4) +15 -: 16] = (sum61 + nOffset1) >> shift1;
    tmp_Pel_4[7][((3-q) << 4) +15 -: 16] = (sum71 + nOffset1) >> shift1;
    tmp_Pel_4[8][((3-q) << 4) +15 -: 16] = (sum81 + nOffset1) >> shift1;
  end  
end
localparam shift_prof = 3'd6;
logic xOffset_4;
logic yOffset_4; 
always_comb
begin
  xOffset_4 = vect_4para_Frac_x >> 3;
  yOffset_4 = vect_4para_Frac_y >> 3;
end
//  Th?c hi?n l?c n?i suy
always_comb
begin
        for (m = 0; m < 4; m++)
        begin
          //cac diem anh bao quanh ben tren và ben duoi c?a khoi tham chieu 4x4
          dst[0][((4-m) << 4) +15 -: 16] = (ref_Pel_4[2 + yOffset_4 - 1][((4-m - xOffset_4 + 2) << 3) + 7 -: 8] << shift_prof) - 15'd8192;
          dst[5][((4-m) << 4) +15 -: 16] = (ref_Pel_4[7 + yOffset_4 - 1][((4-m - xOffset_4 + 2) << 3) + 7 -: 8] << shift_prof) - 15'd8192;
          //cac diem anh bao quanh ben trai va ben phai cua khoi tham chieu 4x4
          dst[m+1][(5 << 4) + 15 : (5 << 4)] = (ref_Pel_4[2 + yOffset_4 + m][((6 - xOffset_4) << 3) +7 -: 8] << shift_prof) - 15'd8192;
          dst[m+1][(0 << 4) + 15 : (0 << 4)] = (ref_Pel_4[2 + yOffset_4 + m][((1 - xOffset_4) << 3) +7 -: 8] << shift_prof) - 15'd8192;
        end
        dst[0][95:80] = 0;
        dst[0][15:0] = 0;
        dst[5][95:80] = 0;
        dst[5][15:0] = 0;
        if(vect_4para_Frac_y == 0 && vect_4para_Frac_x == 0)
        begin
            if(!enab_prof_in)
            begin
                for(k = 0; k < 4; k++)
                begin
                    dst[k+1][79:16] = {ref_Pel_4[k + 2][((6 << 3) + 7) : (6 << 3)], ref_Pel_4[k + 2][((5 << 3) + 7) : (5 << 3)],
                            ref_Pel_4[k + 2][((4 << 3) + 7) : (4 << 3)], ref_Pel_4[k + 2][((3 << 3) + 7) : (3 << 3)]};
                end
            end
            else
            begin
                for(k = 0; k < 4; k++)
                begin
                    dst[k+1][79:64] = ((ref_Pel_4[k + 2][((6 << 3) + 7) : (6 << 3)] << 6) - (1 << 13));
                    dst[k+1][63:48] = ((ref_Pel_4[k + 2][((5 << 3) + 7) : (5 << 3)] << 6) - (1 << 13));
                    dst[k+1][47:32] = (ref_Pel_4[k + 2][((4 << 3) + 7) : (4 << 3)] << 6) - (1 << 13);
                    dst[k+1][31:16] = (ref_Pel_4[k + 2][((3 << 3) + 7) : (3 << 3)]  << 6) - (1 << 13);
                end
            end
        end
        else if(vect_4para_Frac_y != 0 && vect_4para_Frac_x == 0)//thuc hien loc noi suy theo hang doc
        begin
            for(k = 0; k < 4; k++)
            begin
                sum0 = ref_Pel_4[k][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[k + 1][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[k + 2][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[k + 3][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[k + 4][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[k + 5][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_4para_Frac_y][((2 << 3) + 7) : (2 << 3)];
                sum1 = ref_Pel_4[k][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[k + 1][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[k + 2][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[k + 3][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[k + 4][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[k + 5][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_4para_Frac_y][((2 << 3) + 7) : (2 << 3)];
                sum2 = ref_Pel_4[k][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[k + 1][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[k + 2][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[k + 3][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[k + 4][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[k + 5][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_4para_Frac_y][((2 << 3) + 7) : (2 << 3)];
                sum3 = ref_Pel_4[k][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[k + 1][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[k + 2][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[k + 3][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[k + 4][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[k + 5][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_4para_Frac_y][((2 << 3) + 7) : (2 << 3)];
                dst[k+1][(4<< 4) +15 -: 16] = (sum0 + nOffset0) >> shift0;
                dst[k+1][(3 << 4) +15 -: 16] = (sum1 + nOffset0) >> shift0;
                dst[k+1][(2 << 4) +15 -: 16] = (sum2 + nOffset0) >> shift0;
                dst[k+1][(1 << 4) +15 -: 16] = (sum3 + nOffset0) >> shift0;
            end
        end
        else if(vect_4para_Frac_y == 0 && vect_4para_Frac_x != 0)//thuc hien loc noi suy theo hang ngang
        begin
            for(k = 0; k < 4; k++)
            begin
                sum0 = ref_Pel_4[2][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] -
                       ref_Pel_4[2][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[2][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[2][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[2][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[2][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
                sum1 = ref_Pel_4[3][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[3][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[3][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[3][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[3][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[3][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
                sum2 = ref_Pel_4[4][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[4][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[4][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[4][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[4][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[4][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
                sum3 = ref_Pel_4[5][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel_4[5][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel_4[5][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel_4[5][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel_4[5][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel_4[5][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_4para_Frac_x][((2 << 3) + 7) : (2 << 3)];
                dst[1][((4-k) << 4) +15 -: 16] = (sum0 + nOffset0) >> shift0;
                dst[2][((4-k) << 4) +15 -: 16] = (sum1 + nOffset0) >> shift0;
                dst[3][((4-k) << 4) +15 -: 16] = (sum2 + nOffset0) >> shift0;
                dst[4][((4-k) << 4) +15 -: 16] = (sum3 + nOffset0) >> shift0;
            end
        end
        else // thuc hien loc noi suy theo ca ngang va doc
        begin
            for(k = 0; k < 4; k++)
            begin
                abuf0 = affineLumaFilter[vect_4para_Frac_y][((7 << 3) + 7) : ((7 << 3))];
                abuf1 = affineLumaFilter[vect_4para_Frac_y][((6 << 3) + 7) : ((6 << 3))];
                abuf2 = affineLumaFilter[vect_4para_Frac_y][((5 << 3) + 7) : ((5 << 3))];
                abuf3 = affineLumaFilter[vect_4para_Frac_y][((4 << 3) + 7) : ((4 << 3))];
                abuf4 = affineLumaFilter[vect_4para_Frac_y][((3 << 3) + 7) : ((3 << 3))];
                abuf5 = affineLumaFilter[vect_4para_Frac_y][((2 << 3) + 7) : ((2 << 3))];
                
                buf01 = tmp_Pel_4[k][(3 << 4) + 15 : (3 << 4)];
                buf11 = tmp_Pel_4[k + 1][(3 << 4) + 15 : (3 << 4)];
                buf21 = tmp_Pel_4[k + 2][(3 << 4) + 15 : (3 << 4)];
                buf31 = tmp_Pel_4[k + 3][(3 << 4) + 15 : (3 << 4)];
                buf41 = tmp_Pel_4[k + 4][(3 << 4) + 15 : (3 << 4)];
                buf51 = tmp_Pel_4[k + 5][(3 << 4) + 15 : (3 << 4)];
                
                buf02 = tmp_Pel_4[k][(2 << 4) + 15 : (2 << 4)];
                buf12 = tmp_Pel_4[k + 1][(2 << 4) + 15 : (2 << 4)];
                buf22 = tmp_Pel_4[k + 2][(2 << 4) + 15 : (2 << 4)];
                buf32 = tmp_Pel_4[k + 3][(2 << 4) + 15 : (2 << 4)];
                buf42 = tmp_Pel_4[k + 4][(2 << 4) + 15 : (2 << 4)];
                buf52 = tmp_Pel_4[k + 5][(2 << 4) + 15 : (2 << 4)];
                
                buf03 = tmp_Pel_4[k][(1 << 4) + 15 : (1 << 4)];
                buf13 = tmp_Pel_4[k + 1][(1 << 4) + 15 : (1 << 4)];
                buf23 = tmp_Pel_4[k + 2][(1 << 4) + 15 : (1 << 4)];
                buf33 = tmp_Pel_4[k + 3][(1 << 4) + 15 : (1 << 4)];
                buf43 = tmp_Pel_4[k + 4][(1 << 4) + 15 : (1 << 4)];
                buf53 = tmp_Pel_4[k + 5][(1 << 4) + 15 : (1 << 4)];
                
                buf04 = tmp_Pel_4[k][(0 << 4) + 15 : (0 << 4)];
                buf14 = tmp_Pel_4[k + 1][(0 << 4) + 15 : (0 << 4)];
                buf24 = tmp_Pel_4[k + 2][(0 << 4) + 15 : (0 << 4)];
                buf34 = tmp_Pel_4[k + 3][(0 << 4) + 15 : (0 << 4)];
                buf44 = tmp_Pel_4[k + 4][(0 << 4) + 15 : (0 << 4)];
                buf54 = tmp_Pel_4[k + 5][(0 << 4) + 15 : (0 << 4)];

                sum0 = buf01 * abuf0 - buf11 * abuf1 + buf21 * abuf2 + buf31 * abuf3 - buf41 * abuf4 + buf51 * abuf5;
                sum1 = buf02 * abuf0 - buf12 * abuf1 + buf22 * abuf2 + buf32 * abuf3 - buf42 * abuf4 + buf52 * abuf5;
                sum2 = buf03 * abuf0 - buf13 * abuf1 + buf23 * abuf2 + buf33 * abuf3 - buf43 * abuf4 + buf53 * abuf5;
                sum3 = buf04 * abuf0 - buf14 * abuf1 + buf24 * abuf2 + buf34 * abuf3 - buf44 * abuf4 + buf54 * abuf5;

                dst[k+1][(4<< 4) +15 -: 16] = (sum0 + nOffset0) >> shift0;
                dst[k+1][(3 << 4) +15 -: 16] = (sum1 + nOffset0) >> shift0;
                dst[k+1][(2 << 4) +15 -: 16] = (sum2 + nOffset0) >> shift0;
                dst[k+1][(1 << 4) +15 -: 16] = (sum3 + nOffset0) >> shift0;
            end
        end
end
logic [20:0] test1;
logic [20:0] test2;
logic [20:0] test11;
logic [20:0] test22;
assign test1 = dst[1];
assign test2 = dst[2];
assign test11 = final_dst[1];
assign test22 = final_dst[2];

always_ff @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		for(i = 0; i < 6; i++) begin
			final_dst[i] <= 0;
		end
	end else begin
		if(en & export_data_filter) begin
			for(i = 0; i < 6; i++) begin
				final_dst[i] <= dst[i];
			end
		end else begin
			for(i = 0; i < 6; i++) begin
				final_dst[i] <= final_dst[i];
			end
		end
	end
end
endmodule

