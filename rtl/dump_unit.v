`timescale 1ns / 1ps
`default_nettype none

module dump_unit # 
(
    parameter ADDR_SIZE         = 12,
    parameter IAGC_STATUS_SIZE  = 4,
    parameter SAMPLER_DATA_SIZE = 16,
    parameter UART_DATA_SIZE    = 8
)
(
    input  wire                                 i_clock,
    input  wire                                 i_ready,
    input  wire [ IAGC_STATUS_SIZE  - 1 : 0 ]   i_iagc_status,
    input  wire [ ADDR_SIZE         - 1 : 0 ]   i_memory_size,
    input  wire [ SAMPLER_DATA_SIZE - 1 : 0 ]   i_memory_data,
    output wire [ UART_DATA_SIZE    - 1 : 0 ]   o_data,
    output wire [ ADDR_SIZE         - 1 : 0 ]   o_addr,
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
   
    localparam STATUS_SIZE  = 4;
    
    localparam STATUS_INIT          = 0;
    localparam STATUS_FETCH         = 1;
    localparam STATUS_DATA_HIGH     = 2;
    localparam STATUS_VALID_HIGH    = 3;
    localparam STATUS_SEND_HIGH     = 4;
    localparam STATUS_DATA_LOW      = 5;
    localparam STATUS_VALID_LOW     = 6;
    localparam STATUS_SEND_LOW      = 7;
    localparam STATUS_DATA_SYN      = 8;
    localparam STATUS_VALID_SYN     = 9;
    localparam STATUS_SEND_SYN      = 10;
    localparam STATUS_END           = 11;
    
    reg     [ STATUS_SIZE    - 1 : 0 ]  status;
    reg     [ STATUS_SIZE    - 1 : 0 ]  next_status;
    
    reg     [ ADDR_SIZE      - 1 : 0 ]  addr;
    reg                                 valid;
    reg                                 first;
    reg     [ UART_DATA_SIZE - 1 : 0 ]  data;
    
    integer                             counter;
    
    always@( posedge i_clock ) begin
    
        if( i_iagc_status == IAGC_STATUS_RESET ) begin
            
            status <= STATUS_INIT;
            
        end
        else begin
        
            status <= next_status;
            
            case( status )
                
                STATUS_INIT: begin
                    addr    <= { ADDR_SIZE { 1'b0 } };
                    valid   <= 1'b0;
                    first   <= 1'b1;
                    counter <= 0;
                    data    <= { UART_DATA_SIZE { 1'b0 } };
                end
                
                STATUS_FETCH: begin
                    addr    <= first ? { ADDR_SIZE { 1'b0 } } : addr + 1;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= data;
                end
                
                STATUS_DATA_HIGH: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= i_memory_data[ 15 : 8 ];
                end
                
                STATUS_VALID_HIGH: begin
                    addr    <= addr;
                    valid   <= 1'b1;
                    first   <= 1'b0;
                    counter <= counter + 1;
                    data    <= data;
                end
                
                STATUS_SEND_HIGH: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= data;
                end
                
                STATUS_DATA_LOW: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= i_memory_data[ 7 : 0 ];
                end
                
                STATUS_VALID_LOW: begin
                    addr    <= addr;
                    valid   <= 1'b1;
                    first   <= 1'b0;
                    counter <= counter + 1;
                    data    <= data;
                end
                
                STATUS_SEND_LOW: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= data;
                end
                
                STATUS_DATA_SYN: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= { UART_DATA_SIZE { 1'b1 } };
                end
                
                STATUS_VALID_SYN: begin
                    addr    <= addr;
                    valid   <= 1'b1;
                    first   <= 1'b0;
                    counter <= counter + 1;
                    data    <= data;
                end
                
                STATUS_SEND_SYN: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= 0;
                    data    <= data;
                end
                
                STATUS_END: begin
                    addr    <= addr;
                    valid   <= 1'b0;
                    first   <= 1'b0;
                    counter <= counter + 1;
                    data    <= { UART_DATA_SIZE { 1'b0 } };
                end
                
                default: begin
                    addr    <= { ADDR_SIZE { 1'b0 } };
                    valid   <= 1'b0;
                    first   <= 1'b1;
                    counter <= 0;
                    data    <= { UART_DATA_SIZE { 1'b0 } };
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
                next_status = addr >= i_memory_size - 1 ? STATUS_END : STATUS_DATA_HIGH;
            end
            
            STATUS_DATA_HIGH: begin
                next_status = STATUS_VALID_HIGH;
            end
            
            STATUS_VALID_HIGH: begin
                next_status = counter >= 3 ? STATUS_SEND_HIGH : STATUS_VALID_HIGH;                
            end
            
            STATUS_SEND_HIGH: begin
                next_status = i_ready ? STATUS_DATA_LOW : STATUS_SEND_HIGH;
            end
            
            STATUS_DATA_LOW: begin
                next_status = STATUS_VALID_LOW;
            end
            
            STATUS_VALID_LOW: begin
                next_status = counter >= 3 ? STATUS_SEND_LOW: STATUS_VALID_LOW;                
            end
            
            STATUS_SEND_LOW: begin
                next_status = i_ready ? STATUS_DATA_SYN : STATUS_SEND_LOW;
            end
            
            STATUS_DATA_SYN: begin
                next_status = STATUS_VALID_SYN;
            end
            
            STATUS_VALID_SYN: begin
                next_status = counter >= 3 ? STATUS_SEND_SYN: STATUS_VALID_SYN;                
            end
            
            STATUS_SEND_SYN: begin
                next_status = i_ready ? STATUS_FETCH : STATUS_SEND_SYN;
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
    assign o_data   = data;
        
endmodule

`default_nettype wire
