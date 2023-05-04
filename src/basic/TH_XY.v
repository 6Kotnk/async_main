`timescale 1ns / 1ps

module TH_XY#(
	parameter						ENC = "TWO_PHASE",
	parameter						IN_NUM = 2,
	parameter						THRESHOLD = 1
)
(
//---------CTRL-----------------------
	input							rst,
//------------------------------------
	input							en,
	input	[IN_NUM-1 : 0]			in,						
//---------OUT------------------------
	output							out
//------------------------------------
);

		
localparam SUM_W = 32; //Could use clog2, dont want to risk it being unsuported

reg out_r = 0;

generate
	if (ENC == "TWO_PHASE")
	begin

		wire [IN_NUM-1:0] in_p;
		genvar idx;
		
		for (idx = 0; idx < IN_NUM; idx = idx + 1) 
		begin
			P p
			(
				.rst(rst),
				
				.en(en),
				.fb(out_r),
				.in(in[idx]),
				
				.out(in_p[idx])
			);
		end

		reg [SUM_W - 1:0] sum = 0;

		integer in_idx;

		always@(*)
		begin
			sum = 0;
			for (in_idx = 0; in_idx < IN_NUM; in_idx = in_idx + 1)
			begin 
				sum = sum + in_p[in_idx];
			end
			if(sum >= THRESHOLD )
			begin
				out_r = 1;
			end
			if(&(~in_p))
			begin
				out_r = 0;
			end
		end
		
	end
	else
	begin
		
		wire test;
		assign test = &(~in);
		
		
		reg [SUM_W - 1:0] sum = 0;

		integer in_idx;

		always@(*)
		begin
			sum = 0;
			for (in_idx = 0; in_idx < IN_NUM; in_idx = in_idx + 1)
			begin 
				sum = sum + in[in_idx];
			end
			if(sum >= THRESHOLD )
			begin
				out_r = 1;
			end
			if(&(~in))
			begin
				out_r = 0;
			end
		end
	end
	
	assign out = out_r;
	
endgenerate

endmodule