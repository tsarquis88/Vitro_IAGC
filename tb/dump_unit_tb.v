`timescale 1ns / 1ns

module dump_unit_tb ();

  reg         clock;
  reg         reset;
  reg  [ 3:0] iagc_status;
  wire        ready;
  wire [11:0] addr;
  wire        valid;
  wire        dump_end;
  wire        tx;

  initial begin
    clock       = 1'b0;
    reset       = 1'b1;
    iagc_status = 4'b0000;

    #100 reset = 1'b0;
    iagc_status = 4'b0001;

    #100 iagc_status = 4'b0111;

    #30 iagc_status = 4'b0001;
  end

  always begin
    #5 clock = ~clock;
  end

  dump_unit #(
      .MEMORY_SIZE(8)
  ) u_dump_unit (
      .i_clock      (clock),
      .i_ready      (ready),
      .i_iagc_status(iagc_status),
      .o_addr       (addr),
      .o_valid      (valid),
      .o_end        (dump_end)
  );

  uart_tx #(
      .CLK_FREQUENCY (125000000),
      .UART_FREQUENCY(38400)
  ) u_uart_tx (
      .user_clk     (clock),
      .rst_n        (~reset),
      .start_tx     (valid),
      .data         (8'b10100101),
      .tx_bit       (tx),
      .ready        (ready),
      .chipscope_clk()
  );

endmodule
