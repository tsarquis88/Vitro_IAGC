`timescale 1ns / 1ns

module memory_tb ();

  localparam SYS_CLOCK_PERIOD = 10;

  reg          clock;
  reg          reset;

  reg  [7 : 0] addr;
  reg          read;
  reg          write;
  reg  [7 : 0] in_data;
  reg          clean;
  wire [7 : 0] out_data;

  initial begin
    clock = 1'b0;
    addr  = 4;
    write = 1'b0;
    read  = 1'b0;
    clean = 1'b0;

    #10 reset = 1'b1;

    #50 reset = 1'b0;

    #100 write = 1'b1;
    #10000 write = 1'b0;

    #20 read = 1'b1;
    #30 read = 1'b0;

    #100 clean = 1'b1;
    #5 clean = 1'b0;

    #10000 read = 1'b1;
    #30 read = 1'b0;

  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  always @(posedge clock) begin
    if (reset) in_data <= {8{1'b0}};
    else in_data <= in_data + 1'b1;
  end

  memory #(
      .DATA_SIZE  (8),
      .ADDR_SIZE  (5),
      .MEMORY_SIZE(32)
  ) u_memory (
      .i_clock(clock),
      .i_reset(reset),
      .i_addr (addr),
      .i_read (read),
      .i_write(write),
      .i_data (in_data),
      .i_clean(clean),
      .o_data (out_data)
  );

endmodule
