`timescale 1ns / 1ps

module eq2#(
  parameter                    ENC = "TP",
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
  input                           en,
//---------LINK-IN--------------------
  input            [RAIL_NUM-1:0] in0,
//---------LINK-IN--------------------
  input            [RAIL_NUM-1:0] in1,
//---------LINK-OUT-------------------
  output           [RAIL_NUM-1:0] out
//------------------------------------
);

logic [RAIL_NUM-1:0] eq_xor;

xor2#
(
  .ENC  (ENC)
)
xor_inst
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in0(in0),
	.in1(in1),
	.out(eq_xor)
//-----------------------------
);

inv inv_inst
(
//-----------------------------
	.en(en),
	.in(eq_xor),
	.out(out)
//-----------------------------
);

endmodule
