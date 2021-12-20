`timescale 1ns / 1ps
`default_nettype none

module amplitude_detector #
(
    parameter IAGC_STATUS_SIZE      = 4,
    parameter ZMOD_DATA_SIZE        = 14,
    parameter AMPLITUDE_DATA_SIZE   = 14,
    parameter AMPLITUDE_COUNT_SIZE  = 16
)
(
    input  wire                                             i_clock,
    input  wire                                             i_sample,
    input  wire        [ IAGC_STATUS_SIZE      - 1 : 0 ]    i_iagc_status,
    input  wire signed [ ZMOD_DATA_SIZE        - 1 : 0 ]    i_reference,
    input  wire signed [ ZMOD_DATA_SIZE        - 1 : 0 ]    i_error,
    input  wire        [ AMPLITUDE_COUNT_SIZE  - 1 : 0 ]    i_amplitude_count,
    output wire        [ AMPLITUDE_DATA_SIZE   - 1 : 0 ]    o_reference_amplitude,
    output wire        [ AMPLITUDE_DATA_SIZE   - 1 : 0 ]    o_error_amplitude,
    output wire                                             o_valid
);

    localparam IAGC_STATUS_RESET    = 4'b0000;
    localparam IAGC_STATUS_INIT     = 4'b0001;
    
    localparam STATUS_SIZE      = 2;
    
    localparam STATUS_INIT      = 0;
    localparam STATUS_SAMPLE    = 1;
    localparam STATUS_DETECT    = 2;
    localparam STATUS_VALID     = 3;
    
    reg        [ STATUS_SIZE         - 1 : 0 ]   status;           
    reg        [ STATUS_SIZE         - 1 : 0 ]   next_status;
    reg signed [ ZMOD_DATA_SIZE      - 1 : 0 ]   max_reference;
    reg signed [ ZMOD_DATA_SIZE      - 1 : 0 ]   max_error;
    reg        [ AMPLITUDE_DATA_SIZE - 1 : 0 ]   reference_amplitude;
    reg        [ AMPLITUDE_DATA_SIZE - 1 : 0 ]   error_amplitude;
            
    integer samples;
    
    always@( posedge i_clock ) begin
        
        status <= i_iagc_status == IAGC_STATUS_RESET ? STATUS_INIT : next_status;
        
        case( status )
            
            STATUS_INIT: begin
                max_reference       <= { ZMOD_DATA_SIZE { 1'b0 } };
                max_error           <= { ZMOD_DATA_SIZE { 1'b0 } };
                reference_amplitude <= reference_amplitude;
                error_amplitude     <= error_amplitude;
                samples             <= 0;
            end
            
            STATUS_SAMPLE: begin
                if( i_sample ) begin
                    max_reference       <= i_reference > max_reference ? i_reference : max_reference;
                    max_error           <= i_error     > max_error     ? i_error     : max_error;
                    reference_amplitude <= reference_amplitude;
                    error_amplitude     <= error_amplitude;
                    samples             <= samples + 1;
                end
                else begin
                    max_reference       <= max_reference;
                    max_error           <= max_error;
                    reference_amplitude <= reference_amplitude;
                    error_amplitude     <= error_amplitude;
                    samples             <= samples;
                end
            end
            
            STATUS_DETECT: begin
                max_reference       <= max_reference;
                max_error           <= max_error;
                reference_amplitude <= max_reference;
                error_amplitude     <= max_error;
                samples             <= samples;
            end
            
            STATUS_VALID: begin
                max_reference       <= max_reference;
                max_error           <= max_error;
                reference_amplitude <= reference_amplitude;
                error_amplitude     <= error_amplitude;
                samples             <= samples;
            end
            
            default: begin 
                max_reference       <= { ZMOD_DATA_SIZE { 1'b0 } };
                max_error           <= { ZMOD_DATA_SIZE { 1'b0 } };
                reference_amplitude <= reference_amplitude;
                error_amplitude     <= error_amplitude;
                samples             <= 0;
            end
            
        endcase
    end
    
    always@( * ) begin
        case( status )
            STATUS_INIT:    next_status = i_iagc_status == IAGC_STATUS_RESET ? STATUS_INIT   : STATUS_SAMPLE;
            STATUS_SAMPLE:  next_status = samples       >= i_amplitude_count ? STATUS_DETECT : STATUS_SAMPLE;
            STATUS_DETECT:  next_status = STATUS_VALID;
            STATUS_VALID:   next_status = STATUS_INIT;            
            default:        next_status = STATUS_INIT;           
        endcase
    end
    
    assign o_reference_amplitude    = reference_amplitude;
    assign o_error_amplitude        = error_amplitude;
    assign o_valid                  = status == STATUS_VALID;
    
endmodule

`default_nettype wire
