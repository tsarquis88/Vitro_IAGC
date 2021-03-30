`timescale 1ns / 1ps

module processor #
(
    parameter DATA_SIZE         =   10,
    parameter FRACTIONAL_SIZE   =   8
)
(
    input   i_reset,
    input   i_clock,
    input   [ DATA_SIZE - 1 : 0 ]       i_reference,
    input   [ DATA_SIZE - 1 : 0 ]       i_error,
    input                               i_start,
    output  [ DATA_SIZE * 2 - 1 : 0 ]   o_result,
    output                              o_valid
);

    reg [ DATA_SIZE - 1 : 0 ]       abs_reference;
    reg [ DATA_SIZE - 1 : 0 ]       abs_error;
    reg [ DATA_SIZE - 1 : 0 ]       quotient;
    reg [ FRACTIONAL_SIZE - 1 : 0 ] fractional;
    
    always@( i_reference ) begin
        if( i_reference[ DATA_SIZE - 1 ] == 1'b1 )
            abs_reference   =  -i_reference;
        else
            abs_reference   =  i_reference;
    end
    
    always@( i_error ) begin
        if( i_error[ DATA_SIZE - 1 ] == 1'b1 )
            abs_error   =  -i_error;
        else
            abs_error   =  i_error;
    end
    
    always@( o_result ) begin
        quotient    =   o_result[ DATA_SIZE + FRACTIONAL_SIZE - 1 : FRACTIONAL_SIZE ];
        fractional  =   o_result[ FRACTIONAL_SIZE - 1 : 0 ];
    end
    
    div_gen_0
    u_div_gen_0
    (
        .aclk                       (i_clock),
        .s_axis_dividend_tvalid     (i_start),
        .s_axis_dividend_tdata      (abs_error),
        .s_axis_divisor_tvalid      (i_start),
        .s_axis_divisor_tdata       (abs_reference),
        .m_axis_dout_tvalid         (o_valid),
        .m_axis_dout_tdata          (o_result)
    );

endmodule
