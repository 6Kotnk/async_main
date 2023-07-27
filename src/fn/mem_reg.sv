`timescale 1ns / 1ps

module mem_reg#(
  parameter                    INIT = "UNINITIALIZED", // If you make your bus this wide, you have bigger problems than this not working
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
logic[WIDTH-1:0][RAIL_NUM-1:0] out_int;

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
      
      .out(out_int[bit_idx])
    );

    if(INIT == "UNINITIALIZED")
    begin
      assign out[bit_idx] = out_int[bit_idx];
      assign lat_en = ack_o ^ ack_i;
    end
    else
    begin
      assign out[bit_idx][1] = out_int[bit_idx][1] ^   INIT[bit_idx];
      assign out[bit_idx][0] = out_int[bit_idx][0] ^ (!INIT[bit_idx]);
      assign lat_en = ack_o ^ !ack_i;
    end

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
  .in(out_int),
  .cmpl(ack_o)
//-----------------------------
);

endmodule
