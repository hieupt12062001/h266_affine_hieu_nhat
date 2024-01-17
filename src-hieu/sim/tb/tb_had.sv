`timescale 1ns/1ps
module tb_had ();
  logic clk; 
  logic en; 
  logic rst_n;
  logic export_data_had;

  logic [31:0] a4x4_ref_blk1;
  logic [31:0] a4x4_ref_blk2;
  logic [31:0] a4x4_ref_blk3;
  logic [31:0] a4x4_ref_blk4;

  logic [31:0] a4x4_cur_blk1;
  logic [31:0] a4x4_cur_blk2;
  logic [31:0] a4x4_cur_blk3;
  logic [31:0] a4x4_cur_blk4;

  logic [15:0] had_4x4;

  int i;
  int j;

always begin
  #1 clk = ~clk;
end
had had_inst (
.clk               (clk),
.rst_n             (rst_n),
.en             (en),
.export_data_had(export_data_had),
.a4x4_ref_blk1   (a4x4_ref_blk1),
.a4x4_ref_blk2   (a4x4_ref_blk2),
.a4x4_ref_blk3   (a4x4_ref_blk3),
.a4x4_ref_blk4   (a4x4_ref_blk4),
.a4x4_cur_blk1   (a4x4_cur_blk1),
.a4x4_cur_blk2   (a4x4_cur_blk2),
.a4x4_cur_blk3   (a4x4_cur_blk3),
.a4x4_cur_blk4   (a4x4_cur_blk4),
.had_4x4        (had_4x4)
);
initial begin 
  clk = 1;
  rst_n = 1;
  en = 0;
  export_data_had = 0;
  repeat(1) @(posedge clk);
  rst_n = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  repeat(1) @(negedge clk);
  en = 1;
  repeat(3) @(negedge clk);
  for(i = 0; i < 100; i++) begin
    if (i % 3 == 0 ) begin
      export_data_had = 1;
    end
    else begin
      export_data_had = 0; 
    end
    repeat(1) @(negedge clk);
  end
  $finish;
end

initial begin
  repeat(3) @(posedge clk);
  for(j = 0; j < 100; j++) begin
    if (j % 3 == 0 ) begin
        a4x4_cur_blk1 = $random();
        a4x4_cur_blk2 = $random();
        a4x4_cur_blk3 = $random();
        a4x4_cur_blk4 = $random();

        a4x4_ref_blk1 = $random();
        a4x4_ref_blk2 = $random();
        a4x4_ref_blk3 = $random();
        a4x4_ref_blk4 = $random();
    end
    repeat(1) @(posedge clk);
  end
end

endmodule : tb_had