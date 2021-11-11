`timescale 1ns / 1ns

module decimator_tb
(
);
       
    reg         clock;
    reg  [3:0]  iagc_status;
    reg         gate;
    reg  [3:0]  decimator;
    
    wire        sample;
    
    initial begin
        clock       = 1'b0;
        gate        = 1'b0;
        iagc_status = 4'b0000;
        decimator   = 4'b0001;
        
        #100
        iagc_status = 4'b0001;
        
        #100
        iagc_status = 4'b0011;
        
        #10000
        decimator   = 4'b0100;
        
        #10000
        decimator   = 4'b0010;
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
    
    always begin
        #300
        gate    =   ~gate;
    end
   
    decimator #
    (
        .DECIMATOR_SIZE     ( 4             )  
    )
    u_decimator
    (
        .i_clock            ( clock         ),
        .i_iagc_status      ( iagc_status   ),
        .i_gate             ( gate          ),
        .i_decimator        ( decimator     ),
        .o_sample           ( sample        )
    );
    
endmodule