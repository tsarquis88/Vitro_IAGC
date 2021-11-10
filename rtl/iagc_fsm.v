`timescale 1ns / 1ps
`default_nettype none

module iagc_fsm #
(
    parameter STATUS_SIZE       = 4,
    parameter DEF_MEMORY_SIZE   = 4096,
    parameter CMD_PARAM_SIZE    = 4,
    parameter ADDR_SIZE         = 12,
    parameter DECIMATOR_SIZE    = 4,
    parameter DEF_DECIMATOR     = 4,
    parameter DEF_PHASE_COUNT   = 256,
    parameter PHASE_COUNT_SIZE  = 16
)
(
    input  wire                                 i_clock,
    input  wire                                 i_reset,
    input  wire                                 i_adc1410_init_done,
    input  wire                                 i_dac1411_init_done,
    input  wire                                 i_sample,
    input  wire                                 i_cmd_valid,
    input  wire                                 i_sample_end,
    input  wire                                 i_dump_end,
    input  wire                                 i_clean_end,
    input  wire [ CMD_PARAM_SIZE   - 1 : 0 ]    i_cmd_operation,
    input  wire [ CMD_PARAM_SIZE   - 1 : 0 ]    i_cmd_parameter,
    output wire [ ADDR_SIZE        - 1 : 0 ]    o_memory_size,
    output wire [ DECIMATOR_SIZE   - 1 : 0 ]    o_decimator,
    output wire [ PHASE_COUNT_SIZE - 1 : 0 ]    o_phase_count,
    output wire [ STATUS_SIZE      - 1 : 0 ]    o_status
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
    localparam IAGC_STATUS_SET_PHA      = 4'b1100;
    localparam IAGC_STATUS_HALT         = 4'b1101;
    
    localparam CMD_EMPTY        = 0; /* Falso comando recibido en ocaciones */
    localparam CMD_RESET        = 1;
    localparam CMD_SAMPLE       = 2;
    localparam CMD_SET_DEC      = 3;
    localparam CMD_CLEAN_MEM    = 4;
    localparam CMD_DUMP_REF     = 5;
    localparam CMD_DUMP_ERR     = 6;
    localparam CMD_SET_MEM      = 7;
    localparam CMD_SET_PHA      = 8;
    localparam CMD_HALT         = 9;
        
    reg     [ STATUS_SIZE      - 1 : 0 ]    status;
    reg     [ STATUS_SIZE      - 1 : 0 ]    next_status;
    
    reg     [ ADDR_SIZE        - 1 : 0 ]    memory_size;
    reg     [ DECIMATOR_SIZE   - 1 : 0 ]    decimator;
    reg     [ PHASE_COUNT_SIZE - 1 : 0 ]    phase_count;
    
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            status <= IAGC_STATUS_RESET;
        end
        else begin
            status <= next_status;
                
            case( status )
            
                IAGC_STATUS_RESET: begin
                    memory_size <= DEF_MEMORY_SIZE;
                    decimator   <= DEF_DECIMATOR;
                    phase_count <= DEF_PHASE_COUNT;
                end
                
                IAGC_STATUS_INIT: begin
                    memory_size <= DEF_MEMORY_SIZE;
                    decimator   <= DEF_DECIMATOR;
                    phase_count <= DEF_PHASE_COUNT;
                end
                
                IAGC_STATUS_IDLE: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_SAMPLE: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_CMD_PARSE: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_CMD_READ: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_CMD_ERROR: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_DUMP_REF: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_DUMP_ERR: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_CLEAN_MEM: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_SET_MEM: begin
                    memory_size <= 1 << i_cmd_parameter;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_SET_DEC: begin
                    memory_size <= memory_size;
                    decimator   <= i_cmd_parameter;
                    phase_count <= phase_count;
                end
                
                IAGC_STATUS_SET_PHA: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= 1 << i_cmd_parameter;
                end
                
                IAGC_STATUS_HALT: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
                            
                default: begin
                    memory_size <= memory_size;
                    decimator   <= decimator;
                    phase_count <= phase_count;
                end
            endcase
        end
    end
    
    always@( * ) begin
        case( status )
            
            IAGC_STATUS_RESET: begin
                next_status = IAGC_STATUS_INIT;
            end
            
            IAGC_STATUS_INIT: begin
                next_status = i_adc1410_init_done && i_dac1411_init_done ? IAGC_STATUS_IDLE : IAGC_STATUS_INIT;
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
                case( i_cmd_operation )
                    CMD_EMPTY:      next_status = IAGC_STATUS_IDLE;
                    CMD_RESET:      next_status = IAGC_STATUS_RESET;
                    CMD_DUMP_REF:   next_status = IAGC_STATUS_DUMP_REF;
                    CMD_DUMP_ERR:   next_status = IAGC_STATUS_DUMP_ERR;
                    CMD_SAMPLE:     next_status = IAGC_STATUS_SAMPLE;
                    CMD_CLEAN_MEM:  next_status = IAGC_STATUS_CLEAN_MEM;
                    CMD_SET_MEM:    next_status = IAGC_STATUS_SET_MEM;
                    CMD_SET_DEC:    next_status = IAGC_STATUS_SET_DEC;
                    CMD_SET_PHA:    next_status = IAGC_STATUS_SET_PHA;
                    CMD_HALT:       next_status = IAGC_STATUS_HALT;
                    default:        next_status = IAGC_STATUS_CMD_ERROR;
                endcase
            end
            
            IAGC_STATUS_CMD_ERROR: begin
                next_status = IAGC_STATUS_IDLE;
            end
            
            IAGC_STATUS_DUMP_REF: begin
                next_status = i_dump_end ? IAGC_STATUS_IDLE : IAGC_STATUS_DUMP_REF; 
            end
            
            IAGC_STATUS_DUMP_ERR: begin
                next_status = i_dump_end ? IAGC_STATUS_IDLE : IAGC_STATUS_DUMP_ERR; 
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
            
            IAGC_STATUS_SET_PHA: begin
                next_status = IAGC_STATUS_IDLE; 
            end
            
            IAGC_STATUS_HALT: begin
                next_status = IAGC_STATUS_HALT; 
            end
                        
            default: begin
                next_status = IAGC_STATUS_RESET;
            end
            
        endcase
    end
    
    assign o_status         = status;
    assign o_memory_size    = memory_size;
    assign o_decimator      = decimator;
    assign o_phase_count    = phase_count;
    
endmodule

`default_nettype wire
