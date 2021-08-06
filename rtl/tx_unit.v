`timescale 1ns / 1ps

module tx_unit #
(
    parameter   TX_DATA_SIZE    =   8
)
(
    input                               i_clock,
    input                               i_reset,
    input   [ TX_DATA_SIZE - 1 : 0 ]    i_txdata,
    input                               i_send,
    output                              o_txready,
    output                              o_tx
);

    reg     tx_valid;
    wire    tx_ready;
    wire    tx_busy;

    always@( posedge i_clock ) begin
        if( i_reset || ~i_send )
            tx_valid    <= 1'b0;
        else begin
            if( tx_ready && ~tx_busy )
                tx_valid    <= 1'b1;
            else
                tx_valid    <= 1'b0;
        end
    end
    
    assign  o_txready   =   tx_ready;
    
    uart_tx #
    (
        .DATA_WIDTH         ( TX_DATA_SIZE          )
    )
    u_uart_tx
    (
        .clk                ( i_clock               ),
        .rst                ( i_reset               ),   
        .s_axis_tdata       ( i_txdata              ),
        .s_axis_tvalid      ( tx_valid              ),
        .s_axis_tready      ( tx_ready              ),
        .txd                ( o_tx                  ),
        .busy               ( tx_busy               ),
        .prescale           ( 16'b0000010100010110  )
    );
    
endmodule
