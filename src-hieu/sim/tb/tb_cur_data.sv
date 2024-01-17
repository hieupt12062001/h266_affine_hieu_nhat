`timescale 1ns/1ps
module tb_cur_data ();
  logic clk;
  logic rst_n;
  //tin hieu thong bao xuat du lieu khoi anh du doan 4x4 moi den module khac
  logic en;
  //tin hieu tai du lieu vao bo nho
  logic load_cur_ram;
  logic export_data_cur;
  //dia chi diem anh hang thu i cua khoi 4x4 diem anh
  logic [12:0] cur_addr0;
  logic [12:0] cur_addr1;
  logic [12:0] cur_addr2;
  logic [12:0] cur_addr3; 
  //du lieu 4 diem anh thu i cua khoi du doan 4x4 diem anh
  logic [31:0] cur_data0;
  logic [31:0] cur_data1;
  logic [31:0] cur_data2;
  logic [31:0] cur_data3;

  // logic [31:0] cur_line_0;
  // logic [31:0] cur_line_1;
  // logic [31:0] cur_line_2;
  // logic [31:0] cur_line_3;
  // logic [31:0] cur_line_4;
  // logic [31:0] cur_line_5;
  // logic [31:0] cur_line_6;
  // logic [31:0] cur_line_7;
  // logic [31:0] cur_line_8;
  // logic [31:0] cur_line_9;
  // logic [31:0] cur_line_10;
  // logic [31:0] cur_line_11;
  // logic [31:0] cur_line_12;
  // logic [31:0] cur_line_13;
  // logic [31:0] cur_line_14;
  // logic [31:0] cur_line_15;

  int i;
  int j;
  int k;
  // (* ram_style = "block" *) logic [31:0] cur_data_tb [0:255]; 
always begin
  #1 clk = ~clk;
end
cur_data cur_data_inst (
.clk          (clk),
.rst_n        (rst_n),
.cur_addr0    (cur_addr0),
.cur_addr1    (cur_addr1),
.cur_addr2    (cur_addr2),
.cur_addr3    (cur_addr3),
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
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  load_cur_ram = 0;
  export_data_cur = 0;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  load_cur_ram = 1;
  // $readmemh("/data6/workspace/hieupt1/H266/data/cur_ram.txt", cur_data_tb);
  // for (k = 0; k < 256; k = k+8) begin
  //   repeat(1) @(negedge clk);
  //   cur_line_0 = cur_data_tb[k+0];
  //   cur_line_1 = cur_data_tb[k+1];
  //   cur_line_2 = cur_data_tb[k+2];
  //   cur_line_3 = cur_data_tb[k+3];
  //   cur_line_4 = cur_data_tb[k+4];
  //   cur_line_5 = cur_data_tb[k+5];
  //   cur_line_6 = cur_data_tb[k+6];
  //   cur_line_7 = cur_data_tb[k+7];
  //   // cur_line_8 = cur_data_tb[k+8];
  //   // cur_line_9 = cur_data_tb[k+9];
  //   // cur_line_10 = cur_data_tb[k+10];
  //   // cur_line_11 = cur_data_tb[k+11];
  //   // cur_line_12 = cur_data_tb[k+12];
  //   // cur_line_13 = cur_data_tb[k+13];
  //   // cur_line_14 = cur_data_tb[k+14];
  //   // cur_line_15 = cur_data_tb[k+15];
  // end
  repeat(1) @(negedge clk);
  load_cur_ram = 0;
  repeat(1) @(negedge clk);
  en = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_cur = 1;
    end
    else begin
      export_data_cur = 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

initial begin
  repeat(3) @(posedge clk);
  for(j = 0; j < 100; j++) begin
    if (j % 3 == 0 ) begin
      cur_addr0 = $urandom_range(0,200);
      cur_addr1 = $urandom_range(0,200);
      cur_addr2 = $urandom_range(0,200);
      cur_addr3 = $urandom_range(0,200);

    end
    repeat(1) @(posedge clk);
  end
end

endmodule : tb_cur_data