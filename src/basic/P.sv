`timescale 1ns / 1ps

module P#
(
  parameter         INIT = 0
)
(
//---------CTRL-----------------------
  input              rst,
//---------IN-------------------------
  input              en,
  input              fb,
  input              in,
//---------OUT------------------------
  output              out
//------------------------------------
);

logic state_r = INIT;

assign out = state_r ^ in;

always@(*)
begin
  if(rst)
  begin
    state_r = INIT ^ in;
  end
  else
  begin
    if(en)
    begin
      state_r = in ^ fb;
    end
  end
end



endmodule
