`timescale 1ns / 1ns

module processor_tb
(
);

    localparam SYS_CLOCK_PERIOD =   10;   
    
    localparam DATA_SIZE        =   14;
    localparam IAGC_STATUS_SIZE =   4;
    localparam REMAINDER_SIZE   =   8;
    
    wire [ DATA_SIZE      - 1 : 0 ] div_quotient;
    wire [ REMAINDER_SIZE - 1 : 0 ] div_remainder;
    wire                            div_valid;
    reg  [ DATA_SIZE      - 1 : 0 ] reference;
    reg  [ DATA_SIZE      - 1 : 0 ] error;
    reg                             clock;
    wire                            start;
    reg  [ IAGC_STATUS_SIZE - 1 : 0 ] iagc_status;
    
    initial begin
        clock       = 1'b0;
        iagc_status = 0;
        reference   = 14'b01000000110000;
        error       = 14'b10111111111000;
        
        #50
        iagc_status = 1;
        
        #50
        iagc_status = 2;
        
        #200
        reference   = 14'b00001000100111;
        error       = 14'b11110000011010;
        
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
        .i_reference        ( reference         ),
        .i_error            ( error             ),
        .i_start            ( start             ),
        .o_quotient         ( div_quotient      ),
        .o_remainder        ( div_remainder     ),
        .o_valid            ( div_valid         )
    ); 
    
    decimator # 
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  ),
        .DECIMATOR_SIZE     ( 4'b0100           )
    )
    u_decimator
    (
        .i_clock            ( clock             ),
        .i_gate             ( 1'b1              ),
        .i_iagc_status      ( iagc_status       ),
        .i_decimator        ( 4'b0100           ),
        .o_sample           ( start             )
    );
  
endmodule
