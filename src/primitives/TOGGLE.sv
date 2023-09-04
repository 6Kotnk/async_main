`timescale 1ns / 1ps

module TOGGLE
(
//---------CTRL-----------------------
  input                           rst,
//---------IN-------------------------
  input                            in,
//---------OUT------------------------
  output [1 : 0]                  out
//------------------------------------
);

LUT4 #
(
    .INIT(16'h0074)
)
T_0
(
    .O  (out[0]),
    .I0 (out[1]),
    .I1 (in),
    .I2 (out[0]),
    .I3 (rst)
);

LUT4 #
(
    .INIT(16'h00E2)
)
T_1
(
    .O  (out[1]),
    .I0 (out[0]),
    .I1 (in),
    .I2 (out[1]),
    .I3 (rst)
);
endmodule