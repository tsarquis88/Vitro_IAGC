`timescale 1ns / 1ps

module testbench
(
);

    localparam      CLOCK_PERIOD    =   8;
    localparam      DATA_SIZE       =   10;
    localparam      FRACTIONAL_SIZE =   8;
    
    reg clock;
    reg reset;
    
    initial begin
        clock       =   1'b0;
        
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    always begin
        #( CLOCK_PERIOD / 2 )
        clock       =   ~clock;
    end
    
    top #
    (
        .DATA_SIZE          (DATA_SIZE),
        .FRACTIONAL_SIZE    (FRACTIONAL_SIZE)
    )
    u_top
    (
        .i_reset            (reset),
        .i_clock            (clock)
    );
  
endmodule
