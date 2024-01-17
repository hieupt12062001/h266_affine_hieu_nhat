module had (
  input  clk,    // Clock
  input  en, // Clock Enable
  input  rst_n,  // Asynchronous reset active low
  input  export_data_had,

  input  [31:0] a4x4_ref_blk1,
  input  [31:0] a4x4_ref_blk2,
  input  [31:0] a4x4_ref_blk3,
  input  [31:0] a4x4_ref_blk4,

  input  [31:0] a4x4_cur_blk1,
  input  [31:0] a4x4_cur_blk2,
  input  [31:0] a4x4_cur_blk3,
  input  [31:0] a4x4_cur_blk4,

  output logic [15:0] had_4x4
  
);

logic signed [8:0] diff [0:15];
logic signed [15:0] m1 [0:15];
logic signed [15:0] d1 [0:15];
logic signed [15:0] m2 [0:15];
logic signed [15:0] d2 [0:15];
logic [15:0] abs_d2 [0:15];
logic [15:0] tmp_had_4x4;
integer i;
logic [14:0] abs0;
logic [14:0] abs1;
logic [14:0] abs2;
logic [14:0] abs3;
logic [14:0] abs4;

always_comb
begin
    diff[0] = a4x4_ref_blk1[31:24] - a4x4_cur_blk1[31:24];
    diff[1] = a4x4_ref_blk1[23:16] - a4x4_cur_blk1[23:16];
    diff[2] = a4x4_ref_blk1[15:8] - a4x4_cur_blk1[15:8];
    diff[3] = a4x4_ref_blk1[7:0] - a4x4_cur_blk1[7:0];
    diff[4] = a4x4_ref_blk2[31:24] - a4x4_cur_blk2[31:24];
    diff[5] = a4x4_ref_blk2[23:16] - a4x4_cur_blk2[23:16];
    diff[6] = a4x4_ref_blk2[15:8] - a4x4_cur_blk2[15:8];
    diff[7] = a4x4_ref_blk2[7:0] - a4x4_cur_blk2[7:0];
    diff[8] = a4x4_ref_blk3[31:24] - a4x4_cur_blk3[31:24];
    diff[9] = a4x4_ref_blk3[23:16] - a4x4_cur_blk3[23:16];
    diff[10] = a4x4_ref_blk3[15:8] - a4x4_cur_blk3[15:8];
    diff[11] = a4x4_ref_blk3[7:0] - a4x4_cur_blk3[7:0];
    diff[12] = a4x4_ref_blk4[31:24] - a4x4_cur_blk4[31:24];
    diff[13] = a4x4_ref_blk4[23:16] - a4x4_cur_blk4[23:16];
    diff[14] = a4x4_ref_blk4[15:8] - a4x4_cur_blk4[15:8];
    diff[15] = a4x4_ref_blk4[7:0] - a4x4_cur_blk4[7:0];
end
//bien doi HAD
always_comb
begin
  m1[ 0]= diff[ 0] + diff[12];
  m1[ 1]= diff[ 1] + diff[13];
  m1[ 2]= diff[ 2] + diff[14];
  m1[ 3]= diff[ 3] + diff[15];
  m1[ 4]= diff[ 4] + diff[ 8];
  m1[ 5]= diff[ 5] + diff[ 9];
  m1[ 6]= diff[ 6] + diff[10];
  m1[ 7]= diff[ 7] + diff[11];
  m1[ 8]= diff[ 4] - diff[ 8];
  m1[ 9]= diff[ 5] - diff[ 9];
  m1[10]= diff[ 6] - diff[10];
  m1[11]= diff[ 7] - diff[11];
  m1[12]= diff[ 0] - diff[12];
  m1[13]= diff[ 1] - diff[13];
  m1[14]= diff[ 2] - diff[14];
  m1[15]= diff[ 3] - diff[15];
end

always_comb
begin
  d1[ 0] = m1[ 0] + m1[ 4];
  d1[ 1] = m1[ 1] + m1[ 5];
  d1[ 2] = m1[ 2] + m1[ 6];
  d1[ 3] = m1[ 3] + m1[ 7];
  d1[ 4] = m1[ 8] + m1[12];
  d1[ 5] = m1[ 9] + m1[13];
  d1[ 6] = m1[10] + m1[14];
  d1[ 7] = m1[11] + m1[15];
  d1[ 8] = m1[ 0] - m1[ 4];
  d1[ 9] = m1[ 1] - m1[ 5];
  d1[10] = m1[ 2] - m1[ 6];
  d1[11] = m1[ 3] - m1[ 7];
  d1[12] = m1[12] - m1[ 8];
  d1[13] = m1[13] - m1[ 9];
  d1[14] = m1[14] - m1[10];
  d1[15] = m1[15] - m1[11];
end

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    m2[ 0] <= 0;
    m2[ 1] <= 0;
    m2[ 2] <= 0;
    m2[ 3] <= 0;
    m2[ 4] <= 0;
    m2[ 5] <= 0;
    m2[ 6] <= 0;
    m2[ 7] <= 0;
    m2[ 8] <= 0;
    m2[ 9] <= 0;
    m2[10] <= 0; 
    m2[11] <= 0; 
    m2[12] <= 0; 
    m2[13] <= 0; 
    m2[14] <= 0; 
    m2[15] <= 0; 
  end
  else begin
    if (en) begin
      m2[ 0] <= d1[ 0] + d1[ 3];
      m2[ 1] <= d1[ 1] + d1[ 2];
      m2[ 2] <= d1[ 1] - d1[ 2];
      m2[ 3] <= d1[ 0] - d1[ 3];
      m2[ 4] <= d1[ 4] + d1[ 7];
      m2[ 5] <= d1[ 5] + d1[ 6];
      m2[ 6] <= d1[ 5] - d1[ 6];
      m2[ 7] <= d1[ 4] - d1[ 7];
      m2[ 8] <= d1[ 8] + d1[11];
      m2[ 9] <= d1[ 9] + d1[10];
      m2[10] <= d1[ 9] - d1[10];
      m2[11] <= d1[ 8] - d1[11];
      m2[12] <= d1[12] + d1[15];
      m2[13] <= d1[13] + d1[14];
      m2[14] <= d1[13] - d1[14];
      m2[15] <= d1[12] - d1[15];
    end
    else begin
      m2[ 0] <= 0;
      m2[ 1] <= 0;
      m2[ 2] <= 0;
      m2[ 3] <= 0;
      m2[ 4] <= 0;
      m2[ 5] <= 0;
      m2[ 6] <= 0;
      m2[ 7] <= 0;
      m2[ 8] <= 0;
      m2[ 9] <= 0;
      m2[10] <= 0; 
      m2[11] <= 0; 
      m2[12] <= 0; 
      m2[13] <= 0; 
      m2[14] <= 0; 
      m2[15] <= 0; 
    end
  end
end

always_comb
begin
  d2[ 0] = m2[ 0] + m2[ 1];
  d2[ 1] = m2[ 0] - m2[ 1];
  d2[ 2] = m2[ 2] + m2[ 3];
  d2[ 3] = m2[ 3] - m2[ 2];
  d2[ 4] = m2[ 4] + m2[ 5];
  d2[ 5] = m2[ 4] - m2[ 5];
  d2[ 6] = m2[ 6] + m2[ 7];
  d2[ 7] = m2[ 7] - m2[ 6];
  d2[ 8] = m2[ 8] + m2[ 9];
  d2[ 9] = m2[ 8] - m2[ 9];
  d2[10] = m2[10] + m2[11];
  d2[11] = m2[11] - m2[10];
  d2[12] = m2[12] + m2[13];
  d2[13] = m2[12] - m2[13];
  d2[14] = m2[14] + m2[15];
  d2[15] = m2[15] - m2[14];
end
// lay gia tri tuyet doi cua cac gia tri HAD
always_ff @(posedge clk)
begin
  for(i = 0; i < 16; i++)
  begin
    if(d2[i] < 0)
    begin
        abs_d2[i] <= 0 - d2[i];
    end
    else
        abs_d2[i] <= d2[i];
  end
end
//tính SATD: Sum of Absolute Transformed Difference
always_comb 
begin
    abs0 = abs_d2[1] + abs_d2[2] + abs_d2[3];
    abs1 = abs_d2[4] + abs_d2[5] + abs_d2[6];
    abs2 = abs_d2[7] + abs_d2[8] + abs_d2[9];
    abs3 = abs_d2[10]+ abs_d2[11] + abs_d2[12];
    abs4 = abs_d2[13] + abs_d2[14] + abs_d2[15];
    tmp_had_4x4 = (abs_d2[0] >> 2) + abs0 + abs1 + abs2 + abs3 + abs4;
end
//tinh gia tri trung binh
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) begin
    had_4x4 <= 0;
  end
  else begin
    if(export_data_had) begin
      had_4x4 <= tmp_had_4x4 + 1 >> 1;
    end 
    else begin
      had_4x4 <= had_4x4;
    end
  end
end
endmodule : had