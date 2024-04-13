`timescale 1ns / 1ps

module processor #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter AXIS_DATA_SIZE = 32,
    parameter AMPLITUDE_DATA_SIZE = AXIS_DATA_SIZE / 2,
    parameter ZMOD_DATA_SIZE = 14,
    parameter QUOTIENT_SIZE = 8,
    parameter FRACTIONAL_SIZE = 8,
    parameter PHASE_SAMPLES_COUNT = 1500,
    parameter AMPLITUDE_SAMPLES_COUNT = 1500
) (
    input i_clock,
    input [IAGC_STATUS_SIZE-1:0] i_iagcStatus,
    input [AXIS_DATA_SIZE-1:0] i_adcData,
    input i_valid,
    output o_inPhase,
    output [AMPLITUDE_DATA_SIZE-1:0] o_referenceAmplitude,
    output [AMPLITUDE_DATA_SIZE-1:0] o_errorAmplitude,
    output [QUOTIENT_SIZE-1:0] o_quotient,
    output [FRACTIONAL_SIZE-1:0] o_fractional
);
  /* ########################################################### */
  /* PHASE DETECTOR ############################################ */

  phase_detector #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .PHASE_COUNT(PHASE_SAMPLES_COUNT)
  ) u_phase_detector (
      .i_clock      (i_clock),
      .i_iagc_status(i_iagcStatus),
      .i_sample     (i_valid),
      .i_data       (i_adcData),
      .o_in_phase   (o_inPhase)
  );

  /* ########################################################### */
  /* AMPLITUDE DETECTOR ######################################## */

  wire [AMPLITUDE_DATA_SIZE-1:0] ad_referenceAmplitude;
  wire [AMPLITUDE_DATA_SIZE-1:0] ad_errorAmplitude;
  wire ad_amplitudeDetectorUpdate;

  amplitude_detector #(
      .IAGC_STATUS_SIZE       (IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE         (AXIS_DATA_SIZE),
      .AMPLITUDE_SAMPLES_COUNT(AMPLITUDE_SAMPLES_COUNT),
      .AMPLITUDE_DATA_SIZE    (AMPLITUDE_DATA_SIZE),
      .ZMOD_DATA_SIZE         (ZMOD_DATA_SIZE)
  ) u_amplitude_detector (
      .i_clock(i_clock),
      .i_sample(i_valid),
      .i_iagcStatus(i_iagcStatus),
      .i_data(i_adcData),
      .o_referenceAmplitude(ad_referenceAmplitude),
      .o_errorAmplitude(ad_errorAmplitude),
      .o_update(ad_amplitudeDetectorUpdate)
  );

  assign o_referenceAmplitude = ad_referenceAmplitude;
  assign o_errorAmplitude = ad_errorAmplitude;

  /* ########################################################### */
  /* DIVIDER ################################################### */

  divider #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .QUOTIENT_SIZE(QUOTIENT_SIZE),
      .FRACTIONAL_SIZE(FRACTIONAL_SIZE)
  ) u_divider (
      .i_clock(i_clock),
      .i_iagcStatus(i_iagcStatus),
      .i_reference(ad_referenceAmplitude),
      .i_error(ad_errorAmplitude),
      .i_valid(ad_amplitudeDetectorUpdate),
      .o_quotient(o_quotient),
      .o_fractional(o_fractional)
  );

endmodule
