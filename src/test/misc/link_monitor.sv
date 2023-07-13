`timescale 1ns / 1ps


module link_monitor#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  output logic                    ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in
//------------------------------------
);

logic [WIDTH-1:0][RAIL_NUM-1:0] in_state = '{default:'0};
logic [WIDTH-1:0] bit_complete;
logic ack_pre;

always @ ( ack_pre )
begin
  #100;
  ack_o <= ack_pre;
end

string str;

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
  .out(ack_pre)
);

always @ ( ack_o )
begin
  //$display($signed(display_val));
  //str.hextoa(display_val);
  //$display(display_val,str.toupper);
  //in_state <= in;
  $display("DECIMAL:%d      HEX:0x%h",display_val,display_val);
  in_state <= in;
end

endmodule