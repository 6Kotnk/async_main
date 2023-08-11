`timescale 1ns / 1ps

module fib_tp_tb();

localparam ENC = "TP";
localparam WIDTH = 8;

localparam RAIL_NUM = 2;

logic ack_i_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_tb;
logic [WIDTH-1:0] sync_tb;

logic rst_tb = 0;
logic start_tb = 0;

fib_tp#
(
  .WIDTH      (WIDTH)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
  .start                      (start_tb),
//---------LINK-OUT-------------------
  .ack_i                      (ack_i_tb),
  .out                        (out_tb)
//------------------------------------
);

sync#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
SYNC
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .ack_o                      (ack_i_tb),
  .in                         (out_tb),
//------------------------------------
  .out                        (sync_tb)
);

dual_rail_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .in(out_tb));


initial
begin

  rst_tb = 1;
  start_tb = 0;

  #2000;    
  rst_tb = 0;
  #15000;

  start_tb = 1;

  repeat(10)@(ack_i_tb);
  
  #100;
  $finish;  
end


/*
parameter INIT_A = 1;
parameter INIT_B = 0;
parameter INIT_CIN = 0;
parameter WIDTH = 8;

function calc_init (integer calc_bit_idx);

  integer bit_idx;

  logic [WIDTH - 1:0] init_s = 0;
  logic [WIDTH:0] init_carry = 0;

  init_carry[0] = INIT_CIN;

  for (bit_idx = 0; bit_idx <= calc_bit_idx ; bit_idx = bit_idx + 1)
  begin 
    init_s[bit_idx] = INIT_A[bit_idx] ^^ INIT_B[bit_idx] ^^ init_carry[bit_idx];
    init_carry[bit_idx + 1] = 
    (INIT_A[bit_idx] && INIT_B[bit_idx]) ||
    (INIT_B[bit_idx] && init_carry[bit_idx]) ||
    (INIT_A[bit_idx] && init_carry[bit_idx]);
  end

  return {init_carry[calc_bit_idx + 1],init_s[calc_bit_idx]};
endfunction

initial
begin


  integer i;

  for(i = 0; i < WIDTH; i++)
  begin
    integer test = calc_init(i);
    $display("=====================");
    $display(test[0]);
    $display(test[1]);
  end

  $finish;  



end


  */
















endmodule