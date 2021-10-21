`timescale 1ns / 1ps
`default_nettype none

module iagc_fsm #
(
    parameter STATUS_SIZE       = 4,
    parameter DEF_MEMORY_SIZE   = 4096,
    parameter CMD_PARAM_SIZE    = 4,
    parameter ADDR_SIZE         = 12,
    parameter DECIMATOR_SIZE    = 4,
    parameter DEF_DECIMATOR     = 4
)
(
    input  wire                             i_clock,
    input  wire                             i_reset,
    input  wire                             i_adc1410_init_done,
    input  wire                             i_sample,
    input  wire                             i_cmd_valid,
    input  wire                             i_cmd_reset,
    input  wire                             i_cmd_sample,
    input  wire                             i_cmd_dump_mem,
    input  wire                             i_cmd_clean_mem,
    input  wire                             i_cmd_set_mem,
    input  wire                             i_cmd_set_decim,
    input  wire                             i_sample_end,
    input  wire                             i_dump_end,
    input  wire                             i_clean_end,
    input  wire [ CMD_PARAM_SIZE - 1 : 0 ]  i_cmd_parameter,
    output wire [ ADDR_SIZE      - 1 : 0 ]  o_memory_size,
    output wire [ DECIMATOR_SIZE - 1 : 0 ]  o_decimator,
    output wire [ STATUS_SIZE    - 1 : 0 ]  o_status
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
    localparam IAGC_STATUS_SET_MEM      = 4'b1001;
    localparam IAGC_STATUS_SET_DEC      = 4'b1010;
        
    reg     [ STATUS_SIZE    - 1 : 0 ]  status;
    reg     [ STATUS_SIZE    - 1 : 0 ]  next_status;
    reg     [ ADDR_SIZE      - 1 : 0 ]  memory_size;
    reg     [ DECIMATOR_SIZE - 1 : 0 ]  decimator;
    
    /* */
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            status      <= IAGC_STATUS_RESET;
            memory_size <= DEF_MEMORY_SIZE;
            decimator   <= DEF_DECIMATOR;
        end
        else begin
            status      <= next_status;
            
            if( status == IAGC_STATUS_SET_MEM )
                memory_size <= 1 << i_cmd_parameter;
            else
                memory_size <= memory_size;
                
            if( status == IAGC_STATUS_SET_DEC )
                decimator <= i_cmd_parameter;
            else
                decimator <= decimator;
        end
    end
    
    /* */
    always@( * ) begin
        case( status )
            
            IAGC_STATUS_RESET: begin
                next_status = IAGC_STATUS_INIT;
            end
            
            IAGC_STATUS_INIT: begin
                next_status = i_adc1410_init_done ? IAGC_STATUS_IDLE : IAGC_STATUS_INIT;
            end
            
            IAGC_STATUS_IDLE: begin
                if( i_cmd_valid )
                    next_status = IAGC_STATUS_CMD_PARSE;
                else if( i_sample )
                    next_status = IAGC_STATUS_SAMPLE;
                else
                    next_status = IAGC_STATUS_IDLE;
            end
            
            IAGC_STATUS_SAMPLE: begin
                next_status = i_sample_end ? IAGC_STATUS_IDLE : IAGC_STATUS_SAMPLE;
            end
            
            IAGC_STATUS_CMD_PARSE: begin
                next_status = IAGC_STATUS_CMD_READ;
            end
            
            IAGC_STATUS_CMD_READ: begin
                if( i_cmd_reset )
                    next_status = IAGC_STATUS_RESET;
                else if( i_cmd_sample )
                    next_status = IAGC_STATUS_SAMPLE;
                else if( i_cmd_dump_mem )
                    next_status = IAGC_STATUS_DUMP_MEM;
                else if( i_cmd_clean_mem )
                    next_status = IAGC_STATUS_CLEAN_MEM;
                else if( i_cmd_set_mem )
                    next_status = IAGC_STATUS_SET_MEM;
                else if( i_cmd_set_decim )
                    next_status = IAGC_STATUS_SET_DEC;
                else
                    next_status = IAGC_STATUS_CMD_ERROR;
            end
            
            IAGC_STATUS_CMD_ERROR: begin
                next_status = IAGC_STATUS_IDLE;
            end
            
            IAGC_STATUS_DUMP_MEM: begin
                next_status = i_dump_end ? IAGC_STATUS_IDLE : IAGC_STATUS_DUMP_MEM; 
            end
            
            IAGC_STATUS_CLEAN_MEM: begin
                next_status = i_clean_end ? IAGC_STATUS_IDLE : IAGC_STATUS_CLEAN_MEM; 
            end
            
            IAGC_STATUS_SET_MEM: begin
                next_status = IAGC_STATUS_IDLE; 
            end
            
            IAGC_STATUS_SET_DEC: begin
                next_status = IAGC_STATUS_IDLE; 
            end
                        
            default: begin
                next_status = IAGC_STATUS_RESET;
            end
            
        endcase
    end
    
    assign o_status         = status;
    assign o_memory_size    = memory_size;
    assign o_decimator      = decimator;
    
endmodule

`default_nettype wire
