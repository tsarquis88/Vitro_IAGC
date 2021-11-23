`timescale 1ns / 1ns

module processor_tb
(
);

    localparam SYS_CLOCK_PERIOD =   10;   
    
    localparam DATA_SIZE        =   14;
    localparam REMAINDER_SIZE   =   8;
    localparam RESULT_SIZE      =   22;
    
    wire [ DATA_SIZE      - 1 : 0 ] div_quotient;
    wire [ REMAINDER_SIZE - 1 : 0 ] div_remainder;
    wire                            div_valid;
    reg  [ DATA_SIZE      - 1 : 0 ] reference;
    reg  [ DATA_SIZE      - 1 : 0 ] error;
    reg                             clock;
    reg                             reset;
    reg                             start;
    
    initial begin
        clock       = 1'b0;
        reset       = 1'b1;
        reference   = 14'b01000000110000;
        error       = 14'b10111111111000;
        start       = 1'b0;
        
        #50
        reset       =   1'b0;
        
        #10
        start       = 1'b1;
        
        #100
        start       = 1'b0;  
        
        #100
        reference   = 14'b00001000100111;
        error       = 14'b11110000011010;
        
        #500
        start       = 1'b1;
        
        #100
        start       = 1'b0;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock           =   ~clock;
    end
    
    processor #
    (
        .DATA_SIZE          ( DATA_SIZE         ),
        .REMAINDER_SIZE     ( REMAINDER_SIZE    )       
    )
    u_processor
    (
        .i_clock            ( clock             ),
        .i_reset            ( reset             ),
        .i_reference        ( reference         ),
        .i_error            ( error             ),
        .i_start            ( start             ),
        .o_quotient         ( div_quotient      ),
        .o_remainder        ( div_remainder     ),
        .o_valid            ( div_valid         )
    );     
  
endmodule
