`timescale 1ns / 1ps

module fib_fp#(
  parameter                   WIDTH = 32,
  localparam                  RAIL_NUM = 2  

)
(
//---------CTRL-----------------------
  input                           rst,
  input                         start,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

localparam ENC = "FP";

logic [WIDTH:0][RAIL_NUM-1:0]add_dat;
logic add_ack;
logic add_in_ack;

logic [RAIL_NUM-1:0]add_c_in;

mem_reg_src#
(
  .VAL        (0),
  .WIDTH      (1)
)
carry_src
(
//------------------------------------
  .ack_i                      (add_in_ack),
  .out                        (add_c_in)
);

logic [WIDTH:0][RAIL_NUM-1:0]r1_dat;
logic r1_ack;

logic [WIDTH:0][RAIL_NUM-1:0]r2_dat;
logic r2_ack;

logic [WIDTH:0][RAIL_NUM-1:0]r3_dat;
logic r3_ack;
logic r3_ack1;

logic [WIDTH:0][RAIL_NUM-1:0]r4_dat;
logic r4_ack;

logic [WIDTH:0][RAIL_NUM-1:0]r5_dat;
logic r5_ack;

logic [WIDTH:0][RAIL_NUM-1:0]r5_dat_b;
logic r5_add_ack_b;
logic r5_ack1;


assign r5_ack1 = ack_i;
assign out = r5_dat[WIDTH-1:0];


int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
fib_add
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (add_in_ack),
  .a                          (r3_dat[WIDTH-1:0]),
  .b                          (r5_dat_b[WIDTH-1:0]),
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

mem_reg#
(
  .INIT       (1),
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg3
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (r2_ack),
  .in                         (r2_dat),
//------------------------------------
  .ack_i                      (r3_ack),
  .out                        (r3_dat)
);

C_2
c_r3
(
  .rst(rst),
  
  .in({r3_ack1,add_in_ack}),
  .out(r3_ack)
);

mem_reg#
(
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg4
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (r3_ack1),
  .in                         (r3_dat),
//------------------------------------
  .ack_i                      (r4_ack),
  .out                        (r4_dat)
);

mem_reg#
(
  .INIT       (0),
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg5
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (r4_ack),
  .in                         (r4_dat),
//------------------------------------
  .ack_i                      (r5_ack),
  .out                        (r5_dat)
);

barrier#
(
  .WIDTH      (WIDTH+1)
)
barrier
(//---------CTRL-----------------------
  .start                      (start),
//---------LINK-IN--------------------
  .ack_o                      (r5_ack),
  .in                         (r5_dat),
//------------------------------------
  .ack_i                      (r5_add_ack_b),
  .out                        (r5_dat_b)
);

C_2
c_r5
(
  .rst(rst),
  
  .in({r5_ack1,add_in_ack}),
  .out(r5_add_ack_b)
);

endmodule
