module ref_data (
  input clk,
  input rst_n,
  //Ðia chi pixel ðau tiên cua khoi tham chieu 4x4 lýu tru trong bo nho vùng anh tham chieu
  input [12:0] ref_4para_addr,
  //Vi trí pixel ðau tiên cua khoi du ðoán 4x4 lýu tru trong bo nho vùng anh tham chieu
  input [3:0] pos_4,
  input load_ref_ram,
  input export_data_ref,
  //tín hieu bat ðau thuc hien tính toán và ghép các pixel 
  input en,

  // input [127:0] ref_line_0,
  // input [127:0] ref_line_1,
  // input [127:0] ref_line_2,
  // input [127:0] ref_line_3,
  // input [127:0] ref_line_4,
  // input [127:0] ref_line_5,
  // input [127:0] ref_line_6,
  // input [127:0] ref_line_7,
  // // input [127:0] ref_line_8,
  // // input [127:0] ref_line_9,
  // // input [127:0] ref_line_10,
  // // input [127:0] ref_line_11,
  // // input [127:0] ref_line_12,
  // // input [127:0] ref_line_13,
  // // input [127:0] ref_line_14,
  // // input [127:0] ref_line_15,
  //du lieu vung anh thaam chieu 96x64 diem anh
  output logic signed [71:0] ref_Pel_4 [0:8],// khoi 9x9 diem anh tu khoi 256x256


  //fw data
  input  [12:0] cur_addr0_in,
  input  [12:0] cur_addr1_in,
  input  [12:0] cur_addr2_in,
  input  [12:0] cur_addr3_in,

  output logic [12:0] cur_addr0_out,
  output logic [12:0] cur_addr1_out,
  output logic [12:0] cur_addr2_out,
  output logic [12:0] cur_addr3_out, 

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
  if(export_data_ref) begin
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

  cur_addr0_out <= cur_addr0_in;
  cur_addr1_out <= cur_addr1_in;
  cur_addr2_out <= cur_addr2_in;
  cur_addr3_out <= cur_addr3_in;
  end 
end

localparam ref_stride = 5'd4;
(* ram_style = "block" *)logic [127:0] ref_ram  [0:4095] ;
// logic [127:0] ref_0;
// logic [127:0] ref_1;
// logic [127:0] ref_2;
// logic [127:0] ref_3;
// logic [127:0] ref_4;
// logic [127:0] ref_5;
// logic [127:0] ref_6;
// logic [127:0] ref_7;
// logic [127:0] ref_8;

// logic [127:0] ref_01;
// logic [127:0] ref_11;
// logic [127:0] ref_21;
// logic [127:0] ref_31;
// logic [127:0] ref_41;
// logic [127:0] ref_51;
// logic [127:0] ref_61;
// logic [127:0] ref_71;
// logic [127:0] ref_81;

logic[15:0] i =0;
// logic[11:0] test1;
// logic[11:0] test3;
logic[15:0] j =0;
//logic signed  [0:8] ref_Pel_4_temp [71:0];

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    ref_ram <= '{default : 0};
    
    // ref_0 <= 0 ;
    // ref_1 <= 0 ;
    // ref_2 <= 0 ;
    // ref_3 <= 0 ;
    // ref_4 <= 0 ;
    // ref_5 <= 0 ;
    // ref_6 <= 0 ;
    // ref_7 <= 0 ;
    // ref_8 <= 0 ;
    // ref_01 <= 0 ;
    // ref_11 <= 0 ;
    // ref_21 <= 0 ;
    // ref_31 <= 0 ;
    // ref_41 <= 0 ;
    // ref_51 <= 0 ;
    // ref_61 <= 0 ;
    // ref_71 <= 0 ;
    // ref_81 <= 0 ;
  end
  else begin
    if(load_ref_ram) begin
      // if (i < 4095) begin
      //   ref_ram [i] <= ref_line_0;
      //   ref_ram [i+1] <= ref_line_1;
      //   ref_ram [i+2] <= ref_line_2;
      //   ref_ram [i+3] <= ref_line_3;
      //   // ref_ram [i+4] <= ref_line_4;
      //   // ref_ram [i+5] <= ref_line_5;
      //   // ref_ram [i+6] <= ref_line_6;
      //   // ref_ram [i+7] <= ref_line_7;
      //   // ref_ram [i+8] <= ref_line_8;
      //   // ref_ram [i+9] <= ref_line_9;
      //   // ref_ram [i+10] <= ref_line_10;
      //   // ref_ram [i+11] <= ref_line_11;
      //   // ref_ram [i+12] <= ref_line_12;
      //   // ref_ram [i+13] <= ref_line_13;
      //   // ref_ram [i+14] <= ref_line_14;
      //   // ref_ram [i+15] <= ref_line_15;
      //   i = i+4;
      // end
      $readmemh("/data6/workspace/hieupt1/H266_128/data/ref_ram.txt", ref_ram);
    end
  end
end

always_ff @(posedge clk or negedge rst_n) begin : proc_
  if(~rst_n) begin
     ref_Pel_4 <= '{default : 0};
  end 
      else begin
      if(en & export_data_ref) begin
          case(pos_4)
            15: 
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j - 2) << ref_stride) - 1][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) - 1][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((15 << 3) + 7) : (15 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 1) << 3) + 7) : ((15 - 1) << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 2) << 3) + 7) : ((15 - 2) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 3) << 3) + 7) : ((15 - 3) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 4) << 3) + 7) : ((15 - 4) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 5) << 3) + 7) : ((15 - 5) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(((15 - 6) << 3) + 7) : ((15 - 6) << 3)]};
                end
            14:
                for(j= 0; j< 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride) - 1][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((14 << 3) + 7) : (14 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((13 << 3) + 7) : (13 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((11 << 3) + 7) : (11 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((10 << 3) + 7) : (10 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((9 << 3) + 7) : (9 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((8 << 3) + 7) : (8 << 3)]};
                end
            5:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((7 << 3) + 7) : (7 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((6 << 3) + 7) : (6 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((5 << 3) + 7) : (5 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((4 << 3) + 7) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((3 << 3) + 7) : (3 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)]};
                end
            4:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((6 << 3) + 7) : (6 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((5 << 3) + 7) : (5 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((4 << 3) + 3) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((14 << 3) + 7) : (14 << 3)]};
                end
            3:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((5 << 3) + 7) : (5 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((4 << 3) + 7) : (4 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((14 << 3) + 7) : (14 << 3)],   
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((13 << 3) + 7) : (13 << 3)]};
                end
            2:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((4 << 3) + 7) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((3 << 3) + 7) : (3 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((12 << 3) + 7) : (12 << 3)]};
                end
            1:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((11 << 3) + 7) : (11 << 3)]};
                end
            0:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((11 << 3) + 7) : (11 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride) + 1][((10 << 3) + 7) : (10 << 3)]};
                end
            default:
            begin
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel_4[j] <= {ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 + 2)<<3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 + 1) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][(pos_4 << 3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 1) << 3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 2) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 3) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 4) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 5) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) << ref_stride)][((pos_4 - 6) << 3) +7 -: 8]};
                end
            end
            endcase
        end
    end
end

// always_ff @(posedge clk or negedge rst_n)
// begin
//   if(~rst_n) begin
//     ref_Pel_4 <= '{default : 0};
//   end
//   else begin
//     if (export_data_ref) begin
//       ref_Pel_4 <= ref_Pel_4_temp;
//       end
//       else begin
//         ref_Pel_4[0] <= ref_Pel_4[0];
//         ref_Pel_4[1] <= ref_Pel_4[1];
//         ref_Pel_4[2] <= ref_Pel_4[2];
//         ref_Pel_4[3] <= ref_Pel_4[3];
//         ref_Pel_4[4] <= ref_Pel_4[4];
//         ref_Pel_4[5] <= ref_Pel_4[5];
//         ref_Pel_4[6] <= ref_Pel_4[6];
//         ref_Pel_4[7] <= ref_Pel_4[7];
//         ref_Pel_4[8] <= ref_Pel_4[8];
//       end
//   end
// end
endmodule : ref_data