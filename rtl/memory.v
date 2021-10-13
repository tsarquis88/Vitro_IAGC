`timescale 1ns / 1ps

module memory #                      
(
    parameter   DATA_SIZE   =   14,
    parameter   ADDR_SIZE   =   19,
    parameter   MEMORY_SIZE =   10    
)
(
    input                           i_clock,
    input                           i_reset,
    input   [ ADDR_SIZE - 1 : 0 ]   i_addr,
    input                           i_read,
    input                           i_write,
    input   [ DATA_SIZE - 1 : 0 ]   i_data,
    input                           i_clean,
    output  [ DATA_SIZE - 1 : 0 ]   o_data         
);
    
    reg [ DATA_SIZE - 1 : 0 ]   memory [ MEMORY_SIZE - 1 : 0 ];
    reg [ DATA_SIZE - 1 : 0 ]   data;
    reg                         cleaning;
    integer                     clean_addr;

    always@( negedge i_clock ) begin
        if( i_reset ) begin     
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