`timescale 1ns / 1ps
`default_nettype none

module phase_detector #
(
    parameter IAGC_STATUS_SIZE  = 4,
    parameter ZMOD_DATA_SIZE    = 14,
    parameter PHASE_COUNT_SIZE  = 16
)
(
    input  wire                                         i_clock,
    input  wire                                         i_sample,
    input  wire        [ IAGC_STATUS_SIZE  - 1 : 0 ]    i_iagc_status,
    input  wire signed [ ZMOD_DATA_SIZE    - 1 : 0 ]    i_reference,
    input  wire signed [ ZMOD_DATA_SIZE    - 1 : 0 ]    i_error,
    input  wire        [ PHASE_COUNT_SIZE  - 1 : 0 ]    i_phase_count,
    output wire                                         o_in_phase
);

    localparam IAGC_STATUS_RESET    = 4'b0000;
    localparam IAGC_STATUS_INIT     = 4'b0001;
    
    localparam STATUS_SIZE      = 2;
    
    localparam STATUS_INIT      = 0;
    localparam STATUS_SAMPLE    = 1;
    localparam STATUS_DETECT    = 2;
    
    reg     [ STATUS_SIZE - 1 : 0 ] status;           
    reg     [ STATUS_SIZE - 1 : 0 ] next_status;
            
    integer phase_counter;
    integer no_phase_counter;
    integer samples;
    reg     in_phase;
    
    always@( posedge i_clock ) begin
        
        status <= i_iagc_status == IAGC_STATUS_RESET ? STATUS_INIT : next_status;
        
        case( status )
            
            STATUS_INIT: begin
                phase_counter       <= 0;
                no_phase_counter    <= 0;
                samples             <= 0;
                in_phase            <= in_phase;
            end
            
            STATUS_SAMPLE: begin
                if( i_sample ) begin
                    if( i_reference >= 0 && i_error >= 0 )
                        phase_counter       <= phase_counter + 1;
                    else if( i_reference < 0 && i_error < 0 )
                        phase_counter       <= phase_counter + 1;
                    else
                        no_phase_counter    <= no_phase_counter + 1;
                        
                    samples <= samples + 1;
                end
                else begin
                    samples             <= samples;
                    phase_counter       <= phase_counter;
                    no_phase_counter    <= no_phase_counter;
                end
                
                in_phase            <= in_phase;
            end
            
            STATUS_DETECT: begin
                samples             <= samples;
                phase_counter       <= phase_counter;
                no_phase_counter    <= no_phase_counter;
                in_phase            <= phase_counter >= no_phase_counter;
            end
            
            default: begin 
                phase_counter       <= 0;
                no_phase_counter    <= 0;
                samples             <= 0;
                in_phase            <= 1'b0;
            end
            
        endcase
    end
    
    always@( * ) begin
        case( status )
            STATUS_INIT:    next_status = i_iagc_status == IAGC_STATUS_RESET ? STATUS_INIT : STATUS_SAMPLE;
            STATUS_SAMPLE:  next_status = samples >= i_phase_count ? STATUS_DETECT : STATUS_SAMPLE;
            STATUS_DETECT:  next_status = STATUS_INIT;
            default:        next_status = STATUS_INIT;
        endcase
    end
    
    assign o_in_phase = in_phase;
    
endmodule

`default_nettype wire
