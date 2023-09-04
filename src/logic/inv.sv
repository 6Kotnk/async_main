`timescale 1ns / 1ps

module inv#(
  parameter                    ENC = "TP",
  localparam                   RAIL_NUM = 2
)
(

//---------LINK-IN--------------------
  input            [RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  output           [RAIL_NUM-1:0] out
//------------------------------------
);

assign out[0] = in[1];
assign out[1] = in[0];

endmodule
