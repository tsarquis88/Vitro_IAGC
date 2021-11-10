`timescale 1ns / 1ps

module processor #
(
    parameter DATA_SIZE         =   14,
    parameter REMAINDER_SIZE    =   8
)
(
    input                               i_reset,
    input                               i_clock,
    input   [ DATA_SIZE      - 1 : 0 ]  i_reference,
    input   [ DATA_SIZE      - 1 : 0 ]  i_error,
    input                               i_start,
    output  [ DATA_SIZE      - 1 : 0 ]  o_quotient,
    output  [ REMAINDER_SIZE - 1 : 0 ]  o_remainder,
    output                              o_valid
);

    wire    [ DATA_SIZE + REMAINDER_SIZE - 1 : 0 ]  result;
    reg     [ DATA_SIZE                  - 1 : 0 ]  quotient;
    reg     [ REMAINDER_SIZE             - 1 : 0 ]  remainder;
    
    always@( result ) begin
        quotient    =   result[ DATA_SIZE + REMAINDER_SIZE - 1 : REMAINDER_SIZE ];
        remainder   =   result[ REMAINDER_SIZE - 1 : 0 ];
    end
    
    assign  o_quotient  =   quotient;
    assign  o_remainder =   remainder;
    
     /*
               <--- IP Configuration --->
        Algorithm type  =   Radix2
        Operand sign    =   Signed
        Divider width   =   14
        Divisor width   =   14
        Raminder width  =   8
        Remainder type  =   Fractional    
    */
    div_gen_0
    u_div_gen_0
    (
        .aclk                       (i_clock),
        .s_axis_dividend_tvalid     (i_start),
        .s_axis_dividend_tdata      (i_error),
        .s_axis_divisor_tvalid      (i_start),
        .s_axis_divisor_tdata       (i_reference),
        .m_axis_dout_tvalid         (o_valid),
        .m_axis_dout_tdata          (result)
    );

endmodule
