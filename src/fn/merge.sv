`timescale 1ns / 1ps

module merge#(
  parameter                     ENC = "TP",
  parameter                     WIDTH = 1,
  localparam                    RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                         rst,
//---------LINK-IN1-------------------
  output                          ack_o0,
  input [WIDTH-1:0][RAIL_NUM-1:0] in0,
  //---------LINK-IN1-------------------
  output                          ack_o1,
  input [WIDTH-1:0][RAIL_NUM-1:0] in1,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

logic in0_done;
logic in1_done;


cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
done0
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(in0),
  .cmpl(in0_done)
//-----------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
done1
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(in1),
  .cmpl(in1_done)
//-----------------------------
);

C_2 ack0
(
  .rst(rst),
  
  .in({in0_done,ack_i}),
  .out(ack_o0)
);

C_2 ack1
(
  .rst(rst),
  
  .in({in1_done,ack_i}),
  .out(ack_o1)
);

assign out = in0 ^ in1;




endmodule
