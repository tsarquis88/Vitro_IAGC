`timescale 1ns / 1ns

`define assertEq(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module processor_tb ();

  localparam SYS_CLOCK_PERIOD = 8;
  localparam ZMOD_DATA_SIZE = 14;
  localparam AXIS_DATA_SIZE = 32;
  localparam IAGC_STATUS_SIZE = 4;
  localparam PHASE_SAMPLES_COUNT = 20;
  localparam AMPLITUDE_SAMPLES_COUNT = 20;
  localparam AMPLITUDE_DATA_SIZE = AXIS_DATA_SIZE / 2;
  localparam QUOTIENT_SIZE = 8;
  localparam FRACTIONAL_SIZE = 8;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagcStatus;
  reg adcDataValid;
  reg signed [ZMOD_DATA_SIZE-1:0] referenceValue;
  reg signed [ZMOD_DATA_SIZE-1:0] errorValue;

  wire [AXIS_DATA_SIZE-1:0] adcData = (errorValue << 18) + (referenceValue << 2);

  initial begin
    clock = 1'b0;
    adcDataValid = 1'b0;
    iagcStatus = IAGC_STATUS_RESET;
    referenceValue = 0;
    errorValue = 0;

    #100 iagcStatus = IAGC_STATUS_INIT;

    #100 iagcStatus = IAGC_STATUS_IDLE;

    referenceValue = 500;
    errorValue = 200;
    #1000 `assertEq(quotient, 0);
    `assertEq(fractional, 102);  // =0.39
    #1000 referenceValue = 1000;
    errorValue = 999;
    #1000 `assertEq(quotient, 0);
    `assertEq(fractional, 255);  // =0.99
    #1000 referenceValue = 333;
    errorValue = 333;
    #1000 `assertEq(quotient, 1);
    `assertEq(fractional, 0);  // =0.00
    #1000 referenceValue = 400;
    errorValue = 885;
    #1000 `assertEq(quotient, 2);
    `assertEq(fractional, 54);  // =0.21
  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  always begin
    #(SYS_CLOCK_PERIOD * 2) adcDataValid = ~adcDataValid;
  end

  wire inPhase;
  wire [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  wire [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;
  wire [QUOTIENT_SIZE-1:0] quotient;
  wire [FRACTIONAL_SIZE-1:0] fractional;

  processor #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .QUOTIENT_SIZE(QUOTIENT_SIZE),
      .FRACTIONAL_SIZE(FRACTIONAL_SIZE),
      .PHASE_SAMPLES_COUNT(PHASE_SAMPLES_COUNT),
      .AMPLITUDE_SAMPLES_COUNT(AMPLITUDE_SAMPLES_COUNT)
  ) u_processor (
      .i_clock(clock),
      .i_iagcStatus(iagcStatus),
      .i_adcData(adcData),
      .i_valid(adcDataValid),
      .o_inPhase(inPhase),
      .o_referenceAmplitude(referenceAmplitude),
      .o_errorAmplitude(errorAmplitude),
      .o_quotient(quotient),
      .o_fractional(fractional)
  );

endmodule
