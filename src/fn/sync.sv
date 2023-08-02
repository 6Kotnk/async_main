`timescale 1ns / 1ps


module sync#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  output logic                    ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
//------------------------------------
  output[WIDTH-1:0]               out
);



genvar bit_idx;

logic [WIDTH-1:0] in_sync;

cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
reg_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(in),
  .cmpl(ack_o)
//-----------------------------
);

generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    if(ENC == "TP")
    begin
      logic p, n;

      always @(posedge ack_o or posedge rst)
      begin
        if(rst)
          p = 0;
        else
          p <= in[bit_idx][1] ^ n;
      end

      always @(negedge ack_o or posedge rst)
      begin
        if(rst)
          n = 0;
        else
          n <= in[bit_idx][1] ^ p;
      end

      assign in_sync[bit_idx] = p ^ n;


    end
    else if(ENC == "FP")
    begin
      always @(posedge ack_o)
        in_sync[bit_idx] <= in[bit_idx][1];
    end
  end



  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    if(ENC == "TP")
    begin
      logic p, n;

      always @(posedge ack_o)
      begin
        if(rst)
          p = 0;
        else
          p <= (in[bit_idx][1] ^ in_sync[bit_idx]) ^ n;
      end

      always @(negedge ack_o)
      begin
        if(rst)
          n = 0;
        else
          n <= (in[bit_idx][1] ^ in_sync[bit_idx]) ^ p;
      end

      assign out[bit_idx] = p ^ n;
    end
    else if(ENC == "FP")
    begin
      assign out[bit_idx] = in_sync[bit_idx];
    end
  end
endgenerate
endmodule