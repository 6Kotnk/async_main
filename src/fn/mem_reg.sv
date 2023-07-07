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
  logic                           ack_out,
  logic [WIDTH-1:0][RAIL_NUM-1:0] in,
//---------LINK-OUT-------------------
  logic                           ack_in,
  logic [WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

logic [WIDTH-1:0][RAIL_NUM-1:0] cell_in_link ;
logic [WIDTH-1:0][RAIL_NUM-1:0] cell_out_link;

logic [WIDTH-1 : 0] cell_out_ack;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    //assign cell_in_link[bit_idx].data[0] = in.data[bit_idx];
    //assign cell_in_link[bit_idx].ack = in.ack ^ out.ack;
    //assign out.data[bit_idx] = cell_out_link[bit_idx].data[0];
    //assign cell_out_ack[bit_idx] = cell_out_link[bit_idx].ack;

    MEM_CELL#
    (
      .ENC(ENC)
    )
    mem_cell_reg
    (
      .rst(rst),
      
      .in(cell_in_link[bit_idx]),
      .out(cell_out_link[bit_idx])
    );
  end
endgenerate 


C#
(
  .IN_NUM(WIDTH)
)
c_collector
(
  .rst(rst),
  
  .in(cell_out_ack),
  .out(in.ack)
);




endmodule
