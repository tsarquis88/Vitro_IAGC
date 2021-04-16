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
        tx_send     =   1'b1;
        
        #10000
        tx_send     =   1'b0;
        
        #500
        tx_send     =   1'b1;
        
        #500
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
        .i_serial_start     (tx_send),
        .o_serial           (serial)
    );
  
endmodule
