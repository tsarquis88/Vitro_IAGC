`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2021 11:22:05
// Design Name: 
// Module Name: file_reader
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


module file_reader
(
    input   i_reset,
    input   i_clock
);

    localparam      VALUES_SIZE     =   10501;

    integer         file_reference;
    integer         file_error;
    integer         count;
    
    reg             read;
    reg             log;
    
    real    reference_values    [ 64 : 0 ] [ 0 : VALUES_SIZE - 1 ];
    real    error_values        [ 64 : 0 ] [ 0 : VALUES_SIZE - 1 ];

    
    /* Initial */
    initial begin     
    
        read    =   1'b0;
        log     =   1'b0;
    
        file_reference  =   $fopen( "/home/tomsar/eclypse-z7/monopulse/reference.signal", "r" );
        file_error      =   $fopen( "/home/tomsar/eclypse-z7/monopulse/error.signal", "r" );
        
    end
    
    /* Reset */
    always@( posedge i_reset ) begin
    
        count           <=   1'b0;
        
        if ( !file_reference || !file_error ) begin
            $display( ">> Could not open reference or error files" );
            read   <=  1'b0;
        end
        else begin
            $display( "Reference and error files opened" );
            read   <=  1'b1;
        end
        
    end
    
    /* Clock */
    always@( posedge i_clock ) begin
        
        if( read    ==  1'b1 ) begin
            
            $fscanf( file_reference,    "%f:\n", reference_values[ 0 ][ count ] );
            $fscanf( file_error,        "%f:\n", error_values[ 0 ][ count ] );
                            
            if( count   <  VALUES_SIZE ) begin
                count   <=  count + 1;
            end
            else begin
                read    <=  1'b0;
                log     <=  1'b1;
                count   <=  1'b0;
            end

        end
        else if( log    ==  1'b1 ) begin
                $display( ">> %d: %f - %f", count,  reference_values[ 0 ][ count ],
                                                    error_values[ 0 ][ count ]);
                                                    
                if( count   <  VALUES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    log     <=  1'b0;
                end
        end
            
    end

endmodule
