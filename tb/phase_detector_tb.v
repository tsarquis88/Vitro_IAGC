`timescale 1ns / 1ns

module phase_detector_tb ();

  localparam SYS_CLOCK_PERIOD = 8;
  localparam AXIS_DATA_SIZE = 32;
  localparam IAGC_STATUS_SIZE = 4;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam PHASE_COUNT = 10;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagc_status;
  reg sample = 1'b1;
  reg [AXIS_DATA_SIZE-1:0] data;
  wire in_phase;

  initial begin
    clock = 1'b0;
    iagc_status = IAGC_STATUS_RESET;
    data = 0;

    #100 iagc_status = IAGC_STATUS_INIT;

    #300 data[AXIS_DATA_SIZE-1] = 1'b1;

    #300 data[(AXIS_DATA_SIZE/2)-1] = 1'b1;
  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  phase_detector #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .PHASE_COUNT(PHASE_COUNT)
  ) u_phase_detector (
      .i_clock      (clock),
      .i_iagc_status(iagc_status),
      .i_sample     (sample),
      .i_data       (data),
      .o_in_phase   (in_phase)
  );

endmodule
