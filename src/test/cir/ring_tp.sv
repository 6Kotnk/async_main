`timescale 1ns / 1ps

module ring_tb();

localparam ENC = "TP";
localparam WIDTH = 8;
localparam LEN = 127;

localparam RAIL_NUM = 2;

logic ack_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_tb;
logic [WIDTH-1:0] sync_tb;

logic rst_tb = 0;


ring#
(
  .WIDTH      (WIDTH),
  .LEN        (LEN)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-OUT-------------------
  .ack                        (ack_tb),
  .data                       (out_tb)
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
  .ack_o                      (),
  .in                         (out_tb),
//------------------------------------
  .out                        (sync_tb)
);

dual_rail_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .in(out_tb));


initial
begin

  rst_tb = 1;
  //ack_i_tb = 0;
  
  /*
  #1000;
  rst_tb = 1;
  #1000;
  rst_tb = 0;
  */
  
  #1000;
  rst_tb = 1;
  #2000;    
  rst_tb = 0;
  #15000;

  repeat(10)
  begin
    #10000;
    //ack_i_tb = !ack_i_tb;
  end
  
  
  #10000;
  $finish;  
end

endmodule