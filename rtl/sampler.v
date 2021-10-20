`timescale 1ns / 1ps
`default_nettype none

module sampler # 
(
    parameter DATA_SIZE         = 16,
    parameter ADDR_SIZE         = 12,
    parameter MEMORY_SIZE       = 1024,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input  wire                                 i_clock,
    input  wire [ DATA_SIZE        - 1 : 0 ]    i_data,
    input  wire                                 i_gate,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    output wire [ ADDR_SIZE        - 1 : 0 ]    o_addr, 
    output wire [ DATA_SIZE        - 1 : 0 ]    o_data,
    output wire                                 o_end
);

    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;
    localparam IAGC_STATUS_DUMP_MEM     = 4'b0111;

    localparam DECIMATE_DEFAULT =   4;   
    localparam STATUS_SIZE      =   3;
    
    localparam STATUS_INIT      =   0;
    localparam STATUS_WAIT      =   1;
    localparam STATUS_WRITE     =   2;
    localparam STATUS_END       =   3;
    
    reg     [ STATUS_SIZE   - 1 : 0 ]   status;
    reg     [ STATUS_SIZE   - 1 : 0 ]   next_status;
    reg     [ ADDR_SIZE     - 1 : 0 ]   addr;
    reg     [ DATA_SIZE     - 1 : 0 ]   decimate_order;
    reg     [ DATA_SIZE     - 1 : 0 ]   sample;
    
    integer                             samples_count;
    integer                             end_count;
    reg                                 first_write;
    reg                                 last_i_gate;
    wire                                posedge_i_gate;
    
    always@( posedge i_clock ) begin
    
        if( i_iagc_status == IAGC_STATUS_RESET ) begin
            
            status          <= STATUS_INIT;
            decimate_order  <= DECIMATE_DEFAULT;
            
        end
        else begin
        
            status          <= next_status;
            last_i_gate     <= i_gate;
            
            decimate_order  <= DECIMATE_DEFAULT;
            
            case( status )
                
                STATUS_INIT: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    samples_count   <= 0;
                    sample          <= { DATA_SIZE { 1'b0 } };
                    end_count       <= 0;
                end
                
                STATUS_WAIT: begin
                    addr            <= addr;
                    first_write     <= first_write;
                    samples_count   <= 0;
                    sample          <= sample;
                    end_count       <= 0;
                end
                
                STATUS_WRITE: begin
                    if( samples_count >= decimate_order - 1 ) begin
                        addr            <= first_write ? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                        samples_count   <= 0;
                        sample          <= i_data;
                        first_write     <= 1'b0;
                    end
                    else begin
                        addr            <= addr;
                        samples_count   <= samples_count + 1;
                        sample          <= sample;
                        first_write     <= first_write;
                    end
                    
                    end_count       <= 0;
                end
                
                STATUS_END: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    samples_count   <= 0;
                    sample          <= { DATA_SIZE { 1'b0 } };
                    end_count       <= end_count + 1;
                end
            
                default: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_write     <= 1'b1;
                    samples_count   <= 0;
                    sample          <= { DATA_SIZE { 1'b0 } };
                    end_count       <= 0;
                end
                
            endcase 
        end
    end
    
    always@( * ) begin
        case( status )
        
            STATUS_INIT: begin
                next_status = i_iagc_status == IAGC_STATUS_SAMPLE ? STATUS_WAIT : STATUS_INIT;
            end
        
            STATUS_WAIT: begin
                next_status = posedge_i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_WRITE: begin
                if( addr == MEMORY_SIZE - 1 )
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
    
    assign posedge_i_gate   = i_gate && ~last_i_gate ? 1'b1 : 1'b0;
    assign o_end            = status == STATUS_END;
    assign o_data           = sample;
    assign o_addr           = addr;   
    
endmodule

`default_nettype wire
