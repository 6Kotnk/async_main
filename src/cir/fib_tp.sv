`timescale 1ns / 1ps

module fib_tp#(
  parameter                   WIDTH = 32,
  localparam                  RAIL_NUM = 2  

)
(
//---------CTRL-----------------------
  input                           rst,
  input                           clk,
  input                         start,
//---------LINK-OUT-------------------
  input                           ack_i,
  output[WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);


/*
vio_1
(
  .clk(clk),

  .probe_in0(add_ack),
  .probe_in1(add_in_ack),
  .probe_in2(add_r_ack),
  
  .probe_in3(reg_a_ack),
  .probe_in4(reg_a_ack1),
  
  .probe_in5(reg_b_ack),
  .probe_in6(reg_b_ack1),
  .probe_in7(reg_b_add_ack_b)

);
*/

localparam ENC = "TP";

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

logic [WIDTH:0][RAIL_NUM-1:0]add_r_dat;
logic add_r_ack;


logic [WIDTH:0][RAIL_NUM-1:0]reg_a_dat;
logic reg_a_ack;
logic reg_a_ack1;

logic [WIDTH:0][RAIL_NUM-1:0]reg_b_dat;
logic reg_b_ack;

logic [WIDTH:0][RAIL_NUM-1:0]reg_b_dat_b;
logic reg_b_add_ack_b;
logic reg_b_ack1;


assign reg_b_ack1 = ack_i;
assign out = reg_b_dat[WIDTH-1:0];


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
  .a                          (reg_a_dat[WIDTH-1:0]),
  .b                          (reg_b_dat_b[WIDTH-1:0]),
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
adder_reg
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (add_ack),
  .in                         (add_dat),
//------------------------------------
  .ack_i                      (add_r_ack),
  .out                        (add_r_dat)
);

mem_reg#
(
  .INIT       (1),
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
reg_a
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (add_r_ack),
  .in                         (add_r_dat),
//------------------------------------
  .ack_i                      (reg_a_ack),
  .out                        (reg_a_dat)
);

C_2
c_a
(
  .rst(rst),
  
  .in({reg_a_ack1,add_in_ack}),
  .out(reg_a_ack)
);


mem_reg#
(
  .INIT       (0),
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
regb
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (reg_a_ack1),
  .in                         (reg_a_dat),
//------------------------------------
  .ack_i                      (reg_b_ack),
  .out                        (reg_b_dat)
);

barrier#
(
  .WIDTH      (WIDTH+1)
)
barrier
(//---------CTRL-----------------------
  .start                      (start),
//---------LINK-IN--------------------
  .ack_o                      (reg_b_ack),
  .in                         (reg_b_dat),
//------------------------------------
  .ack_i                      (reg_b_add_ack_b),
  .out                        (reg_b_dat_b)
);

C_2
c_b
(
  .rst(rst),
  
  .in({reg_b_ack1,add_in_ack}),
  .out(reg_b_add_ack_b)
);

endmodule
