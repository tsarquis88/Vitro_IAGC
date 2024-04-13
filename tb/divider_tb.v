`timescale 1ns / 1ns

module divider_tb ();

  localparam SYS_CLOCK_PERIOD = 8;
  localparam AMPLITUDE_DATA_SIZE = 16;
  localparam QUOTIENT_SIZE = 8;
  localparam FRACTIONAL_SIZE = 8;

  reg clock;
  reg [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  reg [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;
  reg valid;

  initial begin
    clock = 1'b0;
    valid = 1'b0;
    referenceAmplitude = {AMPLITUDE_DATA_SIZE{1'b0}};
    errorAmplitude = {AMPLITUDE_DATA_SIZE{1'b0}};

    #100 referenceAmplitude = 500;
    errorAmplitude = 200;
    valid = 1'b1;

    #20 valid = 1'b0;
  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  wire [  QUOTIENT_SIZE-1:0] quotient;
  wire [FRACTIONAL_SIZE-1:0] fractional;

  divider #(
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .QUOTIENT_SIZE(QUOTIENT_SIZE),
      .FRACTIONAL_SIZE(FRACTIONAL_SIZE)
  ) u_divider (
      .i_clock(clock),
      .i_reference(referenceAmplitude),
      .i_error(errorAmplitude),
      .i_valid(valid),
      .o_quotient(quotient),
      .o_fractional(fractional)
  );

endmodule
