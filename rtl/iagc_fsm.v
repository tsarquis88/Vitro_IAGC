`timescale 1ns / 1ps `default_nettype none

module iagc_fsm #(
    parameter STATUS_SIZE = 4
) (
    input wire i_clock,
    input wire i_nReset,
    input wire i_adcInitDone,
    input wire i_dacInitDone,
    output wire [STATUS_SIZE-1:0] o_status
);
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;

  reg [STATUS_SIZE-1:0] status;
  reg [STATUS_SIZE-1:0] nextStatus;

  assign o_status = status;

  always @(posedge i_clock) begin
    if (~i_nReset) begin
      status <= IAGC_STATUS_RESET;
    end else begin
      status <= nextStatus;
    end
  end

  always @(*) begin
    case (status)
      IAGC_STATUS_RESET: begin
        nextStatus = IAGC_STATUS_INIT;
      end
      IAGC_STATUS_INIT: begin
        nextStatus = (i_adcInitDone && i_dacInitDone) ? IAGC_STATUS_IDLE : IAGC_STATUS_INIT;
      end
      IAGC_STATUS_IDLE: begin
        nextStatus = IAGC_STATUS_IDLE;
      end
      default: begin
        nextStatus = IAGC_STATUS_RESET;
      end
    endcase
  end
endmodule

`default_nettype wire
