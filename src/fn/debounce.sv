`timescale 1ns / 1ps


module debounce#(
  parameter                       DEBOUNCE_INTERVAL = 250000
)
(
//---------CTRL-----------------------
  input                           clk,
  input                           rst,
//---------LINK-IN--------------------
  input                           in,
//---------LINK-OUT-------------------
  output                          out
);

localparam CNT_W = $clog2(DEBOUNCE_INTERVAL);

logic [CNT_W-1:0] cnt;
logic out_r;

always @(posedge clk)
begin
  if(rst)
  begin
    out_r <= in;
    cnt <= 0;
  end
  else
  begin
    if(in != out_r)
    begin
      if(cnt >= DEBOUNCE_INTERVAL)
      begin
        out_r <= in;
      end
      else
      begin
        cnt <= cnt + 1;
      end
    end
    else
    begin
      cnt <= 0;
    end
  end
end

assign out = out_r;

endmodule