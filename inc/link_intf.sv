import link_pkg::*;

interface link_intf #(
  parameter            LINK_WIDTH = 1,
  parameter            RAIL_NUM   = 2
);

logic ack;
multi_rail_bit [LINK_WIDTH - 1:0] data;

modport out(
  output data,
  input ack
);
modport in(
  input data,
  output ack
);
endinterface
