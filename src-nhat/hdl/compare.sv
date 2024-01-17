`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2023 10:17:04 AM
// Design Name: 
// Module Name: compare
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
module compare (
    input clk,
    input rst_n,
    input start_load,
    input rdcost_done,
    input [20:0] rdcost_HEVC,
    input [20:0] rdcost,
    output logic [20:0] cost_min,
    output logic [2:0] mode,
    output logic start_aff6,
    output logic done
);
//logic [20:0] rdcost_tmp;
logic [20:0] rdcost_tmp_4;
logic [20:0] rdcost_tmp_6;
logic [2:0] count;
//logic [2:0] pre_count;

always_ff @(posedge clk)
begin
    if(rdcost_done)
    begin
//        rdcost_tmp <= rdcost_4;
        start_aff6 <= 1;
    end
    else
    begin
//        rdcost_tmp <= rdcost_tmp;
        start_aff6 <= 0;
    end
end

always_ff @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        count <= 0;
    else
    begin
        if(start_load)
        begin
            count <= 0;
        end
        else
        begin
            if(rdcost_done)
            begin
                count <= count + 1;
            end
            else
                count <= count;
        end
    end
end

always_ff @(posedge clk)
begin
    if(~(&count))  
    //if(count == 0)
    begin
        rdcost_tmp_4 <= rdcost;
//        start_affine6 <= 1;
    end
    else
    begin
        rdcost_tmp_4 <= rdcost_tmp_4;
//        start_affine6 <= 0;
    end
end

always_ff @(posedge clk)
begin
    if(count[0]&(~count[1])&(~count[2]))
    //if(count == 1)
    begin
        rdcost_tmp_6 <= rdcost;
    end
    else
        rdcost_tmp_6 <= rdcost_tmp_6;
end

//always_ff @(negedge clk)
//begin
//    if(count >= 3'd2)
//    begin
//        pre_count <= 3'd1;
//    end
//    else
//        pre_count <= count;
//end
always_ff @(posedge clk) begin
        if (count[1]&(~count[2])&(~count[0])) 
        //if(count == 2)
        begin
            if (rdcost_tmp_4 < rdcost_HEVC && rdcost_tmp_4 < rdcost_tmp_6) begin
                cost_min <= rdcost_tmp_4;
                mode <= 3'b001;
            end else if(rdcost_HEVC < rdcost_tmp_4 && rdcost_HEVC < rdcost_tmp_6)begin
                cost_min <= rdcost_HEVC;
                mode <= 3'b100;
            end
            else
            begin
                cost_min <= rdcost_tmp_6;
                mode <= 3'b010;
            end
            done <= 1;
        end else begin
            cost_min <= 0;
            mode <= 3'b000;
            done <= 0;
        end
    end
endmodule







