`timescale 1ns / 1ps `default_nettype none

module logger #(
    parameter UART_CLK_FREQ = 100_000_000,
    parameter UART_BAUDRATE = 9_200,
    parameter IAGC_STATUS_SIZE = 4,
    parameter AMPLITUDE_DATA_SIZE = 16,
    parameter UART_DATA_SIZE = 8,
    parameter TICKS = 60000000
) (
    input wire i_clock,
    input wire [IAGC_STATUS_SIZE-1:0] i_iagcStatus,
    input wire [AMPLITUDE_DATA_SIZE-1:0] i_referenceAmplitude,
    input wire [AMPLITUDE_DATA_SIZE-1:0] i_errorAmplitude,
    input wire [UART_DATA_SIZE-1:0] i_quotient,
    input wire [UART_DATA_SIZE-1:0] i_fractional,
    input wire i_onPhase,
    input wire i_wdValid,
    output wire o_txBit
);

  localparam DATA_LEN = 7;
  reg [UART_DATA_SIZE-1:0] data[DATA_LEN-1:0];
  reg [UART_DATA_SIZE-1:0] txData;
  reg txValid;
  integer dataAddr;
  integer counter;
  wire txReady;

  localparam STATE_SIZE = 3;
  localparam STATE_RESET = 3'b000;
  localparam STATE_IDLE = 3'b001;
  localparam STATE_SET = 3'b010;
  localparam STATE_START = 3'b011;
  localparam STATE_START_WAIT = 3'b100;
  localparam STATE_WAIT = 3'b101;
  localparam STATE_INCREASE = 3'b110;
  localparam STATE_DONE = 3'b111;
  reg [STATE_SIZE-1:0] state;
  reg [STATE_SIZE-1:0] nextState;

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;

  always @(posedge i_clock) begin
    if (i_iagcStatus == IAGC_STATUS_RESET || i_iagcStatus == IAGC_STATUS_INIT) begin
      state <= STATE_RESET;
    end else begin
      state <= nextState;
    end

    case (state)
      STATE_RESET: begin
        data[0]  <= i_referenceAmplitude[(AMPLITUDE_DATA_SIZE/2)-1:0];
        data[1]  <= i_referenceAmplitude[AMPLITUDE_DATA_SIZE-1:AMPLITUDE_DATA_SIZE/2];
        data[2]  <= i_errorAmplitude[(AMPLITUDE_DATA_SIZE/2)-1:0];
        data[3]  <= i_errorAmplitude[AMPLITUDE_DATA_SIZE-1:AMPLITUDE_DATA_SIZE/2];
        data[4]  <= i_quotient;
        data[5]  <= i_fractional;
        data[6]  <= {UART_DATA_SIZE{1'b0}} + i_onPhase + (i_wdValid << 1);

        txValid  <= 1'b0;
        txData   <= 8'b00000000;
        dataAddr <= 0;
        counter  <= 0;
      end
      STATE_IDLE: begin
        txValid  <= txValid;
        txData   <= txData;
        dataAddr <= dataAddr;
        counter  <= counter + 1;
      end
      STATE_SET: begin
        txValid  <= txValid;
        txData   <= data[dataAddr];
        dataAddr <= dataAddr;
        counter  <= 0;
      end
      STATE_START: begin
        txValid  <= 1'b1;
        txData   <= txData;
        dataAddr <= dataAddr;
        counter  <= counter;
      end
      STATE_START_WAIT: begin
        txValid  <= txValid;
        txData   <= txData;
        dataAddr <= dataAddr;
        counter  <= counter;
      end
      STATE_WAIT: begin
        txValid  <= 1'b0;
        txData   <= txData;
        dataAddr <= dataAddr;
        counter  <= counter;
      end
      STATE_INCREASE: begin
        txValid  <= txValid;
        txData   <= txData;
        dataAddr <= dataAddr + 1;
        counter  <= counter;
      end
      STATE_DONE: begin
        txValid  <= txValid;
        txData   <= txData;
        dataAddr <= dataAddr;
        counter  <= counter;
      end
    endcase
  end

  always @(*) begin
    case (state)
      STATE_RESET: begin
        nextState = (i_iagcStatus == IAGC_STATUS_RESET || i_iagcStatus == IAGC_STATUS_INIT) ? STATE_RESET : STATE_IDLE;
      end
      STATE_IDLE: begin
        nextState = ((counter >= TICKS) && txReady) ? STATE_SET : STATE_IDLE;
      end
      STATE_SET: begin
        nextState = STATE_START;
      end
      STATE_START: begin
        nextState = STATE_START_WAIT;
      end
      STATE_START_WAIT: begin
        nextState = (txReady) ? STATE_START_WAIT : STATE_WAIT;
      end
      STATE_WAIT: begin
        nextState = (txReady) ? STATE_INCREASE : STATE_WAIT;
      end
      STATE_INCREASE: begin
        nextState = STATE_DONE;
      end
      STATE_DONE: begin
        nextState = (dataAddr >= DATA_LEN) ? STATE_RESET : STATE_SET;
      end
      default: begin
        nextState = STATE_RESET;
      end
    endcase
  end

  uart_tx #(
      .CLK_FREQUENCY (UART_CLK_FREQ),
      .UART_FREQUENCY(UART_BAUDRATE)
  ) u_uart_tx (
      .user_clk     (i_clock),
      .rst_n        (state != STATE_RESET),
      .start_tx     (txValid),
      .data         (txData),
      .tx_bit       (o_txBit),
      .ready        (txReady),
      .chipscope_clk()
  );

endmodule

`default_nettype wire
