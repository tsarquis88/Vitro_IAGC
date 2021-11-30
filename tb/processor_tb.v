`timescale 1ns / 1ns

module processor_tb
(
);

    localparam SYS_CLOCK_PERIOD =   10;   
    
    reg  [ 12 : 0 ] ref_amplitude;
    reg  [ 12 : 0 ] err_amplitude;
    reg             clock;
    reg             amplitude_valid;
    wire [ 7  : 0 ] processor_quotient;
    wire [ 7  : 0 ] processor_fractional;
        
    initial begin
        clock           = 1'b0;
        amplitude_valid = 1'b0;
        ref_amplitude   = 3900;
        err_amplitude   = 3740;
        
        #500
        amplitude_valid = 1'b1;
        #20
        amplitude_valid = 1'b0;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock = ~clock;
    end
    
    processor #
    (
        .AMPLITUDE_DATA_SIZE    ( 13                    ),
        .QUOTIENT_SIZE          ( 8                     ),
        .FRACTIONAL_SIZE        ( 8                     )       
    )
    u_processor
    (
        .i_clock                ( clock                 ),
        .i_reference            ( ref_amplitude         ),
        .i_error                ( err_amplitude         ),
        .i_valid                ( amplitude_valid       ),
        .o_quotient             ( processor_quotient    ),
        .o_fractional           ( processor_fractional  )
    ); 
  
endmodule
