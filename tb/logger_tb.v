`timescale 1ns / 1ns

`define assertEq(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module logger_tb ();

  localparam AMPLITUDE_DATA_SIZE = 16;
  localparam UART_DATA_SIZE = 8;
  localparam IAGC_STATUS_SIZE = 4;
  localparam UART_CLK_FREQ = 100_000_000;
  localparam UART_BAUDRATE = 9_200;

  reg clock;
  reg nReset;
  reg [IAGC_STATUS_SIZE-1:0] iagcStatus;
  reg [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  reg [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;
  reg [UART_DATA_SIZE-1:0] quotient;
  reg [UART_DATA_SIZE-1:0] fractional;
  reg onPhase;

  wire txBit;
  integer counter;
  reg [UART_DATA_SIZE-1:0] expectedValues[6:0];

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;

  initial begin
    counter = 0;
    clock = 1'b0;
    nReset = 1'b1;
    iagcStatus = IAGC_STATUS_RESET;
    referenceAmplitude = 16'b0000_0000_0000_1111;
    errorAmplitude = 16'b0000_0000_1111_0000;
    quotient = 8'b0101_0000;
    fractional = 8'b0000_0101;
    onPhase = 1'b1;
    expectedValues[0] = referenceAmplitude[7:0];
    expectedValues[1] = referenceAmplitude[15:8];
    expectedValues[2] = errorAmplitude[7:0];
    expectedValues[3] = errorAmplitude[15:8];
    expectedValues[4] = quotient;
    expectedValues[5] = fractional;
    expectedValues[6] = onPhase;

    #100 nReset = 1'b1;
    iagcStatus = IAGC_STATUS_INIT;

    #100 iagcStatus = 4'b1111;
  end

  localparam SYS_CLOCK_PERIOD = 8;
  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  always @(posedge rxDataValid) begin
    `assertEq(rxData, expectedValues[counter]);
    counter <= (counter < 6) ? counter + 1 : 0;
  end

  logger #(
      .CLK_FREQUENCY(UART_CLK_FREQ),
      .UART_FREQUENCY(UART_BAUDRATE),
      .TICKS(300000)
  ) u_logger (
      .i_clock(clock),
      .i_iagcStatus(iagcStatus),
      .i_referenceAmplitude(referenceAmplitude),
      .i_errorAmplitude(errorAmplitude),
      .i_quotient(quotient),
      .i_fractional(fractional),
      .i_onPhase(onPhase),
      .o_txBit(txBit)
  );

  wire [UART_DATA_SIZE-1:0] rxData;
  wire rxDataValid;

  uart_rx #(
      .CLK_FREQUENCY (UART_CLK_FREQ),
      .UART_FREQUENCY(UART_BAUDRATE)
  ) u_uart_rx (
      .clk(clock),
      .rst_n(nReset),
      .rx(txBit),
      .valid(rxDataValid),
      .data(rxData)
  );

endmodule
