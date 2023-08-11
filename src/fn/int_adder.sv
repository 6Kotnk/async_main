`timescale 1ns / 1ps


module int_adder#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,

  parameter                    INIT_EN = 0,

  parameter                    INIT_A = 0,
  parameter                    INIT_B = 0,
  parameter                    INIT_CIN = 0,

  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
//---------LINK-IN--------------------
  output                                  ack_o,
  input  [WIDTH-1:0][RAIL_NUM-1:0]        a,
  input  [WIDTH-1:0][RAIL_NUM-1:0]        b,
  input  [RAIL_NUM-1:0]                   c_in,
//---------LINK-OUT-------------------
  input                                   ack_i,
  output [WIDTH-1:0][RAIL_NUM-1:0]        s,
  output [RAIL_NUM-1:0]                   c_out,
//------------------------------------
  input                           clk
);

function calc_init (integer calc_bit_idx);

  integer bit_idx;

  logic [WIDTH - 1:0] init_s = 0;
  logic [WIDTH:0] init_carry = 0;

  init_carry[0] = INIT_CIN;

  for (bit_idx = 0; bit_idx <= calc_bit_idx ; bit_idx = bit_idx + 1)
  begin 
    init_s[bit_idx] = INIT_A[bit_idx] ^^ INIT_B[bit_idx] ^^ init_carry[bit_idx];
    init_carry[bit_idx + 1] = 
    (INIT_A[bit_idx] && INIT_B[bit_idx]) ||
    (INIT_B[bit_idx] && init_carry[bit_idx]) ||
    (INIT_A[bit_idx] && init_carry[bit_idx]);
  end

  return {init_carry[calc_bit_idx + 1],init_s[calc_bit_idx]};
endfunction


logic en;
logic out_done;
logic in_done;
logic done;
assign en = done ^^ ack_i;

logic [WIDTH:0][RAIL_NUM-1:0] carry_chain;
assign carry_chain[0] = c_in;
assign c_out = carry_chain[WIDTH];

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    localparam [1:0] bit_init = calc_init(bit_idx);

    logic dbg_en;
    logic [3:0] dbg_in;
    logic dbg_out;
    logic [3:0] dbg_in_p;

    if(INIT_EN)
    begin
      full_adder#
      (
        .ENC  (ENC),

        .INIT_C0(!bit_init[1]),
        .INIT_C1( bit_init[1]),
        .INIT_S0(!bit_init[0]),
        .INIT_S1( bit_init[0])
      )
      fa
      (
      //---------CTRL-----------------------
        .rst                        (rst),
        .en                         (en),
      //---------LINK-IN--------------------
        .a                          (a[bit_idx]),
        .b                          (b[bit_idx]),
        .c_in                       (carry_chain[bit_idx]),
      //---------LINK-OUT-------------------
        .s                          (s[bit_idx]),
        .c_out                      (carry_chain[bit_idx + 1]),
      //------------------------------------
        .dbg_en(dbg_en),
        .dbg_in(dbg_in),
        .dbg_out(dbg_out),
        .dbg_in_p(dbg_in_p)
      );
    end
    else
    begin
      full_adder#
      (
        .ENC  (ENC)
      )
      fa
      (
      //---------CTRL-----------------------
        .rst                        (rst),
        .en                         (en),
      //---------LINK-IN--------------------
        .a                          (a[bit_idx]),
        .b                          (b[bit_idx]),
        .c_in                       (carry_chain[bit_idx]),
      //---------LINK-OUT-------------------
        .s                          (s[bit_idx]),
        .c_out                      (carry_chain[bit_idx + 1]),
      //------------------------------------
        .dbg_en(dbg_en),
        .dbg_in(dbg_in),
        .dbg_out(dbg_out),
        .dbg_in_p(dbg_in_p)
      );
    end

    
    if(bit_idx == 0)
    begin
    `ifndef SIM

vio_1
(
  .clk(clk),

  .probe_in0(dbg_en),
  .probe_in1(dbg_in),
  .probe_in2(dbg_out),
  .probe_in3(dbg_in_p)

);

`endif
    end

  end
endgenerate 





cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH+1)
)
out_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(carry_chain),
  .cmpl(out_done)
//-----------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (2*(WIDTH) + 1)
)
in_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in({a,b,c_in}),
  .cmpl(in_done)
//-----------------------------
);

C_2
c_done
(
  .rst(rst),
  
  .in({out_done,in_done}),
  .out(done)
);


C_2
c_a
(
  .rst(rst),
  
  .in({done,ack_i}),
  .out(ack_o)
);

endmodule