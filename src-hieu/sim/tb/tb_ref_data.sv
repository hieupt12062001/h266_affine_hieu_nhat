`timescale 1ns/1ps
module tb_ref_data ();
  logic clk;
  logic rst_n;
  //Ðia chi pixel ðau tiên cua khoi tham chieu 4x4 lýu tru trong bo nho vùng anh tham chieu
  logic [12:0] ref_4para_addr;
  //Vi trí pixel ðau tiên cua khoi du ðoán 4x4 lýu tru trong bo nho vùng anh tham chieu
  logic [3:0] pos_4;
  logic load_ref_ram;
  logic export_data_ref;
  //tín hieu bat ðau thuc hien tính toán và ghép các pixel 
  logic en;
  logic signed [71:0] ref_Pel_4 [0:8];

  // logic [127:0] ref_line_0;
  // logic [127:0] ref_line_1;
  // logic [127:0] ref_line_2;
  // logic [127:0] ref_line_3;
  // logic [127:0] ref_line_4;
  // logic [127:0] ref_line_5;
  // logic [127:0] ref_line_6;
  // logic [127:0] ref_line_7;
  // logic [127:0] ref_line_8,
  // logic [127:0] ref_line_9,
  // logic [127:0] ref_line_10,
  // logic [127:0] ref_line_11,
  // logic [127:0] ref_line_12,
  // logic [127:0] ref_line_13,
  // logic [127:0] ref_line_14,
  // logic [127:0] ref_line_15,

    //fw_data
  logic enab_prof_in;
  logic enab_prof_out;

  logic signed [10:0] dMv_Scale_Prec_4_x0_in;
  logic signed [10:0] dMv_Scale_Prec_4_y0_in;
  logic signed [10:0] dMv_Scale_Prec_4_x1_in;
  logic signed [10:0] dMv_Scale_Prec_4_y1_in;
  logic signed [10:0] dMv_Scale_Prec_4_x2_in;
  logic signed [10:0] dMv_Scale_Prec_4_y2_in;
  logic signed [10:0] dMv_Scale_Prec_4_x3_in;
  logic signed [10:0] dMv_Scale_Prec_4_y3_in;
  logic signed [10:0] dMv_Scale_Prec_4_x4_in;
  logic signed [10:0] dMv_Scale_Prec_4_y4_in;
  logic signed [10:0] dMv_Scale_Prec_4_x5_in;
  logic signed [10:0] dMv_Scale_Prec_4_y5_in;
  logic signed [10:0] dMv_Scale_Prec_4_x6_in;
  logic signed [10:0] dMv_Scale_Prec_4_y6_in;
  logic signed [10:0] dMv_Scale_Prec_4_x7_in;
  logic signed [10:0] dMv_Scale_Prec_4_y7_in;
  logic signed [10:0] dMv_Scale_Prec_4_x8_in;
  logic signed [10:0] dMv_Scale_Prec_4_y8_in;
  logic signed [10:0] dMv_Scale_Prec_4_x9_in;
  logic signed [10:0] dMv_Scale_Prec_4_y9_in;
  logic signed [10:0] dMv_Scale_Prec_4_x10_in;
  logic signed [10:0] dMv_Scale_Prec_4_y10_in;
  logic signed [10:0] dMv_Scale_Prec_4_x11_in;
  logic signed [10:0] dMv_Scale_Prec_4_y11_in;
  logic signed [10:0] dMv_Scale_Prec_4_x12_in;
  logic signed [10:0] dMv_Scale_Prec_4_y12_in;
  logic signed [10:0] dMv_Scale_Prec_4_x13_in;
  logic signed [10:0] dMv_Scale_Prec_4_y13_in;
  logic signed [10:0] dMv_Scale_Prec_4_x14_in;
  logic signed [10:0] dMv_Scale_Prec_4_y14_in;
  logic signed [10:0] dMv_Scale_Prec_4_x15_in;
  logic signed [10:0] dMv_Scale_Prec_4_y15_in;

  logic signed [10:0] dMv_Scale_Prec_4_x0_out;
  logic signed [10:0] dMv_Scale_Prec_4_y0_out;
  logic signed [10:0] dMv_Scale_Prec_4_x1_out;
  logic signed [10:0] dMv_Scale_Prec_4_y1_out;
  logic signed [10:0] dMv_Scale_Prec_4_x2_out;
  logic signed [10:0] dMv_Scale_Prec_4_y2_out;
  logic signed [10:0] dMv_Scale_Prec_4_x3_out;
  logic signed [10:0] dMv_Scale_Prec_4_y3_out;
  logic signed [10:0] dMv_Scale_Prec_4_x4_out;
  logic signed [10:0] dMv_Scale_Prec_4_y4_out;
  logic signed [10:0] dMv_Scale_Prec_4_x5_out;
  logic signed [10:0] dMv_Scale_Prec_4_y5_out;
  logic signed [10:0] dMv_Scale_Prec_4_x6_out;
  logic signed [10:0] dMv_Scale_Prec_4_y6_out;
  logic signed [10:0] dMv_Scale_Prec_4_x7_out;
  logic signed [10:0] dMv_Scale_Prec_4_y7_out;
  logic signed [10:0] dMv_Scale_Prec_4_x8_out;
  logic signed [10:0] dMv_Scale_Prec_4_y8_out;
  logic signed [10:0] dMv_Scale_Prec_4_x9_out;
  logic signed [10:0] dMv_Scale_Prec_4_y9_out;
  logic signed [10:0] dMv_Scale_Prec_4_x10_out;
  logic signed [10:0] dMv_Scale_Prec_4_y10_out;
  logic signed [10:0] dMv_Scale_Prec_4_x11_out;
  logic signed [10:0] dMv_Scale_Prec_4_y11_out;
  logic signed [10:0] dMv_Scale_Prec_4_x12_out;
  logic signed [10:0] dMv_Scale_Prec_4_y12_out;
  logic signed [10:0] dMv_Scale_Prec_4_x13_out;
  logic signed [10:0] dMv_Scale_Prec_4_y13_out;
  logic signed [10:0] dMv_Scale_Prec_4_x14_out;
  logic signed [10:0] dMv_Scale_Prec_4_y14_out;
  logic signed [10:0] dMv_Scale_Prec_4_x15_out;
  logic signed [10:0] dMv_Scale_Prec_4_y15_out;

  logic [4:0] vect_4para_Frac_x_in;
  logic [4:0] vect_4para_Frac_y_in;

  logic [4:0] vect_4para_Frac_x_out;
  logic [4:0] vect_4para_Frac_y_out;

  logic [12:0] cur_addr0_in;
  logic [12:0] cur_addr1_in;
  logic [12:0] cur_addr2_in;
  logic [12:0] cur_addr3_in;

  logic [12:0] cur_addr0_out;
  logic [12:0] cur_addr1_out;
  logic [12:0] cur_addr2_out;
  logic [12:0] cur_addr3_out;

  int i;
  int j;
  int k;

  logic[127:0] ref_data_tb [0:383];


always begin
  #1 clk = ~clk;
end
ref_data ref_data_inst (
.clk            (clk),
.en             (en),
.rst_n          (rst_n),
.load_ref_ram   (load_ref_ram),
.export_data_ref(export_data_ref),
.pos_4          (pos_4),
.ref_4para_addr (ref_4para_addr),
.ref_Pel_4      (ref_Pel_4),

//fw data
.dMv_Scale_Prec_4_x0_in (dMv_Scale_Prec_4_x0_in),
.dMv_Scale_Prec_4_x1_in (dMv_Scale_Prec_4_x1_in),
.dMv_Scale_Prec_4_x2_in (dMv_Scale_Prec_4_x2_in),
.dMv_Scale_Prec_4_x3_in (dMv_Scale_Prec_4_x3_in),
.dMv_Scale_Prec_4_x4_in (dMv_Scale_Prec_4_x4_in),
.dMv_Scale_Prec_4_x5_in (dMv_Scale_Prec_4_x5_in),
.dMv_Scale_Prec_4_x6_in (dMv_Scale_Prec_4_x6_in),
.dMv_Scale_Prec_4_x7_in (dMv_Scale_Prec_4_x7_in),
.dMv_Scale_Prec_4_x8_in (dMv_Scale_Prec_4_x8_in),
.dMv_Scale_Prec_4_x9_in (dMv_Scale_Prec_4_x9_in),
.dMv_Scale_Prec_4_y0_in (dMv_Scale_Prec_4_y0_in),
.dMv_Scale_Prec_4_y1_in (dMv_Scale_Prec_4_y1_in),
.dMv_Scale_Prec_4_y2_in (dMv_Scale_Prec_4_y2_in),
.dMv_Scale_Prec_4_y3_in (dMv_Scale_Prec_4_y3_in),
.dMv_Scale_Prec_4_y4_in (dMv_Scale_Prec_4_y4_in),
.dMv_Scale_Prec_4_y5_in (dMv_Scale_Prec_4_y5_in),
.dMv_Scale_Prec_4_y6_in (dMv_Scale_Prec_4_y6_in),
.dMv_Scale_Prec_4_y7_in (dMv_Scale_Prec_4_y7_in),
.dMv_Scale_Prec_4_y8_in (dMv_Scale_Prec_4_y8_in),
.dMv_Scale_Prec_4_y9_in (dMv_Scale_Prec_4_y9_in),
.dMv_Scale_Prec_4_x10_in(dMv_Scale_Prec_4_x10_in),
.dMv_Scale_Prec_4_x11_in(dMv_Scale_Prec_4_x11_in),
.dMv_Scale_Prec_4_x12_in(dMv_Scale_Prec_4_x12_in),
.dMv_Scale_Prec_4_x13_in(dMv_Scale_Prec_4_x13_in),
.dMv_Scale_Prec_4_x14_in(dMv_Scale_Prec_4_x14_in),
.dMv_Scale_Prec_4_x15_in(dMv_Scale_Prec_4_x15_in),
.dMv_Scale_Prec_4_y10_in(dMv_Scale_Prec_4_y10_in),
.dMv_Scale_Prec_4_y11_in(dMv_Scale_Prec_4_y11_in),
.dMv_Scale_Prec_4_y12_in(dMv_Scale_Prec_4_y12_in),
.dMv_Scale_Prec_4_y13_in(dMv_Scale_Prec_4_y13_in),
.dMv_Scale_Prec_4_y14_in(dMv_Scale_Prec_4_y14_in),
.dMv_Scale_Prec_4_y15_in(dMv_Scale_Prec_4_y15_in),


.dMv_Scale_Prec_4_x0_out (dMv_Scale_Prec_4_x0_out),
.dMv_Scale_Prec_4_x1_out (dMv_Scale_Prec_4_x1_out),
.dMv_Scale_Prec_4_x2_out (dMv_Scale_Prec_4_x2_out),
.dMv_Scale_Prec_4_x3_out (dMv_Scale_Prec_4_x3_out),
.dMv_Scale_Prec_4_x4_out (dMv_Scale_Prec_4_x4_out),
.dMv_Scale_Prec_4_x5_out (dMv_Scale_Prec_4_x5_out),
.dMv_Scale_Prec_4_x6_out (dMv_Scale_Prec_4_x6_out),
.dMv_Scale_Prec_4_x7_out (dMv_Scale_Prec_4_x7_out),
.dMv_Scale_Prec_4_x8_out (dMv_Scale_Prec_4_x8_out),
.dMv_Scale_Prec_4_x9_out (dMv_Scale_Prec_4_x9_out),
.dMv_Scale_Prec_4_y0_out (dMv_Scale_Prec_4_y0_out),
.dMv_Scale_Prec_4_y1_out (dMv_Scale_Prec_4_y1_out),
.dMv_Scale_Prec_4_y2_out (dMv_Scale_Prec_4_y2_out),
.dMv_Scale_Prec_4_y3_out (dMv_Scale_Prec_4_y3_out),
.dMv_Scale_Prec_4_y4_out (dMv_Scale_Prec_4_y4_out),
.dMv_Scale_Prec_4_y5_out (dMv_Scale_Prec_4_y5_out),
.dMv_Scale_Prec_4_y6_out (dMv_Scale_Prec_4_y6_out),
.dMv_Scale_Prec_4_y7_out (dMv_Scale_Prec_4_y7_out),
.dMv_Scale_Prec_4_y8_out (dMv_Scale_Prec_4_y8_out),
.dMv_Scale_Prec_4_y9_out (dMv_Scale_Prec_4_y9_out),
.dMv_Scale_Prec_4_x10_out(dMv_Scale_Prec_4_x10_out),
.dMv_Scale_Prec_4_x11_out(dMv_Scale_Prec_4_x11_out),
.dMv_Scale_Prec_4_x12_out(dMv_Scale_Prec_4_x12_out),
.dMv_Scale_Prec_4_x13_out(dMv_Scale_Prec_4_x13_out),
.dMv_Scale_Prec_4_x14_out(dMv_Scale_Prec_4_x14_out),
.dMv_Scale_Prec_4_x15_out(dMv_Scale_Prec_4_x15_out),
.dMv_Scale_Prec_4_y10_out(dMv_Scale_Prec_4_y10_out),
.dMv_Scale_Prec_4_y11_out(dMv_Scale_Prec_4_y11_out),
.dMv_Scale_Prec_4_y12_out(dMv_Scale_Prec_4_y12_out),
.dMv_Scale_Prec_4_y13_out(dMv_Scale_Prec_4_y13_out),
.dMv_Scale_Prec_4_y14_out(dMv_Scale_Prec_4_y14_out),
.dMv_Scale_Prec_4_y15_out(dMv_Scale_Prec_4_y15_out),

.vect_4para_Frac_x_in  (vect_4para_Frac_x_in),
.vect_4para_Frac_y_in  (vect_4para_Frac_y_in),
.vect_4para_Frac_x_out (vect_4para_Frac_x_out),
.vect_4para_Frac_y_out (vect_4para_Frac_y_out),
.enab_prof_out         (enab_prof_out),
.enab_prof_in          (enab_prof_in),
.cur_addr0_in          (cur_addr0_in),
.cur_addr1_in          (cur_addr1_in),
.cur_addr2_in          (cur_addr2_in),
.cur_addr3_in          (cur_addr3_in),
.cur_addr0_out         (cur_addr0_out),
.cur_addr1_out         (cur_addr1_out),
.cur_addr2_out         (cur_addr2_out),
.cur_addr3_out         (cur_addr3_out)
// .ref_line_0              (ref_line_0),
// .ref_line_1              (ref_line_1),
// .ref_line_2              (ref_line_2),
// .ref_line_3              (ref_line_3),
// .ref_line_4              (ref_line_4),
// .ref_line_5              (ref_line_5),
// .ref_line_6              (ref_line_6),
// .ref_line_7              (ref_line_7)
);
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  load_ref_ram = 0;
  export_data_ref = 0;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  load_ref_ram = 1;
  // $readmemh("/data6/workspace/hieupt1/H266/data/ref_ram.txt", ref_data_tb);
  // for (k = 0; k < 384; k = k+8) begin
  //   repeat(1) @(negedge clk);
  //   ref_line_0 = ref_data_tb[k+0];
  //   ref_line_1 = ref_data_tb[k+1];
  //   ref_line_2 = ref_data_tb[k+2];
  //   ref_line_3 = ref_data_tb[k+3];
  //   ref_line_4 = ref_data_tb[k+4];
  //   ref_line_5 = ref_data_tb[k+5];
  //   ref_line_6 = ref_data_tb[k+6];
  //   ref_line_7 = ref_data_tb[k+7];
  //   // ref_line_8 = ref_data_tb[k+8];
  //   // ref_line_9 = ref_data_tb[k+9];
  //   // ref_line_10 = ref_data_tb[k+10];
  //   // ref_line_11 = ref_data_tb[k+11];
  //   // ref_line_12 = ref_data_tb[k+12];
  //   // ref_line_13 = ref_data_tb[k+13];
  //   // ref_line_14 = ref_data_tb[k+14];
  //   // ref_line_15 = ref_data_tb[k+15];
  // end
  repeat(1) @(negedge clk);
  load_ref_ram = 0;
  repeat(1) @(negedge clk);
  en = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_ref = 1;
    end
    else begin
      export_data_ref = 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

initial begin
  repeat(3) @(posedge clk);
  for(j = 0; j < 100; j++) begin
    if (j % 3 == 0 ) begin
      ref_4para_addr = $urandom_range(2000,3000);
      pos_4 = $urandom_range(0,15);
    end
    repeat(1) @(posedge clk);
  end
end
//connect cacl and ref
// logic clk;
//   logic en;
//   logic rst_n;
//   logic export_data_cal;

//   logic [11:0] Ipu_x;
//   logic [11:0] Ipu_y;
//   logic signed [7:0] blk4x4_dif_coor_x;
//   logic signed [7:0] blk4x4_dif_coor_y;
//   logic signed [12:0] vect_4para_Int_x;
//   logic signed [12:0] vect_4para_Int_y;
//   logic [12:0] addr_4;
//   logic [3:0] pos_4;
//   logic [12:0] cur_addr0;
//   logic [12:0] cur_addr1;
//   logic [12:0] cur_addr2;
//   logic [12:0] cur_addr3;

//   logic load_ref_ram;
//   logic export_data_ref;
//   logic signed [71:0] ref_Pel_4 [0:8];

//   int i;
//   int j;

// always begin
//   #1 clk = ~clk;
// end
// calc_addr calc_addr_inst (
// .clk               (clk),
// .rst_n             (rst_n),
// .en             (en),
// .export_data_cal  (export_data_cal),
// .Ipu_x            (Ipu_x),
// .Ipu_y            (Ipu_y),
// .pos_4            (pos_4),
// .addr_4           (addr_4),
// .cur_addr0        (cur_addr0),
// .cur_addr1        (cur_addr1),
// .cur_addr2        (cur_addr2),
// .cur_addr3        (cur_addr3),
// .vect_4para_Int_x (vect_4para_Int_x),
// .vect_4para_Int_y (vect_4para_Int_y),
// .blk4x4_dif_coor_x(blk4x4_dif_coor_x),
// .blk4x4_dif_coor_y(blk4x4_dif_coor_y)
// );
// ref_data ref_data_inst(
// .clk            (clk),
// .en             (en),
// .rst_n          (rst_n),
// .pos_4          (pos_4),
// .load_ref_ram   (load_ref_ram),
// .export_data_ref(export_data_ref),
// .ref_Pel_4      (ref_Pel_4),
// .ref_4para_addr (addr_4)
// );
// initial begin 
//   clk = 1;
//   rst_n = 1;
//   en = 0;
//   export_data_cal = 0;
//   load_ref_ram = 0;
//   repeat(1) @(posedge clk);
//   rst_n = 0;
//   repeat(1) @(posedge clk);
//   rst_n = 1;
//   repeat(1) @(negedge clk);
//   load_ref_ram = 1;
//   repeat(1) @(negedge clk);
//   load_ref_ram = 0;
//   repeat(1) @(negedge clk);
//   en = 1;
//   repeat(3) @(negedge clk);
//   for(i = 0; i < 100; i++) begin
//     if (i % 3 == 0 ) begin
//       export_data_cal = 1;
//       export_data_ref = 1;
//     end
//     else begin
//       export_data_cal = 0;
//       export_data_ref = 0;
//     end
//     repeat(1) @(negedge clk);
//   end
//   $finish;
// end

// initial begin
//   repeat(3) @(posedge clk);
//   for(j = 0; j < 100; j++) begin
//     if (j % 3 == 0 ) begin
//         blk4x4_dif_coor_x = $random();
//         blk4x4_dif_coor_y = $random();
//         vect_4para_Int_x = $random();
//         vect_4para_Int_y = $random();

//         Ipu_x = $random();
//         Ipu_y = $random();
//     end
//     repeat(1) @(posedge clk);
//   end
// end

endmodule : tb_ref_data