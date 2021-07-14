`timescale 1ns / 1ps

module tx_unit #
(
    parameter   TX_DATA_SIZE    =   8
)
(
    input                               i_clock,
    input                               i_reset,
    input   [ TX_DATA_SIZE - 1 : 0 ]    i_txdata_0,
    input   [ TX_DATA_SIZE - 1 : 0 ]    i_txdata_1,
    output                              o_tx_0,
    output                              o_tx_1
);

    reg     tx_valid_0;
    reg     tx_valid_1;
    wire    tx_ready_0;
    wire    tx_ready_1;
    wire    tx_busy_0;
    wire    tx_busy_1;

    always@( posedge i_clock ) begin
        if( i_reset )
            tx_valid_0  <= 1'b0;
        else begin
            if( tx_ready_0 && ~tx_busy_0 )
                tx_valid_0  <= 1'b1;
            else
                tx_valid_0  <= 1'b0;
        end
    end
    
    always@( posedge i_clock ) begin
        if( i_reset )
            tx_valid_1  <= 1'b0;
        else begin
            if( tx_ready_1 && ~tx_busy_1 )
                tx_valid_1  <= 1'b1;
            else
                tx_valid_1  <= 1'b0;
        end
    end
    
    uart_tx #
    (
        .DATA_WIDTH         (TX_DATA_SIZE)
    )
    u_uart_tx_0
    (
        .clk                (i_clock),
        .rst                (i_reset),   
        .s_axis_tdata       (i_txdata_0),
        .s_axis_tvalid      (tx_valid_0),
        .s_axis_tready      (tx_ready_0),
        .txd                (o_tx_0),
        .busy               (tx_busy_0),
        .prescale           (16'b0000010100010110)
    );
    
    uart_tx #
    (
        .DATA_WIDTH         (TX_DATA_SIZE)
    )
    u_uart_tx_1
    (
        .clk                (i_clock),
        .rst                (i_reset),   
        .s_axis_tdata       (i_txdata_1),
        .s_axis_tvalid      (tx_valid_1),
        .s_axis_tready      (tx_ready_1),
        .txd                (o_tx_1),
        .busy               (tx_busy_1),
        .prescale           (16'b0000010100010110)
    );
    
endmodule
