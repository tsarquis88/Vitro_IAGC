`timescale 1ns / 1ps
`default_nettype none

module dump_unit # 
(
    parameter ADDR_SIZE         = 12,
    parameter MEMORY_SIZE       = 1024,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input  wire                                 i_clock,
    input  wire                                 i_ready,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    output wire [ ADDR_SIZE        - 1 : 0 ]    o_addr,
    output wire                                 o_valid,
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
   
    localparam STATUS_SIZE  = 3;
    
    localparam STATUS_INIT  = 0;
    localparam STATUS_FETCH = 1;
    localparam STATUS_VALID = 2;
    localparam STATUS_SEND  = 3;
    localparam STATUS_END   = 4;
    
    reg     [ STATUS_SIZE   - 1 : 0 ]   status;
    reg     [ STATUS_SIZE   - 1 : 0 ]   next_status;
    
    reg     [ ADDR_SIZE     - 1 : 0 ]   addr;
    reg                                 valid;
    reg                                 first;
    
    integer                             counter;
    
    always@( posedge i_clock ) begin
    
        if( i_iagc_status == IAGC_STATUS_RESET ) begin
            
            status          <= STATUS_INIT;
            
        end
        else begin
        
            status          <= next_status;
            
            case( status )
                
                STATUS_INIT: begin
                    addr    <= { ADDR_SIZE { 1'b0 } };
                    valid   <= 1'b0;
                    first   <= 1'b1;
                    counter <= 0;
                end
                
                STATUS_FETCH: begin
                    addr    <= first ? { ADDR_SIZE { 1'b0 } } : addr + 1;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                end
                
                STATUS_VALID: begin
                    addr    <= addr;
                    valid   <= 1'b1;
                    first   <= 1'b0;
                    counter <= counter + 1;
                end
                
                STATUS_SEND: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                end
                
                STATUS_END: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= counter + 1;
                end
                
                default: begin
                    addr    <= { ADDR_SIZE { 1'b0 } };
                    valid   <= 1'b0;
                    first   <= 1'b1;
                    counter <= 0;
                end
                
            endcase 
        end
    end
    
    always@( * ) begin
        case( status )
        
            STATUS_INIT: begin
                next_status = i_iagc_status == IAGC_STATUS_DUMP_MEM ? STATUS_FETCH : STATUS_INIT;
            end
        
            STATUS_FETCH: begin
                next_status = addr >= MEMORY_SIZE - 1 ? STATUS_END : STATUS_VALID;
            end
            
            STATUS_VALID: begin
                next_status = counter >= 3 ? STATUS_SEND : STATUS_VALID;                
            end
            
            STATUS_SEND: begin
                next_status = i_ready ? STATUS_FETCH : STATUS_SEND;
            end
            
            STATUS_END: begin
                next_status = counter >= 3 ? STATUS_INIT : STATUS_END;                
            end
            
            default: begin
                next_status = STATUS_INIT;
            end
        endcase
    end
    
    assign o_addr   = addr;
    assign o_valid  = valid;
    assign o_end    = status == STATUS_END;
        
endmodule

`default_nettype wire
