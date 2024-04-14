`timescale 1ns / 1ns

module clock_unit_tb ();

  reg clock;
  reg reset;
  initial begin
    clock = 1'b0;
    reset = 1'b1;

    #100 reset = 1'b0;
  end

  localparam SYS_CLOCK_PERIOD = 8;
  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  wire clock0;
  wire clock1;
  wire clocksValid;
  clock_unit #() u_clock_unit (
      .i_clock (clock),
      .i_reset (reset),
      .o_clock0(clock0),
      .o_clock1(clock1),
      .o_valid (clocksValid)
  );

endmodule
