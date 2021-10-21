`timescale 1ns / 1ps
`default_nettype none

module command_unit #
(
    parameter IAGC_STATUS_SIZE  = 4,
    parameter CMD_PARAM_SIZE    = 4,
    parameter DATA_SIZE         = 8
)
(
    input  wire                                 i_clock,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    output wire [ DATA_SIZE        - 1 : 0 ]    i_cmd,
    output wire                                 o_cmd_reset,
    output wire                                 o_cmd_sample,
    output wire                                 o_cmd_set_decim,
    output wire                                 o_cmd_clean_mem,
    output wire                                 o_cmd_dump_mem,
    output wire                                 o_cmd_set_mem,
    output wire [ CMD_PARAM_SIZE   - 1 : 0 ]    o_cmd_param
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

    reg                             cmd_reset;
    reg                             cmd_sample;
    reg                             cmd_set_decim;
    reg                             cmd_clean_mem;
    reg                             cmd_dump_mem;
    reg                             cmd_set_mem;
    reg [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_param;
    
    always@( posedge i_clock ) begin
        if( i_iagc_status == IAGC_STATUS_CMD_PARSE || i_iagc_status == IAGC_STATUS_CMD_READ ) begin
            cmd_reset       <= i_cmd[ 7 : 4 ] == 4'b0000 ? 1'b1 : 1'b0;
            cmd_sample      <= i_cmd[ 7 : 4 ] == 4'b0001 ? 1'b1 : 1'b0;
            cmd_set_decim   <= i_cmd[ 7 : 4 ] == 4'b0010 ? 1'b1 : 1'b0;
            cmd_clean_mem   <= i_cmd[ 7 : 4 ] == 4'b0011 ? 1'b1 : 1'b0;
            cmd_dump_mem    <= i_cmd[ 7 : 4 ] == 4'b0100 ? 1'b1 : 1'b0;
            cmd_set_mem     <= i_cmd[ 7 : 4 ] == 4'b0101 ? 1'b1 : 1'b0;
            cmd_param       <= i_cmd[ 3 : 0 ];
        end
        else begin
            cmd_reset       <= 1'b0;
            cmd_sample      <= 1'b0;
            cmd_set_decim   <= 1'b0;
            cmd_clean_mem   <= 1'b0;
            cmd_dump_mem    <= 1'b0;
            cmd_set_mem     <= 1'b0;
            cmd_param       <= { CMD_PARAM_SIZE { 1'b0 } };
        end
    end
    
    assign o_cmd_reset      = cmd_reset;
    assign o_cmd_sample     = cmd_sample;
    assign o_cmd_set_decim  = cmd_set_decim;
    assign o_cmd_clean_mem  = cmd_clean_mem;
    assign o_cmd_dump_mem   = cmd_dump_mem;
    assign o_cmd_set_mem    = cmd_set_mem;
    assign o_cmd_param      = cmd_param;
    
endmodule

`default_nettype wire
