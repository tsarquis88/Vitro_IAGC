`timescale 1ns / 1ps `default_nettype none

module sign_extensor #(
    parameter INPUT_DATA_SIZE = 14,
    parameter OUTPUT_DATA_SIZE = 16
) (
    input wire [INPUT_DATA_SIZE-1:0] inputData,
    output wire [OUTPUT_DATA_SIZE-1:0] outputData
);

  assign outputData[OUTPUT_DATA_SIZE-1 : 0] = {
    {(OUTPUT_DATA_SIZE - INPUT_DATA_SIZE) {inputData[INPUT_DATA_SIZE-1]}}, inputData[INPUT_DATA_SIZE-1 : 0]
  };

endmodule

`default_nettype wire

