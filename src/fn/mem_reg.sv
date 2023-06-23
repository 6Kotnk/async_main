`timescale 1ns / 1ps


module mem_reg#(
  parameter            REG_WIDTH = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  link_intf.in                     in,
//---------LINK-OUT-------------------
  link_intf.out                   out
//------------------------------------
);


/*
wire [REG_WIDTH-1:0] ack_bit;
wire ack_link;
wire lat_en;

assign lat_en = ack_link ^ ack_i;
assign ack_o = ack_link;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < REG_WIDTH ; bit_idx = bit_idx + 1)
  begin 
  
    el_latch#
    (
      .RAIL_NUM(RAIL_NUM)
    )
    latch
    (
      .rst(rst),
      
      .in(),
      .out()
    );
    
  end
endgenerate 
*/
/*
link_intf [REG_WIDTH-1 : 0] int_link;

MEM_CELL#
(
  .ENC(ENC)
)
mem_cell_reg [REG_WIDTH-1 : 0]
(
  .rst(rst),
  
  .in(in),
  .out(link_intf)
);

assign out.data = int_link.data
*/



link_intf [REG_WIDTH-1 : 0] int_link;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < REG_WIDTH ; bit_idx = bit_idx + 1)
  begin 

    MEM_CELL#
    (
      .ENC(ENC)
    )
    mem_cell_reg
    (
      .rst(rst),
      
      .in(in),
      .out(link_intf)
    );
  end
endgenerate 


C#
(
  .IN_NUM(REG_WIDTH)
)
c_collector
(
  .rst(rst),
  
  .in(int_link.ack),
  .out(out.ack)
);




endmodule
