`timescale 1ns / 1ps `default_nettype none

module watchdog #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter TICKS = 120000000
) (
    input wire i_clock,
    input wire [IAGC_STATUS_SIZE-1:0] i_iagcStatus,
    input wire i_gate,
    output wire o_valid
);
  localparam IAGC_STATUS_IDLE = 4'b0010;

  integer counter;
  reg gateAlive;
  reg valid;
  always @(posedge i_clock) begin
    if (i_iagcStatus != IAGC_STATUS_IDLE) begin
      counter <= 0;
      gateAlive <= 1'b0;
      valid <= 1'b1;
    end else begin
      if (i_gate) begin
        gateAlive <= 1'b1;
      end

      counter <= counter + 1;
      if (counter == TICKS) begin
        counter <= 0;
        valid <= gateAlive;
        gateAlive <= 1'b0;
      end
    end
  end

  assign o_valid = valid;
endmodule

`default_nettype wire
