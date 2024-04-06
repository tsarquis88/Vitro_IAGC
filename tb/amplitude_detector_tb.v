`timescale 1ns / 1ns

module amplitude_detector_tb ();

  localparam IAGC_STATUS_SIZE = 4;
  localparam AXIS_DATA_SIZE = 32;
  localparam AMPLITUDE_DATA_SIZE = (AXIS_DATA_SIZE / 2);
  localparam AMPLITUDE_COUNT = 10;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagc_status;
  reg sample;
  reg [AXIS_DATA_SIZE-1:0] data;

  wire [AMPLITUDE_DATA_SIZE-1:0] ref_amp;
  wire [AMPLITUDE_DATA_SIZE-1:0] err_amp;
  wire valid;

  initial begin
    clock = 1'b0;
    sample = 1'b0;
    data = {AXIS_DATA_SIZE{1'b0}} + (1'b1 << AXIS_DATA_SIZE - 1) + (1'b1 << AXIS_DATA_SIZE - 2);
    iagc_status = IAGC_STATUS_RESET;

    #100 iagc_status = IAGC_STATUS_INIT;

    #100 iagc_status = IAGC_STATUS_IDLE;
  end

  always begin
    #5 clock = ~clock;
  end

  always begin
    #10 sample = ~sample;
  end

  always @(posedge clock) begin
    data <= data + 1'b1;
  end

  amplitude_detector #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .AMPLITUDE_COUNT(AMPLITUDE_COUNT)
  ) u_amplitude_detector (
      .i_clock              (clock),
      .i_sample             (sample),
      .i_iagc_status        (iagc_status),
      .i_data               (data),
      .o_reference_amplitude(ref_amp),
      .o_error_amplitude    (err_amp),
      .o_valid              (valid)
  );

endmodule
