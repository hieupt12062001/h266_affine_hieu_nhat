`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 11:51:22 AM
// Design Name: 
// Module Name: ref_comb
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
module ref_comb(
    input clk,
    input rst_n,
    //bat dau tai du lieu vao bo nho
    input start_load,
    //tín hieu bat ?au thuc hien tính toán
    input calc_done,
    //chieu dài , chieu rong cua khoi du ?oán 
    input [8:0] Ipu_w,
    input [8:0] Ipu_h,
    //toa ?o cua khoi du ?oán
    input [11:0] Ipu_x,
    input [11:0] Ipu_y,
    //?o chênh lech toa ?o giua block du ?oán 4x4 voi khoi du ?oán hien tai 
    input signed [7:0] blk4x4_dif_coor_x,
    input signed [7:0] blk4x4_dif_coor_y,
    //phan nguyên theo chieu ngang, chieu cao cua vector du ?oán cho khoi du ?oán 4x4 ?iem anh cua khoi du ?oán hien tai
    input signed [12:0] vect_Int_x,
    input signed [12:0] vect_Int_y,
     //toa do phan thap phan cua cac vecto du doan
    input [4:0] vect_Frac_x,
    input [4:0] vect_Frac_y,
    //su khac biet toa do theo chieu ngang, doc giua cac vecto chuyen dong cua khoi du doan 4x4 hien tai
    //voi vecto chuyen dong cua cac diem anh nam trong khoi 4x4 do
    input signed [10:0] dMv_Scale_Prec_x0,
    input signed [10:0] dMv_Scale_Prec_y0,
    input signed [10:0] dMv_Scale_Prec_x1,
    input signed [10:0] dMv_Scale_Prec_y1,
    input signed [10:0] dMv_Scale_Prec_x2,
    input signed [10:0] dMv_Scale_Prec_y2,
    input signed [10:0] dMv_Scale_Prec_x3,
    input signed [10:0] dMv_Scale_Prec_y3,
    input signed [10:0] dMv_Scale_Prec_x4,
    input signed [10:0] dMv_Scale_Prec_y4,
    input signed [10:0] dMv_Scale_Prec_x5,
    input signed [10:0] dMv_Scale_Prec_y5,
    input signed [10:0] dMv_Scale_Prec_x6,
    input signed [10:0] dMv_Scale_Prec_y6,
    input signed [10:0] dMv_Scale_Prec_x7,
    input signed [10:0] dMv_Scale_Prec_y7,
    input signed [10:0] dMv_Scale_Prec_x8,
    input signed [10:0] dMv_Scale_Prec_y8,
    input signed [10:0] dMv_Scale_Prec_x9,
    input signed [10:0] dMv_Scale_Prec_y9,
    input signed [10:0] dMv_Scale_Prec_x10,
    input signed [10:0] dMv_Scale_Prec_y10,
    input signed [10:0] dMv_Scale_Prec_x11,
    input signed [10:0] dMv_Scale_Prec_y11,
    input signed [10:0] dMv_Scale_Prec_x12,
    input signed [10:0] dMv_Scale_Prec_y12,
    input signed [10:0] dMv_Scale_Prec_x13,
    input signed [10:0] dMv_Scale_Prec_y13,
    input signed [10:0] dMv_Scale_Prec_x14,
    input signed [10:0] dMv_Scale_Prec_y14,
    input signed [10:0] dMv_Scale_Prec_x15,
    input signed [10:0] dMv_Scale_Prec_y15,
    //du lieu vung anh thaam chieu 128x96 diem anh
//    input [127:0] ref_line_0,
//    input [127:0] ref_line_1,
//    input [127:0] ref_line_2,
//    input [127:0] ref_line_3,
    input enable_prof,
    //du lieu cua cac dong pixel cua khoi tham chieu 4x4 gan dung nhat so voi khoi du doan
    output logic [31:0] ref_data0,
    output logic [31:0] ref_data1,
    output logic [31:0] ref_data2,
    output logic [31:0] ref_data3,
    //thong bao module cur_data bat dau nap du lieu cua khoi du doan moi vao bo nho
    //va dua ra du lieu cua khoi 4x4 dang du doan
    output logic comb_done
    );
logic start_comb;
//toa ?o khoi tham chieu
logic signed [12:0] ref_x;
logic signed [12:0] ref_y;
//toa ?o vùng anh search
logic signed [12:0] search_x;
logic signed [12:0] search_y;  
logic [12:0] c_addr;
integer i;
integer j;
logic load_done;
logic count;
//du lieu ve ?ia chi ?iem anh ?au tiên cua reference block 4x4
logic [12:0] ref_4para_addr;
//du lieu ve vi trí ?iem anh ?au tiên cua reference block 4x4 
logic [3:0] pos;
logic tmp_done;
logic tmp_done1;

logic tmp_comb;
logic tmp_comb_1;
logic tmp_comb_2;

//(* ram_style = "block" *)logic [127:0] ref_ram [0:4095];//////////du lieu tai vao
(* rom_style = "block" *)logic signed [71:0] ref_Pel [0:8]; // khoi 9x9 diem anh tu khoi 256x256
(* rom_style = "block" *)logic signed [63:0] tmp_Pel [0:8];  
logic signed [63:0] affineLumaFilter [0:15];
(* rom_style = "block" *)logic [95:0] dst [0:5];
(* ram_style = "block" *)logic [127:0] ref_ram [0:4095];
//logic signed [71:0] ref_Pel [0:8];
//logic signed [63:0] tmp_Pel [0:8];
//logic [95:0] dst [0:5];

always_ff @(posedge clk)
begin
    ref_x <= blk4x4_dif_coor_x + Ipu_x + vect_Int_x;
    ref_y <= blk4x4_dif_coor_y + Ipu_y + vect_Int_y;
    search_x <= Ipu_x - (9'd128 - (Ipu_w >> 1));
    search_y <= Ipu_y - (9'd128 - (Ipu_h >> 1)); 
end
////////////////////////thay doi
integer c;
always_ff @(posedge clk)
begin
    for(c = 0; c < 256; c++)
    begin
        if(ref_y == search_y + c)
        begin
              c_addr <= c << 4'd4;
        end 
    end
end

always_ff @(posedge clk)
begin
    if(~rst_n)
    begin
        start_comb <= 0;
        tmp_done <= 0;
        tmp_done1 <= 0;
    end
    else
    begin
        if(calc_done)
        begin
            tmp_done <= 1;
            tmp_done1 <= tmp_done;
            start_comb <= tmp_done1;
        end
        else
        begin
            tmp_done <= 0;
            tmp_done1 <= tmp_done; 
            start_comb <= tmp_done1;
        end
    end
end

integer z;
always_ff @(posedge clk)
begin
    for(z = 0; z < 16; z++)
    begin
        if(ref_x - (search_x + (z << 4)) >= 0 &&  ref_x - (search_x + ((z + 1) << 4) - 1))
        begin
            ref_4para_addr <= c_addr + z;
        end
    end 
    pos <= 5'd15 - (ref_x & 5'd15);
    
end

// doi voi affineLumaFilter[vect_4para_Frac_x][((6 << 3) + 7) : (6 << 3)]
// va affineLumaFilter[vect_4para_Frac_x][((3 << 3) + 7) : (3 << 3)] thuc hien phep tru
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

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        tmp_comb <= 0;
        tmp_comb_1 <= 0;
        tmp_comb_2 <= 0;
        comb_done <= 0;
    end
    else
    begin
        tmp_comb <= start_comb;
        tmp_comb_1 <= tmp_comb;
        tmp_comb_2 <= tmp_comb_1;
        comb_done <= tmp_comb_2;
    end;
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        count <= 0;
        load_done <= 0;
    end
    else
    begin
        if(count >= 4096)
        begin
            load_done <= 1;
        end
        else
        begin
            load_done <= 0;
        end
    end
end
localparam ref_stride = 5'd4;

logic [15:0] w = 0;
always_ff @(posedge clk or negedge rst_n)
begin
        if (~rst_n) begin
            ref_ram <= '{default : 0};
        end
        else begin
            if(start_load)begin
            $readmemh("D:/DATN/ref_search.txt", ref_ram);
//                if (w < 382) begin
//                    ref_ram [w]   <= ref_line_0;
//                    ref_ram [w+1] <= ref_line_1;
//                    ref_ram [w+2] <= ref_line_2;
//                    ref_ram [w+3] <= ref_line_3;
//                    w = w+4;
//                end
            end
        end
end
always_ff @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
            ref_Pel <= '{default : 0};
    end
    else
    begin
         case(pos)
            15: 
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j - 2) *6) - 1][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6) - 1][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((15 << 3) + 7) : (15 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 1) << 3) + 7) : ((15 - 1) << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 2) << 3) + 7) : ((15 - 2) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 3) << 3) + 7) : ((15 - 3) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 4) << 3) + 7) : ((15 - 4) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 5) << 3) + 7) : ((15 - 5) << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(((15 - 6) << 3) + 7) : ((15 - 6) << 3)]};
                end
            14:
                for(j= 0; j< 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6) - 1][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((14 << 3) + 7) : (14 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((13 << 3) + 7) : (13 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((11 << 3) + 7) : (11 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((10 << 3) + 7) : (10 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((9 << 3) + 7) : (9 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((8 << 3) + 7) : (8 << 3)]};
                end
            5:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((7 << 3) + 7) : (7 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((6 << 3) + 7) : (6 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((5 << 3) + 7) : (5 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((4 << 3) + 7) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((3 << 3) + 7) : (3 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)]};
                end
            4:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((6 << 3) + 7) : (6 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((5 << 3) + 7) : (5 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((4 << 3) + 3) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((14 << 3) + 7) : (14 << 3)]};
                end
            3:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((5 << 3) + 7) : (5 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((4 << 3) + 7) : (4 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((14 << 3) + 7) : (14 << 3)],   
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((13 << 3) + 7) : (13 << 3)]};
                end
            2:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((4 << 3) + 7) : (4 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((3 << 3) + 7) : (3 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((12 << 3) + 7) : (12 << 3)]};
                end
            1:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((3 << 3) + 7) : (3 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((11 << 3) + 7) : (11 << 3)]};
                end
            0:
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((2 << 3) + 7) : (2 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((1 << 3) + 7) : (1 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((0 << 3) + 7) : (0 << 3)], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((15 << 3) + 7) : (15 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((14 << 3) + 7) : (14 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((13 << 3) + 7) : (13 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((12 << 3) + 7) : (12 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((11 << 3) + 7) : (11 << 3)],
                                   ref_ram[ref_4para_addr + ((j- 2) *6) + 1][((10 << 3) + 7) : (10 << 3)]};
                end
            default:
            begin
                for(j = 0; j < 9; j++)
                begin
                    ref_Pel[j] <= {ref_ram[ref_4para_addr + ((j- 2) *6)][((pos + 2)<<3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos + 1) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][(pos << 3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 1) << 3) +7 -: 8], 
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 2) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 3) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 4) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 5) << 3) +7 -: 8],
                                   ref_ram[ref_4para_addr + ((j- 2) *6)][((pos - 6) << 3) +7 -: 8]};
                end
            end
            endcase
    end
end

//tính toán giá tr? d?ch bit và giá tr? ph?n bù c?a quá tr?nh l?c n?i suy
logic signed [20:0] nOffset0;
logic [3:0] shift0;
always_comb
begin
    if(~(&vect_Frac_y) && ~(&vect_Frac_x))
    //if(vect_Frac_y == 0 && vect_Frac_x == 0)
    begin
        if(!enable_prof)
        begin
            shift0 = 0;
        end
        else
        begin
            shift0 = 4'd6;
        end
    end
    else if(~(&vect_Frac_y) && vect_Frac_x != 0)
    //else if(vect_Frac_y == 0 && vect_Frac_x != 0)
    begin
        if(!enable_prof)
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
    else if(vect_Frac_y != 0 && ~(&vect_Frac_x))
    //else if(vect_Frac_y != 0 && vect_Frac_x == 0)
    begin
        if(!enable_prof)
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
        if(!enable_prof)
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

integer q;
localparam nOffset1 = -21'd8192;
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
//tinh toan ... phuc vu cho qua trinh loc noi suy theo ca hang ngang va hang doc o duoi
always_comb
begin
    for(q = 0; q < 4; q++)
    begin
        sum01 = ref_Pel[0][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] -
               ref_Pel[0][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[0][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[0][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[0][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[0][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum11 = ref_Pel[1][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[1][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[1][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[1][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[1][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[1][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum21 = ref_Pel[2][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[2][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[2][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[2][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[2][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[2][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum31 = ref_Pel[3][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[3][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[3][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[3][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[3][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[3][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum41 = ref_Pel[4][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[4][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[4][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[4][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[4][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[4][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum51 = ref_Pel[5][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[5][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[5][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[5][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[5][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[5][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum61 = ref_Pel[6][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[6][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[6][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[6][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[6][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[6][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum71 = ref_Pel[7][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[7][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[7][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[7][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[7][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[7][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];
                
                sum81 = ref_Pel[8][((8-q<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
               ref_Pel[8][(((7-q)<<3) +7) -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
               ref_Pel[8][(((6-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
               ref_Pel[8][(((5-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
               ref_Pel[8][(((4-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
               ref_Pel[8][(((3-q)<<3)+7) -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];
                       
                tmp_Pel[0][((3-q) << 4) +15 -: 16] = (sum01 + nOffset1) ;
                tmp_Pel[1][((3-q) << 4) +15 -: 16] = (sum11 + nOffset1) ;
                tmp_Pel[2][((3-q) << 4) +15 -: 16] = (sum21 + nOffset1) ;
                tmp_Pel[3][((3-q) << 4) +15 -: 16] = (sum31 + nOffset1) ;
                tmp_Pel[4][((3-q) << 4) +15 -: 16] = (sum41 + nOffset1) ;
                tmp_Pel[5][((3-q) << 4) +15 -: 16] = (sum51 + nOffset1) ;
                tmp_Pel[6][((3-q) << 4) +15 -: 16] = (sum61 + nOffset1) ;
                tmp_Pel[7][((3-q) << 4) +15 -: 16] = (sum71 + nOffset1) ;
                tmp_Pel[8][((3-q) << 4) +15 -: 16] = (sum81 + nOffset1) ;
            end  
end

integer k;
logic signed [23:0] sum0;
logic signed [23:0] sum1;
logic signed [23:0] sum2;
logic signed [23:0] sum3;

//  Thuc hien loc noi suy
always_comb
begin
        //if(~(&vect_Frac_y) && ~(&vect_Frac_x))
        if(vect_Frac_y == 0 && vect_Frac_x == 0)
        begin
            if(!enable_prof)
            begin
                for(k = 0; k < 4; k++)
                begin
                    dst[k+1][79:16] = {ref_Pel[k + 2][((6 << 3) + 7) : (6 << 3)], ref_Pel[k + 2][((5 << 3) + 7) : (5 << 3)],
                            ref_Pel[k + 2][((4 << 3) + 7) : (4 << 3)], ref_Pel[k + 2][((3 << 3) + 7) : (3 << 3)]};
                end
            end
            else
            begin
                for(k = 0; k < 4; k++)
                begin
                    dst[k+1][79:64] = ((ref_Pel[k + 2][((6 << 3) + 7) : (6 << 3)] << 6) - (1 << 13));
                    dst[k+1][63:48] = ((ref_Pel[k + 2][((5 << 3) + 7) : (5 << 3)] << 6) - (1 << 13));
                    dst[k+1][47:32] = (ref_Pel[k + 2][((4 << 3) + 7) : (4 << 3)] << 6) - (1 << 13);
                    dst[k+1][31:16] = (ref_Pel[k + 2][((3 << 3) + 7) : (3 << 3)]  << 6) - (1 << 13);
                end
            end
        end
        //else if(vect_Frac_y != 0 && ~(&vect_Frac_x))//thuc hien loc noi suy theo hang doc
        else if(vect_Frac_y != 0 && vect_Frac_x == 0)
        begin
            for(k = 0; k < 4; k++)
            begin
                sum0 = ref_Pel[k][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[k + 1][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[k + 2][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[k + 3][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[k + 4][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[k + 5][((6 << 3) + 7) : (6 << 3)] * affineLumaFilter[vect_Frac_y][((2 << 3) + 7) : (2 << 3)];

                sum1 = ref_Pel[k][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[k + 1][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[k + 2][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[k + 3][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[k + 4][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[k + 5][((5 << 3) + 7) : (5 << 3)] * affineLumaFilter[vect_Frac_y][((2 << 3) + 7) : (2 << 3)];
                       
                sum2 = ref_Pel[k][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[k + 1][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[k + 2][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[k + 3][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[k + 4][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[k + 5][((4 << 3) + 7) : (4 << 3)] * affineLumaFilter[vect_Frac_y][((2 << 3) + 7) : (2 << 3)];

                sum3 = ref_Pel[k][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[k + 1][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[k + 2][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[k + 3][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[k + 4][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[k + 5][((3 << 3) + 7) : (3 << 3)] * affineLumaFilter[vect_Frac_y][((2 << 3) + 7) : (2 << 3)];
                
                dst[k+1][(4<< 4) +15 -: 16] = (sum0 + nOffset0) >> shift0;
                dst[k+1][(3 << 4) +15 -: 16] = (sum1 + nOffset0) >> shift0;
                dst[k+1][(2 << 4) +15 -: 16] = (sum2 + nOffset0) >> shift0;
                dst[k+1][(1 << 4) +15 -: 16] = (sum3 + nOffset0) >> shift0;
            end
        end
        //else if(~(&vect_Frac_y) && vect_Frac_x != 0)//thuc hien loc noi suy theo hang ngang
        else if(vect_Frac_y == 0 && vect_Frac_x != 0)
        begin
            for(k = 0; k < 4; k++)
            begin
                
                sum0 = ref_Pel[2][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] -
                       ref_Pel[2][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[2][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[2][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[2][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[2][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum1 = ref_Pel[3][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[3][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[3][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[3][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[3][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[3][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];


                sum2 = ref_Pel[4][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[4][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[4][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[4][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[4][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[4][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

                sum3 = ref_Pel[5][(8-k<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((7 << 3) + 7) : (7 << 3)] - 
                       ref_Pel[5][((7-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((6 << 3) + 7) : (6 << 3)] + 
                       ref_Pel[5][((6-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((5 << 3) + 7) : (5 << 3)] +
                       ref_Pel[5][((5-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((4 << 3) + 7) : (4 << 3)] -
                       ref_Pel[5][((4-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((3 << 3) + 7) : (3 << 3)] +
                       ref_Pel[5][((3-k)<<3) +7 -: 8] * affineLumaFilter[vect_Frac_x][((2 << 3) + 7) : (2 << 3)];

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
                abuf0 = affineLumaFilter[vect_Frac_y][((7 << 3) + 7) : ((7 << 3))];
                abuf1 = affineLumaFilter[vect_Frac_y][((6 << 3) + 7) : ((6 << 3))];
                abuf2 = affineLumaFilter[vect_Frac_y][((5 << 3) + 7) : ((5 << 3))];
                abuf3 = affineLumaFilter[vect_Frac_y][((4 << 3) + 7) : ((4 << 3))];
                abuf4 = affineLumaFilter[vect_Frac_y][((3 << 3) + 7) : ((3 << 3))];
                abuf5 = affineLumaFilter[vect_Frac_y][((2 << 3) + 7) : ((2 << 3))];
                
                buf01 = tmp_Pel[k][(3 << 4) + 15 : (3 << 4)];
                buf11 = tmp_Pel[k + 1][(3 << 4) + 15 : (3 << 4)];
                buf21 = tmp_Pel[k + 2][(3 << 4) + 15 : (3 << 4)];
                buf31 = tmp_Pel[k + 3][(3 << 4) + 15 : (3 << 4)];
                buf41 = tmp_Pel[k + 4][(3 << 4) + 15 : (3 << 4)];
                buf51 = tmp_Pel[k + 5][(3 << 4) + 15 : (3 << 4)];
                
                buf02 = tmp_Pel[k][(2 << 4) + 15 : (2 << 4)];
                buf12 = tmp_Pel[k + 1][(2 << 4) + 15 : (2 << 4)];
                buf22 = tmp_Pel[k + 2][(2 << 4) + 15 : (2 << 4)];
                buf32 = tmp_Pel[k + 3][(2 << 4) + 15 : (2 << 4)];
                buf42 = tmp_Pel[k + 4][(2 << 4) + 15 : (2 << 4)];
                buf52 = tmp_Pel[k + 5][(2 << 4) + 15 : (2 << 4)];
                
                buf03 = tmp_Pel[k][(1 << 4) + 15 : (1 << 4)];
                buf13 = tmp_Pel[k + 1][(1 << 4) + 15 : (1 << 4)];
                buf23 = tmp_Pel[k + 2][(1 << 4) + 15 : (1 << 4)];
                buf33 = tmp_Pel[k + 3][(1 << 4) + 15 : (1 << 4)];
                buf43 = tmp_Pel[k + 4][(1 << 4) + 15 : (1 << 4)];
                buf53 = tmp_Pel[k + 5][(1 << 4) + 15 : (1 << 4)];
                
                buf04 = tmp_Pel[k][(0 << 4) + 15 : (0 << 4)];
                buf14 = tmp_Pel[k + 1][(0 << 4) + 15 : (0 << 4)];
                buf24 = tmp_Pel[k + 2][(0 << 4) + 15 : (0 << 4)];
                buf34 = tmp_Pel[k + 3][(0 << 4) + 15 : (0 << 4)];
                buf44 = tmp_Pel[k + 4][(0 << 4) + 15 : (0 << 4)];
                buf54 = tmp_Pel[k + 5][(0 << 4) + 15 : (0 << 4)];
                       
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

logic xOffset;
logic yOffset; 
//tinh toan phan bu cua che do PDOF va dat gia thi dich shift_prof luon bang 6
always_comb
begin
    xOffset = vect_Frac_x >> 3;
    yOffset = vect_Frac_y >> 3;
end

integer m;
always_comb
begin
        for (m = 0; m < 4; m++)
        begin
            //cac diem anh bao quanh ben tren và ben duoi c?a khoi tham chieu 4x4
            dst[0][((4-m) << 4) +15 -: 16] = (ref_Pel[2 + yOffset - 1][((4-m - xOffset + 2) << 3) + 7 -: 8] << 6) - 15'd8192;
            dst[5][((4-m) << 4) +15 -: 16] = (ref_Pel[7 + yOffset - 1][((4-m - xOffset + 2) << 3) + 7 -: 8] << 6) - 15'd8192;
            //cac diem anh bao quanh ben trai va ben phai cua khoi tham chieu 4x4
            dst[m+1][(5 << 4) + 15 : (5 << 4)] = (ref_Pel[2 + yOffset + m][((6 - xOffset) << 3) +7 -: 8] << 6) - 15'd8192;
            dst[m+1][(0 << 4) + 15 : (0 << 4)] = (ref_Pel[2 + yOffset + m][((1 - xOffset) << 3) +7 -: 8] << 6) - 15'd8192;
        end
end
integer a;
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
//cac diem anh cua khoi 6x6
always_ff @(posedge clk)
begin
    for (a = 0; a < 4; a++)
    begin
        gY0[a] <= dst[a + 2][(4<<4)+15 -: 16];
        gY0[a + 4] <= dst[a + 2][(3<<4)+15 -: 16];
        gY0[a + 8] <= dst[a + 2][(2<<4)+15 -: 16];
        gY0[a + 12] <= dst[a + 2][(1<<4)+15 -: 16];
        
        gY1[a] <= dst[a][(4<<4)+15 -: 16];
        gY1[a + 4] <= dst[a][(3<<4)+15 -: 16];
        gY1[a + 8] <= dst[a][(2<<4)+15 -: 16];
        gY1[a + 12] <= dst[a][(1<<4)+15 -: 16];
        
        gX0[a] <= dst[1][((3-a)<<4)+15 -: 16];
        gX0[a + 4] <= dst[2][((3-a)<<4)+15 -: 16];
        gX0[a + 8] <= dst[3][((3-a)<<4)+15 -: 16];
        gX0[a + 12] <= dst[4][((3-a)<<4)+15 -: 16];
        
        gX1[a] <= dst[1][((5-a)<<4)+15 -: 16];
        gX1[a + 4] <= dst[2][((5-a)<<4)+15 -: 16];
        gX1[a + 8] <= dst[3][((5-a)<<4)+15 -: 16];
        gX1[a + 12] <= dst[4][((5-a)<<4)+15 -: 16];
    end
end
integer b;
always_comb
begin
    for(b = 0; b < 16; b++)
    begin
        agX0[b] = gX0[b] >> 6;
        agY0[b] = gY0[b] >> 6;
        agX1[b] = gX1[b] >> 6;
        agY1[b] = gY1[b] >> 6;
    end
end
integer n;
//tinh toan cac gradient khong gian
always_comb 
begin
        for (n = 0; n < 16; n++)
        begin
            gradY[n] = agY0[n] - agY1[n];
            gradX[n] = agX0[n] - agX1[n];
        end
end
//phan bu cho hoat dong tinh toan chenh lech diem anh giua anh trc khi tinh chinh va sau khi tinh chinh
localparam offset_prof = 15'd8224;
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
always_comb
begin 

        dI_0 = dMv_Scale_Prec_x0 * gradX[0] + dMv_Scale_Prec_y0 * gradY[0];
        dI_1 = dMv_Scale_Prec_x1 * gradX[1] + dMv_Scale_Prec_y1 * gradY[4];
        dI_2 = dMv_Scale_Prec_x2 * gradX[2] + dMv_Scale_Prec_y2 * gradY[8];
        dI_3 = dMv_Scale_Prec_x3 * gradX[3] + dMv_Scale_Prec_y3 * gradY[12];
        dI_4 = dMv_Scale_Prec_x4 * gradX[4] + dMv_Scale_Prec_y4 * gradY[1];
        dI_5 = dMv_Scale_Prec_x5 * gradX[5] + dMv_Scale_Prec_y5 * gradY[5];
        dI_6 = dMv_Scale_Prec_x6 * gradX[6] + dMv_Scale_Prec_y6 * gradY[9];
        dI_7 = dMv_Scale_Prec_x7 * gradX[7] + dMv_Scale_Prec_y7 * gradY[13];
        dI_8 = dMv_Scale_Prec_x8 * gradX[8] + dMv_Scale_Prec_y8 * gradY[2];
        dI_9 = dMv_Scale_Prec_x9 * gradX[9] + dMv_Scale_Prec_y9 * gradY[6];
        dI_10 = dMv_Scale_Prec_x10 * gradX[10] + dMv_Scale_Prec_y10 * gradY[10];
        dI_11 = dMv_Scale_Prec_x11 * gradX[11] + dMv_Scale_Prec_y11 * gradY[14];
        dI_12 = dMv_Scale_Prec_x12 * gradX[12] + dMv_Scale_Prec_y12 * gradY[3];
        dI_13 = dMv_Scale_Prec_x13 * gradX[13] + dMv_Scale_Prec_y13 * gradY[7];
        dI_14 = dMv_Scale_Prec_x14 * gradX[14] + dMv_Scale_Prec_y14 * gradY[11];
        dI_15 = dMv_Scale_Prec_x15 * gradX[15] + dMv_Scale_Prec_y15 * gradY[15];
//        for(i = 0; i < 16; i ++)
//        begin
//        //tinh do chenh lech giua diem anh trc va sau khi tinh chinh
//        dI[i] = dMv_Scale_Prec_x[i] * gradX[i] + dMv_Scale_Prec_y[i] * gradY[i];
//        end
end        
always_comb
begin       
        //du lieu diem anh sau khi qua tinh chinh
        data0 = (dst[1][79:64] + dI_0 + offset_prof) >> 6;
        data1 = (dst[1][63:48] + dI_1 + offset_prof) >> 6;
        data2 = (dst[1][47:32] + dI_2 + offset_prof) >> 6;
        data3 = (dst[1][31:16] + dI_3 + offset_prof) >> 6;
        data4 = (dst[2][79:64] + dI_4 + offset_prof) >> 6;
        data5 = (dst[2][63:48] + dI_5 + offset_prof) >> 6;
        data6 = (dst[2][47:32] + dI_6 + offset_prof) >> 6;
        data7 = (dst[2][31:16] + dI_7 + offset_prof) >> 6;
        data8 = (dst[3][79:64] + dI_8 + offset_prof) >> 6;
        data9 = (dst[3][63:48] + dI_9 + offset_prof) >> 6;
        data10 = (dst[3][47:32] + dI_10 + offset_prof) >> 6;
        data11 = (dst[3][31:16] + dI_11 + offset_prof) >> 6;
        data12 = (dst[4][79:64] + dI_12 + offset_prof) >> 6;
        data13 = (dst[4][63:48] + dI_13 + offset_prof) >> 6;
        data14 = (dst[4][47:32] + dI_14 + offset_prof) >> 6;
        data15 = (dst[4][31:16] + dI_15 + offset_prof) >> 6;
end

always @(posedge clk)
begin
    if(enable_prof)
    begin
        ref_data0 <= {data0, data1, data2, data3};
        ref_data1 <= {data4, data5, data6, data7};
        ref_data2 <= {data8, data9, data10, data11};
        ref_data3 <= {data12, data13, data14, data15};
    end
    else
    begin
        ref_data0 <= {dst[1][71:64], dst[1][55:48], dst[1][39:32], dst[1][23:16]};
        ref_data1 <= {dst[2][71:64], dst[2][55:48], dst[2][39:32], dst[2][23:16]};
        ref_data2 <= {dst[3][71:64], dst[3][55:48], dst[3][39:32], dst[3][23:16]};
        ref_data3 <= {dst[4][71:64], dst[4][55:48], dst[4][39:32], dst[4][23:16]};
    end
end

endmodule
