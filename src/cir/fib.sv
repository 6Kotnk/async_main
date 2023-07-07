`timescale 1ns / 1ps


module fib#(
  parameter            ENC = "TP",
  parameter            WIDTH = 32
)
(
//---------CTRL-----------------------
  input                           rst,
  input                         start,
//----------IN------------------------
  input                          next,
//---------LINK-OUT-------------------
  link_intf.out                  out
//------------------------------------
);








/*

int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
fib_add
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
  .en                         (en_tb),
//---------LINK-IN--------------------
  .a                          (a_tb),
  .b                          (b_tb),
  .c_in                       (c_in_tb),
//---------LINK-OUT-------------------
  .s                          (s_tb),
  .c_out                      (c_out_tb)
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
  .rst                        (rst_tb),
  .en                         (en_tb),
//---------LINK-IN--------------------
  .a                          (a_tb),
  .b                          (b_tb),
  .c_in                       (c_in_tb),
//---------LINK-OUT-------------------
  .s                          (s_tb),
  .c_out                      (c_out_tb)
//------------------------------------
);

mem_reg

mem_reg


*/


endmodule
