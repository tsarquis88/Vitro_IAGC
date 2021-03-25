`timescale 1ns / 1ps

module monopulse #
(
    parameter DATA_SIZE     =   64
)
(
    input   i_reset,
    input   i_clock,
    input   [ DATA_SIZE - 1 : 0 ]   i_reference,
    input   [ DATA_SIZE - 1 : 0 ]   i_error,
    output  [ DATA_SIZE - 1 : 0 ]   o_relation
);

    reg                         division_valid;
    wire                        division_ready;
    reg [ DATA_SIZE - 1 : 0 ]   abs_reference;
    reg [ DATA_SIZE - 1 : 0 ]   abs_error;
    
    always@( posedge i_clock )
    begin
    
        if( i_reset )
        begin
            abs_reference   <=  { DATA_SIZE { 1'b0 } };
            abs_error       <=  { DATA_SIZE { 1'b0 } };
            division_valid  <=  1'b0;
        end
        
        else
        begin
        
            if( i_reference[ DATA_SIZE - 1 ] == 1'b1 ) 
            begin
                abs_reference   <=  -i_reference;
            end
            else 
            begin
                abs_reference   <=  i_reference;
            end
            
            if( i_error[ DATA_SIZE - 1 ] == 1'b1 ) 
            begin
                abs_error       <=  -i_error;
            end
            else 
            begin
                abs_error       <=  i_error;
            end
            
            abs_error       <=  64'b0000000000000000000000000000000000000000000000000000000000001010;
            abs_reference   <=  64'b0000000000000000000000000000000000000000000000000000000000000010;
            
            division_valid  <=  1'b1;
            
        end
    end
    
    always@( posedge division_ready )
    begin
        division_valid  =   1'b0;
    end
    
    div_gen_0
    u_div_gen_0
    (
        .aclk                       (i_clock),
        .s_axis_dividend_tvalid     (division_valid),
        .s_axis_dividend_tdata      (abs_error),
        .s_axis_divisor_tvalid      (division_valid),
        .s_axis_divisor_tdata       (abs_reference),
        .m_axis_dout_tvalid         (division_ready),
        .m_axis_dout_tdata          (o_relation)
    );

endmodule
