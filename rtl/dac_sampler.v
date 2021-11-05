`timescale 1ns / 1ps
`default_nettype none

module dac_sampler # 
(
    parameter ZMOD_DATA_SIZE    = 14,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input  wire                                 i_clock,
    input  wire [ ZMOD_DATA_SIZE   - 1 : 0 ]    i_data_ch1,
    input  wire [ ZMOD_DATA_SIZE   - 1 : 0 ]    i_data_ch2,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    input  wire                                 i_sample, 
    output wire [ ZMOD_DATA_SIZE   - 1 : 0 ]    o_data_ch1,
    output wire [ ZMOD_DATA_SIZE   - 1 : 0 ]    o_data_ch2
);
    
    reg [ ZMOD_DATA_SIZE - 1 : 0 ] data_ch1;
    reg [ ZMOD_DATA_SIZE - 1 : 0 ] data_ch2;
        
    always@( posedge i_clock ) begin
        data_ch1 <= i_sample ? i_data_ch1 : data_ch1;
        data_ch2 <= i_sample ? i_data_ch2 : data_ch2;
    end
    
    assign o_data_ch1 = data_ch1;
    assign o_data_ch2 = data_ch2; 
    
endmodule

`default_nettype wire
