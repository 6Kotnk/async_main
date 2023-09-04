`timescale 1ns / 1ps

module MEM_CELL#(
  parameter                     INIT = 0,
  parameter                     ENC = "TP",
  localparam                    RAIL_NUM = 2
  
)
(
//---------CTRL-----------------------
  input                         rst,
//---------LINK-IN--------------------
  input                       lat_i,
  input   [RAIL_NUM-1 : 0]       in,
//---------LINK-OUT-------------------
  output  [RAIL_NUM-1 : 0]      out
//------------------------------------
);

logic [RAIL_NUM-1 : 0] out_r = INIT;

assign #73 out = out_r;

always@(*)
begin
  if(rst)
  begin
    out_r = INIT;
  end
  else
  begin
    if(!lat_i)
    begin
      out_r = in;
    end
  end
end


endmodule
