`timescale 1ns / 1ps
`default_nettype none

module iagc_fsm#
(
    parameter   STATUS_SIZE =   4
)
(
    input  wire                         i_clock,
    input  wire                         i_reset,
    input  wire                         i_adc1410_init_done,
    input  wire                         i_sample,
    input  wire                         i_cmd_valid,
    input  wire                         i_cmd_reset,
    input  wire                         i_cmd_sample,
    input  wire                         i_cmd_dump_mem,
    input  wire                         i_cmd_clean_mem,
    input  wire                         i_sample_end,
    input  wire                         i_dump_end,
    input  wire                         i_clean_end,
    output wire [ STATUS_SIZE - 1 : 0 ] o_status
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
        
    reg     [ STATUS_SIZE - 1 : 0 ] status;
    reg     [ STATUS_SIZE - 1 : 0 ] next_status;
    
    /* */
    always@( posedge i_clock ) begin
        status  <= i_reset ? IAGC_STATUS_RESET : next_status;
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
                        
            default: begin
                next_status = IAGC_STATUS_RESET;
            end
            
        endcase
    end
    
    assign  o_status    = status;
    
endmodule

`default_nettype wire
