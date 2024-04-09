`timescale 1ns / 1ns

module processor_tb ();

  localparam SYS_CLOCK_PERIOD = 8;
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
  reg [AXIS_DATA_SIZE-1:0] adcData;
  reg adcDataValid;
  
  initial begin
    clock = 1'b0;
    adcDataValid = 1'b0;
    adcData = 32'b1000_0000_1111_0000_0000_1111_0000_0000;
    iagcStatus = IAGC_STATUS_RESET;
    
    #100
    iagcStatus = IAGC_STATUS_INIT;
    
    #100
    iagcStatus = IAGC_STATUS_IDLE;
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
