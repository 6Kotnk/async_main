`timescale 1ns / 1ps

module dual_rail_value_inject#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
  input                                   en,
  input  [WIDTH-1:0]                      data,
//---------LINK-IN--------------------
  input  logic [WIDTH-1:0][RAIL_NUM-1:0]  in,
//---------LINK-OUT-------------------
  output logic [WIDTH-1:0][RAIL_NUM-1:0]  out
//------------------------------------
);


genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    assign out[bit_idx][1] = in[bit_idx][1] ^ ( data[bit_idx] && en);
    assign out[bit_idx][0] = in[bit_idx][0] ^ (!data[bit_idx] && en);
  end
endgenerate 


endmodule
