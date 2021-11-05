`timescale 1ns / 1ps
`default_nettype none

module adc_sampler # 
(
    parameter DATA_SIZE         = 16,
    parameter ADDR_SIZE         = 12,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input  wire                                 i_clock,
    input  wire [ DATA_SIZE        - 1 : 0 ]    i_reference,
    input  wire [ DATA_SIZE        - 1 : 0 ]    i_error,
    input  wire                                 i_gate,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    input  wire [ ADDR_SIZE        - 1 : 0 ]    i_memory_size,
    input  wire                                 i_sample,
    output wire [ ADDR_SIZE        - 1 : 0 ]    o_addr, 
    output wire [ DATA_SIZE        - 1 : 0 ]    o_reference_sample,
    output wire [ DATA_SIZE        - 1 : 0 ]    o_error_sample,
    output wire                                 o_end
);

    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;
    localparam IAGC_STATUS_DUMP_REF     = 4'b0111;
    localparam IAGC_STATUS_DUMP_ERR     = 4'b1000;
    localparam IAGC_STATUS_CLEAN_MEM    = 4'b1001;
    localparam IAGC_STATUS_SET_MEM      = 4'b1010;
    localparam IAGC_STATUS_SET_DEC      = 4'b1011;
    localparam IAGC_STATUS_HALT         = 4'b1100;

    localparam STATUS_SIZE      =   3;
    
    localparam STATUS_INIT      =   0;
    localparam STATUS_WAIT      =   1;
    localparam STATUS_WRITE     =   2;
    localparam STATUS_END       =   3;
    
    reg     [ STATUS_SIZE   - 1 : 0 ]   status;
    reg     [ STATUS_SIZE   - 1 : 0 ]   next_status;
    reg     [ ADDR_SIZE     - 1 : 0 ]   addr;
    reg     [ DATA_SIZE     - 1 : 0 ]   ref_sample;
    reg     [ DATA_SIZE     - 1 : 0 ]   err_sample;
    
    integer                             end_count;
    reg                                 first_write;
    reg                                 last_i_gate;
    wire                                posedge_i_gate;
    
    always@( posedge i_clock ) begin
    
        if( i_iagc_status == IAGC_STATUS_RESET ) begin
            
            status          <= STATUS_INIT;
                        
        end
        else begin
        
            status          <= next_status;
            last_i_gate     <= i_gate;
                        
            case( status )
                
                STATUS_INIT: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    ref_sample      <= { DATA_SIZE { 1'b0 } };
                    err_sample      <= { DATA_SIZE { 1'b0 } };
                    end_count       <= 0; 
                end
                
                STATUS_WAIT: begin
                    addr            <= addr;
                    first_write     <= first_write;
                    ref_sample      <= ref_sample;
                    err_sample      <= err_sample;
                    end_count       <= 0;
                end
                
                STATUS_WRITE: begin
                    if( i_sample ) begin
                        addr            <= first_write ? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                        ref_sample      <= i_reference;
                        err_sample      <= i_error;
                        first_write     <= 1'b0;
                    end
                    else begin
                        addr            <= addr;
                        ref_sample      <= ref_sample;
                        err_sample      <= err_sample;
                        first_write     <= first_write;
                    end
                    
                    end_count       <= 0;
                end
                
                STATUS_END: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    ref_sample      <= { DATA_SIZE { 1'b0 } };
                    err_sample      <= { DATA_SIZE { 1'b0 } };
                    end_count       <= end_count + 1;
                end
            
                default: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    ref_sample      <= { DATA_SIZE { 1'b0 } };
                    err_sample      <= { DATA_SIZE { 1'b0 } };
                    end_count       <= 0;
                end
                
            endcase 
        end
    end
    
    always@( * ) begin
        case( status )
        
            STATUS_INIT: begin
                next_status = i_iagc_status == IAGC_STATUS_SAMPLE ? STATUS_WRITE : STATUS_INIT;
            end
        
            STATUS_WAIT: begin
                next_status = posedge_i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_WRITE: begin
                if( addr == i_memory_size - 1 )
                    next_status = STATUS_END;
                else
                    next_status = i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_END: begin
                next_status = end_count >= 3 ? STATUS_INIT : STATUS_END;
            end
            
            default: begin
                next_status =   STATUS_INIT;
            end
        endcase
    end
    
    assign posedge_i_gate       = i_gate && ~last_i_gate ? 1'b1 : 1'b0;
    assign o_end                = status == STATUS_END;
    assign o_reference_sample   = ref_sample;
    assign o_error_sample       = err_sample;
    assign o_addr               = addr;   
    
endmodule

`default_nettype wire
