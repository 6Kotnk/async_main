`timescale 1ns / 1ps

import link_pkg::*;

module full_adder_tb();

localparam ENC = "TP";




link_intf s_link_tb();
link_intf c_out_link_tb();

link_intf a_link_tb();
link_intf b_link_tb();
link_intf c_in_link_tb();



logic rst_tb = 0;


full_adder#
(
  .ENC  (ENC)
)
DUT
(
//---------CTRL-----------------------
  .rst                        (rst_tb),
//---------LINK-IN--------------------
  .a                          (a_link_tb),
  .b                          (b_link_tb),
  .c_in                       (c_in_link_tb),
//---------LINK-OUT-------------------
  .s                          (s_link_tb),
  .c_out                      (c_out_link_tb)
//------------------------------------
);

link_intf in_link_tb();
link_intf out_link_tb();

mem_reg#
(
  .ENC  (ENC)
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

  s_link_tb.data = '{default:'0};
  s_link_tb.ack = '{default:'0};

  c_out_link_tb.data = '{default:'0};
  c_out_link_tb.ack = '{default:'0};

  a_link_tb.data = '{default:'0};
  a_link_tb.ack = '{default:'0};

  b_link_tb.data = '{default:'0};
  b_link_tb.ack = '{default:'0};

  c_in_link_tb.data = '{default:'0};
  c_in_link_tb.ack = '{default:'0};

  rst_tb = 1;
  #100;    
  rst_tb = 0;
  #1000;

  a_link_tb.data[0][0] = !a_link_tb.data[0][0];
  #100;
  b_link_tb.data[0][0] = !b_link_tb.data[0][0];
  #100;
  c_in_link_tb.data[0][0] = !c_in_link_tb.data[0][0];
  #100;

  #1000;
  $finish;  
end

endmodule