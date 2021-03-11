`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2021 09:52:18
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench
(
);

    localparam      CLOCK_PERIOD    =   10;

    reg                         clock_tb;
    reg                         reset_tb;
    reg                         reset_wz;
    wire                        clock_wz;
    wire                        locked_wz;
    
    /* Initial */
    initial begin
        clock_tb    =   1'b0;
        reset_wz    =   1'b0;
        
        #10
        reset_wz    =   1'b1;
        
        #10
        reset_wz    =   1'b0;
        
        
        while( locked_wz == 1'b0 ) begin
            #5
            reset_tb    =   1'b1;
        end
        
        #5
        reset_tb    =   1'b0;
        
    end
    
    /* 100 MHz CLK GEN */
    always begin
        #( CLOCK_PERIOD / 2 )
        clock_tb    =   ~clock_tb;
    end
    
    /* TOP instance */
    top
    u_top
    (
        .i_reset_tb     (reset_tb),
        .i_clock_tb     (clock_tb),
        .i_reset_wz     (reset_wz),
        .o_locked_wz    (locked_wz),
        .o_clock_wz     (clock_wz)
    );
  
endmodule
