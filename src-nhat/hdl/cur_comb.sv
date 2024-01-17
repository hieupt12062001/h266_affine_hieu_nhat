`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 04:52:00 PM
// Design Name: 
// Module Name: cur_comb
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
module cur_comb(
    input clk,
    input rst_n,
    //chieu dài , chieu rong cua khoi du ?oán 
    input [8:0] Ipu_w,
    input [8:0] Ipu_h,
    //?o chênh lech toa ?o giua block du ?oán 4x4 voi khoi du ?oán hien tai 
    input signed [7:0] blk4x4_dif_coor_x,
    input signed [7:0] blk4x4_dif_coor_y,
    //tin hieu thong bao xuat du lieu khoi anh du doan 4x4 moi den module khac
    input comb_done,
    //tin hieu tai du lieu vao bo nho
    input start_load,
     //du lieu 4 diem anh thu i cua khoi du doan 4x4 diem anh
    output logic [31:0] cur_data0,
    output logic [31:0] cur_data1,
    output logic [31:0] cur_data2,
    output logic [31:0] cur_data3,
//    input [31:0] cur_line_0,
//    input [31:0] cur_line_1,
//    input [31:0] cur_line_2,
//    input [31:0] cur_line_3,
    //bat dau cap nhat lai gia tri rdcost
    output logic start_cost,
    //tin hiu bat dau tinh toan khoi tiep theo
    output logic start_blk,
    //tin hieu thong bao xuat hien khoi du doan 4x4 diem anh dau tien va cuoi cung cua khoi du doan
    output logic first,
    output logic last
    );
//(* ram_style = "block" *) logic [31:0] cur_ram [0:4095];// tai du lieu vao
//dia chi diem anh hang thu i cua khoi 4x4 diem anh
(* ram_style = "block" *)logic [31:0] cur_ram [0:4095]; 

logic [12:0] cur_addr0;
logic [12:0] cur_addr1;
logic [12:0] cur_addr2;
logic [12:0] cur_addr3; 
logic [31:0] cur_tmp_data0;
logic [31:0] cur_tmp_data1;
logic [31:0] cur_tmp_data2;
logic [31:0] cur_tmp_data3;
logic comb_done1;
logic first_blk;
logic last_blk;

always_ff @(posedge clk)
begin
    cur_addr0 <=  (Ipu_w >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2);
    cur_addr1 <= (Ipu_w >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (Ipu_w >> 2);
    cur_addr2 <= (Ipu_w >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (Ipu_w >> 2) * 2;
    cur_addr3 <= (Ipu_w >> 2) * blk4x4_dif_coor_y + (blk4x4_dif_coor_x >> 2) + (Ipu_w >> 2) * 3;
    if(blk4x4_dif_coor_x == Ipu_w - 4 && blk4x4_dif_coor_y == Ipu_h - 4)
    begin
        last_blk <= 1;
    end
    else
    begin
        last_blk <= 0;
    end
    if(blk4x4_dif_coor_x == 0 && blk4x4_dif_coor_y == 0)
    begin
        first_blk <= 1;
    end
    else
    begin
        first_blk <= 0;
    end
end
  
always_ff @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        comb_done1 <= 0;
    else
        comb_done1 <= comb_done;
end

integer i;
always_ff @(posedge clk) 
begin
        if (~rst_n) begin
            cur_ram <= '{default : 0};
 
            cur_tmp_data0 <= 0;
            cur_tmp_data1 <= 0;
            cur_tmp_data2 <= 0;
            cur_tmp_data3 <= 0;
        end
        else begin
            if(start_load)begin
             $readmemh("D:/DATN/cur_data.txt", cur_ram);
//                if (i < 254) begin
//                    cur_ram [i]   <= cur_line_0;
//                    cur_ram [i+1] <= cur_line_1;
//                    cur_ram [i+2] <= cur_line_2;
//                    cur_ram [i+3] <= cur_line_3;
//                    i = i+4;
//                end
            end
            else begin
                if(comb_done)begin
                    cur_tmp_data0 <= cur_ram[cur_addr0];
                    cur_tmp_data1 <= cur_ram[cur_addr1];
                    cur_tmp_data2 <= cur_ram[cur_addr2];
                    cur_tmp_data3 <= cur_ram[cur_addr3];
                end
                else begin
                    cur_tmp_data0 <= cur_tmp_data0;
                    cur_tmp_data1 <= cur_tmp_data1;
                    cur_tmp_data2 <= cur_tmp_data2;
                    cur_tmp_data3 <= cur_tmp_data3;
                end
            end
      end
end

logic [2:0] count;
logic pre_count;

always_ff @(posedge clk)
begin
    if(start_load)
    begin
        start_blk <= 0;
    end
    else
    begin
        if(comb_done)
        begin
            if(last_blk)
            begin
                start_blk <= 0;
                count <= pre_count + 1;
                last <= 1;
            end
            else
            begin
               count <= 0;
               start_blk <= 1;
               last <= 0;
            end
            if(first_blk)
            begin
                first <= 1;
            end
            else
            begin
                first <= 0;
            end
        end
        else
        begin
            start_blk <= 0;
            count <= 2'd2;
        end
    end
end 
always_ff @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        cur_data0 <= 0;
        cur_data1 <= 0;
        cur_data2 <= 0;
        cur_data3 <= 0;
    end
    else
    begin
        cur_data0 <= cur_tmp_data0;
        cur_data1 <= cur_tmp_data1;
        cur_data2 <= cur_tmp_data2;
        cur_data3 <= cur_tmp_data3;
    end
end

always_ff @(posedge clk)
begin
    if(count <= 2'd1)
    begin
        pre_count <= 1;
    end
    else
        pre_count <= 0;
end

logic tmp1;
logic tmp2;

always_ff @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        tmp1 <= 0;
        tmp2 <= 0;
        start_cost <= 0;
    end
    else
    begin
        if(pre_count != 0)
        begin
            tmp1 <= 1;
            tmp2 <= tmp1;
            start_cost <= tmp2;
        end
        else
        begin
            tmp1 <= 0;
            tmp2 <= tmp1;
            start_cost <= tmp2;
        end
    end
end
endmodule
