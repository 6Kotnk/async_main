`timescale 1ns / 1ps

module el_latch#(
	parameter						ENC = "TWO_PHASE",
	parameter						RAIL_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------LINK-IN--------------------
	input							lat_i,
	input	[RAIL_NUM-1 : 0]		in,
//---------LINK-OUT-------------------
	output							ack_o,
	output	[RAIL_NUM-1 : 0]		out
//------------------------------------
);

generate
	if (ENC == "TWO_PHASE")
	begin
		
		
		
	end
	else
	begin
		
		
		
	end
endgenerate


endmodule
