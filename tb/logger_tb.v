`timescale 1ns / 1ns

module logger_tb ();

  localparam AMPLITUDE_DATA_SIZE = 16;
  localparam UART_DATA_SIZE = 8;
  localparam IAGC_STATUS_SIZE = 4;

  reg clock;
  reg nReset;
  reg [IAGC_STATUS_SIZE-1:0] iagcStatus;
  reg [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  reg [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;
  reg [UART_DATA_SIZE-1:0] quotient;
  reg [UART_DATA_SIZE-1:0] fractional;
  reg onPhase;

  wire txReady;
  wire loggerValid;
  wire tx;
  wire [UART_DATA_SIZE-1:0] txData;

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;

  initial begin
    clock = 1'b0;
    nReset = 1'b1;
    iagcStatus = IAGC_STATUS_RESET;
    referenceAmplitude = 16'b0000_0000_0000_1111;
    errorAmplitude = 16'b0000_0000_1111_0000;
    quotient = 8'b0101_0000;
    fractional = 8'b0000_0101;
    onPhase = 1'b1;

    #100 nReset = 1'b1;
    iagcStatus = IAGC_STATUS_INIT;

    #100 iagcStatus = 4'b1111;
  end

  localparam SYS_CLOCK_PERIOD = 8;
  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  logger #(
      .TICKS(300000)
  ) u_logger (
      .i_clock(clock),
      .i_iagcStatus(iagcStatus),
      .i_referenceAmplitude(referenceAmplitude),
      .i_errorAmplitude(errorAmplitude),
      .i_quotient(quotient),
      .i_fractional(fractional),
      .i_onPhase(onPhase),
      .i_txReady(txReady),
      .o_txData(txData),
      .o_txValid(loggerValid)
  );

  uart_tx #(
      .CLK_FREQUENCY (100_000_000),
      .UART_FREQUENCY(9200)
  ) u_uart_tx (
      .user_clk     (clock),
      .rst_n        (nReset),
      .start_tx     (loggerValid),
      .data         (txData),
      .tx_bit       (tx),
      .ready        (txReady),
      .chipscope_clk()
  );

endmodule
