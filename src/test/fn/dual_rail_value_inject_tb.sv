`timescale 1ns / 1ps

module dual_rail_value_inject_tb();

localparam ENC = "TP";
localparam WIDTH = 32;
localparam RAIL_NUM = 2;

logic [WIDTH-1:0][RAIL_NUM-1:0] in_tb;
logic [WIDTH-1:0][RAIL_NUM-1:0] out_tb;

logic rst_tb = 0;
logic en_tb = 0;
logic [WIDTH-1:0] data_tb = 0;

dual_rail_value_inject#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
  .en                         (en_tb),
  .data                       (data_tb),
//---------LINK-IN--------------------
  .in                         (in_tb),
//---------LINK-OUT-------------------
  .out                        (out_tb)
//------------------------------------
);


dual_rail_driver#(.ENC(ENC), .WIDTH(WIDTH))
in_drv(.rst (rst_tb), .out(in_tb));

dual_rail_monitor#(.ENC(ENC), .WIDTH(WIDTH))
out_mon(.rst (rst_tb), .in(out_tb));

initial
begin

  rst_tb = 1;
  in_tb = '{default:'0};
  data_tb = 32'hABCD_1234;
  #100;    
  rst_tb = 0;
  #1000;
  en_tb = 1;
  #100;

  in_drv.drive(0);     #100;
  in_drv.drive(32'h01234567);     #100;
  in_drv.drive(0);     #100;
  in_drv.drive(32'h89abcdef);     #100;


  #1000;
  $finish;  
end

endmodule