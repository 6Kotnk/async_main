`timescale 1ns / 1ps

module ring#(
  parameter                   WIDTH = 32,
  parameter                   LEN = 32,
  localparam                  RAIL_NUM = 2  

)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-OUT-------------------
  output                          ack,
  output [WIDTH-1:0][RAIL_NUM-1:0]data
//------------------------------------
);
/*
(* DONT_TOUCH = "yes" *)
logic chain[LEN-1:0];

assign data = 0;
assign ack = chain[0];

(* DONT_TOUCH = "yes" *)
assign #10 chain[0] = !(chain[LEN-1] && !rst);

genvar idx;
generate;
  for (idx=0; idx < LEN-1; idx++) 
  begin
    (* DONT_TOUCH = "yes" *)
    assign #10 chain[idx+1] = !chain[idx];
  end
endgenerate
*/




localparam DENSITY = 32;
localparam ENC = "TP";

logic [WIDTH-1:0][RAIL_NUM-1:0]conn_data[LEN:0];
logic conn_ack[LEN:0];

assign conn_data[0] = conn_data[LEN];
assign conn_ack[LEN] = conn_ack[0];

assign data = conn_data[LEN];
assign ack = conn_ack[LEN];


genvar idx;
generate;
  for (idx=0; idx < LEN; idx++) 
  begin
    if((idx % DENSITY) == 0)
    begin
    mem_reg#
    (
      .INIT       (idx),
      .ENC        (ENC),
      .WIDTH      (WIDTH)
    )
    reg_n_init
    (
    //---------CTRL-----------------------
      .rst                        (rst),
    //---------LINK-IN--------------------
      .ack_o                      (conn_ack[idx]),
      .in                         (conn_data[idx]),
    //------------------------------------
      .ack_i                      (conn_ack[idx+1]),
      .out                        (conn_data[idx+1])
    );
    end
    else
    begin
    mem_reg#
    (
      .ENC        (ENC),
      .WIDTH      (WIDTH)
    )
    reg_n
    (
    //---------CTRL-----------------------
      .rst                        (rst_glbl),
    //---------LINK-IN--------------------
      .ack_o                      (conn_ack[idx]),
      .in                         (conn_data[idx]),
    //------------------------------------
      .ack_i                      (conn_ack[idx+1]),
      .out                        (conn_data[idx+1])
    );
    end
   

  end
endgenerate


endmodule
