`timescale 1ns / 1ps

module mem_reg#(
  parameter            REG_WIDTH = 2,
  parameter            ENC = "TP"
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

link_intf [REG_WIDTH-1 : 0] cell_in_link;
link_intf [REG_WIDTH-1 : 0] cell_out_link;

genvar bit_idx;

generate
  for (bit_idx = 0; bit_idx < REG_WIDTH ; bit_idx = bit_idx + 1)
  begin 

    assign cell_in_link[bit_idx].data[0] = in.data[bit_idx];
    assign cell_out_link[bit_idx].ack = in.ack ^ out.ack;
    assign out.data[bit_idx] = cell_out_link[bit_idx].data[0];

    MEM_CELL#
    (
      .ENC(ENC)
    )
    mem_cell_reg
    (
      .rst(rst),
      
      .in(cell_in_link[bit_idx]),
      .out(cell_out_link[bit_idx])
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
  
  .in(cell_out_link.ack),
  .out(in.ack)
);




endmodule
