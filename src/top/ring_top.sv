`timescale 1ns / 1ps
(* DONT_TOUCH = "yes" *)
module ring_top(
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
localparam LEN = 7;
localparam RAIL_NUM = 2;

logic ack_o_sync;
logic ack_i_top;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_top;
logic [WIDTH-1:0] sync_top;

logic rst_top;

assign JA[1] = ack_o_sync;
assign JA[0] = ack_i_top;
assign rst_top = btnC;
logic rst_dbnc;

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
/*
debounce
DBNC
(
//---------CTRL-----------------------
  .clk                        (clk),
  .rst                        (rst_top),
//---------LINK-----------------------
  .in                         (rst_top),
  .out                        (rst_dbnc)
//------------------------------------
);
*/

logic osc;


(* DONT_TOUCH = "yes" *)
ring#
(
  .WIDTH      (WIDTH),
  .LEN        (LEN)
)
RING
(
//---------CTRL-----------------------
  .rst                        (rst_top),
//---------LINK-OUT-------------------
  .ack                        (osc),
  .data                       ()
//------------------------------------
);

ODDR #(
   .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
   .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_inst (
   .Q(ack_o_sync),   // 1-bit DDR output
   .C(osc),   // 1-bit clock input
   .CE(1), // 1-bit clock enable input
   .D1(1), // 1-bit data input (positive edge)
   .D2(0), // 1-bit data input (negative edge)
   .R(rst_top),   // 1-bit reset
   .S(0)    // 1-bit set
);



/*
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
*/
assign JB = sync_top;
//assign JC = 0;

endmodule