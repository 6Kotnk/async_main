`timescale 1ns / 1ps
(* DONT_TOUCH = "yes" *)
module fib_tp_top(
/*
  input rst_top,
  input ack_i_top,  
*/  

  output [7:0] JA,
  
  output [7:0] JB,
  //output [7:0] JC,

  input btnC,
  
  input clk
);


localparam ENC = "TP";
localparam WIDTH = 8;
localparam RAIL_NUM = 2;


logic ack_o_sync;
logic ack_i_top;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_top;
logic [WIDTH-1:0] sync_top;

logic rst_top;

assign JA[1] = ack_o_sync;
assign JA[0] = ack_i_top;
assign rst_top = btnC;

/*
vio_0
(
  .clk(clk),

  .probe_in0(sync_top),
  .probe_in1(out_top),
  //.probe_in2(ack_o_sync),

  .probe_out0(rst_top),
  .probe_out1(ack_i_top)

);
*/


fib_tp#
(
  .WIDTH      (WIDTH)
)
FIB
(
//---------CTRL-----------------------
  .rst                        (rst_top),
//---------LINK-OUT-------------------
  .ack_i                      (ack_o_sync),
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
  .ack_o                      (ack_o_sync),
  .in                         (out_top),
//------------------------------------
  .out                        (sync_top)
);
/*

logic [7:0] r1;
logic [7:0] r2;
logic [7:0] r3;

always@(posedge clk)
begin
  if(rst_top)
  begin
    r1 <= 0;
  end
  else
  begin
    r1 <= r1 + r2;
  end
end

always@(posedge clk)
begin
  if(rst_top)
  begin
    r2 <= 1;
  end
  else
  begin
    r2 <= r1;
  end
end

always@(posedge clk)
begin
  if(rst_top)
  begin
    r3 <= 0;
  end
  else
  begin
    r3 <= r3 + 1;
  end
end

assign ack_o_sync = r3[2];
*/
assign JB = sync_top;
//assign JC = 0;

endmodule