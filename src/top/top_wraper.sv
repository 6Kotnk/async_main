`timescale 1ns / 1ps

module top_wraper(
  input clk
);

(* DONT_TOUCH = "yes" *) fib_tp_top top
(
  .clk(clk)
);

endmodule