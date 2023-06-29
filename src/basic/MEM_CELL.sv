`timescale 1ns / 1ps

import link_pkg::*;

module MEM_CELL#(
  parameter                     ENC = "TP"
  
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  link_intf.in                     in,
//---------LINK-OUT-------------------
  link_intf.out                   out
//------------------------------------
);

// Two phase latches can be used for four phase systems

multi_rail_bit out_r = 0;
logic ack;

assign ack = ^out_r;
assign out.ack = ack;
assign out.data = out_r;

always@(*)
begin
  if(rst)
  begin
    out_r = 0;
  end
  else
  begin
    if(!in.ack)
    begin
      out_r = in.data;
    end
  end
end



endmodule
