`timescale 1ns / 1ps

module TH_XY_core#(
  parameter                     ENC = "FP",
  parameter                     CFG = "2_0_2",
  localparam                    IN_NUM = 4
)
(
//---------CTRL-----------------------
  input                           rst,
//------------------------------------
  input  [IN_NUM-1 : 0]            in,            
//---------OUT------------------------
  output                          out
//------------------------------------
);

localparam NUM_INPUTS = CFG[39:32] - "0";
localparam DOUBLE_INPUTS = CFG[23:16] - "0";
localparam THRESHOLD = CFG[7:0] - "0";

localparam NUM_INPUTS_TOTAL = NUM_INPUTS + DOUBLE_INPUTS;

localparam FB_NEEDED = (NUM_INPUTS_TOTAL + 1) != THRESHOLD * 2;

localparam SUM_W = 32;
logic [SUM_W - 1:0] sum = 0;
logic out_r = 0;
integer in_idx;


generate

if (ENC == "TP") 
begin

  if (0)
  begin

    always@(*)
    begin
      sum = 0;
      for (in_idx = 0; in_idx < NUM_INPUTS; in_idx = in_idx + 1)
      begin 
        sum = sum + in[in_idx] + ((in_idx < DOUBLE_INPUTS) ? in[in_idx] : 0);
      end
      if(sum >= ((NUM_INPUTS_TOTAL+1)/2) )
      begin
        out_r = 1;
      end
      else
      begin
        out_r = 0;
      end
    end

    assign out = out_r;

  end  


  else if (CFG == "2_0_2")
  begin
    LUT4 #
    (
      .INIT(16'h00e8)
    )
    TP_2_0_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (out),
      .I3 (rst)
    );
  end  

  else if (CFG == "3_0_2")
  begin
    LUT3 #
    (
      .INIT(8'he8)
    )
    TP_3_0_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2])
    );
  end

  else if (CFG == "3_1_2")
  begin
    LUT5 #
    (
      .INIT(32'h0000a8ea)
    )
    TP_3_1_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (out),
      .I4 (rst)
    );
  end

  if (CFG == "4_1_3")
  begin
    LUT4 #
    (
      .INIT(16'heaa8)
    )
    TP_4_1_3_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (in[3])
    );
  end  

  else if (CFG == "4_2_3")
  begin
    LUT6 #
    (
      .INIT(64'h00000000e888eee8)
    )
    TP_4_2_3_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (in[3]),
      .I4 (out),
      .I5 (rst)
    );
  end
end
else if (ENC == "FP") 
begin
  if (CFG == "2_0_2")
  begin
    LUT4 #
    (
      .INIT(16'h00e8)
    )
    FP_2_0_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (out),
      .I3 (rst)
    );
  end  

  else if (CFG == "3_0_2")
  begin
    LUT5 #
    (
      .INIT(32'h0000fee8)
    )
    FP_3_0_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (out),
      .I4 (rst)
    );
  end

  else if (CFG == "3_1_2")
  begin
    LUT5 #
    (
      .INIT(32'h0000feea)
    )
    FP_3_0_2_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (out),
      .I4 (rst)
    );
  end

  else if (CFG == "4_1_3")
  begin
    LUT6 #
    (
      .INIT(64'h00000000fffeeaa8)
    )
    FP_4_1_3_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (in[3]),
      .I4 (out),
      .I5 (rst)
    );
  end  

  else if (CFG == "4_2_3")
  begin
    LUT6 #
    (
      .INIT(64'h00000000fffeeee8)
    )
    FP_4_2_3_inst
    (
      .O  (out),
      .I0 (in[0]),
      .I1 (in[1]),
      .I2 (in[2]),
      .I3 (in[3]),
      .I4 (out),
      .I5 (rst)
    );
  end
end

endgenerate


  

endmodule