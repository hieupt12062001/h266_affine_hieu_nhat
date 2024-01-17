`timescale 1ns / 1ps
module pdof(
    input clk,
    input rst_n,
    input enab_prof,
    input en,
    input export_data_pdof,
    input [95:0] final_dst [0:5],
    input signed [10:0] dMv_Scale_Prec_4_x0,
    input signed [10:0] dMv_Scale_Prec_4_y0,
    input signed [10:0] dMv_Scale_Prec_4_x1,
    input signed [10:0] dMv_Scale_Prec_4_y1,
    input signed [10:0] dMv_Scale_Prec_4_x2,
    input signed [10:0] dMv_Scale_Prec_4_y2,
    input signed [10:0] dMv_Scale_Prec_4_x3,
    input signed [10:0] dMv_Scale_Prec_4_y3,
    input signed [10:0] dMv_Scale_Prec_4_x4,
    input signed [10:0] dMv_Scale_Prec_4_y4,
    input signed [10:0] dMv_Scale_Prec_4_x5,
    input signed [10:0] dMv_Scale_Prec_4_y5,
    input signed [10:0] dMv_Scale_Prec_4_x6,
    input signed [10:0] dMv_Scale_Prec_4_y6,
    input signed [10:0] dMv_Scale_Prec_4_x7,
    input signed [10:0] dMv_Scale_Prec_4_y7,
    input signed [10:0] dMv_Scale_Prec_4_x8,
    input signed [10:0] dMv_Scale_Prec_4_y8,
    input signed [10:0] dMv_Scale_Prec_4_x9,
    input signed [10:0] dMv_Scale_Prec_4_y9,
    input signed [10:0] dMv_Scale_Prec_4_x10,
    input signed [10:0] dMv_Scale_Prec_4_y10,
    input signed [10:0] dMv_Scale_Prec_4_x11,
    input signed [10:0] dMv_Scale_Prec_4_y11,
    input signed [10:0] dMv_Scale_Prec_4_x12,
    input signed [10:0] dMv_Scale_Prec_4_y12,
    input signed [10:0] dMv_Scale_Prec_4_x13,
    input signed [10:0] dMv_Scale_Prec_4_y13,
    input signed [10:0] dMv_Scale_Prec_4_x14,
    input signed [10:0] dMv_Scale_Prec_4_y14,
    input signed [10:0] dMv_Scale_Prec_4_x15,
    input signed [10:0] dMv_Scale_Prec_4_y15,
    //du lieu cua cac dong pixel cua khoi tham chieu 4x4 gan dung nhat so voi khoi du doan
    output logic [31:0] ref_data0,
    output logic [31:0] ref_data1,
    output logic [31:0] ref_data2,
    output logic [31:0] ref_data3
    //thong bao module cur_data bat dau nap du lieu cua khoi du doan moi vao bo nho
    //va dua ra du lieu cua khoi 4x4 dang du doan
    );

localparam ref_stride = 5'd4;
localparam shift1 = 0;
localparam nOffset1 = -21'd8192;
//logic [12:0] i;
//logic [12:0] j;
//logic [12:0] k;
//logic [12:0] m;
logic [12:0] n;
//logic [12:0] q;

logic signed [20:0] gradX [0:15];
logic signed [20:0] gradY [0:15];
logic signed [15:0] gX0 [0:15];
logic signed [15:0] gY0 [0:15];
logic signed [15:0] gX1 [0:15];
logic signed [15:0] gY1 [0:15];
logic signed [9:0] agX0 [0:15];
logic signed [9:0] agY0 [0:15];
logic signed [9:0] agX1 [0:15];
logic signed [9:0] agY1 [0:15];




logic [14:0] offset_prof;
logic [12:0] a;
logic [12:0] b;
//logic [12:0] s;

logic signed [20:0] dI_0;
logic signed [20:0] dI_1;
logic signed [20:0] dI_2;
logic signed [20:0] dI_3;
logic signed [20:0] dI_4;
logic signed [20:0] dI_5;
logic signed [20:0] dI_6;
logic signed [20:0] dI_7;
logic signed [20:0] dI_8;
logic signed [20:0] dI_9;
logic signed [20:0] dI_10;
logic signed [20:0] dI_11;
logic signed [20:0] dI_12;
logic signed [20:0] dI_13;
logic signed [20:0] dI_14;
logic signed [20:0] dI_15;

logic [7:0] data0;
logic [7:0] data1;
logic [7:0] data2;
logic [7:0] data3;
logic [7:0] data4;
logic [7:0] data5;
logic [7:0] data6;
logic [7:0] data7;
logic [7:0] data8;
logic [7:0] data9;
logic [7:0] data10;
logic [7:0] data11;
logic [7:0] data12;
logic [7:0] data13;
logic [7:0] data14;
logic [7:0] data15;

logic [95:0] final_dst1 [0:5];
localparam [3:0]shift_prof = 3'd6;

//cac diem anh cua khoi 6x6
always_ff @(posedge clk)
begin
  if(en) begin
    for (a = 0; a < 4; a++)
    begin
      gY0[a] <= final_dst[a + 2][(4<<4)+15 -: 16];
      gY0[a + 4] <= final_dst[a + 2][(3<<4)+15 -: 16];
      gY0[a + 8] <= final_dst[a + 2][(2<<4)+15 -: 16];
      gY0[a + 12] <= final_dst[a + 2][(1<<4)+15 -: 16];
      gY1[a] <= final_dst[a][(4<<4)+15 -: 16];
      gY1[a + 4] <= final_dst[a][(3<<4)+15 -: 16];
      gY1[a + 8] <= final_dst[a][(2<<4)+15 -: 16];
      gY1[a + 12] <= final_dst[a][(1<<4)+15 -: 16];
      gX0[a] <= final_dst[1][((3-a)<<4)+15 -: 16];
      gX0[a + 4] <= final_dst[2][((3-a)<<4)+15 -: 16];
      gX0[a + 8] <= final_dst[3][((3-a)<<4)+15 -: 16];
      gX0[a + 12] <= final_dst[4][((3-a)<<4)+15 -: 16];
      gX1[a] <= final_dst[1][((5-a)<<4)+15 -: 16];
      gX1[a + 4] <= final_dst[2][((5-a)<<4)+15 -: 16];
      gX1[a + 8] <= final_dst[3][((5-a)<<4)+15 -: 16];
      gX1[a + 12] <= final_dst[4][((5-a)<<4)+15 -: 16];
    end
  end
  else begin
    gY0 <= '{default : 0};
    gY1 <= '{default : 0};
    gX0 <= '{default : 0};
    gX1 <= '{default : 0};
  end
end

always_comb
begin
    for(b = 0; b < 16; b++)
    begin
        agX0[b] = gX0[b] >> shift_prof;
        agY0[b] = gY0[b] >> shift_prof;
        agX1[b] = gX1[b] >> shift_prof;
        agY1[b] = gY1[b] >> shift_prof;
    end
end
//tinh toan cac gradient khong gian
always_comb 
begin
        for (n = 0; n < 16; n++)
        begin
            gradY[n] = agY0[n] - agY1[n];
            gradX[n] = agX0[n] - agX1[n];
        end
end

always_comb
begin
        //phan bu cho hoat dong tinh toan chenh lech diem anh giua anh trc khi tinh chinh va sau khi tinh chinh
        offset_prof = (1 << shift_prof >> 1) + 15'd8192;
        //tinh do chenh lech giua diem anh trc va sau khi tinh chinh
        dI_0 = dMv_Scale_Prec_4_x0 * gradX[0] + dMv_Scale_Prec_4_y0 * gradY[0];
        dI_1 = dMv_Scale_Prec_4_x1 * gradX[1] + dMv_Scale_Prec_4_y1 * gradY[4];
        dI_2 = dMv_Scale_Prec_4_x2 * gradX[2] + dMv_Scale_Prec_4_y2 * gradY[8];
        dI_3 = dMv_Scale_Prec_4_x3 * gradX[3] + dMv_Scale_Prec_4_y3 * gradY[12];
        dI_4 = dMv_Scale_Prec_4_x4 * gradX[4] + dMv_Scale_Prec_4_y4 * gradY[1];
        dI_5 = dMv_Scale_Prec_4_x5 * gradX[5] + dMv_Scale_Prec_4_y5 * gradY[5];
        dI_6 = dMv_Scale_Prec_4_x6 * gradX[6] + dMv_Scale_Prec_4_y6 * gradY[9];
        dI_7 = dMv_Scale_Prec_4_x7 * gradX[7] + dMv_Scale_Prec_4_y7 * gradY[13];
        dI_8 = dMv_Scale_Prec_4_x8 * gradX[8] + dMv_Scale_Prec_4_y8 * gradY[2];
        dI_9 = dMv_Scale_Prec_4_x9 * gradX[9] + dMv_Scale_Prec_4_y9 * gradY[6];
        dI_10 = dMv_Scale_Prec_4_x10 * gradX[10] + dMv_Scale_Prec_4_y10 * gradY[10];
        dI_11 = dMv_Scale_Prec_4_x11 * gradX[11] + dMv_Scale_Prec_4_y11 * gradY[14];
        dI_12 = dMv_Scale_Prec_4_x12 * gradX[12] + dMv_Scale_Prec_4_y12 * gradY[3];
        dI_13 = dMv_Scale_Prec_4_x13 * gradX[13] + dMv_Scale_Prec_4_y13 * gradY[7];
        dI_14 = dMv_Scale_Prec_4_x14 * gradX[14] + dMv_Scale_Prec_4_y14 * gradY[11];
        dI_15 = dMv_Scale_Prec_4_x15 * gradX[15] + dMv_Scale_Prec_4_y15 * gradY[15];
        //du lieu diem anh sau khi qua tinh chinh
        data0 = (final_dst[1][79:64] + dI_0 + offset_prof) >> shift_prof;
        data1 = (final_dst[1][63:48] + dI_1 + offset_prof) >> shift_prof;
        data2 = (final_dst[1][47:32] + dI_2 + offset_prof) >> shift_prof;
        data3 = (final_dst[1][31:16] + dI_3 + offset_prof) >> shift_prof;
        data4 = (final_dst[2][79:64] + dI_4 + offset_prof) >> shift_prof;
        data5 = (final_dst[2][63:48] + dI_5 + offset_prof) >> shift_prof;
        data6 = (final_dst[2][47:32] + dI_6 + offset_prof) >> shift_prof;
        data7 = (final_dst[2][31:16] + dI_7 + offset_prof) >> shift_prof;
        data8 = (final_dst[3][79:64] + dI_8 + offset_prof) >> shift_prof;
        data9 = (final_dst[3][63:48] + dI_9 + offset_prof) >> shift_prof;
        data10 = (final_dst[3][47:32] + dI_10 + offset_prof) >> shift_prof;
        data11 = (final_dst[3][31:16] + dI_11 + offset_prof) >> shift_prof;
        data12 = (final_dst[4][79:64] + dI_12 + offset_prof) >> shift_prof;
        data13 = (final_dst[4][63:48] + dI_13 + offset_prof) >> shift_prof;
        data14 = (final_dst[4][47:32] + dI_14 + offset_prof) >> shift_prof;
        data15 = (final_dst[4][31:16] + dI_15 + offset_prof) >> shift_prof;
end

always_ff @(posedge clk or negedge rst_n) begin : proc_final_dst1
  if(~rst_n) begin
    final_dst1 <= '{default : 0};
  end else begin
    final_dst1 <= final_dst ;
  end
end

// logic [20:0] test1;
// logic [20:0] test2;
// assign test1 = final_dst1[1];

always_ff  @(posedge clk)
  if (~rst_n) begin
    ref_data0 <= 0;
    ref_data1 <= 0;
    ref_data2 <= 0;
    ref_data3 <= 0;
    // test2 <= 76;
  end
  else
  begin
    if (export_data_pdof) begin
      if(enab_prof)
      begin
          ref_data0 <= {data0, data1, data2, data3};
          ref_data1 <= {data4, data5, data6, data7};
          ref_data2 <= {data8, data9, data10, data11};
          ref_data3 <= {data12, data13, data14, data15};
          // test2 <= 77;
      end
      else
      begin
          // test2 <= 78;
          ref_data0 <= {final_dst1[1][71:64], final_dst1[1][55:48], final_dst1[1][39:32], final_dst1[1][23:16]};
          ref_data1 <= {final_dst1[2][71:64], final_dst1[2][55:48], final_dst1[2][39:32], final_dst1[2][23:16]};
          ref_data2 <= {final_dst1[3][71:64], final_dst1[3][55:48], final_dst1[3][39:32], final_dst1[3][23:16]};
          ref_data3 <= {final_dst1[4][71:64], final_dst1[4][55:48], final_dst1[4][39:32], final_dst1[4][23:16]};
      end
    end
    else begin
      ref_data0 <= ref_data0;
      ref_data1 <= ref_data1;
      ref_data2 <= ref_data2;
      ref_data3 <= ref_data3;
      // test2 <= 79;
    end
  end
endmodule

