`timescale 1ns / 1ps

module C#(
  parameter                      IN_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------IN-------------------------
  input  [IN_NUM-1 : 0]            in,
//---------OUT------------------------
  output                          out
//------------------------------------
);

function [31:0] log2;
  input [31:0] value;
  integer i;
  reg [31:0] j;
  begin
    j = value - 1;
    log2 = 0;
    for (i = 0; i < 31; i = i + 1)
    begin
      if (j[i])
      begin
        log2 = i + 1;
      end
    end
  end
endfunction

function [31:0] parity;
  input [31:0] value;
  input [31:0] len;
  integer idx;
  integer sum;
  begin
    parity = 0;
    sum = 0;
    for (idx = 0; idx < len; idx = idx + 1)
    begin
            sum = sum + value[idx];
    end
    parity = sum[0];
  end
endfunction


localparam NUM_OF_LEVELS = log2(IN_NUM);
localparam ELEM_W = 2;

genvar elem,lvl;

generate 
  if(IN_NUM == 1)
  begin
    assign out = in;
  end
  else
  begin
    for (lvl = 0; lvl < NUM_OF_LEVELS; lvl = lvl + 1) 
    begin: Lvls

      localparam in_size = (lvl == 0) ? IN_NUM : (IN_NUM >> lvl) + parity(IN_NUM,lvl);
      localparam out_size = ((in_size / 2) + in_size[0]);

      wire [in_size-1:0] in_int;
      wire [out_size-1:0] out_int;
      
      if (lvl == 0) 
      begin
        assign in_int = in;
      end
      else
      begin
        assign in_int = Lvls[lvl-1].out_int;
      end

      for (elem = 0; elem < (in_size / 2); elem = elem + 1) 
      begin: Elems

        // for the first level connect inputs to the module
        C_2 c_inst
        (
          .rst(rst),
          .in(in_int[elem * ELEM_W +: ELEM_W]),
          .out(out_int[elem])
        );
      end

      if (in_size[0]) // Unalligned input
      begin
        assign out_int[out_size-1] = in_int[in_size-1];
      end
      
    end

    assign out = Lvls[NUM_OF_LEVELS-1].out_int[0];
  end
endgenerate

  






endmodule