`timescale 1ns / 1ps


module full_adder#(
  parameter            ENC = "TP",

  parameter            INIT_C0 = 0,
  parameter            INIT_C1 = 0,
  parameter            INIT_S0 = 0,
  parameter            INIT_S1 = 0,

  localparam           RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
  input                            en,
//---------LINK-IN--------------------
  input  [RAIL_NUM-1:0]             a,
  input  [RAIL_NUM-1:0]             b,
  input  [RAIL_NUM-1:0]          c_in,
//---------LINK-OUT-------------------
  output [RAIL_NUM-1:0]             s,
  output [RAIL_NUM-1:0]         c_out,
//------------------------------------
  output                          dbg_en,
  output  [4-1 : 0]          dbg_in,
  output                          dbg_out,
  output  [4-1 : 0]          dbg_in_p

);


TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_0_2"),
  .INIT (INIT_C0)
)
c_out_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({a[0],b[0],c_in[0]}),
	.out(c_out[0])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_0_2"),
  .INIT (INIT_C1)
)
c_out_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en),
	.in({a[1],b[1],c_in[1]}),
	.out(c_out[1])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("4_1_3"),
  .INIT (INIT_S0)
)
s_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en),
	.in({a[0],b[0],c_in[0],c_out[1]}),
	.out(s[0]),
//-----------------------------
  .dbg_en(dbg_en),
  .dbg_in(dbg_in),
  .dbg_out(dbg_out),
  .dbg_in_p(dbg_in_p)
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("4_1_3"),
  .INIT (INIT_S1)
)
s_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en),
	.in({a[1],b[1],c_in[1],c_out[0]}),
	.out(s[1])
//-----------------------------
);





endmodule
