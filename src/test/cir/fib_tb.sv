`timescale 1ns / 1ps

module fib_tb();

localparam ENC = "TP";
localparam WIDTH = 32;
localparam RAIL_NUM = 2;

logic ack_i_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_tb;

logic rst_tb = 0;
logic start_tb = 0;

fib#
(
  .ENC        (ENC),
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

link_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .ack_o (ack_i_tb), .in(out_tb));

initial
begin

  rst_tb = 1;
  start_tb = 0;

  #100;    
  rst_tb = 0;
  #1000;

  start_tb = 1;
/*
  repeat(10)
  begin
    #100;
    ack_i_tb = !ack_i_tb;
  end
*/
  #1000;
  $finish;  
end

endmodule