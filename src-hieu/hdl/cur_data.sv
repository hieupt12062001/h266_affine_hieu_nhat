`timescale 1ns / 1ps
module cur_data(
  input clk,
  input rst_n,
  //tin hieu thong bao xuat du lieu khoi anh du doan 4x4 moi den module khac
  input en,
  //tin hieu tai du lieu vao bo nho
  input load_cur_ram,
  input export_data_cur,
  //dia chi diem anh hang thu i cua khoi 4x4 diem anh
  input [12:0] cur_addr0,
  input [12:0] cur_addr1,
  input [12:0] cur_addr2,
  input [12:0] cur_addr3, 


  // input [31:0] cur_line_0,
  // input [31:0] cur_line_1,
  // input [31:0] cur_line_2,
  // input [31:0] cur_line_3,
  // input [31:0] cur_line_4,
  // input [31:0] cur_line_5,
  // input [31:0] cur_line_6,
  // input [31:0] cur_line_7,
  // // input [31:0] cur_line_8,
  // // input [31:0] cur_line_9,
  // // input [31:0] cur_line_10,
  // // input [31:0] cur_line_11,
  // // input [31:0] cur_line_12,
  // // input [31:0] cur_line_13,
  // // input [31:0] cur_line_14,
  // // input [31:0] cur_line_15,
  //du lieu 4 diem anh thu i cua khoi du doan 4x4 diem anh
  output logic [31:0] cur_data0,
  output logic [31:0] cur_data1,
  output logic [31:0] cur_data2,
  output logic [31:0] cur_data3
);
(* ram_style = "block" *)logic [31:0] cur_ram [0:4095]; 
logic [31:0] cur_tmp_data0;
logic [31:0] cur_tmp_data1;
logic [31:0] cur_tmp_data2;
logic [31:0] cur_tmp_data3;

logic [15:0] i = 0;

always_ff @(posedge clk or negedge rst_n) 
begin
  if (~rst_n) begin
    cur_ram <= '{default : 0};

    cur_tmp_data0 <= 0;
    cur_tmp_data1 <= 0;
    cur_tmp_data2 <= 0;
    cur_tmp_data3 <= 0;
  end
  else begin
    if(load_cur_ram)
    begin
      // if (i < 4090) begin
      //   cur_ram [i] <= cur_line_0;
      //   cur_ram [i+1] <= cur_line_1;
      //   cur_ram [i+2] <= cur_line_2;
      //   cur_ram [i+3] <= cur_line_3;
      //   cur_ram [i+4] <= cur_line_4;
      //   cur_ram [i+5] <= cur_line_5;
      //   cur_ram [i+6] <= cur_line_6;
      //   cur_ram [i+7] <= cur_line_7;
      //   // cur_ram [i+8] <= cur_line_8;
      //   // cur_ram [i+9] <= cur_line_9;
      //   // cur_ram [i+10] <= cur_line_10;
      //   // cur_ram [i+11] <= cur_line_11;
      //   // cur_ram [i+12] <= cur_line_12;
      //   // cur_ram [i+13] <= cur_line_13;
      //   // cur_ram [i+14] <= cur_line_14;
      //   // cur_ram [i+15] <= cur_line_15;
      //   i = i+8;
      // end
      $readmemh("/data6/workspace/hieupt1/H266_128/data/cur_ram.txt", cur_ram);
    end
    else
    begin
      if(en)
      begin
        cur_tmp_data0 <= cur_ram[cur_addr0];
        cur_tmp_data1 <= cur_ram[cur_addr1];
        cur_tmp_data2 <= cur_ram[cur_addr2];
        cur_tmp_data3 <= cur_ram[cur_addr3];
      end
      else
      begin
        cur_tmp_data0 <= 0;
        cur_tmp_data1 <= 0;
        cur_tmp_data2 <= 0;
        cur_tmp_data3 <= 0;
      end
    end
  end
end

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    cur_data0 <= 0;
    cur_data1 <= 0;
    cur_data2 <= 0;
    cur_data3 <= 0;
  end
  else begin
    if (export_data_cur) begin
      cur_data0 <= cur_tmp_data0;
      cur_data1 <= cur_tmp_data1;
      cur_data2 <= cur_tmp_data2;
      cur_data3 <= cur_tmp_data3;
    end
    else begin
      cur_data0 <= cur_data0;
      cur_data1 <= cur_data1;
      cur_data2 <= cur_data2;
      cur_data3 <= cur_data3;
    end
  end
end

endmodule