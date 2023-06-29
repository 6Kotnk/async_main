`timescale 1ns / 1ps


module int_adder#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
  input                                   en,
//---------LINK-IN--------------------
  input  [WIDTH-1:0][RAIL_NUM-1:0]        a,
  input  [WIDTH-1:0][RAIL_NUM-1:0]        b,
  input  [RAIL_NUM-1:0]                   c_in,
//---------LINK-OUT-------------------
  output [WIDTH-1:0][RAIL_NUM-1:0]        s,
  output [RAIL_NUM-1:0]                   c_out
//------------------------------------
);


logic [WIDTH:0][RAIL_NUM-1:0] carry_chain;
assign carry_chain[0] = c_in;
assign c_out = carry_chain[WIDTH];

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    full_adder#
    (
      .ENC  (ENC)
    )
    DUT
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
      .c_out                      (carry_chain[bit_idx + 1])
    //------------------------------------
    );

  end
endgenerate 



endmodule