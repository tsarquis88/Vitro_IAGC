`timescale 1ns / 1ps

module top
(
    input   i_reset_tb,
    input   i_clock_tb,
    input   i_reset_wz,
    output  o_locked_wz,
    output  o_clock_wz
);  

    localparam  DATA_SIZE   =   64;
    
    wire    [ DATA_SIZE - 1 : 0 ]   reference;
    wire    [ DATA_SIZE - 1 : 0 ]   error;
    wire    [ DATA_SIZE - 1 : 0 ]   monopulse_output;

    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_in1                (i_clock_tb),
        .reset                  (i_reset_wz),
        .clk_out1               (o_clock_wz),
        .locked                 (o_locked_wz)
    );
    
    memory_reader
    u_memory_reader
    (
        .i_clock                (o_clock_wz),
        .i_reset                (i_reset_tb),
        .o_reference            (reference),
        .o_error                (error)
    );
    
    monopulse
    u_monopulse
    (
        .i_clock                (o_clock_wz),
        .i_reset                (i_reset_tb),
        .i_reference            (reference),
        .i_error                (error),
        .o_relation             (monopulse_output)
    );
     
endmodule
