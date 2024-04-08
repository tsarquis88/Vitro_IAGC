`timescale 1ns / 1ns

module amplitude_detector_tb ();

  localparam IAGC_STATUS_SIZE = 4;
  localparam AXIS_DATA_SIZE = 32;
  localparam AMPLITUDE_DATA_SIZE = (AXIS_DATA_SIZE / 2);
  localparam AMPLITUDE_SAMPLES_COUNT = 10;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagcStatus;
  reg sample;
  reg [AXIS_DATA_SIZE-1:0] data;

  wire [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  wire [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;
  wire update;

  initial begin
    clock = 1'b0;
    sample = 1'b1;
    data = 32'b1000_0000_0000_0001_1000_0000_1000_0000;
    iagcStatus = IAGC_STATUS_RESET;

    #100 iagcStatus = IAGC_STATUS_INIT;

    #100 iagcStatus = IAGC_STATUS_IDLE;
  end

  always begin
    #5 clock = ~clock;
  end

  always @(posedge clock) begin
    data = data + 32'b0000_0000_0000_0001_0000_0000_0000_0000;
    data = data - 32'b0000_0000_0000_0000_0000_0000_0000_0001;
  end

  amplitude_detector #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .AMPLITUDE_SAMPLES_COUNT(AMPLITUDE_SAMPLES_COUNT)
  ) u_amplitude_detector (
      .i_clock(clock),
      .i_sample(sample),
      .i_iagcStatus(iagcStatus),
      .i_data(data),
      .o_referenceAmplitude(referenceAmplitude),
      .o_errorAmplitude(errorAmplitude),
      .o_update(update)
  );

endmodule
