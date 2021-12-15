`timescale 1ns / 1ps
`default_nettype none

module clock_unit
(
    input  wire i_clock,
    input  wire i_reset,
    output wire o_sys_clock,
    output wire o_adc_clock,
    output wire o_dac_in_clock,
    output wire o_dac_clock,
    output wire o_valid
);
    
    wire locked;
    
    assign o_valid = ~locked;

    /*
               <--- IP Configuration --->
        clk_in1      =   125 MHz
        sys_clock    =   100 MHz
        adc_clock    =   400 MHz
        dac_clock    =   100 MHz
        dac_in_clock =   100 MHz (shifted 90)
    */
    clk_wiz_0
    u_clk_wiz_0
    (
        .sys_clock      ( o_sys_clock       ),
        .adc_clock      ( o_adc_clock       ),
        .dac_clock      ( o_dac_in_clock    ),
        .dac_in_clock   ( o_dac_clock       ),
        .reset          ( i_reset           ),
        .locked         ( locked            ),
        .clk_in1        ( i_clock           )
    );
    
endmodule

`default_nettype wire
