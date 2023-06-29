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

generate

if (ENC == "TP") 
begin
  if (CFG == "2_0_2")
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