`timescale 1ns/1ps
module tb_affine_control ();

  logic clk;
  logic rst_n;
  logic start;
  logic load_ram;
  logic [20:0] rd_cost_me;
  logic [8:0] lamda_m;
  logic [20:0] ctrl_point_bits;
  logic [15:0] had_4_param ;
  logic [15:0] had_6_param ;

  logic [5:0]num_of_sub_blk;
  logic export_data_init;
  logic export_data_cal;
  logic export_data_ref;
  logic export_data_filter;
  logic export_data_pdof;
  logic export_data_cur;
  logic export_data_had;
  logic load_ref_ram;
  logic load_cur_ram;
  logic en;
  logic [1:0] best_mode;
  logic [20:0] rd_cost_min;
  logic done;

  int i;

always begin
  #1 clk = ~clk;
end
affine_control affine_control_inst (
.clk               (clk),
.rst_n             (rst_n),
.start             (start),
.load_ram          (load_ram),
.rd_cost_me        (rd_cost_me),
.had_4_param       (had_4_param),
.had_6_param       (had_6_param),
.lamda_m           (lamda_m),
.ctrl_point_bits   (ctrl_point_bits),
.en                (en),
.export_data_init  (export_data_init),
.export_data_cal   (export_data_cal),
.export_data_ref   (export_data_ref),
.export_data_filter(export_data_filter),
.export_data_pdof  (export_data_pdof),
.export_data_cur   (export_data_cur),
.export_data_had   (export_data_had),
.load_ref_ram      (load_ref_ram),
.load_cur_ram      (load_cur_ram),
.rd_cost_min    (rd_cost_min),
.num_of_sub_blk    (num_of_sub_blk),
.best_mode         (best_mode),
.done              (done)
);
initial begin 
  clk = 1;
  rst_n = 1;
  repeat(1) @(posedge clk);
  rst_n = 0;
  start = 0;
  load_ram = 0;
  repeat(1) @(posedge clk);
  rst_n = 1;
  load_ram = 1;
  repeat(1) @(posedge clk);
  load_ram = 0;
  start = 1;
  lamda_m = 20'd12;
  rd_cost_me = 20'd14;
  for(i = 0; i < 250; i++) begin
    if (i % 3 == 0 ) begin
      had_4_param = $random();
      had_6_param = $random();
      ctrl_point_bits = 20'd13;
    end
    else begin
      ctrl_point_bits = 20'd13;
    end
    repeat(1) @(posedge clk);
  end
  $finish;
end

endmodule : tb_affine_control