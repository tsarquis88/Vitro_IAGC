`timescale 1ns / 1ps

module serial #
(
    parameter   SERIAL_DATA_SIZE    =   16
)
(
    input                                   i_clock,
    input                                   i_reset,
    input                                   i_tx_start,
    input   [ SERIAL_DATA_SIZE - 1 : 0 ]    i_tx_data,
    output                                  o_tx
);

    localparam  UART_PRESCALE       =   16'b0000010100010110;   /* 9600 BR 8-bit    */
    localparam  UART_PRESCALE_SIZE  =   16;

    reg     [ SERIAL_DATA_SIZE - 1 : 0 ]    tx_data;
    reg     [ UART_PRESCALE_SIZE - 1 : 0 ]  tx_prescale;
    wire                                    tx_ready;
    wire                                    tx_busy;
    reg                                     tx_start_last;
    reg                                     tx_valid;
    
    always@( posedge i_clock ) begin
    
        if( i_reset ) begin
            tx_prescale     <= UART_PRESCALE;
            tx_data         <= 0;
            tx_start_last   <= 1'b0;
            tx_valid        <= 1'b0;
        end 
        else begin
            if( i_tx_start && ~tx_start_last ) begin
                tx_data     <= i_tx_data;
                tx_valid    <= 1'b1;   
            end
            else if( i_tx_start && tx_start_last )
                tx_valid    <= 1'b0;
            else if( ~i_tx_start )
                tx_valid    <= 1'b0;
            
            tx_start_last    <= i_tx_start;
        end
    end
    
    /* ###################################### */
    uart_tx #
    (
        .DATA_WIDTH     (SERIAL_DATA_SIZE)
    )
    u_uart_tx
    (
        .clk            (i_clock),
        .rst            (i_reset),
        .s_axis_tdata   (tx_data),
        .s_axis_tvalid  (tx_valid),
        .s_axis_tready  (tx_ready),
        .txd            (o_tx),
        .busy           (tx_busy),
        .prescale       (tx_prescale)
    );
    /* ###################################### */

endmodule
