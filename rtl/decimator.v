`timescale 1ns / 1ps `default_nettype none

module decimator #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter DECIMATOR_SIZE   = 4
) (
    input  wire                            i_clock,
    input  wire [IAGC_STATUS_SIZE - 1 : 0] i_iagc_status,
    input  wire                            i_gate,
    input  wire [DECIMATOR_SIZE   - 1 : 0] i_decimator,
    output wire                            o_sample
);

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;

  integer counter;

  always @(posedge i_clock) begin

    if (i_iagc_status == IAGC_STATUS_RESET || i_iagc_status == IAGC_STATUS_INIT || ~i_gate)
      counter <= 0;
    else counter <= counter >= i_decimator - 1 ? 0 : counter + 1;
  end

  assign o_sample = counter == (i_decimator - 1);

endmodule

`default_nettype wire
