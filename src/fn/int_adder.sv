`timescale 1ns / 1ps


module int_adder#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
//---------LINK-IN--------------------
  output                                  ack_o,
  input  [WIDTH-1:0][RAIL_NUM-1:0]        a,
  input  [WIDTH-1:0][RAIL_NUM-1:0]        b,
  input  [RAIL_NUM-1:0]                   c_in,
//---------LINK-OUT-------------------
  input                                   ack_i,
  output [WIDTH-1:0][RAIL_NUM-1:0]        s,
  output [RAIL_NUM-1:0]                   c_out
//------------------------------------
);

logic en;
logic out_done;
logic in_done;
logic done;
assign en = done ^^ ack_i;

logic [WIDTH:0][RAIL_NUM-1:0] carry_chain;
assign carry_chain[0] = c_in;
assign c_out = carry_chain[WIDTH];

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    full_adder#
    //full_adder#
    (
      .ENC  (ENC)
    )
    fa
    (
    //---------CTRL-----------------------
      .rst                        (rst),
      //.en                         (en),
    //---------LINK-IN--------------------
      .a                          (a[bit_idx]),
      .b                          (b[bit_idx]),
      .c_in                       (carry_chain[bit_idx]),
    //---------LINK-OUT-------------------
      .s                          (s[bit_idx]),
      .c_out                      (carry_chain[bit_idx + 1])
    //------------------------------------
    );

  end
endgenerate 

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH+1)
)
out_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(carry_chain),
  .cmpl(out_done)
//-----------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (2*WIDTH+1)
)
in_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in({a,b,c_in}),
  .cmpl(in_done)
//-----------------------------
);

C_2
c_done
(
  .rst(rst),
  
  .in({out_done,in_done}),
  .out(done)
);


C_2
c_a
(
  .rst(rst),
  
  .in({done,ack_i}),
  .out(ack_o)
);

endmodule