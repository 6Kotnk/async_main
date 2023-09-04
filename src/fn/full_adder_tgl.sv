`timescale 1ns / 1ps


module full_adder_tgl#(
  parameter            ENC = "TP",
  localparam           RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  input  [RAIL_NUM-1:0]             a,
  input  [RAIL_NUM-1:0]             b,
  input  [RAIL_NUM-1:0]          c_in,
//---------LINK-OUT-------------------
  output [RAIL_NUM-1:0]             s,
  output [RAIL_NUM-1:0]         c_out
//------------------------------------
);

localparam IN_W = 3;
localparam TGL_W = 2**IN_W;
localparam OUT_W = 4;

logic [RAIL_NUM-1:0] in_xored [IN_W-1:0];
logic  toggle_c [TGL_W-1:0];

logic  toggle [TGL_W-1:0];
logic  out_pre [TGL_W-1:0];

genvar bit_idx;
/*
generate
  for (bit_idx = 0; bit_idx < IN_W ; bit_idx = bit_idx + 1)
  begin
    logic fb_vec = toggle[bit_idx[0]] ^^ toggle[bit_idx[1]] ^^ toggle[bit_idx[2]] ^^ toggle[bit_idx[3]];
    assign in_xored[bit_idx] = in[bit_idx] ^^ (fb_vec);

  end
endgenerate 
*/

logic fb_vec [(IN_W*RAIL_NUM)-1:0];

assign fb_vec[0] = toggle[0] ^^ toggle[2] ^^ toggle[4] ^^ toggle[6];
assign in_xored[0][0] = a[0] ^^ fb_vec[0];

assign fb_vec[1] = toggle[1] ^^ toggle[3] ^^ toggle[5] ^^ toggle[7];
assign in_xored[0][1] = a[1] ^^ fb_vec[1];

assign fb_vec[2] = toggle[0] ^^ toggle[1] ^^ toggle[4] ^^ toggle[5];
assign in_xored[1][0] = b[0] ^^ fb_vec[2];

assign fb_vec[3] = toggle[2] ^^ toggle[3] ^^ toggle[6] ^^ toggle[7];
assign in_xored[1][1] = b[1] ^^ fb_vec[3];

assign fb_vec[4] = toggle[0] ^^ toggle[1] ^^ toggle[2] ^^ toggle[3];
assign in_xored[2][0] = c_in[0] ^^ fb_vec[4];

assign fb_vec[5] = toggle[4] ^^ toggle[5] ^^ toggle[6] ^^ toggle[7];
assign in_xored[2][1] = c_in[1] ^^ fb_vec[5];


generate
  for (bit_idx = 0; bit_idx < TGL_W ; bit_idx = bit_idx + 1)
  begin

    C#
    (
      .IN_NUM                (3)
    )
    c_collector
    (
    //---------CTRL----------------
      .rst(rst),
    //-----------------------------
      .in({in_xored[0][bit_idx[0]],in_xored[1][bit_idx[1]],in_xored[2][bit_idx[2]]}),
      .out(toggle_c[bit_idx])
    //-----------------------------
    );

    
    TOGGLE
    tgl
    (
    //---------CTRL----------------
      .rst(rst),
    //-----------------------------
      .in(toggle_c[bit_idx]),
      .out({out_pre[bit_idx],toggle[bit_idx]})
    //-----------------------------
    );

    assign s[0] = out_pre[0] ^^ out_pre[3] ^^ out_pre[5] ^^ out_pre[6];
    assign s[1] = out_pre[1] ^^ out_pre[2] ^^ out_pre[4] ^^ out_pre[7];

    assign c_out[0] = out_pre[0] ^^ out_pre[1] ^^ out_pre[2] ^^ out_pre[4];
    assign c_out[1] = out_pre[3] ^^ out_pre[5] ^^ out_pre[6] ^^ out_pre[7];

  end
endgenerate 











endmodule
