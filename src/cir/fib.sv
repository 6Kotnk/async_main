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

vector of injectors

adder

mem_reg

mem_reg


*/


endmodule
