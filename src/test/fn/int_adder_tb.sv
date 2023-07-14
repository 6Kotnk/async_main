`timescale 1ns / 1ps

module int_adder_tb();

localparam ENC = "FP";
localparam WIDTH = 32;
localparam RAIL_NUM = 2;

logic ack_o_tb;
logic ack_s_tb;
logic ack_c_tb;
logic ack_i_tb;

logic [WIDTH-1:0][RAIL_NUM-1:0] a_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] b_tb;
logic [RAIL_NUM-1:0]            c_in_tb;

logic [WIDTH-1:0][RAIL_NUM-1:0] s_tb;
logic [RAIL_NUM-1:0]            c_out_tb;


logic rst_tb = 0;
logic en_tb = 0;



int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .ack_o                      (ack_o_tb),
  .a                          (a_tb),
  .b                          (b_tb),
  .c_in                       (c_in_tb),
//---------LINK-OUT-------------------
  .ack_i                      (ack_i_tb),
  .s                          (s_tb),
  .c_out                      (c_out_tb)
//------------------------------------
);

logic [WIDTH:0][RAIL_NUM-1:0] test;
assign test = {c_out_tb,s_tb};

link_driver#(.ENC(ENC), .WIDTH(WIDTH))
a_drv(.rst (rst_tb), .ack_i (ack_o_tb), .out(a_tb));

link_driver#(.ENC(ENC), .WIDTH(WIDTH))
b_drv(.rst (rst_tb), .ack_i (ack_o_tb), .out(b_tb));

link_driver#(.ENC(ENC))
c_in_drv(.rst (rst_tb), .ack_i (ack_o_tb), .out(c_in_tb));

link_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_s_mon(.rst (rst_tb), .ack_o (ack_s_tb), .in(s_tb));

link_monitor#(.ENC(ENC), .WIDTH(1))
out_c_mon(.rst (rst_tb), .ack_o (ack_c_tb), .in(c_out_tb));

C_2
c_ack
(
  .rst(rst_tb),
  
  .in({ack_c_tb,ack_s_tb}),
  .out(ack_i_tb)
);

initial
begin

  rst_tb = 1;
  a_tb = '{default:'0};
  b_tb = '{default:'0};
  c_in_tb = '{default:'0};

  #100;    
  rst_tb = 0;
  #1000;
  
  fork
    a_drv.drive(0);     #100;
    b_drv.drive(0);     #100;
    c_in_drv.drive(0);  #100;
  join

  fork
    a_drv.drive(0);     #100;
    b_drv.drive(0);     #100;
    c_in_drv.drive(0);  #100;
  join

  fork
    a_drv.drive(-10);   #100;
    b_drv.drive(20);    #100;
    c_in_drv.drive(1);  #100;
  join

  fork
    a_drv.drive(12);    #100;
    b_drv.drive(15);    #100;
    c_in_drv.drive(1);  #100;
  join

  fork
    a_drv.drive(-1);    #100;
    b_drv.drive(-1);    #100;
    c_in_drv.drive(1);  #100;
  join

  #10000;
  $finish;  
end

endmodule