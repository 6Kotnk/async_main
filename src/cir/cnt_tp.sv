`timescale 1ns / 1ps

module cnt_tp#(
  parameter                   WIDTH = 32,
  localparam                  RAIL_NUM = 2  

)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

localparam ENC = "TP";

logic [WIDTH:0][RAIL_NUM-1:0]add_dat;
logic add_ack;
logic add_in_ack;

logic [RAIL_NUM-1:0]add_c_in;
logic [WIDTH-1:0][RAIL_NUM-1:0]add_b_in;

mem_reg_src#
(
  .VAL        (1),
  .WIDTH      (1)
)
inc_src
(
//------------------------------------
  .ack_i                      (add_in_ack),
  .out                        (add_c_in)
);

mem_reg_src#
(
  .VAL        (0),
  .WIDTH      (WIDTH)
)
zero_src
(
//------------------------------------
  .ack_i                      (add_in_ack),
  .out                        (add_b_in)
);

logic [WIDTH:0][RAIL_NUM-1:0]r1_dat;
logic r1_ack;

logic [WIDTH:0][RAIL_NUM-1:0]r2_dat;
logic r2_ack;
logic r2_ack1;

assign r2_ack1 = ack_i;
assign out = r2_dat[WIDTH-1:0];


int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
cnt_add
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (add_in_ack),
  .a                          (r2_dat[WIDTH-1:0]),
  .b                          (add_b_in),
  .c_in                       (add_c_in),
//---------LINK-OUT-------------------
  .ack_i                      (add_ack),
  .s                          (add_dat[WIDTH-1:0]),
  .c_out                      (add_dat[WIDTH])
//------------------------------------
);


mem_reg#
(
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg1
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (add_ack),
  .in                         (add_dat),
//------------------------------------
  .ack_i                      (r1_ack),
  .out                        (r1_dat)
);

mem_reg#
(
  .INIT       (0),
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg2
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (r1_ack),
  .in                         (r1_dat),
//------------------------------------
  .ack_i                      (r2_ack),
  .out                        (r2_dat)
);

C_2
c_r2
(
  .rst(rst),
  
  .in({r2_ack1,add_in_ack}),
  .out(r2_ack)
);

endmodule
