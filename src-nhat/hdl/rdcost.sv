`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2023 09:30:15 AM
// Design Name: 
// Module Name: rdcost
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
module rdcost(
    input clk,
    input first,
    input start_cost,
    input last,
    input [20:0] bits,
    input [31:0] cur_data0,
    input [31:0] cur_data1,
    input [31:0] cur_data2,
    input [31:0] cur_data3,
    input [31:0] ref_data0,
    input [31:0] ref_data1,
    input [31:0] ref_data2,
    input [31:0] ref_data3,
    input [8:0] lamb,
    output logic [20:0] rdcost,
    output logic rdcost_done
    );
logic [21:0] ahad;
logic [15:0] ahad_4x4;


always_ff @(posedge clk)
begin
        rdcost_done <= 0;
        if(start_cost)
        begin
            if(last)
            begin
                rdcost_done <= 1;
                ahad <= ahad + ahad_4x4;
            end
            else if(first)
            begin
                ahad <= {6'd0, ahad_4x4};
            end
            else
                ahad <= ahad + ahad_4x4;
        end
        else
        begin
            ahad <= ahad;
        end
end

had4x4 had(
.clk(clk), .cur_data0(cur_data0), .cur_data1(cur_data1), .cur_data2(cur_data2), .cur_data3(cur_data3),
.ref_data0(ref_data0), .ref_data1(ref_data1), .ref_data2(ref_data2),.ref_data3(ref_data3),.had_4x4(ahad_4x4)
    );

always_comb
begin
    if(rdcost_done)
        rdcost = ahad + lamb * bits;
    else
        rdcost = 0;
end

endmodule
