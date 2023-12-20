`timescale 1ns / 1ps

module C_2
(
//---------CTRL-----------------------
  input                           rst,
//---------IN-------------------------
  input  [1 : 0]                   in,
//---------OUT------------------------
  output                          out
//------------------------------------
);

/*
wire set;
wire reset;

assign set = (&in) && (|in);
assign reset = !(|in) && !(&in);

rs_lat primitive_latch
(
    .rst(rst),
    .r(reset),
    .s(set),
    .out(out)
);
*/


/*
LDCE #(
   .INIT(1'b0),            // Initial value of latch, 1'b0, 1'b1
   // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
   .IS_CLR_INVERTED(1'b0), // Optional inversion for CLR
   .IS_G_INVERTED(1'b0)    // Optional inversion for G
)
LDCE_inst (
   .Q(out),     // 1-bit output: Data
   .CLR(rst), // 1-bit input: Asynchronous clear
   .D(in[0]),     // 1-bit input: Data
   .G(in[1] ^ out),     // 1-bit input: Gate
   .GE(1)    // 1-bit input: Gate enable
);
*/



logic out_pre;
assign #37 out = out_pre;

LUT4 #
(
    .INIT(16'h88E8)
)
LUT4_inst
(
    .O  (out_pre),
    .I0 (in[0]),
    .I1 (in[1]),
    .I2 (out),
    .I3 (rst)
);


/*
always@(*)
begin
  if(rst)
  begin
    out_pre = &in;
  end
  else
  begin
    if(in[0] == in[1])
    begin
      out_pre = in[0];
    end
  end
end
*/

endmodule