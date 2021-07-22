`timescale 1ns / 1ps

module clock_unit
(
    input   i_clock,
    input   i_reset,
    output  o_adc_clock,
    output  o_sys_clock,
    output  o_valid
);
    
    wire        locked;
    
    assign  o_valid =   ~locked;

    /*
               <--- IP Configuration --->
        clk_in1     =   125 MHz
        clk_out1    =   100 MHz
        clk_out1    =   400 MHz
    */
    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_out1           ( o_sys_clock   ),
        .clk_out2           ( o_adc_clock   ),
        .reset              ( i_reset       ),
        .locked             ( locked        ),
        .clk_in1            ( i_clock       )
    );
    
endmodule
