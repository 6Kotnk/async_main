`timescale 1ns / 1ps

module full_adder_tb();

localparam ENC = "TP";
localparam RAIL_NUM = 2;

logic [RAIL_NUM-1:0] a_tb;
logic [RAIL_NUM-1:0] b_tb;
logic [RAIL_NUM-1:0] c_in_tb;

logic [RAIL_NUM-1:0] s_tb;
logic [RAIL_NUM-1:0] c_out_tb;


logic rst_tb = 0;
logic en_tb = 0;

task automatic pulse_en;
begin
  if(ENC == "TP")
  begin
    #100;
    en_tb = 1;
    #100;
    en_tb = 0;
    #100; 
  end
end
endtask

full_adder_tgl#
(
  .ENC  (ENC)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .a                          (a_tb),
  .b                          (b_tb),
  .c_in                       (c_in_tb),
//---------LINK-OUT-------------------
  .s                          (s_tb),
  .c_out                      (c_out_tb)
//------------------------------------
);

logic [2-1:0][RAIL_NUM-1:0] test;
assign test = {c_out_tb,s_tb};

dual_rail_driver#(.ENC(ENC))
a_drv(.rst (rst_tb), .out(a_tb));

dual_rail_driver#(.ENC(ENC))
b_drv(.rst (rst_tb), .out(b_tb));

dual_rail_driver#(.ENC(ENC))
c_out_drv(.rst (rst_tb), .out(c_in_tb));

dual_rail_monitor#(.ENC(ENC), .WIDTH(2))
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

  fork
    a_drv.drive(0);     #1000;
    b_drv.drive(0);     #1000;
    c_out_drv.drive(0); #1000;
  join
  pulse_en();
  fork
    a_drv.drive(1);     #1000;
    b_drv.drive(0);     #1000;
    c_out_drv.drive(0); #1000;
  join
  pulse_en();
  fork
    a_drv.drive(1);     #1000;
    b_drv.drive(1);     #1000;
    c_out_drv.drive(1); #1000;
  join
  pulse_en();
  fork
    a_drv.drive(1);     #1000;
    b_drv.drive(0);     #1000;
    c_out_drv.drive(1); #1000;
  join
  pulse_en();

  #1000;
  $finish;  
end

endmodule