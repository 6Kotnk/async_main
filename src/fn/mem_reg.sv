`timescale 1ns / 1ps

module mem_reg#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  output                          ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);


logic lat_en;
assign lat_en = ack_o ^ ack_i;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 


    MEM_CELL#
    (
      .ENC(ENC)
    )
    reg_mem_cell
    (
      .rst(rst),
      
      .in(in[bit_idx]),
      .lat_i(lat_en),
      
      .out(out[bit_idx])
    );
  end
endgenerate 


cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
reg_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(out),
  .cmpl(ack_o)
//-----------------------------
);




endmodule
