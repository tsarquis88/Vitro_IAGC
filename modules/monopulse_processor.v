`timescale 1ns / 1ps

module monopulse_processor #
(
    parameter DATA_SIZE         =   16,
    parameter FRACTIONAL_SIZE   =   16
)
(
    input                               i_clock,
    input   [ DATA_SIZE       - 1 : 0 ] i_reference,
    input   [ DATA_SIZE       - 1 : 0 ] i_error,
    input                               i_start,
    output  [ DATA_SIZE       - 1 : 0 ] o_quotient,
    output  [ FRACTIONAL_SIZE - 1 : 0 ] o_fractional,
    output                              o_valid
);

    reg     [ DATA_SIZE       - 1 : 0 ] abs_reference;
    reg     [ DATA_SIZE       - 1 : 0 ] abs_error;
    reg     [ DATA_SIZE       - 1 : 0 ] quotient;
    reg     [ FRACTIONAL_SIZE - 1 : 0 ] fractional;
    wire    [ DATA_SIZE * 2   - 1 : 0 ] result;
    
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
    
    always@( result ) begin
        quotient    =   result[ DATA_SIZE + FRACTIONAL_SIZE - 1 : FRACTIONAL_SIZE ];
        fractional  =   result[ FRACTIONAL_SIZE - 1 : 0 ];
    end
    
    assign o_fractional =   fractional;
    assign o_quotient   =   quotient;
    
    div_gen_0
    u_div_gen_0
    (
        .aclk                       (i_clock),
        .s_axis_dividend_tvalid     (i_start),
        .s_axis_dividend_tdata      (abs_error),
        .s_axis_divisor_tvalid      (i_start),
        .s_axis_divisor_tdata       (abs_reference),
        .m_axis_dout_tvalid         (o_valid),
        .m_axis_dout_tdata          (result)
    );

endmodule
