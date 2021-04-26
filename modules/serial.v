`timescale 1ns / 1ps

module serial #
(
    parameter   SERIAL_DATA_SIZE    =   8
)
(
    input                                   i_clock,
    input                                   i_reset,
    input                                   i_tx_start,
    input   [ SERIAL_DATA_SIZE - 1 : 0 ]    i_tx_data_l,
    input   [ SERIAL_DATA_SIZE - 1 : 0 ]    i_tx_data_h,
    output                                  o_tx
);

    localparam  UART_PRESCALE       =   16'b0000010100010110;   /* 9600 BR 8-bit    */
    localparam  UART_PRESCALE_SIZE  =   16;
    localparam  UART_DATA_CANT      =   3;
    
    reg     [ SERIAL_DATA_SIZE - 1 : 0 ]    tx_data_in [ UART_DATA_CANT - 1 : 0 ];
    reg     [ SERIAL_DATA_SIZE - 1 : 0 ]    tx_data;
    reg     [ UART_PRESCALE_SIZE - 1 : 0 ]  tx_prescale;
    wire                                    tx_ready;
    wire                                    tx_busy;
    reg                                     tx_start_last;
    reg                                     tx_valid;
    reg                                     tx_logging;
    integer                                 tx_c;
    integer                                 tx_c_next;
    
     always@( posedge i_clock ) begin
    
        if( i_reset ) begin
            tx_prescale     <= UART_PRESCALE;
            tx_start_last   <= 1'b0;
            tx_valid        <= 1'b0;
            tx_c            <= 0;
        end 
        else begin
        
            if( i_tx_start && ~tx_start_last ) begin
                tx_logging  <= 1'b1;
            end
            tx_start_last   <= i_tx_start;
            
            if( tx_logging ) begin
                tx_c    <= tx_c_next;
                
                if( tx_ready ) begin
                    if( tx_c == UART_DATA_CANT - 1 && tx_c_next == 1 ) begin
                        tx_logging  <= 1'b0;
                        tx_c        <= 1'b0;
                        tx_valid    <= 1'b0;
                    end 
                    else
                        tx_valid    <= 1'b1;
                end
                else
                    tx_valid    <= 1'b0;
            end
            else begin
                tx_valid    <= 1'b0;
                tx_c        <= 0;
            end
        end
    end
        
    always@( posedge tx_ready ) begin            
        if( tx_c_next == UART_DATA_CANT - 1 ) begin
            tx_c_next   =   1;
        end
        else begin
            tx_c_next   =   tx_c + 1;
        end
    end
    
    always@( * ) begin
        tx_data_in[ 0 ]     <= "\n";
        tx_data_in[ 1 ]     <= i_tx_data_h;
        tx_data_in[ 2 ]     <= i_tx_data_l;
        
        tx_data             <= tx_data_in[ tx_c ];
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
