`timescale 1ns / 1ps


module dual_rail_monitor#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
//---------LINK-OUT-------------------
  input  logic [WIDTH-1:0][RAIL_NUM-1:0]  in
//------------------------------------
);

logic [WIDTH-1:0][RAIL_NUM-1:0] in_state = '{default:'0};
logic in_complete;
logic [WIDTH-1:0] bit_complete;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    assign bit_complete[bit_idx] = ^in[bit_idx];
  end
endgenerate

logic [WIDTH-1:0] display_val;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    assign display_val[bit_idx] = ((in_state[bit_idx] ^ in[bit_idx]) ==  2);
  end
endgenerate

C#
(
  .IN_NUM(WIDTH)
)
c_collector
(
  .rst(rst),
  
  .in(bit_complete),
  .out(in_complete)
);

always @ ( in_complete )
begin
  $display($signed(display_val));
  in_state <= in;
end

endmodule