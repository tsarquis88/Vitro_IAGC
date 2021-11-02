`timescale 1ns / 1ps
`default_nettype none

module data_conversor #
(
    parameter ZMOD_DATA_SIZE    = 14,
    parameter SAMPLER_DATA_SIZE = 16
)
(
    input  wire [ ZMOD_DATA_SIZE    - 1 : 0 ] i_raw_reference,
    input  wire [ ZMOD_DATA_SIZE    - 1 : 0 ] i_raw_error,
    output wire [ SAMPLER_DATA_SIZE - 1 : 0 ] o_reference,
    output wire [ SAMPLER_DATA_SIZE - 1 : 0 ] o_error
);
    
    localparam OFFSET = 16'h2000;
  
    assign o_reference = i_raw_reference > OFFSET ? i_raw_reference - OFFSET : i_raw_reference + OFFSET;
    assign o_error     = i_raw_error     > OFFSET ? i_raw_error     - OFFSET : i_raw_error     + OFFSET;
    
endmodule

`default_nettype wire
