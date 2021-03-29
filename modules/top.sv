`timescale 1ns / 1ps

module top #
(
    parameter   DATA_SIZE   =   64
)
(
    input                               i_reset,
    input                               i_clock,
    output  [ DATA_SIZE * 2 - 1 : 0 ]   o_res,
    output                              o_led_b,
    output                              o_led_r
);  
    
    wire                            clock;
    wire                            locked;
    wire    [ DATA_SIZE - 1 : 0 ]   reference;
    wire    [ DATA_SIZE - 1 : 0 ]   error;
    
    reg                             divider_start;
    reg                             divider_start_next;
    wire                            divider_valid;
    
    always@( posedge clock ) begin
            divider_start   <= divider_start_next;
    end
    
    always@( * ) begin
        if( divider_valid == 1'b1 )
            divider_start_next  = 1'b0;
        else
            divider_start_next  = 1'b1;
    end

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
        .i_next                 (divider_valid),
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
        .i_start                (divider_start),
        .o_result               (o_res),
        .o_valid                (divider_valid)
    );
    
    assign  o_led_r =   ~locked;
    assign  o_led_b =   locked;
     
endmodule