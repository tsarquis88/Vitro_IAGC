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
    input  wire                         i_ready,
    output wire                         o_sample,
    output wire                         o_reset,
    output wire [ DATA_SIZE - 1 : 0 ]   o_param,
    output wire                         o_decim,
    output wire                         o_valid
);

    localparam UART_PRESCALE     = 16'b0000000101000101; /* 38400 */
    
    wire    [ DATA_SIZE - 1 : 0 ]   rx_data;
    reg     [ DATA_SIZE - 1 : 0 ]   rx_param;
    reg     [ DATA_SIZE - 1 : 0 ]   rx_cmd;
    wire                            rx_valid;
    wire                            rx_busy;
    wire                            rx_overrun_error;
    wire                            rx_frame_error;
    
    reg                             cmd_reset;
    reg                             cmd_sample;
    reg                             cmd_decim;
    
    uart_rx #
    (
        .DATA_WIDTH         ( DATA_SIZE             )
    )
    u_uart_rx
    (
        .clk                ( i_clock               ),
        .rst                ( i_reset               ),   
        .m_axis_tdata       ( rx_data               ),
        .m_axis_tvalid      ( rx_valid              ),
        .m_axis_tready      ( i_ready               ),
        .rxd                ( i_rx                  ),
        .busy               ( rx_busy               ),
        .overrun_error      ( rx_overrun_error      ),
        .frame_error        ( rx_frame_error        ),
        .prescale           ( UART_PRESCALE         )
    );
    
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            cmd_reset   <= 1'b0;
            cmd_sample  <= 1'b0;
            cmd_decim   <= 1'b0;
            rx_param    <= { DATA_SIZE { 1'b0 } };
            rx_cmd      <= { DATA_SIZE { 1'b0 } };
        end
        else begin
            if( rx_valid ) begin
                rx_cmd      <= rx_data[ 7 : 4 ];
                rx_param    <= rx_data[ 3 : 0 ];
                
                cmd_reset   <= rx_cmd == 4'b1111 ? 1'b1 : 1'b0;
                cmd_sample  <= rx_cmd == 4'b1110 ? 1'b1 : 1'b0;
                cmd_decim   <= rx_cmd == 4'b1101 ? 1'b1 : 1'b0;
            end 
            else begin
                rx_cmd      <= rx_cmd;
                rx_param    <= rx_param;
                
                cmd_reset   <= 1'b0;
                cmd_sample  <= 1'b0;
                cmd_decim   <= 1'b0;
            end
        end
    end
    
    assign  o_sample    =   cmd_sample;
    assign  o_reset     =   cmd_reset;
    assign  o_decim     =   cmd_decim;
    assign  o_param     =   rx_param;
    assign  o_valid     =   rx_valid;
    
endmodule

`default_nettype wire
