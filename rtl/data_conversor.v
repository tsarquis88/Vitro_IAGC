`timescale 1ns / 1ps
`default_nettype none

module data_conversor #
(
    parameter   CONVERSOR_DATA_SIZE =   14
)
(
    input  wire [ CONVERSOR_DATA_SIZE - 1 : 0 ] i_data,
    output wire [ CONVERSOR_DATA_SIZE - 1 : 0 ] o_data
);
    
    localparam  OFFSET  =   16'h2000;
  
    assign  o_data  =   i_data > OFFSET ? i_data - OFFSET : i_data + OFFSET;
    
endmodule

`default_nettype wire
