`timescale 1ns / 1ps

import link_pkg::*;

module mem_reg_tb();

localparam ENC = "TP";

logic rst_tb = 0;



localparam REG_WIDTH = 2;



link_intf #(.LINK_WIDTH(REG_WIDTH)) in_link_tb();
link_intf #(.LINK_WIDTH(REG_WIDTH))out_link_tb();

mem_reg#
(
  .REG_WIDTH  (REG_WIDTH),
  .ENC        (ENC)
)
DUT2
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .in                     (in_link_tb),
//------------------------------------
  .out                   (out_link_tb)
);


initial
begin

  in_link_tb.data = '{default:'0};
  in_link_tb.ack = '{default:'0};

  out_link_tb.data = '{default:'0};
  out_link_tb.ack = '{default:'0};


  rst_tb = 1;
  #100;    
  rst_tb = 0;
  #1000;

  in_link_tb.data[0][0] = !in_link_tb.data[0][0];
  #100;
  in_link_tb.data[1][1] = !in_link_tb.data[1][1];
  #100;

  in_link_tb.data[0][1] = !in_link_tb.data[0][1];
  #100;
  in_link_tb.data[1][0] = !in_link_tb.data[1][0];
  #100;

  out_link_tb.ack = !out_link_tb.ack;
  #100;


  #1000;
  $finish;  
end

endmodule