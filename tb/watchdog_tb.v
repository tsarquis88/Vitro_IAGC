`timescale 1ns / 1ns

module watchdog_tb ();

  localparam SYS_CLOCK_PERIOD = 10;
  localparam IAGC_STATUS_SIZE = 4;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;
  localparam TICKS = 5;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagcStatus;
  reg gate;
  wire valid;

  initial begin
    clock = 1'b0;
    gate = 1'b0;
    iagcStatus = IAGC_STATUS_RESET;
    #100 iagcStatus = IAGC_STATUS_INIT;
    #100 iagcStatus = IAGC_STATUS_IDLE;

    #1000 gate = 1'b1;
    #20 gate = 1'b0;

    #100 gate = 1'b1;
    #4 gate = 1'b0;

    #50 gate = 1'b1;

  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  watchdog #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .TICKS(TICKS)
  ) u_watchdog (
      .i_clock(clock),
      .i_iagcStatus(iagcStatus),
      .i_gate(gate),
      .o_valid(valid)
  );

endmodule
