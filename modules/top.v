`timescale 1ns / 1ps

module top
(
    input   i_clock,
    input   i_reset
       
);
    
    /* ########################################################### */
    /* CLOCK WIZARD ############################################## */
    
    wire    clock;
    wire    sample_clock;
    wire    locked;
    
    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_out1           ( clock         ),
        .clk_out2           ( sample_clock  ),
        .reset              ( i_reset       ),
        .locked             ( locked        ),
        .clk_in1            ( i_clock       )
    );
    
    /* ########################################################### */
    /* SIMULATOR ################################################# */
    
    localparam  DATA_SIZE = 16;
    
    wire    [ DATA_SIZE - 1 : 0 ] reference;
    wire    [ DATA_SIZE - 1 : 0 ] error;

    monopulse_simulator #
    (
        .DATA_SIZE      (DATA_SIZE)
    )
    u_monopulse_simulator
    (
        .i_clock        (clock),
        .i_reset        (~locked),
        .o_reference    (reference),
        .o_error        (error)
    );
    
    /* ########################################################### */
    /* PROCESSOR ################################################# */
        
    wire    [ DATA_SIZE - 1 : 0 ]   fractional;
    wire    [ DATA_SIZE - 1 : 0 ]   quotient;
    wire                            valid;
    
    monopulse_processor #
    (
        .DATA_SIZE          (DATA_SIZE),
        .FRACTIONAL_SIZE    (DATA_SIZE)
    )
    u_monopulse_processor
    (
        .i_clock        (clock),
        .i_reference    (reference),
        .i_error        (error),
        .i_start        (sample_clock),
        .o_quotient     (quotient),
        .o_fractional   (fractional),
        .o_valid        (valid)
    );
    
endmodule