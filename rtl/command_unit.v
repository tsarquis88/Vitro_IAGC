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
    output wire [ CMD_PARAM_SIZE   - 1 : 0 ]    o_cmd_op,
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
    
    reg [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_op;
    reg [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_param;
    
    always@( posedge i_clock ) begin
            cmd_param   <= i_cmd[ 3 : 0 ];
            cmd_op      <= i_cmd[ 7 : 4 ];
    end
    
    assign o_cmd_op     = cmd_op;
    assign o_cmd_param  = cmd_param;
    
endmodule

`default_nettype wire
