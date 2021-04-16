`timescale 1ns / 1ps

module serial #
(
    parameter   SERIAL_DATA_SIZE    =   8
)
(
    input   i_clock,
    input   i_reset,
    input   i_start,
    output  o_serial
);

    localparam  UART_PRESCALE       =   16'b0000010100010110;   /* 9600 BR */
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
            tx_data         <= 48;
            tx_start_last   <= 1'b0;
            tx_valid        <= 1'b0;
        end 
        else begin
            if( i_start && ~tx_start_last ) begin
                tx_valid    <= 1'b1;
                tx_data     <= tx_data + 1'b1;
                
                if( tx_data == 57 )
                    tx_data <= 48;     
            end
            else if( i_start && tx_start_last )
                tx_valid    <= 1'b0;
            else if( ~i_start )
                tx_valid    <= 1'b0;
            
            tx_start_last    <= i_start;
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
        .txd            (o_serial),
        .busy           (tx_busy),
        .prescale       (tx_prescale)
    );
    /* ###################################### */

endmodule
