`timescale 1ns / 1ps `default_nettype none

module amplitude_detector #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter AXIS_DATA_SIZE = 32,
    parameter AMPLITUDE_DATA_SIZE = (AXIS_DATA_SIZE / 2),
    parameter AMPLITUDE_SAMPLES_COUNT = 256,
    parameter ZMOD_DATA_SIZE = 14
) (
    input wire i_clock,
    input wire i_sample,
    input wire [IAGC_STATUS_SIZE-1:0] i_iagcStatus,
    input wire [AXIS_DATA_SIZE-1:0] i_data,
    output wire [AMPLITUDE_DATA_SIZE-1:0] o_referenceAmplitude,
    output wire [AMPLITUDE_DATA_SIZE-1:0] o_errorAmplitude,
    output wire o_update
);

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;

  localparam STATUS_SIZE = 2;
  localparam STATUS_INIT = 0;
  localparam STATUS_SAMPLE = 1;
  localparam STATUS_DETECT = 2;
  localparam STATUS_UPDATE = 3;
  reg [STATUS_SIZE-1:0] status;
  reg [STATUS_SIZE-1:0] nextStatus;

  reg signed [AMPLITUDE_DATA_SIZE-1:0] maxReference;
  reg signed [AMPLITUDE_DATA_SIZE-1:0] maxError;
  reg signed [AMPLITUDE_DATA_SIZE-1:0] referenceAmplitude;
  reg signed [AMPLITUDE_DATA_SIZE-1:0] errorAmplitude;

  integer samples;

  wire signed [(AXIS_DATA_SIZE/2)-1:0] referenceSignal;
  wire signed [(AXIS_DATA_SIZE/2)-1:0] errorSignal;

  sign_extensor #
  (
    .INPUT_DATA_SIZE(ZMOD_DATA_SIZE),
    .OUTPUT_DATA_SIZE(AMPLITUDE_DATA_SIZE)
  )
  u_sign_extensor_reference
  (
    .inputData(i_data[(AXIS_DATA_SIZE/2)-1:2]),
    .outputData(referenceSignal)
  );
  
   sign_extensor #
  (
    .INPUT_DATA_SIZE(ZMOD_DATA_SIZE),
    .OUTPUT_DATA_SIZE(AMPLITUDE_DATA_SIZE)
  )
  u_sign_extensor_error
  (
    .inputData(i_data[AXIS_DATA_SIZE-1:(AXIS_DATA_SIZE/2)+2]),
    .outputData(errorSignal)
  );

  always @(posedge i_clock) begin
    if (i_iagcStatus == IAGC_STATUS_RESET || i_iagcStatus == IAGC_STATUS_INIT) begin
      status <= STATUS_INIT;
      referenceAmplitude <= {AMPLITUDE_DATA_SIZE{1'b0}};
      errorAmplitude <= {AMPLITUDE_DATA_SIZE{1'b0}};
    end else begin
      status <= nextStatus;
    end

    case (status)
      STATUS_INIT: begin
        maxReference <= {AMPLITUDE_DATA_SIZE{1'b0}};
        maxError <= {AMPLITUDE_DATA_SIZE{1'b0}};
        referenceAmplitude <= referenceAmplitude;
        errorAmplitude <= errorAmplitude;
        samples <= 0;
      end
      STATUS_SAMPLE: begin
        if (i_sample) begin
          maxReference <= referenceSignal > maxReference ? referenceSignal : maxReference;
          maxError <= errorSignal > maxError ? errorSignal : maxError;
          referenceAmplitude <= referenceAmplitude;
          errorAmplitude <= errorAmplitude;
          samples <= samples + 1;
        end else begin
          maxReference <= maxReference;
          maxError <= maxError;
          referenceAmplitude <= referenceAmplitude;
          errorAmplitude <= errorAmplitude;
          samples <= samples;
        end
      end
      STATUS_DETECT: begin
        maxReference <= maxReference;
        maxError <= maxError;
        referenceAmplitude <= maxReference;
        errorAmplitude <= maxError;
        samples <= samples;
      end
      STATUS_UPDATE: begin
        maxReference <= maxReference;
        maxError <= maxError;
        referenceAmplitude <= referenceAmplitude;
        errorAmplitude <= errorAmplitude;
        samples <= samples;
      end
      default: begin
        maxReference <= {AMPLITUDE_DATA_SIZE{1'b0}};
        maxError <= {AMPLITUDE_DATA_SIZE{1'b0}};
        referenceAmplitude <= {AMPLITUDE_DATA_SIZE{1'b0}};
        errorAmplitude <= {AMPLITUDE_DATA_SIZE{1'b0}};
        samples <= 0;
      end
    endcase
  end

  always @(*) begin
    case (status)
      STATUS_INIT:
      nextStatus = (i_iagcStatus == IAGC_STATUS_RESET || i_iagcStatus == IAGC_STATUS_INIT) ? STATUS_INIT : STATUS_SAMPLE;
      STATUS_SAMPLE:
      nextStatus = samples >= AMPLITUDE_SAMPLES_COUNT ? STATUS_DETECT : STATUS_SAMPLE;
      STATUS_DETECT: nextStatus = STATUS_UPDATE;
      STATUS_UPDATE: nextStatus = STATUS_INIT;
      default: nextStatus = STATUS_INIT;
    endcase
  end

  assign o_referenceAmplitude = referenceAmplitude;
  assign o_errorAmplitude = errorAmplitude;
  assign o_update = (status == STATUS_UPDATE);

endmodule

`default_nettype wire
