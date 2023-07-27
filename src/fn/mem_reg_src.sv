`timescale 1ns / 1ps

module mem_reg_src#(
  parameter                    VAL = 0,
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

logic[WIDTH-1:0][RAIL_NUM-1:0] out;

genvar bit_idx;

generate

  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    assign out[bit_idx][1] = !ack_i &   VAL[bit_idx] ;
    assign out[bit_idx][0] = !ack_i & (!VAL[bit_idx]);
  end
endgenerate 

endmodule
