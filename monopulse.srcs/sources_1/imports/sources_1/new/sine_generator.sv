`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2021 11:24:32 AM
// Design Name: 
// Module Name: sine_generator
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

module sine_generator
(
    input i_clock,
    input i_reset,
    output o_sine
);

    localparam  SAMPLES_SIZE    =   10000;
    localparam  ini_status      = 1'b0,                   
                out_status      = 1'b1;

    const real pi   = 3.1416;
    const real T    = 1.0;
    
    real        f       = 1000;
    real        t       [ 64 : 0 ] [ 0 : SAMPLES_SIZE - 1 ];
    real        sine;
    
    reg     [ 1 : 0 ]   status;
    
    integer count;

    always@( posedge i_reset ) begin
        status  <=  ini_status;
        count   <=  0;
    end

    always @( posedge i_clock ) begin
        
        case( status )
        
            ini_status: begin
                t[ 0 ][ count ]  <=  ( T / SAMPLES_SIZE ) * count;
                
                if( count < SAMPLES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    count   <=  0;
                    status  <=  out_status;
                end
            end
            
            out_status: begin
                sine    <=  $sin( 2 * pi * f * t[ 0 ][ count ] );
                
                if( count < SAMPLES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    count   <=  0;
                end
            end
            
        endcase  
    end

    assign o_sine   =   sine; 

endmodule
