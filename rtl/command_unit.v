`timescale 1ns / 1ps
`default_nettype none

module command_unit #
(
    parameter   DATA_SIZE   =   8
)
(
    input  wire                         i_clock,
    input  wire                         i_reset,
    input  wire                         i_rx,
    output wire                         o_wait_cmd,
    output wire                         o_cmd_reset,
    output wire                         o_cmd_sample,
    output wire                         o_cmd_set_decim,
    output wire [ DATA_SIZE - 1 : 0 ]   o_cmd_param,
    output wire                         o_succes,
    output wire                         o_error
);

    localparam STATUS_SIZE  = 2;
    
    localparam STATUS_IDLE  = 0;
    localparam STATUS_WAIT  = 1;
    localparam STATUS_HOLD  = 2;

    wire    [ DATA_SIZE - 1 : 0 ]   rx_data;
    wire                            rx_valid;
    
    reg     [ STATUS_SIZE - 1 : 0 ] status;
    reg     [ STATUS_SIZE - 1 : 0 ] next_status;
    integer                         count;
    reg                             cmd_reset;
    reg                             cmd_sample;
    reg                             cmd_set_decim;
    reg     [ DATA_SIZE - 1 : 0 ]   cmd_param;
    
    reg                             error;
    reg                             succes;
        
    uart_rx #
    (
        .CLK_FREQUENCY  ( 100000000             ),
        .UART_FREQUENCY ( 9600                  )
    )
    u_uart_rx
    (
        .clk            ( i_clock               ),
        .rst_n          ( ~i_reset              ),
        .data           ( rx_data               ),
        .rx             ( i_rx                  ),
        .valid          ( rx_valid              )
    );
    
    always@( posedge i_clock ) begin
    
        if( i_reset ) begin
            status  <= STATUS_IDLE;
        end
        else begin
        
            status  <= next_status;
            
            case( status )
            
                STATUS_IDLE: begin
                    cmd_reset       <= 1'b0;
                    cmd_sample      <= 1'b0;
                    cmd_set_decim   <= 1'b0;
                    cmd_param       <= { DATA_SIZE { 1'b0 } };
                    count           <= 0;
                    succes          <= 1'b0;
                    error           <= 1'b0;
                end
                
                STATUS_WAIT: begin
                    cmd_reset       <= 1'b0;
                    cmd_sample      <= 1'b0;
                    cmd_set_decim   <= 1'b0;
                    cmd_param       <= { DATA_SIZE { 1'b0 } };
                    count           <= 0;
                    succes          <= 1'b0;
                    error           <= 1'b0;
                end
                
                STATUS_HOLD: begin
                    cmd_reset       <= rx_data[ 7 : 4 ] == 4'b0001 ? 1'b1 : 1'b0;
                    cmd_sample      <= rx_data[ 7 : 4 ] == 4'b0010 ? 1'b1 : 1'b0;
                    cmd_set_decim   <= rx_data[ 7 : 4 ] == 4'b0100 ? 1'b1 : 1'b0;
                    cmd_param       <= rx_data[ 3 : 0 ];
                    count           <= count + 1;
                    succes          <= rx_data[ 7 : 4 ] == 4'b0001 || rx_data[ 7 : 4 ] == 4'b0010 || rx_data[ 7 : 4 ] == 4'b0100;
                    error           <= rx_data[ 7 : 4 ] != 4'b0001 && rx_data[ 7 : 4 ] != 4'b0010 && rx_data[ 7 : 4 ] != 4'b0100;
                end
                
                default: begin
                    cmd_reset       <= 1'b0;
                    cmd_sample      <= 1'b0;
                    cmd_set_decim   <= 1'b0;
                    cmd_param       <= { DATA_SIZE { 1'b0 } };
                    count           <= 0;
                    succes          <= 1'b0;
                    error           <= 1'b0;
                end
                
            endcase
        end
    end
    
    always@( * ) begin
        if( i_reset ) begin
            next_status = STATUS_IDLE;
        end
        else begin
            case( status )
                STATUS_IDLE:    next_status = rx_valid && rx_data == 8'b00000000    ? STATUS_WAIT : STATUS_IDLE;
                STATUS_WAIT:    next_status = rx_valid                              ? STATUS_HOLD : STATUS_WAIT;
                STATUS_HOLD:    next_status = count == 3                            ? STATUS_IDLE : STATUS_HOLD;
                default:        next_status = STATUS_IDLE;
            endcase
        end
    end
    
    assign  o_wait_cmd      =   status == STATUS_WAIT;
    assign  o_cmd_reset     =   cmd_reset;
    assign  o_cmd_sample    =   cmd_sample;
    assign  o_cmd_set_decim =   cmd_set_decim;
    assign  o_cmd_param     =   cmd_param;
    assign  o_succes        =   succes;
    assign  o_error         =   error;
    
endmodule

`default_nettype wire
