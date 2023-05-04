`timescale 1ns / 1ps

module TH_XY_core#(
	parameter						            ENC = "TWO_PHASE",
	parameter						            CFG = "THR:2 D:X",
	localparam						          IN_NUM = 4,
	localparam						          MAX_IN_NUM = 4
)
(
//---------CTRL-----------------------
	input							              rst,
//------------------------------------
	input	[IN_NUM-1 : 0]		        in,						
//---------OUT------------------------
	output							            out
//------------------------------------
);


wire [MAX_IN_NUM-1 : 0] in_fill;
assign in_fill = { {MAX_IN_NUM - IN_NUM{1'b0}} ,in};

localparam LUT_SIZE = 6;
localparam FB_IDX = 4;
localparam RST_IDX = 5;

localparam THR = CFG[4*8  +: 4];
localparam D =   CFG[0*8  +: 8];
localparam D_USED =   D != "X";

localparam IN_TOTAL = IN_NUM + D_USED;

localparam FB_NEEDED = (IN_TOTAL + 1) != (THR * 2);

localparam SUM_W = 32;
reg [SUM_W - 1:0] sum = 0;
reg state = 0;
integer loc;
integer in_idx;

reg[2**LUT_SIZE-1 : 0] init = 0;
reg this_loc = 0;

always@(*)
begin
  sum = 0;
  for (loc = 0; loc < 2**LUT_SIZE; loc = loc + 1)
  begin 

    for (in_idx = 0; in_idx < MAX_IN_NUM; in_idx = in_idx + 1)
    begin 
      sum = sum + loc[in_idx];
    end

    if(loc[RST_IDX])
    begin
      this_loc = 0;
    end
    else if(!loc[FB_IDX])
    begin
      this_loc = sum > THR;
    end
    else if(loc[FB_IDX])
    begin
      this_loc = (ENC == "TWO_PHASE") ? (sum < THR) : (sum == 0);
    end

    init[loc] = this_loc;


  end

end

parameter INIT = init;

wire fb;

generate
  if(FB_NEEDED)
  begin
    assign fb = out;
  end
  else
  begin
    assign fb = 0;
  end
endgenerate


LUT6 #
(
  .INIT(init)
)
LUT6_inst
(
  .O  (out),
  .I0 (in_fill[0]),
  .I1 (in_fill[1]),
  .I2 (in_fill[2]),
  .I3 (in_fill[3]),
  .I4 (fb),
  .I5 (rst)
);

	

endmodule