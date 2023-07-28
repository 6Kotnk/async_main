`timescale 1ns / 1ps

module flip#(
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------LINK-IN--------------------
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

localparam SPLITPOINT = WIDTH/2;

assign out[SPLITPOINT-1:0] = in[WIDTH-1:SPLITPOINT];
assign out[WIDTH-1:SPLITPOINT] = in[SPLITPOINT-1:0];

endmodule
