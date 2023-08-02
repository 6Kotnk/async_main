`timescale 1ns / 1ps

module fib_fp_tb();

localparam ENC = "FP";
localparam WIDTH = 32;
localparam RAIL_NUM = 2;

logic ack_i_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_tb;
logic [WIDTH-1:0] sync_tb;

logic rst_tb = 0;
logic start_tb = 0;

fib_fp#
(
  .WIDTH      (WIDTH)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
  .start                      (start_tb),
//---------LINK-OUT-------------------
  .ack_i                      (ack_i_tb),
  .out                        (out_tb)
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
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .ack_o                      (ack_i_tb),
  .in                         (out_tb),
//------------------------------------
  .out                        (sync_tb)
);

/*
link_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .ack_o (ack_i_tb), .in(out_tb));
*/

dual_rail_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .in(out_tb));

initial
begin

  rst_tb = 1;
  start_tb = 0;

  #2000;    
  rst_tb = 0;
  #2000;

  start_tb = 1;

  repeat(10)@(posedge ack_i_tb);

  #100;
  $finish;  
end

endmodule