`timescale 1ns / 1ps

module processor #
(
    parameter AMPLITUDE_DATA_SIZE   = 13,
    parameter QUOTIENT_SIZE         = 8,
    parameter FRACTIONAL_SIZE       = 8
)
(
    input                                   i_clock,
    input   [ AMPLITUDE_DATA_SIZE - 1 : 0 ] i_reference,
    input   [ AMPLITUDE_DATA_SIZE - 1 : 0 ] i_error,
    input                                   i_valid,
    output  [ QUOTIENT_SIZE       - 1 : 0 ] o_quotient,
    output  [ FRACTIONAL_SIZE     - 1 : 0 ] o_fractional
);
    
    localparam DIV_RESULT_DATA_SIZE = 24;
    
    wire    [ DIV_RESULT_DATA_SIZE - 1 : 0 ]    div_result;
    wire                                        div_valid;
    reg     [ QUOTIENT_SIZE        - 1 : 0 ]    quotient;
    reg     [ FRACTIONAL_SIZE      - 1 : 0 ]    fractional;
    
    always@( posedge i_clock ) begin
        quotient   <= div_valid ? div_result[ 15 : 8 ] : quotient;
        fractional <= div_valid ? div_result[ 7  : 0 ] : fractional;
    end
    
    assign o_quotient   = quotient;
    assign o_fractional = fractional;
    
     /*
               <--- IP Configuration --->
        Algorithm type  =   Radix2
        Operand sign    =   Unsigned
        Divider width   =   13
        Divisor width   =   13
        Raminder width  =   8
        Remainder type  =   Fractional
        Clocks p/d      =   1
        Latency         =   1    
        
        Debido a warning [Timing 38-316], se hizo el siguiente cambio mediante la consola TLC:
            set_property CONFIG.ACLK_INTF.FREQ_HZ 100000000 [get_ips div_gen_0]
            
        Para ver los valores del IP:
            report_property [get_ips div_gen_0]
    */
    div_gen_0
    u_div_gen_0
    (
        .aclk                       ( i_clock       ),
        .s_axis_dividend_tvalid     ( i_valid       ),
        .s_axis_dividend_tdata      ( i_error       ),
        .s_axis_divisor_tvalid      ( i_valid       ),
        .s_axis_divisor_tdata       ( i_reference   ),
        .m_axis_dout_tvalid         ( div_valid     ),
        .m_axis_dout_tdata          ( div_result    )
    );

endmodule
