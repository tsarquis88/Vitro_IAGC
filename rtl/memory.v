`timescale 1ns / 1ps

module memory #                      
(
    parameter DATA_SIZE         = 14,
    parameter ADDR_SIZE         = 19,
    parameter MEMORY_SIZE       = 10,
    parameter IAGC_STATUS_SIZE  = 4
)
(
    input                                       i_clock,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    input   [ ADDR_SIZE - 1 : 0 ]               i_addr,
    input                                       i_read,
    input                                       i_write,
    input   [ DATA_SIZE - 1 : 0 ]               i_data,
    input                                       i_clean,
    output  [ DATA_SIZE - 1 : 0 ]               o_data         
);
    
    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;

    reg [ DATA_SIZE - 1 : 0 ]   memory [ MEMORY_SIZE - 1 : 0 ];
    reg [ DATA_SIZE - 1 : 0 ]   data;
    reg                         cleaning;
    integer                     clean_addr;

    always@( negedge i_clock ) begin
        if( i_iagc_status == IAGC_STATUS_RESET ) begin     
            data        <=  { DATA_SIZE { 1'b0 } };
            cleaning    <= 1'b0;
            clean_addr  <= 0;
        end
        else begin
            if( cleaning ) begin
                memory[ clean_addr ]    <= { DATA_SIZE { 1'b0 } };
                clean_addr              <= clean_addr + 1;
                cleaning                <= clean_addr >= MEMORY_SIZE ? 1'b0 : 1'b1;
            end
            else begin
                if( i_read )
                    data                <=  memory[ i_addr ];
                else if( i_write )   
                    memory[ i_addr ]    <=  i_data;
                else if( i_clean )
                    cleaning            <= 1'b1;
                    
                clean_addr  <= 0;
            end
        end
    end    
    
    assign  o_data  =   data;

endmodule