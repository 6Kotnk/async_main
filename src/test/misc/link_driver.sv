`timescale 1ns / 1ps


module link_driver#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-OUT-------------------
  input                           ack_i,
  output logic [WIDTH-1:0][RAIL_NUM-1:0] out
//------------------------------------
);

always @(*)
begin
  if(rst)
  begin
    ack_state <= 0;
  end
end

logic ack_state = 0; 
logic pending; 
assign pending = ack_i ^^ ack_state;

task automatic drive;
  input         [WIDTH - 1:0]  data;
  
begin
  int bit_idx;

  if(ENC == "TP")
  begin
    wait(!pending);
    #100;
    ack_state <= !ack_state;

    for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
    begin 
      out[bit_idx][1] <= out[bit_idx][1] ^ data[bit_idx];
      out[bit_idx][0] <= out[bit_idx][0] ^ (!data[bit_idx]);
    end
  end
  else if(ENC == "FP")
  begin
    
    wait(!ack_i);
    #101;
    for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
    begin 
      out[bit_idx][1] <=  data[bit_idx];
      out[bit_idx][0] <= !data[bit_idx];
    end

    wait(ack_i);
    #101;
    for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
    begin 
      out[bit_idx][1] <= 0;
      out[bit_idx][0] <= 0;
    end

  end
end
endtask


endmodule