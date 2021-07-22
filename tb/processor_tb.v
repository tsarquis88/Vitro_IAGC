`timescale 1ns / 1ns

module processor_tb
(
);

    localparam      SYS_CLOCK_PERIOD    =   10;   
    
    reg         clock;
    reg         reset;
    reg         start;
    
    initial begin
        clock       =   1'b0;
                
        #10
        reset       =   1'b1;
        reference   =   { PROCESSOR_DATA_SIZE { 1'b0 } };
        error       =   { PROCESSOR_DATA_SIZE { 1'b0 } };   
        start       =   1'b1;
        
        #50
        reset       =   1'b0;  
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock           =   ~clock;
    end
    
    always@( posedge clock ) begin
        if( ~reset ) begin
            //reference   <=   reference  + 1'b1;
            //error       <=   error      + 2'b11;
            reference   <=   14'b01000000110000;
            error       <=   14'b10111111111000;
        end
    end
    
    /* ########################################################### */
    /* PROCESSOR ################################################# */
    
    localparam  PROCESSOR_DATA_SIZE         =   14;
    localparam  PROCESSOR_REMAINDER_SIZE    =   8;
    localparam  PROCESSOR_RESULT_SIZE       =   24;
    
    wire    [ PROCESSOR_DATA_SIZE - 1 : 0 ] processor_quotient;
    wire    [ PROCESSOR_DATA_SIZE - 1 : 0 ] processor_remainder;
    wire                                    processor_valid;
    reg     [ PROCESSOR_DATA_SIZE - 1 : 0 ] reference;
    reg     [ PROCESSOR_DATA_SIZE - 1 : 0 ] error;
    
    processor #
    (
        .DATA_SIZE          (PROCESSOR_DATA_SIZE),
        .REMAINDER_SIZE     (PROCESSOR_REMAINDER_SIZE),
        .RESULT_SIZE        (PROCESSOR_RESULT_SIZE)       
    )
    u_processor
    (
        .i_clock        (clock),
        .i_reset        (reset),
        .i_reference    (reference),
        .i_error        (error),
        .i_start        (start),
        .o_quotient     (processor_quotient),
        .o_remainder    (processor_remainder),
        .o_valid        (processor_valid)
    );     
  
endmodule
