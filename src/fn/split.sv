`timescale 1ns / 1ps

module split#(
  parameter                     ENC = "TP",
  parameter                     WIDTH = 1,
  localparam                    RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                         rst,
//---------LINK-IN---------------------
  output                          ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
  input            [RAIL_NUM-1:0] sel,
//---------LINK-OUT1-------------------
  output                          ack_i0,
  input [WIDTH-1:0][RAIL_NUM-1:0] out0,
//---------LINK-OUT2-------------------
  input                           ack_i1,
  output[WIDTH-1:0][RAIL_NUM-1:0] out1
//------------------------------------
);

logic in_done;
logic sel_done;
logic inputs_done;

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
in_done
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(in),
  .cmpl(in_done)
//-----------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (1)
)
sel_done
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(sel),
  .cmpl(sel_done)
//-----------------------------
);

C_2 inputs_done
(
  .rst(rst),
  
  .in({in_done,sel_done}),
  .out(inputs_done)
);

logic en;

genvar bit_idx;

generate

  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    TH_XY#
    (
      .ENC  (ENC),
      .CFG  ("2_0_2")
    )
    split_to_0
    (
    //---------CTRL----------------
      .rst(rst),
    //-----------------------------
      .en(en),
      .in({in[bit_idx],sel[0]}),
      .out(out0[bit_idx])
    //-----------------------------
    );

    TH_XY#
    (
      .ENC  (ENC),
      .CFG  ("2_0_2")
    )
    split_to_1
    (
    //---------CTRL----------------
      .rst(rst),
    //-----------------------------
      .en(en),
      .in({in[bit_idx],sel[1]}),
      .out(out1[bit_idx])
    //-----------------------------
    );

  end
endgenerate 

logic out0_done;
logic out1_done;

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (1)
)
out0_done
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(out0),
  .cmpl(out0_done)
//-----------------------------
);

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (1)
)
out1_done
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(out1),
  .cmpl(out1_done)
//-----------------------------
);

logic output_done;
logic ack_in;

assign output_done = out0_done ^^ out1_done;
assign ack_in = ack_i0 ^^ ack_i1;

logic data_propagated;

C_2 data_propagated
(
  .rst(rst),
  
  .in({output_done,input_done}),
  .out(data_propagated)
);

assign en = data_propagated ^^ ack_in;

C_2 ack_o
(
  .rst(rst),
  
  .in({ack_in,input_done}),
  .out(ack_o)
);

endmodule
