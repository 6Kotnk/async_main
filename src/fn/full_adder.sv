`timescale 1ns / 1ps


module full_adder#(
  parameter            ENC = "TP"
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  link_intf.in                     a,
  link_intf.in                     b,
  link_intf.in                  c_in,
//---------LINK-OUT-------------------
  link_intf.out                    s,
  link_intf.out                c_out
//------------------------------------
);

localparam IN_NUM = 3;
localparam OUT_NUM = 2;

logic input_complete;
logic output_complete;
logic all_complete;

assign a.ack = all_complete;
assign b.ack = all_complete;
assign c_in.ack = all_complete;

C#
(
  .IN_NUM(IN_NUM)
)
in_agg
(
  .rst(rst),
  
  .in({^a.data[0],^b.data[0],^c_in.data[0]}),
  .out(input_complete)
);

C#
(
  .IN_NUM(OUT_NUM)
)
out_agg
(
  .rst(rst),
  
  .in({^c_out.data[0],^s.data[0]}),
  .out(output_complete)
);

C#
(
  .IN_NUM(2)
)
ack_agg
(
  .rst(rst),
  
  .in({input_complete,output_complete}),
  .out(all_complete)
);

logic en_c;
assign en_c = (^c_out.data[0]) ^ c_out.ack;

logic en_s;
assign en_s = (^s.data[0]) ^ s.ack;


TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_0_2")
)
c_out_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en_c),
	.in({a.data[0][0],b.data[0][0],c_in.data[0][0]}),
	.out(c_out.data[0][0])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_0_2")
)
c_out_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en_c),
	.in({a.data[0][1],b.data[0][1],c_in.data[0][1]}),
	.out(c_out.data[0][1])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("4_1_3")
)
s_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en_s),
	.in({c_out.data[0][1],a.data[0][0],b.data[0][0],c_in.data[0][0]}),
	.out(s.data[0][0])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("4_1_3")
)
s_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
  .en(en_s),
	.in({c_out.data[0][0],a.data[0][1],b.data[0][1],c_in.data[0][1]}),
	.out(s.data[0][1])
//-----------------------------
);





endmodule
