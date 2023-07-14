`timescale 1ns / 1ps


module dual_rail_monitor#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                                   rst,
//---------LINK-OUT-------------------
  input  logic [WIDTH-1:0][RAIL_NUM-1:0]  in
//------------------------------------
);

string str;
logic [WIDTH-1:0] display_val;

genvar bit_idx;

logic [WIDTH-1:0][RAIL_NUM-1:0] in_state = '{default:'0};
logic ack;

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
  .cmpl(ack)
//-----------------------------
);


generate
  for (bit_idx = 0; bit_idx < WIDTH ; bit_idx = bit_idx + 1)
  begin 
    if(ENC == "TP")
    begin
      assign display_val[bit_idx] = ((in_state[bit_idx] ^ in[bit_idx]) ==  2);
    end
    else if(ENC == "FP")
    begin
      assign display_val[bit_idx] = in[bit_idx][1];
    end
  end
endgenerate


if(ENC == "TP")
begin
  always @ ( ack )
  begin
    $display("DECIMAL:%d      HEX:0x%h",display_val,display_val);
    in_state <= in;
  end
end
else if(ENC == "FP")
begin
  always @ ( posedge ack )
  begin
    $display("DECIMAL:%d      HEX:0x%h",display_val,display_val);
  end
end


endmodule