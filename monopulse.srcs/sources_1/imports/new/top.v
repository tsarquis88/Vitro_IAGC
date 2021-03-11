`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2021 09:45:53
// Design Name: 
// Module Name: top
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


module top
(
    input   i_reset_tb,
    input   i_clock_tb,
    input   i_reset_wz,
    output  o_locked_wz,
    output  o_clock_wz
);    
    
    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_in1                (i_clock_tb),
        .reset                  (i_reset_wz),
        .clk_out1               (o_clock_wz),
        .locked                 (o_locked_wz)
    );
    
    file_reader
    u_file_reader
    (
        .i_clock                (o_clock_wz),
        .i_reset                (i_reset_tb)
    );
     
endmodule
