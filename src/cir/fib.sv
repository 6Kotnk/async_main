`timescale 1ns / 1ps


module fib#(
  parameter                   ENC = "TP",
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


logic add_done;
logic [WIDTH:0][RAIL_NUM-1:0]add_dat;
logic add_ack;

logic en;
assign en = add_done ^^ add_ack;

logic [RAIL_NUM-1:0]add_c_in;
assign add_c_in = {0,!add_ack};

logic [WIDTH:0][RAIL_NUM-1:0]add_r_dat;
logic add_r_ack;

logic [WIDTH:0][RAIL_NUM-1:0]reg_a_inj_dat;
logic [WIDTH:0][RAIL_NUM-1:0]reg_a_dat;
logic reg_a_add_ack;
logic reg_a_ack;

logic [WIDTH:0][RAIL_NUM-1:0]reg_b_inj_dat;
logic [WIDTH:0][RAIL_NUM-1:0]reg_b_dat;
logic reg_b_add_ack;
logic reg_b_ack;

assign reg_b_ack = ack_i;
assign out = reg_b_dat[WIDTH-1:0];

dual_rail_value_inject#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH+1)
)
inj_a
(
//---------CTRL-----------------------
  .rst                        (rst),
  .en                         (start),
  .data                       (1),
//---------LINK-IN--------------------
  .in                         (reg_a_dat),
//---------LINK-OUT-------------------
  .out                        (reg_a_inj_dat)
//------------------------------------
);

dual_rail_value_inject#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH+1)
)
inj_b
(
//---------CTRL-----------------------
  .rst                        (rst),
  .en                         (start),
  .data                       (1),
//---------LINK-IN--------------------
  .in                         (reg_b_dat),
//---------LINK-OUT-------------------
  .out                        (reg_b_inj_dat)
//------------------------------------
);

int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
fib_add
(
//---------CTRL-----------------------
  .rst                        (rst),
  .en                         (en),
//---------LINK-IN--------------------
  .a                          (reg_a_inj_dat[WIDTH-1:0]),
  .b                          (reg_b_inj_dat[WIDTH-1:0]),
  .c_in                       (add_c_in),
//---------LINK-OUT-------------------
  .s                          (add_dat[WIDTH-1:0]),
  .c_out                      (add_dat[WIDTH])
//------------------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH+1)
)
reg_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(add_dat),
  .cmpl(add_done)
//-----------------------------
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
  .ack_i                      (!reg_a_add_ack),
  .out                        (reg_a_dat)
);

C_2
c_a
(
  .rst(rst),
  
  .in({reg_a_ack,add_ack}),
  .out(reg_a_add_ack)
);

mem_reg#
(
  .ENC        (ENC),
  .WIDTH      (WIDTH+1)
)
regb
(
//---------CTRL-----------------------
  .rst                        (rst),
//---------LINK-IN--------------------
  .ack_o                      (reg_a_ack),
  .in                         (reg_a_inj_dat),
//------------------------------------
  .ack_i                      (!reg_b_add_ack),
  .out                        (reg_b_dat)
);

C_2
c_b
(
  .rst(rst),
  
  .in({reg_b_ack,add_ack}),
  .out(reg_b_add_ack)
);



endmodule
