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

module monopulse
(
    input   i_reset,
    input   i_clock
);

    localparam      VALUES_SIZE     =   10501;
    localparam      SAMPLES_SIZE    =   10000;
    localparam      STATUS_SIZE     =   2;
    localparam [1:0]    
                    generate_status = 2'b00,                   
                    process_status  = 2'b01,                   
                    display_status  = 2'b10,                    
                    end_status      = 2'b11;
                    
    const real pi   = 3.1416;
    const real T    = 1.0;
    
    real        f       = 1000;
    real        t;

    integer         file_reference;
    integer         file_error;
    integer         count;
    
    reg             [ STATUS_SIZE - 1 : 0 ] status;
    
    real    reference_values    [ 64 : 0 ] [ 0 : VALUES_SIZE - 1 ];
    real    error_values        [ 64 : 0 ] [ 0 : VALUES_SIZE - 1 ];
    real    processed           [ 64 : 0 ] [ 0 : VALUES_SIZE - 1 ];
    
    /* Initial */
    initial begin     
        
        file_reference  =   $fopen( "/home/tomsar/eclypse_z7/monopulse/reference.signal", "r" );
        file_error      =   $fopen( "/home/tomsar/eclypse_z7/monopulse/error.signal", "r" );
        
    end
    
    /* Reset */
    always@( posedge i_reset ) begin
    
        count           <=  1'b0;

        if ( !file_reference || !file_error ) begin
            $display( ">> Could not open reference or error files" );
            status  <=  end_status;
        end
        else begin
            $display( "Reference and error files opened" );
            status  <=  generate_status;
            $display( ">> READING" );
        end
        
    end
    
    /* Clock */
    always@( posedge i_clock ) begin
        
       case( status )
       
            generate_status: begin
                //$fscanf( file_reference,    "%f:\n", reference_values[ 0 ][ count ] );
                //$fscanf( file_error,        "%f:\n", error_values[ 0 ][ count ] );
                
                t   <=  ( T / SAMPLES_SIZE ) * count;
                
                reference_values[ 0 ][ count ]  <=  $sin( 2 * pi * f * t );
                //error_values[ 0 ][ count ]      <=  0.5 * $sin( 2 * pi * f * t );
                                
                if( count   <  VALUES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    status  <=  process_status;
                    count   <=  0;
                    $display( ">> PROCESSING" );
                end
            end
            
            process_status: begin
                if( reference_values[ 0 ][ count ] != 0 && error_values[ 0 ][ count ] != 0 ) begin
                    processed[ 0 ][ count ] <=  error_values[ 0 ][ count ] / 
                                                reference_values[ 0 ][ count ];
                    if( processed[ 0 ][ count ] < 0) begin
                        processed[ 0 ][ count ] <= processed[ 0 ][ count ] * (-1.0);
                    end
                end
                else begin
                    processed[ 0 ][ count ] <= 0.0;
                end               
                    
                if( count   <  VALUES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    status          <=  display_status;
                    count           <=  0;
                    $display( ">> DISPLAYING" );
                end
            end
            
            display_status: begin
                $display( ">> %d: %f", count, processed[ 0 ][ count ] );    
                                
                if( count   <  VALUES_SIZE ) begin
                    count   <=  count + 1;
                end
                else begin
                    status  <=  end_status;
                    $display(  ">> ENDING" );
                end
            end
            
            end_status: begin
                // narnia
            end
            
        endcase
            
    end

endmodule
