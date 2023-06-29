`timescale 1ns / 1ps

module int_adder_tb();

localparam ENC = "TP";
localparam WIDTH = 32;
localparam RAIL_NUM = 2;

logic [WIDTH-1:0][RAIL_NUM-1:0] a_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] b_tb;
logic [RAIL_NUM-1:0]            c_in_tb;

logic [WIDTH-1:0][RAIL_NUM-1:0] s_tb;
logic [RAIL_NUM-1:0]            c_out_tb;


logic rst_tb = 0;
logic en_tb = 0;

task automatic pulse_en;
begin
  #100;
  en_tb = 1;
  #100;
  en_tb = 0;
  #100;    
end
endtask

int_adder#
(
  .WIDTH  (WIDTH),
  .ENC    (ENC)
)
DUT
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

logic [WIDTH:0][RAIL_NUM-1:0] test;
assign test = {c_out_tb,s_tb};

dual_rail_driver#(.ENC(ENC), .WIDTH(WIDTH))
a_drv(.rst (rst_tb), .out(a_tb));

dual_rail_driver#(.ENC(ENC), .WIDTH(WIDTH))
b_drv(.rst (rst_tb), .out(b_tb));

dual_rail_driver#(.ENC(ENC))
c_in_drv(.rst (rst_tb), .out(c_in_tb));

dual_rail_monitor#(.ENC(ENC), .WIDTH(WIDTH+1))
out_mon(.rst (rst_tb), .in(test));

initial
begin

  rst_tb = 1;
  a_tb = '{default:'0};
  b_tb = '{default:'0};
  c_in_tb = '{default:'0};

  #100;    
  rst_tb = 0;
  #1000;
  
  a_drv.drive(0);     #100;
  b_drv.drive(0);     #100;
  c_in_drv.drive(0);  #100;

  pulse_en();

  a_drv.drive(0);     #100;
  b_drv.drive(0);     #100;
  c_in_drv.drive(0);  #100;

  pulse_en();

  a_drv.drive(-10);   #100;
  b_drv.drive(20);    #100;
  c_in_drv.drive(1);  #100;

  pulse_en();
  
  a_drv.drive(12);    #100;
  b_drv.drive(15);    #100;
  c_in_drv.drive(1);  #100;


  pulse_en();

  a_drv.drive(-1);    #100;
  b_drv.drive(-1);    #100;
  c_in_drv.drive(1);  #100;

  pulse_en();

  #1000;
  $finish;  
end

endmodule