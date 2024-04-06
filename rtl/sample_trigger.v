`timescale 1ns / 1ps `default_nettype none

module sample_trigger #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter DECIMATOR = 4
) (
    input wire i_clock,
    input wire [IAGC_STATUS_SIZE-1:0] i_iagc_status,
    input wire i_adc_data_valid,
    input wire i_gate,
    output wire o_valid
);

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  integer counter;
  reg valid;

  always @(posedge i_clock) begin
    if (i_iagc_status == IAGC_STATUS_RESET || i_iagc_status == IAGC_STATUS_INIT) counter <= 0;
    else counter <= counter >= DECIMATOR - 1 ? 0 : counter + 1;
  end

  always @(posedge i_clock) begin
    valid = i_adc_data_valid && i_gate && counter == (DECIMATOR - 1);
  end

  assign o_valid = valid;

endmodule

`default_nettype wire
