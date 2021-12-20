`timescale 1ns / 1ps
`default_nettype none

module sign_extensor #
(
    parameter   IN_DATA_SIZE   = 14,
    parameter   OUT_DATA_SIZE  = 16
)
(   
    input  wire [ IN_DATA_SIZE  - 1 : 0 ]  data_in,
    output wire [ OUT_DATA_SIZE - 1 : 0 ]  data_out
);

	assign data_out[ OUT_DATA_SIZE - 1 : 0 ] = { { ( OUT_DATA_SIZE - IN_DATA_SIZE ) { data_in [ IN_DATA_SIZE - 1 ] } }, data_in[ IN_DATA_SIZE - 1 : 0 ] };

endmodule

`default_nettype wire

