`timescale 1ns / 1ps

module cmpl_det#(
  parameter                     ENC = "TP",
  parameter                     WIDTH = 1,
  localparam                    RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                         rst,
//---------LINK-IN--------------------
  input[WIDTH-1:0][RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  output                       cmpl
//------------------------------------
);

logic [WIDTH-1:0] cmpl_bit;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin
    assign cmpl_bit[bit_idx] = ^in[bit_idx];
  end
endgenerate 

C#
(
  .IN_NUM(WIDTH)
)
c_collector
(
  .rst(rst),
  
  .in(cmpl_bit),
  .out(cmpl)
);

endmodule
