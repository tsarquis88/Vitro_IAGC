`timescale 1ns / 1ps

module top
(
    input   i_reset,
    input   i_clock,
    output  o_led_b,
    output  o_led_r
);  

    localparam  DATA_SIZE   =   64;
    
    wire                            clock;
    wire                            locked;
    wire    [ DATA_SIZE - 1 : 0 ]   reference;
    wire    [ DATA_SIZE - 1 : 0 ]   error;
    wire    [ DATA_SIZE - 1 : 0 ]   monopulse_output;

    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_in1                (i_clock),
        .reset                  (i_reset),
        .clk_out1               (clock),
        .locked                 (locked)
    );
    
    memory_reader
    u_memory_reader
    (
        .i_clock                (clock),
        .i_reset                (~locked),
        .o_reference            (reference),
        .o_error                (error)
    );
    
    monopulse
    u_monopulse
    (
        .i_clock                (clock),
        .i_reset                (~locked),
        .i_reference            (reference),
        .i_error                (error),
        .o_relation             (monopulse_output)
    );
    
    assign  o_led_r =   ~locked;
    assign  o_led_b =   locked;
     
endmodule