`timescale 1ns / 1ps
(* DONT_TOUCH = "yes" *)
module fib_tp_top(
/*
  input rst_top,
  input ack_i_top,  
*/  
  input clk
);

localparam ENC = "TP";
localparam WIDTH = 8;
localparam RAIL_NUM = 2;

logic ack_i_top;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_top;
logic [WIDTH-1:0] sync_top;

logic rst_top;

vio_0
(
  .clk(clk),

  .probe_in0(sync_top),
  .probe_in1(out_top),

  .probe_out0(rst_top),
  .probe_out1(ack_i_top)

);


fib_tp#
(
  .WIDTH      (WIDTH)
)
FIB
(
//---------CTRL-----------------------
  .rst                        (rst_top),
  .clk                        (clk),
//---------LINK-OUT-------------------
  .ack_i                      (ack_i_top),
  .out                        (out_top)
//------------------------------------
);

sync#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
SYNC
(
//---------CTRL-----------------------
  .rst                        (rst_top),
//---------LINK-IN--------------------
  .ack_o                      (),
  .in                         (out_top),
//------------------------------------
  .out                        (sync_top)
);



endmodule