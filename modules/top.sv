`timescale 1ns / 1ps

module top #
(
    parameter   DATA_SIZE   =   64
)
(
    input                           i_reset,
    input                           i_clock,
    output  [ DATA_SIZE - 1 : 0 ]   o_rel,
    output                          o_led_b,
    output                          o_led_r
);  
    
    wire                            clock;
    wire                            locked;
    wire    [ DATA_SIZE - 1 : 0 ]   reference;
    wire    [ DATA_SIZE - 1 : 0 ]   error;

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
        .o_relation             (o_rel)
    );
    
    assign  o_led_r =   ~locked;
    assign  o_led_b =   locked;
     
endmodule