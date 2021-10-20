`timescale 1ns / 1ps
`default_nettype none

module memory #                      
(
    parameter DATA_SIZE         = 16,
    parameter ADDR_SIZE         = 12,
    parameter MEMORY_SIZE       = 1024,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input  wire                                 i_clock,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    input  wire [ ADDR_SIZE        - 1 : 0 ]    i_raddr,
    input  wire [ ADDR_SIZE        - 1 : 0 ]    i_waddr,
    input  wire [ DATA_SIZE        - 1 : 0 ]    i_data,
    output wire                                 o_clean_end,
    output wire [ DATA_SIZE        - 1 : 0 ]    o_data         
);
    
    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;
    localparam IAGC_STATUS_DUMP_MEM     = 4'b0111;
    localparam IAGC_STATUS_CLEAN_MEM    = 4'b1000;

    reg [ DATA_SIZE - 1 : 0 ]   memory [ MEMORY_SIZE - 1 : 0 ];
    reg [ DATA_SIZE - 1 : 0 ]   data;
    
    reg                         clean_end;
    reg                         clean_first;
    integer                     clean_addr;

    always@( negedge i_clock ) begin
    
        case( i_iagc_status )
        
            IAGC_STATUS_SAMPLE: begin     
                memory[ i_waddr ]       <= i_data;
                clean_end               <= 1'b0; 
                clean_addr              <= 0;
                clean_first             <= 1'b1;
            end
        
            IAGC_STATUS_DUMP_MEM: begin
                data                    <= memory[ i_raddr ];
                clean_end               <= 1'b0;
                clean_addr              <= 0;
                clean_first             <= 1'b1; 
            end
            
            IAGC_STATUS_CLEAN_MEM: begin
                if( clean_addr >= MEMORY_SIZE - 1 ) begin
                    clean_end       <= 1'b1;
                    clean_addr      <= clean_addr;
                end
                else begin
                    clean_end       <= 1'b0;
                    clean_addr      <= clean_first ? 0 : clean_addr + 1;
                end
                
                memory[ clean_addr ]    <= { DATA_SIZE { 1'b0 } };
                clean_first             <= 1'b0;
            end
            
            default: begin
                clean_end   <= 1'b0;
                clean_addr  <= 0;
                clean_first <= 1'b1;
            end
        endcase
    end    
    
    assign o_data       = data;
    assign o_clean_end  = clean_end;

endmodule

`default_nettype wire