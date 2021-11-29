`timescale 1ns / 1ps
`default_nettype none

module logger # 
(
    parameter IAGC_STATUS_SIZE      = 4,
    parameter AMPLITUDE_DATA_SIZE   = 13,
    parameter UART_DATA_SIZE        = 8
)
(
    input  wire                                 i_clock,
    input  wire [ IAGC_STATUS_SIZE    - 1 : 0 ] i_iagc_status,
    input  wire [ AMPLITUDE_DATA_SIZE - 1 : 0 ] i_reference_amplitude,
    input  wire [ AMPLITUDE_DATA_SIZE - 1 : 0 ] i_error_amplitude,
    input  wire                                 i_tx_ready,
    output wire [ UART_DATA_SIZE      - 1 : 0 ] o_tx_data,
    output wire                                 o_tx_start
);

    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_LOG          = 4'b1110;
   
    localparam STATUS_SIZE          = 4;
        
    localparam STATUS_INIT    = 0;
    localparam STATUS_WAIT    = 1;
    localparam STATUS_LOG     = 2;
    localparam STATUS_REF_L   = 3;
    localparam STATUS_REF_L_W = 4;
    localparam STATUS_REF_H   = 5;
    localparam STATUS_REF_H_W = 6;
    localparam STATUS_ERR_L   = 7;
    localparam STATUS_ERR_L_W = 8;
    localparam STATUS_ERR_H   = 9;
    localparam STATUS_ERR_H_W = 10;
    
    reg     [ STATUS_SIZE    - 1 : 0 ]  status;
    reg     [ STATUS_SIZE    - 1 : 0 ]  next_status;
    reg     [ UART_DATA_SIZE - 1 : 0 ]  tx_data;
    reg                                 tx_start;    
    integer                             counter;
    
    always@( posedge i_clock ) begin
    
        if( i_iagc_status == IAGC_STATUS_RESET || i_iagc_status == IAGC_STATUS_INIT )
            status <= STATUS_INIT;
        else
            status <= next_status;
            
        case( status )
        
            STATUS_INIT: begin
                counter     <= 0;
                tx_data     <= { UART_DATA_SIZE { 1'b0 } };
                tx_start    <= 1'b0;
            end
            
            STATUS_WAIT: begin
                counter     <= counter + 1;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            STATUS_LOG: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            STATUS_REF_L: begin
                counter     <= counter + 1;
                tx_data     <= i_reference_amplitude[ UART_DATA_SIZE - 1 : 0 ];
                tx_start    <= 1'b1;
            end
            
            STATUS_REF_L_W: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            STATUS_REF_H: begin
                counter     <= counter + 1;
                tx_data     <= i_reference_amplitude[ AMPLITUDE_DATA_SIZE - 1 : UART_DATA_SIZE ] + { UART_DATA_SIZE { 1'b0 } };
                tx_start    <= 1'b1;
            end
            
            STATUS_REF_H_W: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            STATUS_ERR_L: begin
                counter     <= counter + 1;
                tx_data     <= i_error_amplitude[ UART_DATA_SIZE - 1 : 0 ];
                tx_start    <= 1'b1;
            end
            
            STATUS_ERR_L_W: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            STATUS_ERR_H: begin
                counter     <= counter + 1;
                tx_data     <= i_error_amplitude[ AMPLITUDE_DATA_SIZE - 1 : UART_DATA_SIZE ] + { UART_DATA_SIZE { 1'b0 } };
                tx_start    <= 1'b1;
            end
            
            STATUS_ERR_H_W: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
            
            default: begin
                counter     <= 0;
                tx_data     <= tx_data;
                tx_start    <= 1'b0;
            end
                
        endcase
    end
    
    always@( * ) begin
        case( status )
            STATUS_INIT:    next_status = STATUS_WAIT;
            STATUS_WAIT:    next_status = counter > 50000000  ? STATUS_LOG     : STATUS_WAIT;
            STATUS_LOG:     next_status = STATUS_REF_L;
            STATUS_REF_L:   next_status = counter > 3         ? STATUS_REF_L_W : STATUS_REF_L;
            STATUS_REF_L_W: next_status = i_tx_ready          ? STATUS_REF_H   : STATUS_REF_L_W;
            STATUS_REF_H:   next_status = counter > 3         ? STATUS_REF_H_W : STATUS_REF_H;
            STATUS_REF_H_W: next_status = i_tx_ready          ? STATUS_ERR_L   : STATUS_REF_H_W;
            STATUS_ERR_L:   next_status = counter > 3         ? STATUS_ERR_L_W : STATUS_ERR_L;
            STATUS_ERR_L_W: next_status = i_tx_ready          ? STATUS_ERR_H   : STATUS_ERR_L_W;
            STATUS_ERR_H:   next_status = counter > 3         ? STATUS_ERR_H_W : STATUS_ERR_H;
            STATUS_ERR_H_W: next_status = i_tx_ready          ? STATUS_INIT    : STATUS_ERR_H_W;
            default:        next_status = STATUS_INIT;
        endcase
    end
    
    assign o_tx_data  = tx_data;
    assign o_tx_start = tx_start;
        
endmodule

`default_nettype wire
