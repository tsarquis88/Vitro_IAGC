`timescale 1ns / 1ps

module testbench
(
);

    localparam      CLOCK_PERIOD    =   8;
    
    reg     clock;
    reg     reset;
    reg     tx_send;
    wire    serial;
    
    initial begin
        clock       =   1'b0;
        
        #10
        reset       =   1'b1;
        tx_send     =   1'b0;
        
        #50
        reset       =   1'b0;
        
        #10000
        tx_send     =   1'b1;
        
        #1000
        tx_send     =   1'b0;
        
        #2500000
        tx_send     =   1'b1;
        
        #1000
        tx_send     =   1'b0;
    end
    
    always begin
        #( CLOCK_PERIOD / 2 )
        clock       =   ~clock;
    end
    
    top
    u_top
    (
        .i_reset            (reset),
        .i_clock            (clock),
        .i_tx_start         (tx_send),
        .o_tx               (serial)
    );
  
endmodule
