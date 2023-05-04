`timescale 1ns / 1ps

module C_2
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input	[1 : 0]					in,
//---------OUT------------------------
	output							out
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

LUT4 #
(
    .INIT(16'h00E8)
)
LUT4_inst
(
    .O  (out),
    .I0 (in[0]),
    .I1 (in[1]),
    .I2 (out),
    .I3 (rst)
);



endmodule