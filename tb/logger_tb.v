`timescale 1ns / 1ns

module logger_tb ();

  reg         clock;
  reg         reset;
  reg  [ 3:0] iagc_status;
  reg  [12:0] ref_amp;
  reg  [12:0] err_amp;
  wire        ready;
  wire        start;
  wire        tx;

  initial begin
    clock       = 1'b0;
    reset       = 1'b1;
    iagc_status = 4'b0000;
    ref_amp     = 12256;
    err_amp     = 8000;

    #100 reset = 1'b0;
    iagc_status = 4'b0001;

    #100 iagc_status = 4'b1110;

    #30 iagc_status = 4'b0010;
  end

  always begin
    #5 clock = ~clock;
  end

  logger u_logger (
      .i_clock              (clock),
      .i_iagc_status        (iagc_status),
      .i_reference_amplitude(ref_amp),
      .i_error_amplitude    (err_amp),
      .i_tx_ready           (ready),
      .o_tx_data            (data),
      .o_tx_start           (start)
  );

  uart_tx #(
      .CLK_FREQUENCY (125000000),
      .UART_FREQUENCY(38400)
  ) u_uart_tx (
      .user_clk     (clock),
      .rst_n        (~reset),
      .start_tx     (start),
      .data         (8'b10100101),
      .tx_bit       (tx),
      .ready        (ready),
      .chipscope_clk()
  );

endmodule
