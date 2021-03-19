`timescale 1ns / 1ps

module testbench
(
);

    localparam      CLOCK_PERIOD    =   8;

    reg clock;
    reg reset;
    
    /* Initial */
    initial begin
        clock       =   1'b0;
        
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    /* 100 MHz CLK GEN */
    always begin
        #( CLOCK_PERIOD / 2 )
        clock       =   ~clock;
    end
    
    /* TOP instance */
    top
    u_top
    (
        .i_reset        (reset),
        .i_clock        (clock)
    );
  
endmodule