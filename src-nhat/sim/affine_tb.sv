`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2023 04:24:07 PM
// Design Name: 
// Module Name: affine_tb2
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
module affine_tb();

    logic clk;
    logic rst_n;
    // dau vao bat dau tinh toan affine cho khoi du doan
    logic start_calc;
    // bat dau tinh toan
    // mvbits
    logic [20:0] mvBits;
    // 3 control point vector
    logic signed [12:0] mvLT_x;
    logic signed [12:0] mvLT_y;
    logic signed [12:0] mvRT_x;
    logic signed [12:0] mvRT_y;
    logic signed [12:0] mvLB_x;
    logic signed [12:0] mvLB_y;
    // Ipu_coor
    logic [11:0] Ipu_x;
    logic [11:0] Ipu_y;
    // use for enableProf
    logic iref_scale;
    // use for enableProf
    logic large_mv_grad;
    // Ipu size
    logic [8:0] Ipu_w;
    logic [8:0] Ipu_h;

    logic start_load;
    logic [20:0] bits;
    logic [8:0] lamb;
    logic [20:0] rdcost_HEVC;
    wire [20:0] cost_min;
    wire [2:0] mode;
    wire done; 
   affine iAffine(.clk(clk), .rst_n(rst_n), .start_load(start_load), .Ipu_w(Ipu_w), .Ipu_h(Ipu_h), .start_calc(start_calc), .mvLT_x(mvLT_x), .mvLT_y(mvLT_y), .mvRT_x(mvRT_x), .mvRT_y(mvRT_y), .mvLB_x(mvLB_x), .mvLB_y(mvLB_y), 
    .Ipu_x(Ipu_x), .Ipu_y(Ipu_y), .iref_scale(iref_scale), .bits(bits), .lamb(lamb),
    .large_mv_grad(large_mv_grad), .rdcost_HEVC(rdcost_HEVC), .cost_min(cost_min), .mode(mode), .done(done));
    
    initial
    begin
        clk = 1;
    end
    
      initial
      begin
        start_calc = 0;
        rst_n = 0;
        repeat (1) @(posedge clk)
        rst_n = 1;
        repeat (1) @(negedge clk)
        start_load = 1;
        //$readmemh("E:/DATN/ref_search.txt", ref_data_4_tmp);
        repeat(1) @(negedge clk);
        start_load = 0;
        repeat (1) @(posedge clk)
        start_calc = 1;
        repeat (1) @(posedge clk);
        start_calc = 0;
      end
        
    initial
    begin
        Ipu_w = 8'd128;
        Ipu_h = 8'd128;
        large_mv_grad = 0;
        iref_scale = 0;
        mvBits = 21'd2;
        Ipu_x = 9'd0;
        Ipu_y = 9'd0;
        mvLT_x = -13'd92;
        mvLT_y = -13'd20;
        mvRT_x = -13'd92;
        mvRT_y = -13'd20;
        mvLB_x = -13'd92;
        mvLB_y = -13'd20;
        lamb = 8'd0;
        bits = 20'd24;
        rdcost_HEVC = 20'd21982;
    end
    
    always #5 clk = ~clk;
endmodule
