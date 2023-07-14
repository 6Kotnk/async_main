`timescale 1ns / 1ps


module dual_rail_driver#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
//---------LINK-OUT-------------------
  output logic [WIDTH-1:0][RAIL_NUM-1:0]  out
//------------------------------------
);




task automatic rst_bus;
begin
    out <= {default:'0};#100;
end
endtask



task automatic drive;
  input         [WIDTH - 1:0]  data;
  
begin
  int bit_idx;

  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 

    if(ENC == "TP")
    begin
      out[bit_idx][1] <= out[bit_idx][1] ^ data[bit_idx];#1;
      out[bit_idx][0] <= out[bit_idx][0] ^ (!data[bit_idx]);#1;
    end
    else if(ENC == "FP")
    begin
      for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
      begin 
        out[bit_idx][1] <=  data[bit_idx];#1;
        out[bit_idx][0] <= !data[bit_idx];#1;
      end
      #100;
      rst_bus();
    end
  end
end
endtask


endmodule