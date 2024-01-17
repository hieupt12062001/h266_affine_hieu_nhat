module affine_control (
  input  clk,    // Clock
  input  rst_n,  // Asynchronous reset active low
  input  start,
  input  load_ram,
  input  [20:0] rd_cost_me,
  input  [8:0] lamda_m,
  input  [20:0] ctrl_point_bits,
  input  [15:0] had_4_param ,
  input  [15:0] had_6_param ,

  output logic [15:0]num_of_sub_blk,
  output logic export_data_init,
  output logic export_data_cal,
  output logic export_data_ref,
  output logic export_data_filter,
  output logic export_data_pdof,
  output logic export_data_cur,
  output logic export_data_had,
  output  logic load_ref_ram,
  output  logic load_cur_ram,
  output  logic en,
  output  logic [1:0] best_mode,
  output  logic [20:0] rd_cost_min,
  output  logic done
);

logic c_pipe_line;
logic [1:0] count_clk;

always_ff @(posedge clk or negedge rst_n) begin : cal_c_pipe_line
  if(~rst_n) begin
    c_pipe_line <= 1;
    count_clk <= 2'd2;
  end 
  else begin
    if (count_clk == 2'd2) begin
      count_clk <= 2'd0;
      c_pipe_line <= 1;
    end
    else begin
      count_clk <= count_clk + 1;
      c_pipe_line <= 0;
    end
  end
end

logic [15:0] count_c_pipe_line;

always_ff @(posedge c_pipe_line or negedge rst_n) begin : cal_count_c_pipe_line
  if(~rst_n) begin
     count_c_pipe_line <= 0;
  end else begin
    if(~start || load_ram) begin
      count_c_pipe_line <= 0;
    end
    else begin
      count_c_pipe_line <= count_c_pipe_line + 1;
    end
  end
end


always_ff @(negedge clk or negedge rst_n) begin : gen_en
  if(~rst_n | ~start | done | load_ram) begin
     en <= 0;
  end 
  else begin
     if (c_pipe_line) begin
       en <= 1;
     end
     else begin
       en <= en;
     end
  end
end


always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_init
  if(~rst_n) begin
    export_data_init <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || c_pipe_line == 0) begin
      export_data_init <= 0;
    end
    else begin
      export_data_init <= 1;
    end
  end
end

always_ff @(posedge export_data_init or negedge rst_n) begin : gen_num_of_sub_blk
  if(~rst_n) begin
     num_of_sub_blk<= 0;
  end else begin
     num_of_sub_blk<= num_of_sub_blk+1;
  end
end

always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_cal
  if(~rst_n) begin
    export_data_cal <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || count_c_pipe_line == 1 || c_pipe_line == 0) begin
      export_data_cal <= 0;
    end
    else begin
      export_data_cal <= 1;
    end
  end
end

always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_ref
  if(~rst_n) begin
    export_data_ref <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || count_c_pipe_line == 1 || count_c_pipe_line ==2 || c_pipe_line == 0) begin
      export_data_ref <= 0;
    end
    else begin
      export_data_ref <= 1;
    end
  end
end

always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_filter
  if(~rst_n) begin
    export_data_filter <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || count_c_pipe_line == 1 || count_c_pipe_line ==2 || count_c_pipe_line == 3 || c_pipe_line == 0) begin
      export_data_filter <= 0;
    end
    else begin
      export_data_filter <= 1;
    end
  end
end

always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_fpof_cur
  if(~rst_n) begin
    export_data_pdof <= 0;
    export_data_cur <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || count_c_pipe_line == 1 || count_c_pipe_line ==2 || count_c_pipe_line == 3 || count_c_pipe_line == 4 || c_pipe_line == 0) begin
      export_data_pdof <= 0;
      export_data_cur <= 0;
    end
    else begin
      export_data_pdof  <= 1;
      export_data_cur  <= 1;
    end
  end
end

always_ff @(negedge  clk or negedge rst_n) begin : gen_export_data_had
  if(~rst_n) begin
    export_data_had <= 0;
  end 
  else begin
    if (count_c_pipe_line == 0 || count_c_pipe_line == 1 || count_c_pipe_line ==2 || count_c_pipe_line == 3 || count_c_pipe_line == 4 || count_c_pipe_line == 5 || c_pipe_line == 0) begin
      export_data_had <= 0;
    end
    else begin
      export_data_had  <= 1;
    end
  end
end

always_ff @(negedge clk or negedge rst_n) begin : gen_load_data_to_ram
  if(~rst_n) begin
     load_cur_ram <= 0;
     load_ref_ram <= 0;
  end 
  else begin
    if (load_ram) begin
      load_cur_ram <= 1;
      load_ref_ram <= 1;
    end
    else begin
      load_cur_ram <= 0;
      load_ref_ram <= 0;
    end
  end
end

logic [20:0] tot_had_4_reg;
logic [20:0] tot_had_6_reg; 

always_ff @(negedge export_data_had or negedge rst_n) begin : calc_tot_had 
  if(~rst_n) begin
     tot_had_4_reg <= 0;
     tot_had_6_reg <= 0;
  end else begin
     tot_had_4_reg <= tot_had_4_reg + had_4_param ;
     tot_had_6_reg <= tot_had_6_reg + had_6_param ;
  end
end
//calc _rd _cost
logic [20:0] rd_cost_4_param;
logic [20:0] rd_cost_6_param;
assign rd_cost_4_param = tot_had_4_reg + lamda_m * ctrl_point_bits;
assign rd_cost_6_param = tot_had_6_reg + lamda_m * ctrl_point_bits;



always_ff @(posedge c_pipe_line or negedge rst_n) begin : compare_and_output
  if (~rst_n) begin
    done <= 0;
    best_mode <= 0;
    rd_cost_min <= 0; 
  end
  else begin
    if (count_c_pipe_line == 16'd1029) begin
      done <= 1;
      if (rd_cost_4_param < rd_cost_me && rd_cost_4_param < rd_cost_6_param) begin
        rd_cost_min <= rd_cost_4_param;
        best_mode <= 3'b01;
      end else if(rd_cost_me < rd_cost_4_param && rd_cost_me < rd_cost_6_param)begin
        rd_cost_min <= rd_cost_me;
        best_mode <= 3'b11;
      end
      else begin
        rd_cost_min <= rd_cost_6_param;
        best_mode <= 3'b10;
      end
    end
    else begin
      done <= done;
      best_mode <= best_mode;
      rd_cost_min <= rd_cost_min; 
    end
  end
end

endmodule : affine_control