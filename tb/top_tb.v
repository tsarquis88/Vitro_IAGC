`timescale 1ns / 1ns

module testbench
(
);

    localparam      SYS_CLOCK_PERIOD    =   8;   
    
    reg         clock;
    reg         reset;
    
    initial begin
        clock           =   1'b0;
                
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock           =   ~clock;
    end
    
    top
    u_top
    (
        .i_reset                (reset),
        .i_clock                (clock)
    );       
  
endmodule