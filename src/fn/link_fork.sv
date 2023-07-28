`timescale 1ns / 1ps

module link_fork#(
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           start,
//---------LINK-IN--------------------
  output                          ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);


genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    assign out[bit_idx][1] = in[bit_idx][1] && start;
    assign out[bit_idx][0] = in[bit_idx][0] && start;
  end
endgenerate 

assign ack_o = ack_i;

endmodule
