`timescale 1ns / 1ps

module monopulse #
(
    parameter DATA_SIZE     =   64
)
(
    input   i_reset,
    input   i_clock,
    input   [ DATA_SIZE - 1 : 0 ]   i_reference,
    input   [ DATA_SIZE - 1 : 0 ]   i_error,
    output  [ DATA_SIZE - 1 : 0 ]   o_relation
);

    assign o_relation   =   i_error * i_reference;

endmodule
